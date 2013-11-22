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

@implementation HMRI99ViewControllerTests
{
    HMRI99ViewController * sut;
    UITableView *tableView;
    id <UITableViewDataSource, UITableViewDelegate> dataSource;
}
- (void) setUp
{
    [super setUp];
    sut=[[HMRI99ViewController alloc] init];
    tableView = [[UITableView alloc] init];
    sut.tableView = tableView;
    dataSource=[[MeasurementSessionsTableViewDataSource alloc] init];
    sut.dataSource=dataSource;
}

- (void) tearDown
{
    sut=nil;
    tableView=nil;
    dataSource=nil;
    //delegate=nil;
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

@end
