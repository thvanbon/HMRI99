    // Class under test
#import "HMRI99ViewController.h"

#import <objc/runtime.h>
#import "MeasurementSessionsTableViewDataSource.h"
//#import "MeasurementSessionsTableViewDelegate.h"

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

- (void)userDidSelectTopicNotification: (NSNotification *)note
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
}
- (void) setUp
{
    [super setUp];
    sut=[[HMRI99ViewController alloc] init];
    tableView = [[UITableView alloc] init];
    sut.tableView = tableView;
    dataSource=[[MeasurementSessionsTableViewDataSource alloc] init];
    sut.dataSource=dataSource;
    objc_removeAssociatedObjects(sut);
}

- (void) tearDown
{
    sut=nil;
    tableView=nil;
    dataSource=nil;
    receivedNotification=nil;
//    objc_removeAssociatedObjects(sut);
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

- (void)testDefaultStateOfViewControllerDoesNotReceiveNotifications {
    [[NSNotificationCenter defaultCenter] postNotificationName: measurementSessionsTableDidSelectMeasurementSessionNotification object: nil
                                                      userInfo: nil];
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(nilValue()));
}

- (void)testViewControllerReceivesTableSelectionNotificationAfterViewDidAppear
{
    [sut viewDidAppear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName: measurementSessionsTableDidSelectMeasurementSessionNotification object: nil userInfo: nil];
    
    assertThat(objc_getAssociatedObject(sut, notificationKey),is(notNilValue()));
}

- (void)testViewControllerDoesNotReceiveTableSelectNotificationAfterViewWillDisappear
{
    [sut viewDidAppear: NO];
    [sut viewWillDisappear: NO];
    [[NSNotificationCenter defaultCenter] postNotificationName: measurementSessionsTableDidSelectMeasurementSessionNotification
                                                        object: nil
                                                      userInfo: nil];
    assertThat(objc_getAssociatedObject(sut, notificationKey), is(nilValue()));
}

@end
