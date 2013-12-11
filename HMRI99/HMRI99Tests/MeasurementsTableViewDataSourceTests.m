    // Class under test
#import "MeasurementsTableViewDataSource.h"
#import "Session.h"
#import "Measurement.h"
#import "MeasurementSummaryCell.h"
#import "SessionSummaryCell.h"

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
    NSDate * myDate;
    Measurement * measurement1;
    Measurement * measurement2;
    NSMutableArray * measurements;
    NSIndexPath * firstIndexPath;
    NSIndexPath * firstIndexPathSecondSection;
    NSIndexPath * firstIndexPathThirdSection;
    SessionSummaryCell *firstCellFirstSection;
    
    NSNotification * receivedNotification;
}

- (void) setUp
{
    [super setUp];
    sut= [[MeasurementsTableViewDataSource alloc] init];
    myDate=[NSDate dateWithTimeIntervalSinceNow:0.0f];
    session =[[Session alloc] initWithName: @"CARG.13.01"
                                                           date:myDate
                                                       location:@"Zaandam"
                                                       engineer:@"HKu"];
    measurement1=[[Measurement alloc] initWithID:@"R1"];
    measurement2=[[Measurement alloc] initWithID:@"R2"];
    measurements=[NSMutableArray arrayWithObjects:measurement1,measurement2,nil];
    sut.session=session;
    firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    firstIndexPathSecondSection = [NSIndexPath indexPathForRow: 0 inSection: 1];
    firstIndexPathThirdSection= [NSIndexPath indexPathForRow: 0 inSection: 2];
    firstCellFirstSection = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveNotification:)
                                                 name: measurementsTableDidSelectMeasurementNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveNotification:)
                                                 name: measurementsTableDidAddMeasurementNotification
                                               object: nil];
}

- (void) tearDown
{
    sut=nil;
    session=nil;
    myDate=nil;
    measurement1=nil;
    measurement2=nil;
    measurements=nil;
    firstIndexPath=nil;
    firstIndexPathSecondSection=nil;
    firstIndexPathThirdSection=nil;
    firstCellFirstSection=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    receivedNotification=nil;
    [super tearDown];
}

//- (void) testMeasurementSummaryCellShouldBeConnected
//{
//    assertThat([sut summaryCell], is(notNilValue()));
//}
- (void)testSessionWithMeasurementsResultsInOnlyOneRowInSectionOneInTheTable
{
    [session addMeasurement: measurement1];
    [session addMeasurement: measurement2];
    assertThatInt([sut tableView: nil numberOfRowsInSection: 0], is(equalTo(@1)));
}

- (void) testCellInSectionOneContainsSessionInformation
{
    assertThat(firstCellFirstSection.nameTextField.text,is(equalTo(@"CARG.13.01")));
}

- (void)testSessionWithNoMeasurementsLeadsToOneRowInThirdSectionOfTheTableStatingNoMeasurementsYet
{
    UITableViewCell *cellThirdSection=[sut tableView:nil cellForRowAtIndexPath:firstIndexPathThirdSection];
    assertThatInt([sut tableView: nil numberOfRowsInSection:2], is(equalTo(@1)));
    assertThat(cellThirdSection.textLabel.text, is(equalTo(@"No Measurements yet!")));
}

- (void)testSessionWithMeasurementsResultsInOneRowPerMeasurementInSectionTwoInTheTable
{
    [session addMeasurement: measurement1];
    [session addMeasurement: measurement2];
    assertThatInt([sut tableView: nil numberOfRowsInSection: 1], is(equalTo(@2)));
}

- (void)testCellIDIsTheSameAsTheMeasurementID
{
    [session addMeasurement: measurement1];
    MeasurementSummaryCell *cellSecondSection = (MeasurementSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPathSecondSection] ;
    assertThat(cellSecondSection.iDLabel.text, is(equalTo(@"R1")));
}

- (void) testMeasurementsDataSourceCanReceiveAListOfMeasurements
{
    STAssertNoThrow([sut setMeasurements:measurements], @"The data source needs a list of measurements");
}

- (void) testOneRowForOneMeasurement
{
    NSMutableArray * measurementsWithOneMeasurement=[NSMutableArray arrayWithObject:measurement1];
    [sut setMeasurements:measurementsWithOneMeasurement];
    assertThatInt([sut tableView:nil numberOfRowsInSection:1],is(equalToInt(1)));
    measurementsWithOneMeasurement=nil;
}

- (void) testTwoRowsForTwoMeasurements
{
    [sut setMeasurements:measurements];
    assertThatInt([sut tableView:nil numberOfRowsInSection:1],is(equalToInt(2)));
}

- (void)testDataSourceCellCreationExpectsThreeSections
{
        NSIndexPath *fourthSection = [NSIndexPath indexPathForRow: 1 inSection: 3];
    STAssertThrows([sut tableView:nil cellForRowAtIndexPath:fourthSection], @"Data source will not prepare cells for non existing sections");
}

- (void)testDataSourceDoesNotCreateMoreCellsThanMeasurements
{
    [sut setMeasurements:measurements];
    NSIndexPath * thirdCellSecondSection= [NSIndexPath indexPathForRow: 2 inSection: 1];
    STAssertThrows([sut tableView:nil cellForRowAtIndexPath:thirdCellSecondSection], @"Data source will not prepare more cells than Measurements");
}

-(void)testDataSourceSendsNotificationWhenMeasurementIsSelected
{
    NSIndexPath * selection=[NSIndexPath indexPathForRow:0 inSection:1];
    [sut tableView:nil didSelectRowAtIndexPath:selection];
    assertThat([receivedNotification name], is(equalTo(measurementsTableDidSelectMeasurementNotification)));
}

-(void)testDataSourceSendsNotificationWithMeasurementWhenMeasurementIsSelected
{
    NSIndexPath * selection=[NSIndexPath indexPathForRow:0 inSection:1];
    [sut tableView:nil didSelectRowAtIndexPath:selection];
    assertThat([receivedNotification name], is(equalTo(measurementsTableDidSelectMeasurementNotification)));
}

- (void) testMeasurementCanBeAddedToDataSource
{
    STAssertNoThrow([sut addMeasurement], @"The data source should be able to receive an extra measurement");
}

-(void)testDataSourceSendsNotificationWhenMeasurementIsAdded
{
    [sut addMeasurement];
    assertThat([receivedNotification name], is(equalTo(measurementsTableDidAddMeasurementNotification)));
}

- (void)testCellHasSessionNameLabel
{
    assertThat(firstCellFirstSection.nameLabel.text, is(equalTo(@"Project Name")));
}

- (void)testCellHasSessionDateLabel
{
    assertThat(firstCellFirstSection.dateLabel.text, is(equalTo(@"Date")));
}

- (void)testCellHasSessionEngineerLabel
{
    assertThat(firstCellFirstSection.engineerLabel.text, is(equalTo(@"Engineer")));
}

- (void)testCellHasSessionNameTextField
{
    assertThat(firstCellFirstSection.nameTextField.text, is(equalTo(@"CARG.13.01")));
}

- (void)testCellHasSessionDateTextField
{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
    assertThat(firstCellFirstSection.dateTextField.text, is(equalTo([NSString stringWithFormat:@"%@", stringFromDate])));
}

- (void)testCellHasSessionLocationTextField
{
    assertThat(firstCellFirstSection.locationTextField.text, is(equalTo(@"Zaandam")));
}

- (void)testCellHasSessionEngineerTextField
{
    assertThat(firstCellFirstSection.engineerTextField.text, is(equalTo(@"HKu")));
}

- (void)testHeightOfTheSessionRowIsAtLeastTheSameAsTheHeightOfTheCell
{
    NSInteger height = [sut tableView: nil heightForRowAtIndexPath: firstIndexPath];
    assertThatFloat(height,is(greaterThanOrEqualTo([NSNumber numberWithFloat:firstCellFirstSection.frame.size.height])));
}

- (void)testHeightOfAMeasurementRowIsAtLeastTheSameAsTheHeightOfTheCell
{
    [session addMeasurement: measurement1];
    NSInteger height = [sut tableView: nil heightForRowAtIndexPath: firstIndexPathSecondSection];
    MeasurementSummaryCell * firstCellSecondSection=(MeasurementSummaryCell*) [sut tableView:nil cellForRowAtIndexPath:firstIndexPathSecondSection];
    assertThatFloat(height,is(greaterThanOrEqualTo([NSNumber numberWithFloat:firstCellSecondSection.frame.size.height])));
}

- (void) testChangingNameTextFieldUpdatesSessionName
{
    firstCellFirstSection.nameTextField.text=@"ABC14.01";
    assertThat([[sut session] name],is(equalTo(@"ABC14.01")));
}
#pragma mark helper methods

- (void) didReceiveNotification:(NSNotification *) myNote
{
    receivedNotification=myNote;
}
@end
