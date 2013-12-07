    // Class under test
#import "MeasurementsTableViewDataSource.h"
#import "Session.h"
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
    Session * session;
    Measurement * measurement1;
    Measurement * measurement2;
    NSIndexPath * firstCell;
}

- (void) setUp
{
    [super setUp];
    sut= [[MeasurementsTableViewDataSource alloc] init];
    session =[[Session alloc] initWithName: @"CARG.13.01"
                                                           date:[NSDate date]
                                                       location:@"Zaandam"
                                                       engineer:@"HKu"];
    measurement1=[[Measurement alloc] initWithID:@"R1"];
    measurement2=[[Measurement alloc] initWithID:@"R2"];
    sut.session=session;
    firstCell = [NSIndexPath indexPathForRow: 0 inSection: 0];
}

- (void) tearDown
{
    sut=nil;
    session=nil;
    measurement1=nil;
    measurement2=nil;
    firstCell=nil;
    [super tearDown];
}

//- (void) testMeasurementSummaryCellShouldBeConnected
//{
//    assertThat([sut summaryCell], is(notNilValue()));
//}

- (void)testSessionWithNoMeasurementsLeadsToOneRowInTheTableStatingNoMeasurementsYet
{
    assertThatInt([sut tableView: nil numberOfRowsInSection: 0], is(equalTo(@1)));
}

- (void)testSessionWithMeasurementsResultsInOneRowPerMeasurementInTheTable
{
    
    [session addMeasurement: measurement1];
    [session addMeasurement: measurement2];
    assertThatInt([sut tableView: nil numberOfRowsInSection: 0], is(equalTo(@2)));
}

- (void)testCellIDIsTheSameAsTheMeasurementID
{
    [session addMeasurement: measurement1];
    MeasurementSummaryCell *cell = (MeasurementSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstCell] ;
    assertThat(cell.iDLabel.text, is(equalTo(@"R1")));
}



@end
