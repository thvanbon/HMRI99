// Class under test
#import "MeasurementsViewController.h"

#import <objc/runtime.h>
#import "MeasurementsTableViewDataSource.h"
#import "Session.h"
#import "MeasurementDetailViewController.h"
#import "Measurement.h"
#import "MeasurementDetailTableViewDataSource.h"

// Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementsViewControllerTests : XCTestCase
@end

static const char *notificationKey = "MeasurementsViewControllerTestsAssociatedNotificationKey";

@implementation MeasurementsViewController (TestNotificationDelivery)

- (void)measurementsViewControllerTests_userDidSelectMeasurementNotification: (NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

- (void)measurementsViewControllerTests_userDidAddMeasurementNotification: (NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation MeasurementsViewControllerTests
{
    MeasurementsViewController * sut;
    UITableView *tableView;
    
    MeasurementsTableViewDataSource <UITableViewDataSource, UITableViewDelegate> *dataSource;
    SEL realUserDidSelectMeasurement, testUserDidSelectMeasurement;
    SEL realUserDidAddMeasurement, testUserDidAddMeasurement;
    UINavigationController *navController;
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
    
}

+ (void)swapInstanceMethodsForClass: (Class) cls selector: (SEL)sel1 andSelector: (SEL)sel2 {
    Method method1 = class_getInstanceMethod(cls, sel1); Method method2 = class_getInstanceMethod(cls, sel2); method_exchangeImplementations(method1, method2);
}

- (void) setUp
{
    [super setUp];
    sut=[[MeasurementsViewController alloc] init];
    tableView = [[UITableView alloc] init];
    sut.tableView = tableView;
    model = [NSManagedObjectModel mergedModelFromBundles: nil];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [ctx setPersistentStoreCoordinator: coord];
    dataSource=[[MeasurementsTableViewDataSource alloc] init];
    dataSource.managedObjectContext=ctx;
    sut.dataSource=dataSource;
    realUserDidSelectMeasurement = @selector(userDidSelectMeasurementNotification:);
    testUserDidSelectMeasurement = @selector(measurementsViewControllerTests_userDidSelectMeasurementNotification:);
    realUserDidAddMeasurement = @selector(userDidAddMeasurementNotification:);
    testUserDidAddMeasurement = @selector(measurementsViewControllerTests_userDidAddMeasurementNotification:);
    navController = [[UINavigationController alloc] initWithRootViewController: sut];
    objc_removeAssociatedObjects(sut);
}

- (void) tearDown
{
    objc_removeAssociatedObjects(sut);
    sut=nil;
    tableView=nil;
    dataSource=nil;
    realUserDidSelectMeasurement=nil;
    testUserDidSelectMeasurement=nil;
    realUserDidAddMeasurement=nil;
    testUserDidAddMeasurement=nil;
    navController=nil;
    ctx = nil;
    NSError *error = nil;
    XCTAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
    [super tearDown];
}

- (void) testViewControllerHasATableView
{
    objc_property_t tableViewProperty = class_getProperty([sut class], "tableView");
    XCTAssertTrue(tableViewProperty != NULL, @"MeasurementsViewController needs a table view");
}

- (void)testViewControllerHasADataSourceProperty { objc_property_t dataSourceProperty =class_getProperty([sut class], "dataSource");
    XCTAssertTrue(dataSourceProperty != NULL, @"MeasurementsViewController needs a data source");
}

- (void) testViewControllerConnectsDataSourceInViewDidLoad
{
    [sut viewDidLoad];
    assertThat([tableView dataSource],is(equalTo(dataSource)));
}

- (void) testViewControllerConnectsDelegateInViewDidLoad
{
    [sut viewDidLoad];
    assertThat([tableView delegate],is(equalTo(dataSource)));
}

- (void) testNavigationControllerHasRightBarButton
{
    [sut viewDidLoad];
    assertThat([[sut navigationItem]rightBarButtonItem], is(notNilValue()));
}

- (void) testNavigationControllerHasMeasurementsTitle
{
    [sut viewDidLoad];
    assertThat([[sut navigationItem]title], is(equalTo(@"Measurements")));
}

//
////- (void) testNavigationControllerHasRightBarButtonThatIsPlus
////{
////    [sut viewDidLoad];
////    UIBarButtonItem *myButton=[[sut navigationItem] rightBarButtonItem];
////    NSLog(@"++++++++++++++++ %i ++++++++++++",myButton.style);
////    assertThatInt(myButton.style, is(equalToInt(4)));
////}

- (void) testInsertNewObjectMethodIsCalledWhenRightBarButtonIsTapped
{
    [sut viewDidLoad];
    UIBarButtonItem *myButton=[[sut navigationItem] rightBarButtonItem];
    assertThat(NSStringFromSelector([myButton action]), is(equalTo(@"insertNewObject:")));
}

- (void) testAddNewMeasurementIsCalledWhenInsertNewObjectIsCalled
{
    MeasurementsTableViewDataSource * mockDataSource=mock([MeasurementsTableViewDataSource class]);
    sut.dataSource=mockDataSource;
    navController = [[UINavigationController alloc] initWithRootViewController: sut];
    [sut viewDidLoad];
    [sut insertNewObject:nil];
    [verify(mockDataSource) addMeasurement];
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotificationsForSelecting {
    [self swapInstanceMethods];
    [self postMeasurementSelectedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [self postMeasurementSelectedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [self postMeasurementSelectedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testSelectingMeasurementDeselectsMeasurementsViewControllerAsTopViewController
{
    NSLog(@"%@", sut);
    [sut userDidSelectMeasurementNotification:nil];
    UIViewController *currentTopVC = [navController topViewController];
    NSLog(@"%@", currentTopVC);
    XCTAssertFalse([currentTopVC isEqual: sut], @"New view controller should be pushed onto the stack");
}

- (void)testSelectingMeasurementShouldSelectDifferentViewControllerAsTopViewController
{
    
    [sut userDidSelectMeasurementNotification:nil];
    UIViewController *currentTopVC = [navController topViewController];
    XCTAssertTrue([currentTopVC isKindOfClass:[MeasurementDetailViewController class]], @"New view controller should be of class MeasurementDetailViewController");
}

- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad
{
    MeasurementsTableViewDataSource *measurementsTableViewDataSource = [[MeasurementsTableViewDataSource alloc] init];
    sut.dataSource = measurementsTableViewDataSource;
    [sut viewDidLoad];
    XCTAssertEqualObjects(measurementsTableViewDataSource.tableView, tableView, @"Back-link to table view should be set in data source");
}


#pragma mark Notifications for adding
- (void)testDefaultStateOfViewControllerDoesNotReceiveNotificationsForAdding {
    [self swapInstanceMethods];
    [self postMeasurementAddedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerReceivesTableAddedNotificationAfterViewDidAppear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [self postMeasurementAddedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerDoesNotReceiveTableAddedNotificationAfterViewWillDisappear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [self postMeasurementAddedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testReceivingTableAddedNotificationAddsRowToTableView
{
    dataSource.session=[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:ctx];
    [sut viewDidAppear: NO];
    int numberOfRowsInSectionOne=(int) [sut.dataSource tableView:sut.tableView numberOfRowsInSection:0];
    [dataSource addMeasurement];
    assertThatInt((int) [sut.dataSource tableView:sut.tableView numberOfRowsInSection:0], is(equalToInt(numberOfRowsInSectionOne+1)));
}

- (void)testReceivingMeasurementAddedNotificationHasAMeasurementDetailDataSourceForTheAddedSession
{
    [sut viewDidAppear:NO];
    [self postMeasurementAddedNotification];
    MeasurementDetailViewController *nextViewController = (MeasurementDetailViewController *)navController.topViewController;
    //NSLog(@"%@", [MeasurementDetailTableViewDataSource class]);
    NSLog(@"%@", [navController.topViewController  class]);
    //assertThatBool([nextViewController.dataSource isKindOfClass: [MeasurementDetailTableViewDataSource class]], is(equalToLong(YES)));
    XCTAssert([nextViewController.dataSource isKindOfClass: [MeasurementDetailTableViewDataSource class]]);
}

- (void)testReceivingMeasurementAddedNotificationHasAMeasurementDetailDataSourceForTheSelectedSession
{
    [sut viewDidAppear:NO];
    [self postMeasurementSelectedNotification];
    MeasurementDetailViewController *nextViewController = (MeasurementDetailViewController *)navController.topViewController;
    assertThatBool([nextViewController.dataSource isKindOfClass: [MeasurementDetailTableViewDataSource class]], is(equalToLong(YES)));
}


//- (void)testKeyboardIsResignedWhenClickedOutsideTextFieldInTableView
//{
//    [sut viewDidAppear: NO];
//    int numberOfRowsInSectionZero=[sut.dataSource tableView:[sut tableView] numberOfRowsInSection:0];
//    [dataSource addSession];
//    assertThat([NSNumber numberWithInt:[sut.dataSource tableView:[sut tableView] numberOfRowsInSection:0]], is(equalTo([NSNumber numberWithInt:numberOfRowsInSectionZero+1])));
//}

#pragma mark Helper methods
- (void)swapInstanceMethods
{
    [MeasurementsViewControllerTests swapInstanceMethodsForClass: [MeasurementsViewController class]
                                                    selector: realUserDidSelectMeasurement
                                                 andSelector: testUserDidSelectMeasurement];
    [MeasurementsViewControllerTests swapInstanceMethodsForClass: [MeasurementsViewController class]
                                                    selector: realUserDidAddMeasurement
                                                 andSelector: testUserDidAddMeasurement];
}

- (void)postMeasurementSelectedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName: measurementsTableDidSelectMeasurementNotification
                                                        object: nil
                                                      userInfo: nil];
}
- (void)postMeasurementAddedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName: measurementsTableDidAddMeasurementNotification
                                                        object: nil
                                                      userInfo: nil];
}

@end
