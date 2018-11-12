    // Class under test
#import "SessionsTableViewDataSource.h"

    // Collaborators
#import "Session.h"
//#import "SessionSummaryCell.h"

    // Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>


@interface SessionsTableViewDataSourceTests : XCTestCase
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
    ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
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
    firstCell = (SessionSummaryStaticCell *)[sut tableView:sut.tableView  cellForRowAtIndexPath: firstIndexPath];
    
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
    XCTAssertTrue([coord removePersistentStore: store error: &error],
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
//    XCTAssertNoThrow([sut setSessions:sessions], @"The data source needs a list of measurement sessions");
//}
//
- (void) testSessionsDataSourceCanReceiveAnAddedSession
{
    [sut addSession];
    assertThat([NSNumber numberWithInt:(int)[sut tableView:sut.tableView numberOfRowsInSection:0]],is(equalTo(@2)));
}

- (void) testOneRowForOneSession
{
    assertThatInt((int) [sut tableView:sut.tableView numberOfRowsInSection:0],is(equalToInt(1)));
}

- (void) testTwoRowsForTwoSessions
{
   [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:ctx];
    assertThatInt((int) [sut tableView:sut.tableView numberOfRowsInSection:0],is(equalToInt(2)));
}

- (void)testOneSectionInTheTableView
{
    XCTAssertThrows([sut tableView:sut.tableView numberOfRowsInSection:1], @"Data source doesn't allow asking about additional sections");
}

- (void)testDataSourceCellCreationExpectsOneSection
{
    NSIndexPath *secondSection = [NSIndexPath indexPathForRow: 0 inSection: 1];
        XCTAssertThrows([sut tableView:sut.tableView cellForRowAtIndexPath:secondSection], @"Data source will not prepare cells for non existing sections");
}

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasSessions
{
    NSIndexPath * afterLastSession=[NSIndexPath indexPathForItem:1 inSection:0];
    XCTAssertThrows([sut tableView:sut.tableView cellForRowAtIndexPath:afterLastSession], @"Data source will not prepare more cells than existing Sessions");
}

- (void)testDataSourceIndicatesWhichSessionIsRepresentedForAnIndexPath
{
    [sut tableView:sut.tableView numberOfRowsInSection:0];
    Session *firstSession=[sut sessionForIndexPath:firstIndexPath];
    assertThat(firstSession.name, is(equalTo(@"CARG.13.01")));    
}

-(void)testDataSourceSendsNotificationWhenSessionIsSelected
{
    [sut tableView:sut.tableView didSelectRowAtIndexPath:firstIndexPath];
    assertThat([receivedNotification name], is(equalTo(sessionsTableDidSelectSessionNotification)));
}

-(void)testDataSourceSendsNotificationWithSessionWhenSessionIsSelected
{
    [sut tableView:sut.tableView numberOfRowsInSection:0];
    [sut tableView:sut.tableView didSelectRowAtIndexPath:firstIndexPath];
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
    UITableViewCell * cell=(UITableViewCell*)[sut tableView:sut.tableView cellForRowAtIndexPath:firstIndexPath];
    assertThatInt([cell accessoryType], is(equalToInt(UITableViewCellAccessoryDetailDisclosureButton)));
}

-(void)testDataSourceSendsNotificationWhenAccessoryDetailButtonIsPressed
{
    [sut tableView:sut.tableView accessoryButtonTappedForRowWithIndexPath:firstIndexPath];
    assertThat([receivedNotification name], is(equalTo(sessionsTableDidPressAccessoryDetailButtonNotification)));
}

-(void)testDataSourceSendsNotificationWithSessionWhenAccessoryDetailButtonIsPressed
{
    [sut tableView:sut.tableView numberOfRowsInSection:0];
    [sut tableView:sut.tableView accessoryButtonTappedForRowWithIndexPath:firstIndexPath];
    assertThat([[receivedNotification object] name], is(equalTo(@"CARG.13.01")));
}

#pragma mark helper methods
- (void) didReceiveNotification:(NSNotification *) myNote
{
    receivedNotification=myNote;
}


@end
