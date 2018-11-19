    // Class under test
#import "MeasurementDetailTableViewDataSource.h"

    // Collaborators
#import "Measurement.h"
#import <CoreData/CoreData.h>
//#import "NoiseSource.h"

    // Test support
#import <XCTest/XCTest.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementDetailTableViewDataSourceTests : XCTestCase
@end

@implementation MeasurementDetailTableViewDataSourceTests

{
    MeasurementDetailTableViewDataSource * sut;
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
    
    Measurement *sampleMeasurement;
    UITextField *textField;
}

- (void)setUp
{
    [super setUp];
    sut=[[MeasurementDetailTableViewDataSource alloc] init];
    model = [NSManagedObjectModel mergedModelFromBundles: nil];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [ctx setPersistentStoreCoordinator: coord];
    
    sampleMeasurement=(Measurement*)[NSEntityDescription
                                     insertNewObjectForEntityForName:@"Measurement"
                                     inManagedObjectContext: ctx];
    sut.measurement=sampleMeasurement;
    NoiseSource * noiseSource=[NSEntityDescription
                               insertNewObjectForEntityForName:@"NoiseSource"
                               inManagedObjectContext: ctx];
    sampleMeasurement.noiseSource=noiseSource;
}

- (void)tearDown
{
    sampleMeasurement=nil;
    textField=nil;
    sut=nil;
    ctx = nil;
    NSError *error = nil;
    XCTAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
    [super tearDown];
}
// 00 ID
// 01 measurement device
// 02 Name
// 03 Image
// 04 gps coordinates
// 05 address
// 06 operating conditions
// 07 Lp
// 08 background noise correction
// 09 Type
// 10 Distance
// 11 Hemispherecorrection
// 12 Surface
// 13 Near field correction
// 14 Custom remarks to measurement
// 15 Lw



- (void)testThatEnvironmentWorks
{
    XCTAssertNotNil(store, @"no persistent store");
}

- (void) testNumberOfSectionsReturnsOne
{
    assertThatInt((int) [sut numberOfSectionsInTableView:sut.tableView],is(equalToInt(1)));
}

- (void) testNumberOfRowsReturnsSixteenForFirstSection
{
    assertThatInt((int) [sut tableView:[[UITableView alloc] init] numberOfRowsInSection:0],is(equalToInt(16)));
}

- (void) testObjectShouldConformToUITextFieldDelegate
{
    assertThat(sut, conformsTo(@protocol(UITextFieldDelegate)));
}

- (void) testTextFieldDidBeginEditingIsImplemented
{
    assertThatBool([sut respondsToSelector:@selector(textFieldDidBeginEditing:)],is(equalToLong(YES)));
}

- (void) testTextFieldDidEndEditingIsImplemented
{
    assertThatBool([sut respondsToSelector:@selector(textFieldDidEndEditing:)],is(equalToLong(YES)));
}

#pragma mark row 0

- (void) testRow0HasTextLabelID
{
    assertThat([[self textLabelForRow:0] text], is(equalTo(@"ID")));
}

- (void) testRow0HasTextFieldWithIDPlaceholder
{
    assertThat([[self textFieldForRow:0] placeholder], is(equalTo(@"eg. R5")));
}

- (void) testRow0HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:0]keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow0HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:0]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsIDTextFieldDelegate
{
    assertThat([[self textFieldForRow:0] delegate], is(equalTo(sut)));
}

- (void) testChangingIDTextFieldUpdatesMeasurementID
{
    [self updateRow:0 withInsertedSampleText:@"R4"];
    assertThat([[sut measurement] identification],is(equalTo(@"R4")));
}

- (void) testIDTextFieldShowsMeasurementID
{
    sut.measurement.identification=@"R2";
    assertThat([[self textFieldForRow:0] text], is(equalTo(@"R2")));
}

#pragma mark row 1
//
//- (void) testRow1HasTextLabelDevice
//{
//    assertThat([[self textLabelForRow:1] text], is(equalTo(@"Device")));
//}
//
//- (void) testRow1HasTextFieldWithDevicePlaceholder
//{
//    assertThat([[self textFieldForRow:1] placeholder], is(equalTo(@"eg. Rion NA28 - 41")));
//}
//
//- (void) testRow1HasTextFieldWithDefaultKeyboard
//{
//    assertThatInt([[self textFieldForRow:1]keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
//}
//
//- (void) testRow1HasTextFieldWithReturnKeyNext
//{
//    assertThatInt([[self textFieldForRow:1]returnKeyType], is(equalToInt(UIReturnKeyNext)));
//}
//
//- (void) testObjectShouldBeSetAsDeviceTextFieldDelegate
//{
//    assertThat([[self textFieldForRow:1] delegate], is(equalTo(sut)));
//}
//
//- (void) testChangingDeviceTextFieldUpdatesMeasurementDevice
//{
//    [self updateRow:1 withInsertedSampleText:@"Rion NA28 - 45"];
//    assertThat([[sut measurement] measurementDevice],is(equalTo(@"Rion NA28 - 45")));
//}
//
//- (void) testDeviceTextFieldShowsMeasurementDevice
//{
//    sut.measurement.measurementDevice=@"Rion NA28 - 77";
//    assertThat([[self textFieldForRow:1] text], is(equalTo(@"Rion NA28 - 77")));
//}

# pragma mark row 2

- (void) testRow2HasTextLabelName
{
    assertThat([[self textLabelForRow:2] text], is(equalTo(@"Name")));
}

- (void) testRow2HasTextFieldWithNamePlaceholder
{
    assertThat([[self textFieldForRow:2] placeholder], is(equalTo(@"eg. compressor")));
}

- (void) testRow2HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:2] keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow2HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:2]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsNameTextFieldDelegate
{
    assertThat([[self textFieldForRow:2] delegate], is(equalTo(sut)));
}

- (void) testChangingNameTextFieldUpdatesMeasurementName
{
    [self updateRow:2 withInsertedSampleText:@"compressor"];
    assertThat([[[sut measurement] noiseSource] name],is(equalTo(@"compressor")));
}

- (void) testNameTextFieldShowsMeasurementName
{
    sut.measurement.noiseSource.name=@"shovel";
    assertThat([[self textFieldForRow:2] text], is(equalTo(@"shovel")));
}

#pragma mark row 3

- (void) testRow3HasTextLabelImage
{
    assertThat([[self textLabelForRow:3] text], is(equalTo(@"Image")));
}

- (void) testRow3TextFieldIsDisabled
{
    UITextField * myTextField=(UITextField *)[self textFieldForRow:3];
    assertThatBool(myTextField.enabled, is(equalToLong(NO)));
}

- (void) testRow3ContainsAButtonWithHeight60
{
    UITableViewCell *imageCell=[self cellForRow:3];
    UIButton *imageButton=(UIButton*)[imageCell viewWithTag:333];
    assertThatFloat(imageButton.frame.size.height, is(equalToFloat(60.0f)));
}

- (void) testRow3HasHeightGreaterThanImageButtonHeight
{
    UITableViewCell *imageCell=[self cellForRow:3];
    UIButton *imageButton=(UIButton*)[imageCell viewWithTag:333];
    assertThat([NSNumber numberWithFloat: imageButton.frame.size.height], is(lessThan([NSNumber numberWithFloat:(float)[sut tableView:sut.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]])));
}

- (void) testRow3ButtonClickedSendsAlert
{
}

- (void) testRow3ButtonShowsSelectedImage
{
}



#pragma mark row 7

- (void) testRow7HasTextLabelLp
{
    assertThat([[self textLabelForRow:7] text], is(equalTo(@"Lp")));
}

- (void) testRow7HasTextFieldWithSoundPressureLevelPlaceholder
{
    assertThat([[self textFieldForRow:7]placeholder], is(equalTo(@"eg. 88")));
}

- (void) testRow7HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:7] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow7HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:7] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsLpTextFieldDelegate
{
    assertThat([[self textFieldForRow:7] delegate], is(equalTo(sut)));
}

- (void) testChangingLpTextFieldUpdatesMeasurementLp
{
    [self updateRow:7 withInsertedSampleText:@"88"];
    assertThatFloat([[sut measurement] soundPressureLevel],is(equalToFloat(88.0f)));
}

- (void) testLpTextFieldShowsMeasurementLp
{
    sut.measurement.soundPressureLevel=83.0f;
    assertThat([[self textFieldForRow:7] text], is(equalTo(@"83.0")));
}

#pragma mark row 9

- (void) testRow9HasTextLabelType
{
    assertThat([[self textLabelForRow:9] text], is(equalTo(@"Type")));
}

- (void) testChangingTypeSegmentedControlUpdatesMeasurementType
{
    UISegmentedControl * measurementTypeControl=(UISegmentedControl *)[[self cellForRow:9] viewWithTag:20];
    measurementTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:measurementTypeControl];
    assertThat([[sut measurement] type],is(equalTo(@"II.3")));
}

- (void) testTypeSegmentedControlShowsMeasurementType
{
    sut.measurement.type=@"II.3";
    assertThatInt((int) [(UISegmentedControl *)[[self cellForRow:9] viewWithTag:20]selectedSegmentIndex], is(equalToInt(1)));
}

#pragma mark row 10

- (void) testRow10HasTextLabelDistance
{
    assertThat([[self textLabelForRow:10] text], is(equalTo(@"Distance")));
}

- (void) testLabelRow10IsGreyWhenMeasurementTypeIsNotII2
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:10].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow10IsBlackWhenMeasurementTypeNotII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:10].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow10TextFieldIsEnabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:10].enabled, is(equalToLong(YES)));
}

- (void) testRow10TextFieldIsDisabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:10].enabled, is(equalToLong(NO)));
}

//- (void) testRow10IsHiddenWhenMeasurementTypeIsNotII2
//{
//    sut.measurement.type=@"II.3";
//    assertThatBool([self cellForRow:10].hidden, is(equalToLong(YES)));
//}
//
//- (void) testRow5IsNotHiddenWhenMeasurementTypeIsII2
//{
//    sut.measurement.type=@"II.2";
//    assertThatBool([self cellForRow:10].hidden, is(equalToLong(NO)));
//}

- (void) testRow10HasTextFieldWithDistancePlaceholder
{
    assertThat([[self textFieldForRow:10] placeholder], is(equalTo(@"in meters")));
}

- (void) testRow10HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:10] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow10HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:10] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsDistanceTextFieldDelegate
{
    assertThat([[self textFieldForRow:10] delegate], is(equalTo(sut)));
}

- (void) testChangingDistanceTextFieldUpdatesMeasurementDistance
{
    [self updateRow:10 withInsertedSampleText:@"23"];
    assertThatFloat([[sut measurement] distance],is(equalToFloat(23.0f)));
}

- (void) testDistanceTextFieldShowsMeasurementDistance
{
    sut.measurement.distance=7.0f;
    assertThat([[self textFieldForRow:10] text], is(equalTo(@"7.0")));
}

#pragma mark row 12

- (void) testRow12HasTextLabelMeasurementSurface
{
    assertThat([[self textLabelForRow:12] text], is(equalTo(@"Surface")));
}

- (void) testLabelRow12IsGreyWhenMeasurementTypeIsNotII3
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:12].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow12IsBlackWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:12].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow12TextFieldIsEnabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:12].enabled, is(equalToLong(YES)));
}

- (void) testRow12TextFieldIsDisabledWhenMeasurementTypeIsNotII3
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:12].enabled, is(equalToLong(NO)));
}

- (void) testRow12HasTextFieldWithSurfacePlaceholder
{
    assertThat([[self textFieldForRow:12] placeholder], is(equalTo(@"in m2")));
}

- (void) testRow12HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:12] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow12HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:12] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsSurfaceTextFieldDelegate
{
    assertThat([[self textFieldForRow:12] delegate], is(equalTo(sut)));
}

- (void) testChangingSurfaceTextFieldUpdatesMeasurementSurface
{
    sut.measurement.type=@"II.3";    
    [self updateRow:12 withInsertedSampleText:@"23"];
    assertThatFloat([[sut measurement] surfaceArea],is(equalToFloat(23.0f)));
}

- (void) testSurfaceTextFieldShowsMeasurementSurfaceArea
{
    sut.measurement.surfaceArea=7.0f;
    assertThat([[self textFieldForRow:12] text], is(equalTo(@"7.0")));
}

#pragma mark row 13

- (void) testRow13HasTextLabelMeasurementNearFieldCorrection
{
    assertThat([[self textLabelForRow:13] text], is(equalTo(@"Near f. corr.")));
}

- (void) testLabelRow13IsGreyWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:13].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow13IsBlackWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:13].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow13SegmentedControlIsEnabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:13] viewWithTag:21];
    assertThatBool(segmentedControl.enabled, is(equalToLong(YES)));
}

- (void) testRow13SegmentedControlIsDisabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:13] viewWithTag:11];
    assertThatBool(segmentedControl.enabled, is(equalToLong(NO)));
}

- (void) testObjectShouldBeSetAsNearFieldCorrectionTextFieldDelegate
{
    assertThat([[self textFieldForRow:13] delegate], is(equalTo(sut)));
}

- (void) testChangingNearFieldCorrectionSegmentedControlUpdatesNearFieldCorrection
{
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:13] viewWithTag:21];
    segmentedControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:segmentedControl];
    assertThatInt([[sut measurement] nearFieldCorrection],is(equalToInt(-1)));
}

- (void) testNearFieldCorrectionSegmentedControlShowsNearFieldCorrection
{
    sut.measurement.nearFieldCorrection=-2;
    assertThatInt((int) [(UISegmentedControl *)[[self cellForRow:13] viewWithTag:21]selectedSegmentIndex], is(equalToInt(2)));
}

#pragma mark row 15

- (void) testRow15HasTextLabelSoundPowerLevel
{
    assertThat([[self textLabelForRow:15] text], is(equalTo(@"Lw")));
}

- (void) testRow15HasTextFieldWithLwPlaceholder
{
    assertThat([[self textFieldForRow:15] placeholder], is(equalTo(@"-")));
}

- (void) testSoundPowerLevelTextFieldShowsSoundPowerLevel{
    sut.measurement.soundPowerLevel=83.2;
    assertThat([[self textFieldForRow:15] text], is(equalTo(@"83.2")));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenLpIsUpdated
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=80;
    sut.measurement.type=@"II.2";
    sut.measurement.distance=10;
    [self updateRow:7 withInsertedSampleText:@"50"];
    float myValue =[[(UITextField *)[self textFieldForRow:15] text] floatValue];
    assertThatFloat(myValue, is(closeTo(81.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenTypeIsChanged
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=50;
    sut.measurement.type=@"II.2";
    sut.measurement.distance=10;
    sut.measurement.surfaceArea=10;
    sut.measurement.nearFieldCorrection=-1;
    UISegmentedControl * measurementTypeControl=(UISegmentedControl *)[[self cellForRow:9] viewWithTag:20];
    measurementTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:measurementTypeControl];  
    float myValue =[[(UITextField *)[self textFieldForRow:15] text] floatValue];
    assertThatFloat(myValue, is(closeTo(59.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenDistanceIsUpdated
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=50;
    sut.measurement.type=@"II.2";
    sut.measurement.distance=20;
    sut.measurement.surfaceArea=10;
    sut.measurement.nearFieldCorrection=-1;
    [self updateRow:10 withInsertedSampleText:@"10"];
    float myValue =[[(UITextField *)[self textFieldForRow:15] text] floatValue];
    assertThatFloat(myValue, is(closeTo(81.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenSurfaceAreaIsUpdated
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=50;
    sut.measurement.type=@"II.3";
    sut.measurement.distance=10;
    sut.measurement.surfaceArea=10;
    sut.measurement.nearFieldCorrection=-1;
    [self updateRow:12 withInsertedSampleText:@"10"];
    float myValue =[[(UITextField *)[self textFieldForRow:15] text] floatValue];
    assertThatFloat(myValue, is(closeTo(59.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenNearFieldCorrectionIsUpdated
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=50;
    sut.measurement.type=@"II.3";
    sut.measurement.distance=10;
    sut.measurement.surfaceArea=10;
    sut.measurement.nearFieldCorrection=0;
    [self updateRow:13 withInsertedSampleText:@"-1"];
    float myValue =[[(UITextField *)[self textFieldForRow:15] text] floatValue];
    assertThatFloat(myValue, is(closeTo(59.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldShowsPlaceholderWhenSPLSmallerOrEqualToZero{
    sut.measurement.soundPowerLevel=0;
    assertThat([[self textFieldForRow:15] text], is(equalTo(@"")));
}

- (void) testSoundPowerLevelTextFieldIsDisabled
{
    UITextField * myTextField=(UITextField *)[self textFieldForRow:15];
     assertThatBool(myTextField.enabled, is(equalToLong(NO)));
}

#pragma mark helper methods

-(UITableViewCell *)cellForRow:(int)row
{
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    return [sut tableView:sut.tableView cellForRowAtIndexPath:indexPath];
}

-(UITextField *)textFieldForRow:(int)row
{
    return (UITextField *) [[self cellForRow:row] viewWithTag:row+1];
}

-(UILabel *)textLabelForRow:(int)row
{
    return (UILabel *) [[self cellForRow:row] textLabel];
}

- (void)updateRow:(int)row withInsertedSampleText:(NSString *)insertedSampleText
{
    textField=[self textFieldForRow:row];
    [sut textFieldDidBeginEditing:textField];
    textField.text=insertedSampleText;
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:textField];
    [sut textFieldDidEndEditing:textField];
}
@end
