    // Class under test
#import "HMRI99ViewController.h"

#import <objc/runtime.h>
#import "MeasurementSessionsTableViewDataSource.h"
#import "MeasurementsTableViewDataSource.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface HMRI99ViewControllerTests : SenTestCase
@end

static const char *notificationKey = "HMRI99ViewControllerTestsAssociatedNotificationKey";

@implementation HMRI99ViewController (TestNotificationDelivery)

- (void)hMRI99ControllerTests_userDidSelectMeasurementSessionNotification: (NSNotification *)note
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
    SEL realUserDidSelectMeasurementSession, testUserDidSelectMeasurementSession;
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
    dataSource=[[MeasurementSessionsTableViewDataSource alloc] init];
    sut.dataSource=dataSource;
    realUserDidSelectMeasurementSession = @selector(userDidSelectMeasurementSessionNotification:);
    testUserDidSelectMeasurementSession = @selector(hMRI99ControllerTests_userDidSelectMeasurementSessionNotification:);
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

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications {
    [HMRI99ViewControllerTests swapInstanceMethodsForClass: [HMRI99ViewController class]
     selector: realUserDidSelectMeasurementSession
     andSelector: testUserDidSelectMeasurementSession];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: measurementSessionsTableDidSelectMeasurementSessionNotification object: nil
                                                      userInfo: nil];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
    [HMRI99ViewControllerTests swapInstanceMethodsForClass: [HMRI99ViewController class]
                                                  selector: realUserDidSelectMeasurementSession
                                               andSelector: testUserDidSelectMeasurementSession];
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear
{
    [HMRI99ViewControllerTests swapInstanceMethodsForClass: [HMRI99ViewController class]
                                                  selector: realUserDidSelectMeasurementSession
                                               andSelector: testUserDidSelectMeasurementSession];
    [sut viewDidAppear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName: measurementSessionsTableDidSelectMeasurementSessionNotification object: nil userInfo: nil];
    
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
    [HMRI99ViewControllerTests swapInstanceMethodsForClass: [HMRI99ViewController class]
                                                  selector: realUserDidSelectMeasurementSession
                                               andSelector: testUserDidSelectMeasurementSession];
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear
{
    [HMRI99ViewControllerTests swapInstanceMethodsForClass: [HMRI99ViewController class]
                                                  selector: realUserDidSelectMeasurementSession
                                               andSelector: testUserDidSelectMeasurementSession];
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName: measurementSessionsTableDidSelectMeasurementSessionNotification
                                                        object: nil
                                                      userInfo: nil];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
    [HMRI99ViewControllerTests swapInstanceMethodsForClass: [HMRI99ViewController class]
                                                  selector: realUserDidSelectMeasurementSession
                                               andSelector: testUserDidSelectMeasurementSession];
}

- (void)testSelectingMeasurementSessionDeselectsHMRI99ViewControllerAsTopViewController
{
    [sut userDidSelectMeasurementSessionNotification:nil];   
    UIViewController *currentTopVC = [navController topViewController];
    STAssertFalse([currentTopVC isEqual: sut], @"New view controller should be pushed onto the stack");
}

- (void)testSelectingMeasurementSessionShouldSelectDifferentHMRI99ViewControllerAsTopViewController
{
    [sut userDidSelectMeasurementSessionNotification:nil];
    UIViewController *currentTopVC = [navController topViewController];
    STAssertTrue([currentTopVC isKindOfClass:[HMRI99ViewController class]], @"New view controller should be of class HMRI99ViewController");
}

- (void)testNewViewControllerHasAMeasurementListDataSourceForTheSelectedMeasurementSession
{
    MeasurementSession *CargillMeasurementSession = [[MeasurementSession alloc] initWithName:@"CARG.13.01"
                                                                                 date:[NSDate date]
                                                                             location:@"Zaandam"
                                                                             engineer:@"HKu"];
    NSNotification *CargillMeasurementSessionSelectedNotification = [NSNotification notificationWithName: measurementSessionsTableDidSelectMeasurementSessionNotification
                                      object: CargillMeasurementSession];
    [sut userDidSelectMeasurementSessionNotification: CargillMeasurementSessionSelectedNotification];
    HMRI99ViewController *nextViewController = (HMRI99ViewController *)navController.topViewController;
    STAssertTrue([nextViewController.dataSource isKindOfClass: [MeasurementsTableViewDataSource class]], @"Selecting a Measurement Session should push a list of Measurements");
    STAssertEqualObjects([(MeasurementsTableViewDataSource *)
                          nextViewController.dataSource measurementSession], CargillMeasurementSession,
                         @"The Measurements to display should come from the selected Measurement Session");
}

- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad
{
    MeasurementsTableViewDataSource *measurementsTableViewDataSource = [[MeasurementsTableViewDataSource alloc] init];
    sut.dataSource = measurementsTableViewDataSource;
    [sut viewDidLoad];
    STAssertEqualObjects(measurementsTableViewDataSource.tableView, tableView, @"Back-link to table view should be set in data source");
}

@end
