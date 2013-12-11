    // Class under test
#import "SessionsTableViewDataSource.h"

    // Collaborators
#import "Session.h"
#import "SessionSummaryStaticCell.h"

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
    NSIndexPath * firstIndexPath;
    SessionSummaryStaticCell *firstCell;
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
    [sut setSessions:sessions];
    firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    firstCell = (SessionSummaryStaticCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
    
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
    firstIndexPath=nil;
    firstCell=nil;
    [super tearDown];
}

//- (void) testSessionSummaryCellShouldBeConnected
//{
//    assertThat([sut summaryCell], is(notNilValue()));
//}

- (void) testSessionsDataSourceCanReceiveAListOfSessions
{
    STAssertNoThrow([sut setSessions:sessions], @"The data source needs a list of measurement sessions");
}

- (void) testSessionsDataSourceCanReceiveAnAddedSession
{
    [sut addSession];
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo(@2)));
}

- (void) testOneRowForOneSession
{
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
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo(@2)));
}

- (void)testOneSectionInTheTableView
{
    STAssertThrows([sut tableView:nil numberOfRowsInSection:1], @"Data source doesn't allow asking about additional sections");
}

- (void)testDataSourceCellCreationExpectsOneSection
{
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow: 0 inSection: 1];
        STAssertThrows([sut tableView:nil cellForRowAtIndexPath:secondSection], @"Data source will not prepare cells for non existing sections");
}

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasSessions
{
    NSIndexPath * afterLastSession=[NSIndexPath indexPathForItem:[sessions count] inSection:0];
    STAssertThrows([sut tableView:nil cellForRowAtIndexPath:afterLastSession], @"Data source will not prepare more cells than existing Sessions");
}

- (void)testDataSourceIndicatesWhichSessionIsRepresentedForAnIndexPath
{
    Session *firstSession=[sut sessionForIndexPath:firstIndexPath];
    assertThat(firstSession.name, is(equalTo(@"CARG.13.01")));    
}

-(void)testDataSourceSendsNotificationWhenSessionIsSelected
{
    [sut tableView:nil didSelectRowAtIndexPath:firstIndexPath];
    assertThat([receivedNotification name], is(equalTo(sessionsTableDidSelectSessionNotification)));
}

-(void)testDataSourceSendsNotificationWithSessionWhenSessionIsSelected
{
    [sut tableView:nil didSelectRowAtIndexPath:firstIndexPath];
    assertThat([[receivedNotification object] name], is(equalTo(@"CARG.13.01")));
}

-(void)testDataSourceSendsNotificationWhenSessionIsAdded
{
    [sut addSession];
    assertThat([receivedNotification name], is(equalTo(sessionsTableDidAddSessionNotification)));
}

- (void)testCellHasSessionNameLabel
{
    assertThat(firstCell.nameLabel.text, is(equalTo(@"CARG.13.01")));
}

- (void)testCellHasSessionDateLabel
{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:myDate];
        assertThat(firstCell.dateLabel.text, is(equalTo(stringFromDate)));
}

- (void)testCellHasSessionLocationLabel
{
    assertThat(firstCell.locationLabel.text, is(equalTo(@"Zaandam")));
}

- (void)testCellHasSessionEngineerLabel
{
    assertThat(firstCell.engineerLabel.text, is(equalTo(@"HKa")));
}

- (void)testHeightOfASessionRowIsAtLeastTheSameAsTheHeightOfTheCell
{
    NSInteger height = [sut tableView: nil heightForRowAtIndexPath: firstIndexPath];
    assertThatFloat(height,is(greaterThanOrEqualTo([NSNumber numberWithFloat:firstCell.frame.size.height])));
}

#pragma mark helper methods
- (void) didReceiveNotification:(NSNotification *) myNote
{
    receivedNotification=myNote;
}


@end
