    // Class under test
#import "SessionsTableViewDataSource.h"

    // Collaborators
#import "Session.h"
//#import "SessionSummaryCell.h"

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
    
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
    
}

- (void) setUp
{
    [super setUp];
    sut=[[SessionsTableViewDataSource alloc] init];
    model = [NSManagedObjectModel mergedModelFromBundles: nil];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] init];
    [ctx setPersistentStoreCoordinator: coord];
    sut.managedObjectContext=ctx;
    myDate=[NSDate dateWithTimeIntervalSinceNow:0.0f];
    sampleSession=[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:ctx];
    sampleSession.name=@"CARG.13.01";
    sampleSession.date=myDate;
    sampleSession.location=@"Zaandam";
    sampleSession.engineer=@"Alfred Brooks";
    //sampleSession.creationDate=[NSDate date];
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
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveNotification:)
                                                 name: sessionsTableDidPressAccessoryDetailButtonNotification
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
    
    ctx = nil;
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
    firstCell=nil;
    [super tearDown];
}

//- (void) testSessionSummaryCellShouldBeConnected
//{
//    assertThat([sut summaryCell], is(notNilValue()));
//}

//- (void) testSessionsDataSourceCanReceiveAListOfSessions
//{
//    STAssertNoThrow([sut setSessions:sessions], @"The data source needs a list of measurement sessions");
//}
//
- (void) testSessionsDataSourceCanReceiveAnAddedSession
{
    [sut addSession];
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo(@2)));
}

- (void) testOneRowForOneSession
{
    assertThatInt([sut tableView:nil numberOfRowsInSection:0],is(equalToInt(1)));
}

- (void) testTwoRowsForTwoSessions
{
   [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:ctx];
    assertThatInt([sut tableView:nil numberOfRowsInSection:0],is(equalToInt(2)));
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
    NSIndexPath * afterLastSession=[NSIndexPath indexPathForItem:1 inSection:0];
    STAssertThrows([sut tableView:nil cellForRowAtIndexPath:afterLastSession], @"Data source will not prepare more cells than existing Sessions");
}

- (void)testDataSourceIndicatesWhichSessionIsRepresentedForAnIndexPath
{
    [sut tableView:nil numberOfRowsInSection:0];
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
    [sut tableView:nil numberOfRowsInSection:0];
    [sut tableView:nil didSelectRowAtIndexPath:firstIndexPath];
    assertThat([[receivedNotification object] name], is(equalTo(@"CARG.13.01")));
}

-(void)testDataSourceSendsNotificationWhenSessionIsAdded
{
    [sut addSession];
    assertThat([receivedNotification name], is(equalTo(sessionsTableDidAddSessionNotification)));
}

//- (void)testHeightOfASessionRowIsAtLeastTheSameAsTheHeightOfTheCell
//{
//    NSInteger height = [sut tableView: nil heightForRowAtIndexPath: firstIndexPath];
//    assertThatFloat(height,is(greaterThanOrEqualTo([NSNumber numberWithFloat:firstCell.frame.size.height])));
//}

- (void)testRowHasAccessoryDetailButton
{
    UITableViewCell * cell=(UITableViewCell*)[sut tableView:nil cellForRowAtIndexPath:firstIndexPath];
    assertThatInt([cell accessoryType], is(equalToInt(UITableViewCellAccessoryDetailDisclosureButton)));
}

-(void)testDataSourceSendsNotificationWhenAccessoryDetailButtonIsPressed
{
    [sut tableView:nil accessoryButtonTappedForRowWithIndexPath:firstIndexPath];
    assertThat([receivedNotification name], is(equalTo(sessionsTableDidPressAccessoryDetailButtonNotification)));
}

-(void)testDataSourceSendsNotificationWithSessionWhenAccessoryDetailButtonIsPressed
{
    [sut tableView:nil numberOfRowsInSection:0];
    [sut tableView:nil accessoryButtonTappedForRowWithIndexPath:firstIndexPath];
    assertThat([[receivedNotification object] name], is(equalTo(@"CARG.13.01")));
}

#pragma mark helper methods
- (void) didReceiveNotification:(NSNotification *) myNote
{
    receivedNotification=myNote;
}


@end
