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
    Location * sampleLocation=[NSEntityDescription
                               insertNewObjectForEntityForName:@"Location"
                               inManagedObjectContext: ctx];
    sampleMeasurement.location=sampleLocation;
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
// 03 Subname
// 04 Image (03)
// 05 Source height
// 06 gps coordinates (04)
// 07 address (05)
// 08 operating conditions (06)
// 09 Lp (07)
// 10 Background noise correction type
// 11 background noise correction
// 12 Ambient sound level (08)
// 13 Ambient sound level measurement ID
// 14 Type (09)
// 15 Distance (10)
// 16 Hemispherecorrection (11)
// 17 Measurement height
// 18 Surface type
// 19 Surface (12)
// 20 Near field correction (13)
// 21 Custom remarks to measurement (14)
// 22 Lw (15)


- (void)testThatEnvironmentWorks
{
    XCTAssertNotNil(store, @"no persistent store");
}

- (void) testNumberOfSectionsReturnsOne
{
    assertThatInt((int) [sut numberOfSectionsInTableView:sut.tableView],is(equalToInt(1)));
}

- (void) testNumberOfRowsReturnsTwentyThreeForFirstSection
{
    assertThatInt((int) [sut tableView:[[UITableView alloc] init] numberOfRowsInSection:0],is(equalToInt(23)));
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

- (void) testRow1HasTextLabelDevice
{
    assertThat([[self textLabelForRow:1] text], is(equalTo(@"Device")));
}

- (void) testRow1HasTextFieldWithDevicePlaceholder
{
    assertThat([[self textFieldForRow:1] placeholder], is(equalTo(@"eg. Rion NA28 - 41")));
}

- (void) testRow1HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:1]keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow1HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:1]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsDeviceTextFieldDelegate
{
    assertThat([[self textFieldForRow:1] delegate], is(equalTo(sut)));
}

- (void) testChangingDeviceTextFieldUpdatesMeasurementDevice
{
    [self updateRow:1 withInsertedSampleText:@"Rion NA28 - 45"];
    assertThat([[sut measurement] measurementDevice],is(equalTo(@"Rion NA28 - 45")));
}

- (void) testDeviceTextFieldShowsMeasurementDevice
{
    sut.measurement.measurementDevice=@"Rion NA28 - 77";
    assertThat([[self textFieldForRow:1] text], is(equalTo(@"Rion NA28 - 77")));
}

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


- (void) testRow3HasTextLabelSubname
{
    assertThat([[self textLabelForRow:3] text], is(equalTo(@"Subname")));
}

- (void) testRow3HasTextFieldWithSubnamePlaceholder
{
    assertThat([[self textFieldForRow:3] placeholder], is(equalTo(@"eg. C-1000")));
}

- (void) testRow3HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:3] keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow3HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:3]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsSubnameTextFieldDelegate
{
    assertThat([[self textFieldForRow:3] delegate], is(equalTo(sut)));
}

- (void) testChangingSubnameTextFieldUpdatesMeasurementSubname
{
    [self updateRow:3 withInsertedSampleText:@"C-1000"];
    assertThat([[[sut measurement] noiseSource] subname],is(equalTo(@"C-1000")));
}

- (void) testSubnameTextFieldShowsMeasurementSubname
{
    sut.measurement.noiseSource.subname=@"shovel";
    assertThat([[self textFieldForRow:3] text], is(equalTo(@"shovel")));
}

#pragma mark row 4

- (void) testRow4HasTextLabelImage
{
    assertThat([[self textLabelForRow:4] text], is(equalTo(@"Image")));
}

- (void) testRow4TextFieldIsDisabled
{
    UITextField * myTextField=(UITextField *)[self textFieldForRow:4];
    assertThatBool(myTextField.enabled, is(equalToLong(NO)));
}

- (void) testRow4ContainsAButtonWithHeight60
{
    UITableViewCell *imageCell=[self cellForRow:4];
    UIButton *imageButton=(UIButton*)[imageCell viewWithTag:333];
    assertThatFloat(imageButton.frame.size.height, is(equalToFloat(60.0f)));
}

- (void) testRow4HasHeightGreaterThanImageButtonHeight
{
    UITableViewCell *imageCell=[self cellForRow:4];
    UIButton *imageButton=(UIButton*)[imageCell viewWithTag:333];
    assertThat([NSNumber numberWithFloat: imageButton.frame.size.height], is(lessThan([NSNumber numberWithFloat:(float)[sut tableView:sut.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]]])));
}

- (void) testRow4ButtonClickedSendsAlert
{
}

- (void) testRow4ButtonShowsSelectedImage
{
}

#pragma mark row 5


- (void) testRow5HasTextLabelSourceHeight
{
    assertThat([[self textLabelForRow:5] text], is(equalTo(@"Source height")));
}

- (void) testRow5HasTextFieldWithSourceHeightPlaceholder
{
    assertThat([[self textFieldForRow:5] placeholder], is(equalTo(@"in meters")));
}

- (void) testRow5HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:5] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow5HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:5]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsSourceHeightTextFieldDelegate
{
    assertThat([[self textFieldForRow:5] delegate], is(equalTo(sut)));
}

- (void) testChangingSourceHeightTextFieldUpdatesMeasurementSubname
{
    [self updateRow:5 withInsertedSampleText:@"3.5"];
    assertThatFloat([[[sut measurement] noiseSource] height],is(equalToFloat(3.5f)));
}

- (void) testSourceHeightTextFieldShowsSourceHeight
{
    sut.measurement.noiseSource.height=5.5f;
    assertThat([[self textFieldForRow:5] text], is(equalTo(@"5.5")));
}

# pragma mark row 6

- (void) testRow6HasTextLabelCoordinates
{
    assertThat([[self textLabelForRow:6] text], is(equalTo(@"Coordinates")));
}

- (void) testRow6HasTextFieldWithCoordinatesPlaceholder
{
    assertThat([[self textFieldForRow:6] placeholder], is(equalTo(@"eg. 52.370216, 4.895168")));
}

- (void) testRow6HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:6] keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow6HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:6]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsCoordinatesTextFieldDelegate
{
    assertThat([[self textFieldForRow:6] delegate], is(equalTo(sut)));
}


- (void) testChangingCoordinatesTextFieldUpdatesCoordinates
{
    [self updateRow:6 withInsertedSampleText:@"53.33216, 4.925168"];
    assertThat([[[sut measurement] location] coordinates],is(equalTo(@"53.33216, 4.925168")));
}

- (void) testCoordinatesTextFieldShowsMeasurementCoordinates
{
    sut.measurement.location.coordinates=@"53.635243, 4.124234";
    assertThat([[self textFieldForRow:6] text], is(equalTo(@"53.635243, 4.124234")));
}

# pragma mark row 7

- (void) testRow7HasTextLabelAddress
{
    assertThat([[self textLabelForRow:7] text], is(equalTo(@"Address")));
}

- (void) testRow7HasTextFieldWithAddressPlaceholder
{
    assertThat([[self textFieldForRow:7] placeholder], is(equalTo(@"eg. Visserstraat 50, Aalsmeer, NL")));
}

- (void) testRow7HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:7] keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow7HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:7]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsAddressTextFieldDelegate
{
    assertThat([[self textFieldForRow:7] delegate], is(equalTo(sut)));
}

- (void) testChangingAddressTextFieldUpdatesAddress
{
    [self updateRow:7 withInsertedSampleText:@"Wolfskamerweg 47"];
    assertThat([[[sut measurement] location] address],is(equalTo(@"Wolfskamerweg 47")));
}

- (void) testAddressTextFieldShowsMeasurementAddress
{
    sut.measurement.location.address=@"adres";
    assertThat([[self textFieldForRow:7] text], is(equalTo(@"adres")));
}

# pragma mark row 8

- (void) testRow8HasTextLabelOperatingConditions
{
    assertThat([[self textLabelForRow:8] text], is(equalTo(@"Conditions")));
}

- (void) testRow8HasTextFieldWithOperatingConditionsPlaceholder
{
    assertThat([[self textFieldForRow:8] placeholder], is(equalTo(@"eg. 1000 rpm")));
}

- (void) testRow8HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:8] keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow8HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:8]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsOperatingConditionsTextFieldDelegate
{
    assertThat([[self textFieldForRow:8] delegate], is(equalTo(sut)));
}

- (void) testChangingOperatingConditionsTextFieldUpdatesOperatingConditions
{
    [self updateRow:8 withInsertedSampleText:@"10 bar"];
    assertThat([[[sut measurement] noiseSource] operatingConditions],is(equalTo(@"10 bar")));
}

- (void) testOperatingConditionsTextFieldShowsMeasurementOperatingConditions
{
    sut.measurement.noiseSource.operatingConditions=@"300 ton/hr";
    assertThat([[self textFieldForRow:8] text], is(equalTo(@"300 ton/hr")));
}

#pragma mark row 9

- (void) testRow9HasTextLabelLp
{
    assertThat([[self textLabelForRow:9] text], is(equalTo(@"Lp")));
}

- (void) testRow9HasTextFieldWithSoundPressureLevelPlaceholder
{
    assertThat([[self textFieldForRow:9]placeholder], is(equalTo(@"eg. 88")));
}

- (void) testRow9HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:9] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow9HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:9] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsLpTextFieldDelegate
{
    assertThat([[self textFieldForRow:9] delegate], is(equalTo(sut)));
}

- (void) testChangingLpTextFieldUpdatesMeasurementLp
{
    [self updateRow:9 withInsertedSampleText:@"88"];
    assertThatFloat([[sut measurement] soundPressureLevel],is(equalToFloat(88.0f)));
}

- (void) testLpTextFieldShowsMeasurementLp
{
    sut.measurement.soundPressureLevel=83.0f;
    assertThat([[self textFieldForRow:9] text], is(equalTo(@"83.0")));
}

#pragma mark row 10

- (void) testRow10HasTextLabelType
{
    assertThat([[self textLabelForRow:10] text], is(equalTo(@"Ambient noise correction type")));
}

- (void) testChangingCorrectionTypeSegmentedControlUpdatesCorrectionType
{
    UISegmentedControl * correctionTypeControl=(UISegmentedControl *)[[self cellForRow:10] viewWithTag:337];
    correctionTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:correctionTypeControl];
    assertThat([[sut measurement] backgroundLevelCorrectionType],is(equalTo(@"Correction")));
}

- (void) testChangingCorrectionTypeSegmentedControlTwiceUpdatesCorrectionType
{
    UISegmentedControl * correctionTypeControl=(UISegmentedControl *)[[self cellForRow:10] viewWithTag:337];
    correctionTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:correctionTypeControl];
    correctionTypeControl.selectedSegmentIndex=0;
    [sut measurementSegmentedControlWasUpdated:correctionTypeControl];
    assertThat([[sut measurement] backgroundLevelCorrectionType],is(equalTo(@"Level")));
}

- (void) testCorrectionTypeSegmentedControlShowsCorrectionType
{
    sut.measurement.backgroundLevelCorrectionType=@"Correction";
    assertThatInt((int) [(UISegmentedControl *)[[self cellForRow:10] viewWithTag:337]selectedSegmentIndex], is(equalToInt(1)));
}

#pragma mark row 11

- (void) testRow11HasTextLabelBackgroundNoiseCorrection
{
    assertThat([[self textLabelForRow:11] text], is(equalTo(@"Ambient noise correction")));
}

- (void) testRow11HasTextFieldWithBackgroundNoiseLevelPlaceholder
{
    assertThat([[self textFieldForRow:11]placeholder], is(equalTo(@"eg. 2")));
}

- (void) testRow11HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:11] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow11HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:11] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsBackgroundNoiseCorrectionTextFieldDelegate
{
    assertThat([[self textFieldForRow:11] delegate], is(equalTo(sut)));
}

- (void) testChangingBackgroundNoiseCorrectionTextFieldUpdatesBackgroundNoiseCorrection
{
    [self updateRow:11 withInsertedSampleText:@"3"];
    assertThatFloat([[sut measurement] backgroundLevelCorrection],is(equalToFloat(3.0f)));
}

- (void) testBackgroundNoiseCorrectionTextFieldShowsMeasurementBackgroundNoiseCorrection
{
    sut.measurement.backgroundLevelCorrection=2.5f;
    assertThat([[self textFieldForRow:11] text], is(equalTo(@"2.5")));
}

#pragma mark row 12

- (void) testRow12HasTextLabelBackgroundNoiseLevel
{
    assertThat([[self textLabelForRow:12] text], is(equalTo(@"Lambient")));
}

- (void) testRow12HasTextFieldWithBackgroundNoiseLevelPlaceholder
{
    assertThat([[self textFieldForRow:12]placeholder], is(equalTo(@"eg. 75")));
}

- (void) testRow12HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:12] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow12HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:12] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsBackgroundNoiseLevelTextFieldDelegate
{
    assertThat([[self textFieldForRow:12] delegate], is(equalTo(sut)));
}

- (void) testChangingBackgroundNoiseLevelTextFieldUpdatesMeasurementBackgroundNoiseLevel
{
    [self updateRow:12 withInsertedSampleText:@"75"];
    assertThatFloat([[sut measurement] backgroundSoundPressureLevel],is(equalToFloat(75.0f)));
}

- (void) testBackgroundNoiseLevelTextFieldShowsMeasurementBackgroundNoiseLevel
{
    sut.measurement.backgroundSoundPressureLevel=45.0f;
    assertThat([[self textFieldForRow:12] text], is(equalTo(@"45.0")));
}

#pragma mark row 13

- (void) testRow13HasTextLabelBackgroundNoiseLevelID
{
    assertThat([[self textLabelForRow:13] text], is(equalTo(@"Lambient ID")));
}

- (void) testRow13HasTextFieldWithBackgroundNoiseLevelIDPlaceholder
{
    assertThat([[self textFieldForRow:13] placeholder], is(equalTo(@"eg. R9")));
}

- (void) testRow13HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:13]keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow13HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:13]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsBackgroundNoiseLevelIDTextFieldDelegate
{
    assertThat([[self textFieldForRow:13] delegate], is(equalTo(sut)));
}

- (void) testChangingBackgroundNoiseLevelIDTextFieldUpdatesMeasurementBackgroundNoiseLevelID
{
    [self updateRow:13 withInsertedSampleText:@"R4"];
    assertThat([[sut measurement] backgroundSoundPressureLevelIdentification],is(equalTo(@"R4")));
}

- (void) testBackgroundNoiseLevelIDTextFieldShowsMeasurementBackgroundNoiseLevelID
{
    sut.measurement.backgroundSoundPressureLevelIdentification=@"R2";
    assertThat([[self textFieldForRow:13] text], is(equalTo(@"R2")));
}

#pragma mark row 14

- (void) testRow14HasTextLabelType
{
    assertThat([[self textLabelForRow:14] text], is(equalTo(@"Type")));
}

- (void) testChangingTypeSegmentedControlUpdatesMeasurementType
{
    UISegmentedControl * measurementTypeControl=(UISegmentedControl *)[[self cellForRow:14] viewWithTag:334];
    measurementTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:measurementTypeControl];
    assertThat([[sut measurement] type],is(equalTo(@"II.3")));
}

- (void) testTypeSegmentedControlShowsMeasurementType
{
    sut.measurement.type=@"II.3";
    assertThatInt((int) [(UISegmentedControl *)[[self cellForRow:14] viewWithTag:334]selectedSegmentIndex], is(equalToInt(1)));
}

#pragma mark row 15

- (void) testRow10HasTextLabelDistance
{
    assertThat([[self textLabelForRow:15] text], is(equalTo(@"Distance")));
}

- (void) testLabelRow15IsGreyWhenMeasurementTypeIsNotII2
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:15].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow15IsBlackWhenMeasurementTypeNotII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:15].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow15TextFieldIsEnabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:15].enabled, is(equalToLong(YES)));
}

- (void) testRow15TextFieldIsDisabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:15].enabled, is(equalToLong(NO)));
}

//- (void) testRow15IsHiddenWhenMeasurementTypeIsNotII2
//{
//    sut.measurement.type=@"II.3";
//    assertThatBool([self cellForRow:15].hidden, is(equalToLong(YES)));
//}
//
//- (void) testRow15IsNotHiddenWhenMeasurementTypeIsII2
//{
//    sut.measurement.type=@"II.2";
//    assertThatBool([self cellForRow:15].hidden, is(equalToLong(NO)));
//}

- (void) testRow15HasTextFieldWithDistancePlaceholder
{
    assertThat([[self textFieldForRow:15] placeholder], is(equalTo(@"in meters")));
}

- (void) testRow15HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:15] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow15HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:15] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsDistanceTextFieldDelegate
{
    assertThat([[self textFieldForRow:15] delegate], is(equalTo(sut)));
}

- (void) testChangingDistanceTextFieldUpdatesMeasurementDistance
{
    [self updateRow:15 withInsertedSampleText:@"23"];
    assertThatFloat([[sut measurement] distance],is(equalToFloat(23.0f)));
}

- (void) testDistanceTextFieldShowsMeasurementDistance
{
    sut.measurement.distance=7.0f;
    assertThat([[self textFieldForRow:15] text], is(equalTo(@"7.0")));
}

#pragma mark row 16

- (void) testRow16HasTextLabelHemisphereCorrection
{
    assertThat([[self textLabelForRow:16] text], is(equalTo(@"Hemi. corr.")));
}

- (void) testLabelRow16IsGreyWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:16].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow16IsBlackWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:16].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow16SegmentedControlIsEnabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:16] viewWithTag:336];
    assertThatBool(segmentedControl.enabled, is(equalToLong(YES)));
}

- (void) testRow16SegmentedControlIsDisabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:16] viewWithTag:336];
    assertThatBool(segmentedControl.enabled, is(equalToLong(NO)));
}

- (void) testObjectShouldBeSetAsHemisphereCorrectionTextFieldDelegate
{
    assertThat([[self textFieldForRow:16] delegate], is(equalTo(sut)));
}

- (void) testChangingHemisphereCorrectionSegmentedControlUpdatesHemisphereCorrection
{
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:16] viewWithTag:336];
    segmentedControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:segmentedControl];
    assertThatInt([[sut measurement] hemiSphereCorrection],is(equalToInt(-2)));
}

- (void) testHemisphereCorrectionSegmentedControlShowsHemisphereCorrection
{
    sut.measurement.hemiSphereCorrection=0;
    assertThatInt((int) [(UISegmentedControl *)[[self cellForRow:16] viewWithTag:336]selectedSegmentIndex], is(equalToInt(0)));
}

#pragma mark row 17

- (void) testRow17HasTextLabelMeasurementHeight
{
    assertThat([[self textLabelForRow:17] text], is(equalTo(@"Measurement height")));
}

- (void) testLabelRow17IsGreyWhenMeasurementTypeIsNotII2
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:17].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow17IsBlackWhenMeasurementTypeNotII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:17].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow17TextFieldIsEnabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:17].enabled, is(equalToLong(YES)));
}

- (void) testRow17TextFieldIsDisabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:17].enabled, is(equalToLong(NO)));
}

//- (void) testRow17IsHiddenWhenMeasurementTypeIsNotII2
//{
//    sut.measurement.type=@"II.3";
//    assertThatBool([self cellForRow:17].hidden, is(equalToLong(YES)));
//}
//
//- (void) testRow17IsNotHiddenWhenMeasurementTypeIsII2
//{
//    sut.measurement.type=@"II.2";
//    assertThatBool([self cellForRow:17].hidden, is(equalToLong(NO)));
//}

- (void) testRow17HasTextFieldWithHeightPlaceholder
{
    assertThat([[self textFieldForRow:17] placeholder], is(equalTo(@"in meters")));
}

- (void) testRow17HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:17] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow17HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:17] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsMeasurementHeightTextFieldDelegate
{
    assertThat([[self textFieldForRow:17] delegate], is(equalTo(sut)));
}

- (void) testChangingMeasurementHeightTextFieldUpdatesMeasurementHeight
{
    [self updateRow:17 withInsertedSampleText:@"3.5"];
    assertThatFloat([[sut measurement] measurementHeight],is(equalToFloat(3.5f)));
}

- (void) testMeasurementHeightTextFieldShowsMeasurementHeight
{
    sut.measurement.measurementHeight=7.0f;
    assertThat([[self textFieldForRow:17] text], is(equalTo(@"7.0")));
}

#pragma mark row 18



#pragma mark row 19

- (void) testRow19HasTextLabelMeasurementSurface
{
    assertThat([[self textLabelForRow:19] text], is(equalTo(@"Surface")));
}

- (void) testLabelRow19IsGreyWhenMeasurementTypeIsNotII3
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:19].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow19IsBlackWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:19].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow19TextFieldIsEnabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:19].enabled, is(equalToLong(YES)));
}

- (void) testRow19TextFieldIsDisabledWhenMeasurementTypeIsNotII3
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:19].enabled, is(equalToLong(NO)));
}

- (void) testRow19HasTextFieldWithSurfacePlaceholder
{
    assertThat([[self textFieldForRow:19] placeholder], is(equalTo(@"in m2")));
}

- (void) testRow19HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:19] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow19HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:19] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsSurfaceTextFieldDelegate
{
    assertThat([[self textFieldForRow:19] delegate], is(equalTo(sut)));
}

- (void) testChangingSurfaceTextFieldUpdatesMeasurementSurface
{
    sut.measurement.type=@"II.3";    
    [self updateRow:19 withInsertedSampleText:@"23"];
    assertThatFloat([[sut measurement] surfaceArea],is(equalToFloat(23.0f)));
}

- (void) testSurfaceTextFieldShowsMeasurementSurfaceArea
{
    sut.measurement.surfaceArea=7.0f;
    assertThat([[self textFieldForRow:19] text], is(equalTo(@"7.0")));
}

#pragma mark row 20

- (void) testRow13HasTextLabelMeasurementNearFieldCorrection
{
    assertThat([[self textLabelForRow:20] text], is(equalTo(@"Near f. corr.")));
}

- (void) testLabelRow20IsGreyWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:20].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow20IsBlackWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:20].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow20SegmentedControlIsEnabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:20] viewWithTag:335];
    assertThatBool(segmentedControl.enabled, is(equalToLong(YES)));
}

- (void) testRow20SegmentedControlIsDisabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:20] viewWithTag:335];
    assertThatBool(segmentedControl.enabled, is(equalToLong(NO)));
}

- (void) testObjectShouldBeSetAsNearFieldCorrectionTextFieldDelegate
{
    assertThat([[self textFieldForRow:20] delegate], is(equalTo(sut)));
}

- (void) testChangingNearFieldCorrectionSegmentedControlUpdatesNearFieldCorrection
{
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:20] viewWithTag:335];
    segmentedControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:segmentedControl];
    assertThatInt([[sut measurement] nearFieldCorrection],is(equalToInt(-1)));
}

- (void) testNearFieldCorrectionSegmentedControlShowsNearFieldCorrection
{
    sut.measurement.nearFieldCorrection=-2;
    assertThatInt((int) [(UISegmentedControl *)[[self cellForRow:20] viewWithTag:335]selectedSegmentIndex], is(equalToInt(2)));
}

# pragma mark row 21

- (void) testRow21HasTextLabelMeasurementRemarks
{
    assertThat([[self textLabelForRow:21] text], is(equalTo(@"Remarks")));
}

//- (void) testRow21HasTextViewWithMeasurementRemarksPlaceholder
//{
//    assertThat([[self textViewForRow:21] placeholder], is(equalTo(@"eg. measured in front of facade")));
//}

- (void) testRow21HasTextViewWithDefaultKeyboard
{
    UITextView* textView = (UITextView *) [[self cellForRow:21] viewWithTag:21+1];
    assertThatInt([textView keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow21HasTextViewWithReturnKeyNext
{
    UITextView* textView = (UITextView *) [[self cellForRow:21] viewWithTag:21+1];
    assertThatInt([textView returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsMeasurementRemarksTextViewDelegate
{
    UITextView* textView = (UITextView *) [[self cellForRow:21] viewWithTag:21+1];
    assertThat([textView delegate], is(equalTo(sut)));
}

//- (void) testChangingMeasurementRemarksTextViewUpdatesMeasurementRemarks
//{
//    UITextView* textView = (UITextView *) [[self cellForRow:21] viewWithTag:14+1];
//
//    [sut textViewDidBeginEditing:textView];
//    textView.text=@"background noise of fan";
//    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:textView];
//    [sut textViewDidEndEditing:textView];
//    assertThat([[sut measurement] remarks],is(equalTo(@"background noise of fan")));
//}

- (void) testMeasurementRemarksTextViewShowsMeasurementRemarks
{
    sut.measurement.remarks=@"measured with reflections in neighbouring facade";
    assertThat([[self textFieldForRow:21] text], is(equalTo(@"measured with reflections in neighbouring facade")));
}

#pragma mark row 22

- (void) testRow15HasTextLabelSoundPowerLevel
{
    assertThat([[self textLabelForRow:22] text], is(equalTo(@"Lw")));
}

- (void) testRow22HasTextFieldWithLwPlaceholder
{
    assertThat([[self textFieldForRow:22] placeholder], is(equalTo(@"-")));
}

- (void) testSoundPowerLevelTextFieldShowsSoundPowerLevel{
    sut.measurement.soundPowerLevel=83.2;
    assertThat([[self textFieldForRow:22] text], is(equalTo(@"83.2")));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenLpIsUpdated
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=80;
    sut.measurement.type=@"II.2";
    sut.measurement.distance=10;
    [self updateRow:9 withInsertedSampleText:@"50"];
    float myValue =[[(UITextField *)[self textFieldForRow:22] text] floatValue];
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
    UISegmentedControl * measurementTypeControl=(UISegmentedControl *)[[self cellForRow:14] viewWithTag:334];
    measurementTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:measurementTypeControl];  
    float myValue =[[(UITextField *)[self textFieldForRow:22] text] floatValue];
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
    [self updateRow:15 withInsertedSampleText:@"10"];
    float myValue =[[(UITextField *)[self textFieldForRow:22] text] floatValue];
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
    [self updateRow:19 withInsertedSampleText:@"10"];
    float myValue =[[(UITextField *)[self textFieldForRow:22] text] floatValue];
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
    [self updateRow:20 withInsertedSampleText:@"-1"];
    float myValue =[[(UITextField *)[self textFieldForRow:22] text] floatValue];
    assertThatFloat(myValue, is(closeTo(59.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenNearBackgroundNoiseLevelIsUpdated
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=50;
    sut.measurement.type=@"II.3";
    sut.measurement.distance=10;
    sut.measurement.surfaceArea=10;
    sut.measurement.nearFieldCorrection=-1;
    [self updateRow:12 withInsertedSampleText:@"47"];
    float myValue =[[(UITextField *)[self textFieldForRow:22] text] floatValue];
    assertThatFloat(myValue, is(closeTo(56.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldShowsPlaceholderWhenSPLSmallerOrEqualToZero{
    sut.measurement.soundPowerLevel=0;
    assertThat([[self textFieldForRow:22] text], is(equalTo(@"")));
}

- (void) testSoundPowerLevelTextFieldIsDisabled
{
    UITextField * myTextField=(UITextField *)[self textFieldForRow:22];
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
