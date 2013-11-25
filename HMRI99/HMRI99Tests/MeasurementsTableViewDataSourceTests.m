    // Class under test
#import "MeasurementsTableViewDataSource.h"
#import "MeasurementSession.h"
#import "Measurement.h"
#import "MeasurementSummaryCell.h"

    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementsTableViewDataSourceTests : SenTestCase
@end

@implementation MeasurementsTableViewDataSourceTests
{
    MeasurementsTableViewDataSource * sut;
    MeasurementSession * measurementSession;
    Measurement * measurement1;
    Measurement * measurement2;
    NSIndexPath * firstCell;
}

- (void) setUp
{
    [super setUp];
    sut= [[MeasurementsTableViewDataSource alloc] init];
    measurementSession =[[MeasurementSession alloc] initWithName: @"CARG.13.01"
                                                           date:[NSDate date]
                                                       location:@"Zaandam"
                                                       engineer:@"HKu"];
    measurement1=[[Measurement alloc] initWithID:@"R1"];
    measurement2=[[Measurement alloc] initWithID:@"R2"];
    sut.measurementSession=measurementSession;
    firstCell = [NSIndexPath indexPathForRow: 0 inSection: 0];
}

- (void) tearDown
{
    sut=nil;
    measurementSession=nil;
    measurement1=nil;
    measurement2=nil;
    firstCell=nil;
    [super tearDown];
}

- (void)testMeasurementSessionWithNoMeasurementsLeadsToOneRowInTheTableStatingNoMeasurementsYet
{
    assertThatInt([sut tableView: nil numberOfRowsInSection: 0], is(equalTo(@1)));
}

- (void)testMeasurementSessionWithMeasurementsResultsInOneRowPerMeasurementInTheTable
{
    
    [measurementSession addMeasurement: measurement1];
    [measurementSession addMeasurement: measurement2];
    assertThatInt([sut tableView: nil numberOfRowsInSection: 0], is(equalTo(@2)));
}

- (void)testCellIDIsTheSameAsTheMeasurementID
{
    [measurementSession addMeasurement: measurement1];
    MeasurementSummaryCell *cell = (MeasurementSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstCell] ;
    assertThat(cell.iDLabel.text, is(equalTo(@"R1")));
}

@end
