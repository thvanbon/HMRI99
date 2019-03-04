    // Class under test
#import "SessionDetailsViewController.h"

    // Collaborators
#import "SessionDetailsDataSource.h"

    // Test support
#import <objc/runtime.h>
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface SessionDetailsViewControllerTests : XCTestCase
@end

@implementation SessionDetailsViewControllerTests
{
    SessionDetailsViewController * sut;
    UITableView *tableView;
    SessionDetailsDataSource * dataSource;
}

- (void) setUp
{
    [super setUp];
    sut=[[SessionDetailsViewController alloc]init];
    tableView=[[UITableView alloc] init];
    dataSource=[[SessionDetailsDataSource alloc]init];
    sut.tableView=tableView;
    sut.dataSource=dataSource;
}

- (void) tearDown
{
    sut=nil;
    tableView=nil;
    dataSource=nil;
    [super tearDown];
}

- (void) testViewIsConnected
{
    XCTAssertNoThrow([sut view], @"Nib needs to be connected to right class" );
}

- (void) testViewControllerHasATableView
{
    objc_property_t tableViewProperty = class_getProperty([sut class], "tableView");
    XCTAssertTrue(tableViewProperty != NULL, @"SessionDetailsViewController needs a table view");
}

- (void) testTableViewHasGroupedStyle
{
//    assertThat(sut.tableView.style
}


- (void)testViewControllerHasADataSourceProperty { objc_property_t dataSourceProperty =class_getProperty([sut class], "dataSource");
    XCTAssertTrue(dataSourceProperty != NULL, @"SessionDetailsViewController needs a data source");
}

- (void) testViewControllerConnectsDataSourceInViewDidLoad
{
    [sut viewDidLoad];
    assertThat([sut.tableView dataSource],is(equalTo(dataSource)));
}

- (void) testViewControllerConnectsDelegateInViewDidLoad
{
    [sut viewDidLoad];
    assertThat([tableView delegate],is(equalTo(dataSource)));
}

- (void) testNavigationControllerHasMeasurementTitle
{
    [sut viewDidLoad];
    assertThat([[sut navigationItem]title], is(equalTo(@"Session details")));
}

- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad
{
//    SessionDetailsDataSource *sessionDetailsDataSource = [[SessionDetailsDataSource alloc] init];
//    sut.dataSource = sessionDetailsDataSource;
    [sut viewDidLoad];
    XCTAssertEqualObjects(sut.dataSource.tableView, sut.tableView, @"Back-link to table view should be set in data source");
}
@end
