    // Class under test
#import "MeasurementDetailViewController.h"

    // Collaborators
#import <objc/runtime.h>
#import "MeasurementDetailTableViewDataSource.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementDetailViewControllerTests : SenTestCase
@end

@implementation MeasurementDetailViewControllerTests
{
    MeasurementDetailViewController * sut;
    UITableView *tableView;
    MeasurementDetailTableViewDataSource * dataSource;
}

- (void) setUp
{
    [super setUp];
    sut=[[MeasurementDetailViewController alloc]init];
    tableView=[[UITableView alloc] init];
    dataSource=[[MeasurementDetailTableViewDataSource alloc]init];
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
    STAssertNoThrow([sut view], @"Nib needs to be connected to right class" );
}

- (void) testViewControllerHasATableView
{
    objc_property_t tableViewProperty = class_getProperty([sut class], "tableView");
    STAssertTrue(tableViewProperty != NULL, @"MeasurementsViewController needs a table view");
}

- (void)testViewControllerHasADataSourceProperty { objc_property_t dataSourceProperty =class_getProperty([sut class], "dataSource");
    STAssertTrue(dataSourceProperty != NULL, @"MeasurementsViewController needs a data source");
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
    assertThat([[sut navigationItem]title], is(equalTo(@"Measurement details")));
}

- (void)testViewControllerConnectsTableViewBacklinkInViewDidLoad
{
    MeasurementDetailTableViewDataSource *measurementDetailTableViewDataSource = [[MeasurementDetailTableViewDataSource alloc] init];
    sut.dataSource = measurementDetailTableViewDataSource;
    [sut viewDidLoad];
    STAssertEqualObjects(measurementDetailTableViewDataSource.tableView, tableView, @"Back-link to table view should be set in data source");
}

@end
