    // Class under test
#import "SessionsTableViewDataSource.h"

    // Collaborators
#import "Session.h"
#import "SessionSummaryCell.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface SessionsTableViewDataSourceTests : SenTestCase
@end

@implementation SessionsTableViewDataSourceTests
{
    SessionsTableViewDataSource * sut;
    NSDate * myDate;
    Session * sampleSession;
    NSMutableArray * sessions;
    NSNotification * receivedNotification;
}

- (void) setUp
{
    [super setUp];
    sut=[[SessionsTableViewDataSource alloc] init];
    myDate=[NSDate dateWithTimeIntervalSinceNow:0.0f];
    sampleSession=[[Session alloc] initWithName:@"CARG.13.01"
                                           date:myDate
                                       location:@"Zaandam"
                                       engineer:@"HKa"];
    sessions=[NSMutableArray arrayWithObject:sampleSession];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveNotification:)
                                                 name: sessionsTableDidSelectSessionNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveNotification:)
                                                 name: sessionsTableDidAddSessionNotification
                                               object: nil];
}

- (void) tearDown
{
    sut=nil;
    myDate =nil;
    sampleSession=nil;
    sessions=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    receivedNotification=nil;
    [super tearDown];
}

//- (void) testSessionSummaryCellShouldBeConnected
//{
//    assertThat([sut summaryCell], is(notNilValue()));
//}

- (void) testSessionsDataSourceCanReceiveAListOfSessions
{
    [sut setSessions:sessions];
    STAssertNoThrow([sut setSessions:sessions], @"The data source needs a list of measurement sessions");
}

- (void) testSessionsDataSourceCanReceiveAnAddedSession
{
    [sut setSessions:sessions];
    [sut addSession];
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo(@2)));
}

- (void) testOneRowForOneSession
{
    [sut setSessions:sessions];
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo([NSNumber numberWithInt:[sessions count]])));
}

- (void) testTwoRowsForTwoSessions
{
    sessions=[NSArray arrayWithObjects:sampleSession,sampleSession,nil];
    [sut setSessions:sessions];
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo([NSNumber numberWithInt:[sessions count]])));
}

- (void) testDataSourceCanReceiveFirstSessionThroughAddSession
{
    [sut addSession];
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo(@1)));
}

- (void)testOneSectionInTheTableView
{
    [sut setSessions:sessions];
    STAssertThrows([sut tableView:nil numberOfRowsInSection:1], @"Data source doesn't allow asking about additional sections");
}

- (void)testDataSourceCellCreationExpectsOneSection
{
    [sut setSessions:sessions];
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow: 0 inSection: 1];
        STAssertThrows([sut tableView:nil cellForRowAtIndexPath:secondSection], @"Data source will not prepare cells for non existing sections");
}

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasSessions
{
    [sut setSessions:sessions];
    NSIndexPath * afterLastSession=[NSIndexPath indexPathForItem:[sessions count] inSection:0];
    STAssertThrows([sut tableView:nil cellForRowAtIndexPath:afterLastSession], @"Data source will not prepare more cells than existing Sessions");
}

//- (void)testCellCreatedByDataSourceContainsSessionNameAsTextLabel
//{
//    [sut setSessions:sessions];
//    NSIndexPath *firstSession = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    UITableViewCell *firstCell = [sut tableView: nil cellForRowAtIndexPath: firstSession];
//    NSString *cellTitle = firstCell.textLabel.text;
//    assertThat(cellTitle, is(equalTo(@"CARG.13.01")));
//}

//- (void)testCellCreatedByDataSourceContainsSessionNameAsTextLabel
//{
//    [sut setSessions:sessions];
//    NSIndexPath *firstSession = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    UITableViewCell *firstCell = [sut tableView: nil cellForRowAtIndexPath: firstSession];
//    NSString *cellTitle = firstCell.textLabel.text;
//    assertThat(cellTitle, is(equalTo(@"CARG.13.01")));
//}

- (void)testDataSourceIndicatesWhichSessionIsRepresentedForAnIndexPath
{
    [sut setSessions:sessions];
    NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    Session *firstSession=[sut sessionForIndexPath:firstRow];
    assertThat(firstSession.name, is(equalTo(@"CARG.13.01")));    
}

- (void) didReceiveNotification:(NSNotification *) myNote
{
    receivedNotification=myNote;
}
 
-(void)testDataSourceSendsNotificationWhenSessionIsSelected
{
    [sut setSessions:sessions];
    NSIndexPath * selection=[NSIndexPath indexPathForRow:0 inSection:0];
    [sut tableView:nil didSelectRowAtIndexPath:selection];
    assertThat([receivedNotification name], is(equalTo(sessionsTableDidSelectSessionNotification)));
}

-(void)testDataSourceSendsNotificationWithSessionWhenSessionIsSelected
{
    [sut setSessions:sessions];
    NSIndexPath * selection=[NSIndexPath indexPathForRow:0 inSection:0];
    [sut tableView:nil didSelectRowAtIndexPath:selection];
    assertThat([[receivedNotification object] name], is(equalTo(@"CARG.13.01")));
}

-(void)testDataSourceSendsNotificationWhenSessionIsAdded
{
    [sut addSession];
    assertThat([receivedNotification name], is(equalTo(sessionsTableDidAddSessionNotification)));
}


- (void)testCellHasSessionNameLabel
{
    [sut setSessions:sessions];
    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
    assertThat(cell.nameLabel.text, is(equalTo(@"Project Name")));
}

- (void)testCellHasSessionDateLabel
{
    [sut setSessions:sessions];
    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
    assertThat(cell.dateLabel.text, is(equalTo(@"Date")));
}

- (void)testCellHasSessionEngineerLabel
{
    [sut setSessions:sessions];
    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
    assertThat(cell.engineerLabel.text, is(equalTo(@"Engineer")));
}

- (void)testCellHasSessionNameTextField
{
    [sut setSessions:sessions];
    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
    assertThat(cell.nameTextField.text, is(equalTo(@"CARG.13.01")));
}

- (void)testCellHasSessionDateTextField
{
    [sut setSessions:sessions];
    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-mm-yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    assertThat(cell.dateTextField.text, is(equalTo([NSString stringWithFormat:@"%@", stringFromDate])));
}

- (void)testCellHasSessionEngineerTextField
{
    [sut setSessions:sessions];
    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
    assertThat(cell.engineerTextField.text, is(equalTo(@"HKa")));
}

//- (void)testCellNameIsTheSameAsTheSessionName
//{
//    [sut setSessions:sessions];
//    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
//    assertThat(cell.name.text, is(equalTo(@"CARG.13.01")));
//}
//
//- (void)testCellDateIsTheSameAsTheSessionDate
//{
//    [sut setSessions:sessions];
//    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
//    assertThat(cell.date.text;, is(equalTo([sampleSession date])));
//}
//
//- (void)testCellEngineerIsTheSameAsTheSessionEngineer
//{
//    [sut setSessions:sessions];
//    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
//    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
//    assertThat(cell.engineer.text;, is(equalTo(@"HKu")));
//}
- (void)testHeightOfASessionRowIsAtLeastTheSameAsTheHeightOfTheCell
{
    [sut setSessions:sessions];
    NSIndexPath * firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    SessionSummaryCell *cell = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
    NSInteger height = [sut tableView: nil heightForRowAtIndexPath: firstIndexPath];
    assertThatFloat(height,is(greaterThanOrEqualTo([NSNumber numberWithFloat:cell.frame.size.height])));
}

@end
