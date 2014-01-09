// Class under test
#import "MeasurementsTableViewDataSource.h"

// Collaborators
#import "Session.h"
#import "Measurement.h"
#import "MeasurementSummaryStaticCell.h"
//#import "SessionSummaryCell.h"
#import "MeasurementsViewController.h"

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
    NSDateFormatter *formatter;
    Measurement * measurement1;
    Measurement * measurement2;
    NSMutableArray * measurements;
    NSIndexPath * firstIndexPath;
    NSIndexPath * firstIndexPathSecondSection;
    NSIndexPath * firstIndexPathThirdSection;
    MeasurementSummaryStaticCell *firstCell;
    
    NSNotification * receivedNotification;
}

- (void) setUp
{
    [super setUp];
    sut= [[MeasurementsTableViewDataSource alloc] init];
    myDate=[NSDate dateWithTimeIntervalSinceNow:0.0f];
    formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
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
    firstCell = (MeasurementSummaryStaticCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
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
    formatter=nil;
    measurement1=nil;
    measurement2=nil;
    measurements=nil;
    firstIndexPath=nil;
    firstIndexPathSecondSection=nil;
    firstIndexPathThirdSection=nil;
    firstCell=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    receivedNotification=nil;
    [super tearDown];
}

//- (void) testMeasurementSummaryCellShouldBeConnected
//{
//    assertThat([sut summaryCell], is(notNilValue()));
//}
- (void)testSessionWithOneMeasurementsResultsInOnlyOneRowInTheTable
{
    [session addMeasurement: measurement1];
    assertThatInt([sut tableView: nil numberOfRowsInSection: 0], is(equalTo(@1)));
}

//- (void) testCellInSectionOneContainsSessionInformation
//{
//    assertThat(firstCellFirstSection.nameTextField.text,is(equalTo(@"CARG.13.01")));
//}

//- (void)testSessionWithNoMeasurementsLeadsToOneRowInThirdSectionOfTheTableStatingNoMeasurementsYet
//{
//    UITableViewCell *cellThirdSection=[sut tableView:nil cellForRowAtIndexPath:firstIndexPathThirdSection];
//    assertThatInt([sut tableView: nil numberOfRowsInSection:2], is(equalTo(@1)));
//    assertThat(cellThirdSection.textLabel.text, is(equalTo(@"No measurements yet!")));
//}

- (void)testSessionWithMeasurementsResultsInOneRowPerMeasurementInTheTable
{
    [session addMeasurement: measurement1];
    [session addMeasurement: measurement2];
    assertThatInt([sut tableView: nil numberOfRowsInSection: 0], is(equalTo(@2)));
}

- (void) testCellAccessoryTypeIsDisclosureIndicator
{
    [session addMeasurement: measurement1];
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:nil cellForRowAtIndexPath:firstIndexPath];
    assertThatInt(cell.accessoryType, is(equalToInt(UITableViewCellAccessoryDisclosureIndicator)));
}

- (void)testCellIDIsTheSameAsTheMeasurementID
{
    [session addMeasurement: measurement1];
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:nil cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.iDLabel.text, is(equalTo(@"R1")));
}

- (void)testCellTypeIsTheSameAsTheMeasurementType
{
    [session addMeasurement: measurement1];
    measurement1.type=@"II.2";
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:nil cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.measurementTypeLabel.text, is(equalTo(@"II.2")));
}

- (void)testCellNameIsTheSameAsTheMeasurementName
{
    [session addMeasurement: measurement1];
    measurement1.noiseSource.name=@"shovel";
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:nil cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.nameLabel.text, is(equalTo(@"shovel")));
}

- (void)testCellLpIsTheSameAsTheMeasurementLp
{
    [session addMeasurement: measurement1];
    measurement1.soundPressureLevel=83.0f;
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:nil cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.soundPressureLevelLabel.text, is(equalTo(@"Lp = 83.0 dB(A)")));
}

- (void)testCellLwIsTheSameAsTheMeasurementLw
{
    [session addMeasurement: measurement1];
    measurement1.soundPowerLevel=105.0f;
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:nil cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.soundPowerLevelLabel.text, is(equalTo(@"Lw = 105.0 dB(A)")));
}

- (void) testMeasurementsDataSourceCanReceiveAListOfMeasurements
{
    STAssertNoThrow([sut setMeasurements:measurements], @"The data source needs a list of measurements");
}

//- (void) testOneRowForOneMeasurement
//{
//    NSMutableArray * measurementsWithOneMeasurement=[NSMutableArray arrayWithObject:measurement1];
//    [sut setMeasurements:measurementsWithOneMeasurement];
//    assertThatInt([sut tableView:nil numberOfRowsInSection:1],is(equalToInt(1)));
//    measurementsWithOneMeasurement=nil;
//}
//
//- (void) testTwoRowsForTwoMeasurements
//{
//    [sut setMeasurements:measurements];
//    assertThatInt([sut tableView:nil numberOfRowsInSection:1],is(equalToInt(2)));
//}

//- (void)testDataSourceCellContainsThreeSections
//{
//    assertThatInt([sut numberOfSectionsInTableView:nil], is(equalToInt(3)));
//}

//- (void)testDataSourceCellCreationExpectsThreeSections
//{
//    NSIndexPath *fourthSection = [NSIndexPath indexPathForRow: 1 inSection: 3];
//    STAssertThrows([sut tableView:nil cellForRowAtIndexPath:fourthSection], @"Data source will not prepare cells for non existing sections");
//}

- (void)testDataSourceDoesNotCreateMoreCellsThanMeasurements
{
    [sut setMeasurements:measurements];
    NSIndexPath * thirdCellSecondSection= [NSIndexPath indexPathForRow: 2 inSection: 1];
    STAssertThrows([sut tableView:nil cellForRowAtIndexPath:thirdCellSecondSection], @"Data source will not prepare more cells than Measurements");
}

-(void)testDataSourceSendsNotificationWhenMeasurementIsSelected
{
     [session addMeasurement: measurement1];
    NSIndexPath * selection=[NSIndexPath indexPathForRow:0 inSection:1];
    [sut tableView:nil didSelectRowAtIndexPath:selection];
    assertThat([receivedNotification name], is(equalTo(measurementsTableDidSelectMeasurementNotification)));
}

-(void)testDataSourceSendsNotificationWithMeasurementWhenMeasurementIsSelected
{
     [session addMeasurement: measurement1];
    [sut tableView:nil didSelectRowAtIndexPath:firstIndexPath];
    assertThat([(Measurement *)[receivedNotification object] ID], is(equalTo(@"R1")));
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
-(void)testDataSourceSendsNotificationWithMeasurementWhenMeasurementIsAdded
{
    [sut addMeasurement];
    assertThat([(Measurement *)[receivedNotification object] ID], is(equalTo(@"")));
}

//- (void)testCellHasEmptySessionNameTextFieldForNewSession
//{
//    Session *newSession=[[Session alloc] init];
//    sut.session=newSession;
//    SessionSummaryCell * firstCellFirstSectionForEmptySession = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
//    assertThat(firstCellFirstSectionForEmptySession.nameTextField.text, is(equalTo(@"")));
//}
//
//- (void)testCellHasTodaysDateTextFieldForNewSession
//{
//    Session *newSession=[[Session alloc] init];
//    sut.session=newSession;
//    SessionSummaryCell * firstCellFirstSectionForEmptySession = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
//    assertThat(firstCellFirstSectionForEmptySession.dateTextField.text, is(equalTo([self formatDate:[NSDate date]])));
//}
//
//- (void)testCellHasEmptySessionLocationTextFieldForNewSession
//{
//    Session *newSession=[[Session alloc] init];
//    sut.session=newSession;
//    SessionSummaryCell * firstCellFirstSectionForEmptySession = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
//    assertThat(firstCellFirstSectionForEmptySession.locationTextField.text, is(equalTo(@"")));
//}
//- (void)testCellHasEmptySessionEngineereTextFieldForNewSession
//{
//    Session *newSession=[[Session alloc] init];
//    sut.session=newSession;
//    SessionSummaryCell * firstCellFirstSectionForEmptySession = (SessionSummaryCell *)[sut tableView: nil cellForRowAtIndexPath: firstIndexPath];
//    assertThat(firstCellFirstSectionForEmptySession.engineerTextField.text, is(equalTo(@"")));
//}
//- (void)testCellHasSessionNameTextFieldContainingSessionName
//{
//    assertThat(firstCell.nameTextField.text, is(equalTo(@"CARG.13.01")));
//}
//
//- (void)testCellHasSessionDateTextFieldContainingSessionDate
//{
//    assertThat(firstCell.dateTextField.text, is(equalTo([self formatDate:myDate])));
//}
//
//- (void)testCellHasSessionLocationTextFieldContainingSessionLocation
//{
//    assertThat(firstCell.locationTextField.text, is(equalTo(@"Zaandam")));
//}
//
//- (void)testCellHasSessionEngineerTextFieldContainingSessionEngineer
//{
//    assertThat(firstCell.engineerTextField.text, is(equalTo(@"HKu")));
//}

//- (void)testHeightOfTheSessionRowIsAtLeastTheSameAsTheHeightOfTheCell
//{
//    NSInteger height = [sut tableView: nil heightForRowAtIndexPath: firstIndexPath];
//    assertThatFloat(height,is(greaterThanOrEqualTo([NSNumber numberWithFloat:firstCell.frame.size.height])));
//}

- (void)testHeightOfAMeasurementRowIsAtLeastTheSameAsTheHeightOfTheCell
{
    [session addMeasurement: measurement1];
    NSInteger height = [sut tableView: nil heightForRowAtIndexPath: firstIndexPathSecondSection];
    MeasurementSummaryStaticCell * firstCellSecondSection=(MeasurementSummaryStaticCell*) [sut tableView:nil cellForRowAtIndexPath:firstIndexPathSecondSection];
    assertThatFloat(height,is(greaterThanOrEqualTo([NSNumber numberWithFloat:firstCellSecondSection.frame.size.height])));
}

//
//
//
//- (void) testTextFieldDidBeginEditingIsImplemented
//{
//    assertThatBool([sut respondsToSelector:@selector(textFieldDidBeginEditing:)],is(equalToBool(YES)));
//}
//
//- (void) testTextFieldDidEndEditingIsImplemented
//{
//    assertThatBool([sut respondsToSelector:@selector(textFieldDidEndEditing:)],is(equalToBool(YES)));
//}
//- (void) testChangingNameTextFieldUpdatesSessionName
//{
//    [sut textFieldDidBeginEditing:firstCell.nameTextField];
//    firstCell.nameTextField.text=@"ABC14.01";
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:firstCell.nameTextField];
//    [sut textFieldDidEndEditing:firstCell.nameTextField];
//    assertThat([[sut session] name],is(equalTo(@"ABC14.01")));
//}
//
//- (void) testChangingDateTextFieldUpdatesSessionDate
//{
//    [sut textFieldDidBeginEditing:firstCell.dateTextField];
//    firstCell.dateTextField.text=@"17-12-2013";
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:firstCell.dateTextField];
//    [sut textFieldDidEndEditing:firstCell.dateTextField];
//    assertThat([[sut session] date],is(equalTo([formatter dateFromString:@"17-12-2013"])));
//}
//
//- (void) testChangingLocationTextFieldUpdatesSessionLocation
//{
//    [sut textFieldDidBeginEditing:firstCell.locationTextField];
//    firstCell.locationTextField.text=@"Amsterdam";
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:firstCell.locationTextField];
//    [sut textFieldDidEndEditing:firstCell.locationTextField];
//    assertThat([[sut session] location],is(equalTo(@"Amsterdam")));
//}
//
//- (void) testChangingEngineerTextFieldUpdatesSessionEngineer
//{
//    [sut textFieldDidBeginEditing:firstCell.engineerTextField];
//    firstCell.engineerTextField.text=@"ABc";
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:firstCell.engineerTextField];
//    [sut textFieldDidEndEditing:firstCell.engineerTextField];
//    assertThat([[sut session] engineer],is(equalTo(@"ABc")));
//}
//



#pragma mark helper methods

- (void) didReceiveNotification:(NSNotification *) myNote
{
    receivedNotification=myNote;
}

- (NSString *)formatDate:(NSDate *)myNewDate
{
    NSString *stringFromDate = [formatter stringFromDate:myNewDate];
    return stringFromDate;
}

@end
