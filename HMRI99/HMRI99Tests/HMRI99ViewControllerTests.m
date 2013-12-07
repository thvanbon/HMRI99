    // Class under test
#import "HMRI99ViewController.h"

#import <objc/runtime.h>
#import "SessionsTableViewDataSource.h"
#import "MeasurementsTableViewDataSource.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface HMRI99ViewControllerTests : SenTestCase
@end

static const char *notificationKey = "HMRI99ViewControllerTestsAssociatedNotificationKey";

@implementation HMRI99ViewController (TestNotificationDelivery)

- (void)hMRI99ControllerTests_userDidSelectSessionNotification: (NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}

- (void)hMRI99ControllerTests_userDidAddSessionNotification: (NSNotification *)note
{
    objc_setAssociatedObject(self, notificationKey, note, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation HMRI99ViewControllerTests
{
    HMRI99ViewController * sut;
    UITableView *tableView;
    id <UITableViewDataSource, UITableViewDelegate> dataSource;
    NSNotification * receivedNotification;
    SEL realUserDidSelectSession, testUserDidSelectSession;
    SEL realUserDidAddSession, testUserDidAddSession;
    UINavigationController *navController;
}

+ (void)swapInstanceMethodsForClass: (Class) cls selector: (SEL)sel1 andSelector: (SEL)sel2 {
    Method method1 = class_getInstanceMethod(cls, sel1); Method method2 = class_getInstanceMethod(cls, sel2); method_exchangeImplementations(method1, method2);
}

- (void) setUp
{
    [super setUp];
    sut=[[HMRI99ViewController alloc] init];
    tableView = [[UITableView alloc] init];
    sut.tableView = tableView;
    dataSource=[[SessionsTableViewDataSource alloc] init];
    sut.dataSource=dataSource;
    realUserDidSelectSession = @selector(userDidSelectSessionNotification:);
    testUserDidSelectSession = @selector(hMRI99ControllerTests_userDidSelectSessionNotification:);
    realUserDidAddSession = @selector(userDidAddSessionNotification:);
    testUserDidAddSession = @selector(hMRI99ControllerTests_userDidAddSessionNotification:);
    navController = [[UINavigationController alloc] initWithRootViewController: sut];
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
    navController=nil;
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

- (void) testAddNewMeasurementIsCalledWhenInsertNewObjectIsCalled
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
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidSelectSessionNotification object: nil
                                                      userInfo: nil];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidSelectSessionNotification object: nil userInfo: nil];
    
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidSelectSessionNotification
                                                        object: nil
                                                      userInfo: nil];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testSelectingSessionDeselectsHMRI99ViewControllerAsTopViewController
{
    [sut userDidSelectSessionNotification:nil];   
    UIViewController *currentTopVC = [navController topViewController];
    STAssertFalse([currentTopVC isEqual: sut], @"New view controller should be pushed onto the stack");
}

- (void)testSelectingSessionShouldSelectDifferentHMRI99ViewControllerAsTopViewController
{
    [sut userDidSelectSessionNotification:nil];
    UIViewController *currentTopVC = [navController topViewController];
    STAssertTrue([currentTopVC isKindOfClass:[HMRI99ViewController class]], @"New view controller should be of class HMRI99ViewController");
}

- (void)testNewViewControllerHasAMeasurementListDataSourceForTheSelectedSession
{
    Session *cargillSession = [[Session alloc] initWithName:@"CARG.13.01"
                                                                                 date:[NSDate date]
                                                                             location:@"Zaandam"
                                                                             engineer:@"HKu"];
    NSNotification *cargillSessionSelectedNotification = [NSNotification notificationWithName: sessionsTableDidSelectSessionNotification
                                      object: cargillSession];
    [sut userDidSelectSessionNotification: cargillSessionSelectedNotification];
    HMRI99ViewController *nextViewController = (HMRI99ViewController *)navController.topViewController;
    STAssertTrue([nextViewController.dataSource isKindOfClass: [MeasurementsTableViewDataSource class]], @"Selecting a Measurement Session should push a list of Measurements");
    STAssertEqualObjects([(MeasurementsTableViewDataSource *)
                          nextViewController.dataSource session], cargillSession,
                         @"The Measurements to display should come from the selected Measurement Session");
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidAddSessionNotification object: nil
                                                      userInfo: nil];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerReceivesTableAddedNotificationAfterViewDidAppear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidAddSessionNotification object: nil userInfo: nil];
    
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
    [self swapInstanceMethods];
}

- (void)testViewControllerDoesNotReceiveTableAddedNotificationAfterViewWillDisappear
{
    [self swapInstanceMethods];
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName: sessionsTableDidAddSessionNotification
                                                        object: nil
                                                      userInfo: nil];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
    [self swapInstanceMethods];
}

//- (void)testReceivingTableAddedNotificationAddsRowToTableView
//{
//    [sut viewDidAppear: NO];
//    [dataSource addSession];
//    
////    int numberOfRows2=[[sut tableView] numberOfRowsInSection:0];
////    
////    NSLog(@"+++++++++++%d and %d",numberOfRows1,numberOfRows2);
//    assertThat([NSNumber numberWithInt:[[sut tableView] numberOfRowsInSection:0]], is(@5));
//    
//    // why is addSession not recognized?
//    //userDidAddSessionNotification already implemented
//}





#pragma mark Helper methods
- (void)swapInstanceMethods
{
    [HMRI99ViewControllerTests swapInstanceMethodsForClass: [HMRI99ViewController class]
                                                  selector: realUserDidSelectSession
                                               andSelector: testUserDidSelectSession];
    [HMRI99ViewControllerTests swapInstanceMethodsForClass: [HMRI99ViewController class]
                                                  selector: realUserDidAddSession
                                               andSelector: testUserDidAddSession];
}



@end
