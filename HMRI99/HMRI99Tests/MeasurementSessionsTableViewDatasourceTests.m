    // Class under test
#import "MeasurementSessionsTableViewDataSource.h"

    // Collaborators
#import "MeasurementSession.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementSessionsTableViewDataSourceTests : SenTestCase
@end

@implementation MeasurementSessionsTableViewDataSourceTests
{
    MeasurementSessionsTableViewDataSource * sut;
    MeasurementSession * sampleMeasurementSession;
    NSArray * MeasurementSessions;
}

- (void) setUp
{
    [super setUp];
    sut=[[MeasurementSessionsTableViewDataSource alloc] init];    
    sampleMeasurementSession=[[MeasurementSession alloc] initWithName:@"CARG.13.01"
                                                                                             date:[NSDate date]
                                                                                         location:@"Zaandam"
                                                                                         engineer:@"HKa"];
    MeasurementSessions=[NSArray arrayWithObject:sampleMeasurementSession];
}

- (void) tearDown
{
    sut=nil;
    sampleMeasurementSession=nil;
    MeasurementSessions=nil;
    [super tearDown];
}

- (void) testMeasurementSessionsDataSourceCanReceiveAListOfMeasurementSessions
{
    STAssertNoThrow([sut setMeasurementSessions:MeasurementSessions], @"The data source needs a list of measurement sessions");
}

- (void) testOneRowForOneMeasurementSession
{
    [sut setMeasurementSessions:MeasurementSessions];
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo([NSNumber numberWithInt:[MeasurementSessions count]])));
}

- (void) testTwoRowsForTwoMeasurementSessions
{
    MeasurementSessions=[NSArray arrayWithObjects:sampleMeasurementSession,sampleMeasurementSession,nil];
    [sut setMeasurementSessions:MeasurementSessions];
    assertThat([NSNumber numberWithInt:[sut tableView:nil numberOfRowsInSection:0]],is(equalTo([NSNumber numberWithInt:[MeasurementSessions count]])));
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

- (void)testDataSourceCellCreationWillNotCreateMoreRowsThanItHasMeasurementSessions
{
    NSIndexPath * afterLastMeasurementSession=[NSIndexPath indexPathForItem:[MeasurementSessions count] inSection:0];
    STAssertThrows([sut tableView:nil cellForRowAtIndexPath:afterLastMeasurementSession], @"Data source will not prepare more cells than existing MeasurementSessions");
}

- (void)testCellCreatedByDataSourceContainsMeasurementSessionNameAsTextLabel
{
    [sut setMeasurementSessions:MeasurementSessions];
    NSIndexPath *firstMeasurementSession = [NSIndexPath indexPathForRow: 0 inSection: 0];
    UITableViewCell *firstCell = [sut tableView: nil cellForRowAtIndexPath: firstMeasurementSession];
    NSString *cellTitle = firstCell.textLabel.text;
    assertThat(cellTitle, is(equalTo(@"CARG.13.01")));
}

@end
