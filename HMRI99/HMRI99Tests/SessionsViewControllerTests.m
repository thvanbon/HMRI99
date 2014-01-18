    // Class under test
#import "SessionsViewController.h"

#import <objc/runtime.h>
#import "SessionsTableViewDataSource.h"
#import "MeasurementsViewController.h"
#import "MeasurementsTableViewDataSource.h"
#import "SessionDetailsViewController.h"
#import "SessionDetailsDataSource.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface SessionsViewControllerTests : SenTestCase
@end

static const char *notificationKey = "HMRI99ViewControllerTestsAssociatedNotificationKey";

@implementation SessionsViewController (TestNotificationDelivery)

- (void)hMRI99ControllerTests_userDidSelectSessionNotification: (NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

- (void)hMRI99ControllerTests_userDidAddSessionNotification: (NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

- (void)hMRI99ControllerTests_userDidPressDetailDisclosureButtonNotification: (NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation SessionsViewControllerTests
{
    SessionsViewController * sut;
    UITableView *tableView;
    SessionsTableViewDataSource <UITableViewDataSource, UITableViewDelegate> *dataSource;
    NSNotification * receivedNotification;
    SEL realUserDidSelectSession, testUserDidSelectSession;
    SEL realUserDidAddSession, testUserDidAddSession;
    SEL realUserDidPressDetailDisclosureButton, testUserDidPressDetailDisclosureButton;
    UINavigationController *navController;
    Session *cargillSession;
    
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
    sut=[[SessionsViewController alloc] init];
    tableView = [[UITableView alloc] init];
    sut.tableView = tableView;
    dataSource=[[SessionsTableViewDataSource alloc] init];
    sut.dataSource=dataSource;
    realUserDidSelectSession = @selector(userDidSelectSessionNotification:);
    testUserDidSelectSession = @selector(hMRI99ControllerTests_userDidSelectSessionNotification:);
    realUserDidAddSession = @selector(userDidAddSessionNotification:);
    testUserDidAddSession = @selector(hMRI99ControllerTests_userDidAddSessionNotification:);
    realUserDidPressDetailDisclosureButton = @selector(userDidPressDetailDisclosureButtonNotification:);
    testUserDidPressDetailDisclosureButton = @selector(hMRI99ControllerTests_userDidPressDetailDisclosureButtonNotification:);
    navController = [[UINavigationController alloc] initWithRootViewController: sut];
    
    
    model = [NSManagedObjectModel mergedModelFromBundles: nil];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] init];
    [ctx setPersistentStoreCoordinator: coord];
    dataSource.managedObjectContext=ctx;
    
    cargillSession=[NSEntityDescription insertNewObjectForEntityForName:@"Session"
                                  inManagedObjectContext:ctx];
    
    cargillSession.name=@"CARG.13.01";
    cargillSession.date=[NSDate date];
    cargillSession.location=@"Zaandam";
    cargillSession.engineer=@"HKu";
    
    objc_removeAssociatedObjects(sut);
}

- (void) tearDown
{
    objc_removeAssociatedObjects(sut);
    sut=nil;
    tableView=nil;
    dataSource=nil;
    receivedNotification=nil;
    realUserDidSelectSession=nil;
    testUserDidSelectSession=nil;
    realUserDidAddSession=nil;
    testUserDidAddSession=nil;
    realUserDidPressDetailDisclosureButton=nil;
    testUserDidPressDetailDisclosureButton=nil;
    navController=nil;
    cargillSession=nil;
    
    
    ctx = nil;
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
    
    [super tearDown];
}

- (void) testViewControllerHasATableView
{
    objc_property_t tableViewProperty = class_getProperty([sut class], "tableView");
    STAssertTrue(tableViewProperty != NULL, @"HMRI99ViewController needs a table view");
}

- (void)testViewControllerHasADataSourceProperty { objc_property_t dataSourceProperty =class_getProperty([sut class], "dataSource");
    STAssertTrue(dataSourceProperty != NULL, @"HMRI99ViewController needs a data source");
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

- (void) testNavigationControllerHasMeasurementSessionsTitle
{
    [sut viewDidLoad];
    assertThat([[sut navigationItem]title], is(equalTo(@"Measurement Sessions")));
}


//- (void) testNavigationControllerHasRightBarButtonThatIsPlus
//{
//    [sut viewDidLoad];
//    UIBarButtonItem *myButton=[[sut navigationItem] rightBarButtonItem];
//    NSLog(@"++++++++++++++++ %i ++++++++++++",myButton.style);
//    assertThatInt(myButton.style, is(equalToInt(4)));
//}

- (void) testInsertNewObjectMethodIsCalledWhenRightBarButtonIsTapped
{
    [sut viewDidLoad];
    UIBarButtonItem *myButton=[[sut navigationItem] rightBarButtonItem];
    assertThat(NSStringFromSelector([myButton action]), is(equalTo(@"insertNewObject:")));
}

- (void) testAddNewSessionIsCalledWhenInsertNewObjectIsCalled
{
    SessionsTableViewDataSource * mockDataSource=mock([SessionsTableViewDataSource class]);
    sut.dataSource=mockDataSource;
    navController = [[UINavigationController alloc] initWithRootViewController: sut];
    [sut viewDidLoad];
    [sut insertNewObject:nil];
    [verify(mockDataSource) addSession];
}

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotificationsForSelecting {
    [self swapInstanceMethods];
    [self postSessionSelectedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [self postSessionSelectedNotification]; 
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [self postSessionSelectedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testSelectingSessionDeselectsSessionsViewControllerAsTopViewController
{
    [sut userDidSelectSessionNotification:nil];   
    UIViewController *currentTopVC = [navController topViewController];
    STAssertFalse([currentTopVC isEqual: sut], @"New view controller should be pushed onto the stack");
}

- (void)testSelectingSessionShouldSelectMeasurementsViewControllerAsTopViewController
{
    [sut userDidSelectSessionNotification:nil];
    UIViewController *currentTopVC = [navController topViewController];
    assertThatBool([currentTopVC isKindOfClass:[MeasurementsViewController class]], is(equalToBool(YES)));
}

//- (void)testSelectingSessionForSecondTimeShouldSelectSameMeasurementsViewControllerAsTopViewController
//{
//    NSNotification *cargillSessionSelectedNotification = [NSNotification notificationWithName: sessionsTableDidSelectSessionNotification
//                                                                                       object: cargillSession];
//    [sut userDidSelectSessionNotification:cargillSessionSelectedNotification];
//
//}

- (void)testNewViewControllerHasAMeasurementListDataSourceForTheSelectedSession
{
    NSNotification *cargillSessionSelectedNotification = [NSNotification notificationWithName: sessionsTableDidSelectSessionNotification
                                      object: cargillSession];
    
    
    [sut userDidSelectSessionNotification: cargillSessionSelectedNotification];
    MeasurementsViewController *nextViewController = (MeasurementsViewController *)navController.topViewController;
    STAssertTrue([nextViewController.dataSource isKindOfClass: [MeasurementsTableViewDataSource class]], @"Selecting a Session should push a list of Measurements");
    STAssertEqualObjects([(MeasurementsTableViewDataSource *)
                          nextViewController.dataSource session], cargillSession,
                         @"The Measurements to display should come from the selected Session");
}

- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad
{
    MeasurementsTableViewDataSource *measurementsTableViewDataSource = [[MeasurementsTableViewDataSource alloc] init];
    sut.dataSource = measurementsTableViewDataSource;
    [sut viewDidLoad];
    STAssertEqualObjects(measurementsTableViewDataSource.tableView, tableView, @"Back-link to table view should be set in data source");
}


#pragma mark Notifications for adding

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotificationsForAdding {
    [self swapInstanceMethods];
    [self postSessionAddedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerReceivesTableAddedNotificationAfterViewDidAppear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [self postSessionAddedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerDoesNotReceiveTableAddedNotificationAfterViewWillDisappear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [self postSessionAddedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testReceivingTableAddedNotificationAddsRowToTableView
{
    [sut viewDidAppear: NO];
    int numberOfRowsInSectionZero=[sut.dataSource tableView:[sut tableView] numberOfRowsInSection:0];
    [dataSource addSession];
    assertThat([NSNumber numberWithInt:[sut.dataSource tableView:[sut tableView] numberOfRowsInSection:0]], is(equalTo([NSNumber numberWithInt:numberOfRowsInSectionZero+1])));
}

- (void)testReceivingTableAddedNotificationHasASessionDetailsListDataSourceForTheAddedSession
{
    Session *newSession=[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:ctx];
    NSNotification *sessionAddedNotification = [NSNotification notificationWithName: sessionsTableDidAddSessionNotification object: newSession];
    
    [sut userDidAddSessionNotification: sessionAddedNotification];
    SessionDetailsViewController *nextViewController = (SessionDetailsViewController *)navController.topViewController;
    STAssertTrue([nextViewController.dataSource isKindOfClass: [SessionDetailsDataSource class]], @"Adding a Session should open Session and show Session Details");
}

- (void)testReceivingTableAddedNotificationHasAMeasurementListDataSourceForTheAddedSession
{
    Session *newSession=[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:ctx];
    NSNotification *sessionAddedNotification = [NSNotification notificationWithName: sessionsTableDidAddSessionNotification object: newSession];
    
    [sut userDidAddSessionNotification: sessionAddedNotification];
    SessionDetailsViewController *nextViewController = (SessionDetailsViewController *)navController.topViewController;
    STAssertTrue([nextViewController.dataSource isKindOfClass: [SessionDetailsDataSource class]], @"Adding a Session should open Session and show session details");
}

#pragma mark Notifications for pressing detail disclosure button

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotificationsForPressingDetailDisclosureButton {
    [self swapInstanceMethods];
    [self postDetailDisclosureButtonPressedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerReceivesDetailDisclosureButtonPressedNotificationAfterViewDidAppear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [self postDetailDisclosureButtonPressedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerDoesNotReceiveDetailDisclosureButtonPressedNotificationAfterViewWillDisappear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [self postDetailDisclosureButtonPressedNotification];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testPressingDetailDisclosureButtonShouldSelectSessionDetailsViewControllerAsTopViewController
{
    [sut userDidPressDetailDisclosureButtonNotification:nil];
    UIViewController *currentTopVC = [navController topViewController];
    assertThatBool([currentTopVC isKindOfClass:[SessionDetailsViewController class]], is(equalToBool(YES)));
}

- (void)testNewViewControllerHasASessionDetailsListDataSourceForTheSelectedSession
{
    NSNotification *cargillSessionDetailDisclosureButtonPressedNotification = [NSNotification notificationWithName: sessionsTableDidPressAccessoryDetailButtonNotification
                                                                                       object: cargillSession];    
    [sut userDidPressDetailDisclosureButtonNotification: cargillSessionDetailDisclosureButtonPressedNotification];
    SessionDetailsViewController *nextViewController = (SessionDetailsViewController *)navController.topViewController;
    STAssertTrue([nextViewController.dataSource isKindOfClass: [SessionDetailsDataSource class]], @"Selecting a Session should push a list of Session Details");
    STAssertEqualObjects([(SessionDetailsDataSource *)
                          nextViewController.dataSource session], cargillSession,
                         @"The Details to display should come from the selected Session");
}


#pragma mark Helper methods
- (void)swapInstanceMethods
{
    [SessionsViewControllerTests swapInstanceMethodsForClass: [SessionsViewController class]
                                                  selector: realUserDidSelectSession
                                               andSelector: testUserDidSelectSession];
    [SessionsViewControllerTests swapInstanceMethodsForClass: [SessionsViewController class]
                                                  selector: realUserDidAddSession
                                               andSelector: testUserDidAddSession];
    [SessionsViewControllerTests swapInstanceMethodsForClass: [SessionsViewController class]
                                                    selector: realUserDidPressDetailDisclosureButton
                                                 andSelector: testUserDidPressDetailDisclosureButton];
}

- (void)postSessionSelectedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidSelectSessionNotification
                                                        object: nil
                                                      userInfo: nil];
}

- (void)postSessionAddedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidAddSessionNotification
                                                        object: nil
                                                      userInfo: nil];
}

- (void)postDetailDisclosureButtonPressedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidPressAccessoryDetailButtonNotification
                                                        object: nil
                                                      userInfo: nil];
}



@end
