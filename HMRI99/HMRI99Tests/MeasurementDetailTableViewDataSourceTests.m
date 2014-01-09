    // Class under test
#import "MeasurementDetailTableViewDataSource.h"

    // Collaborators
#import "Measurement.h"
//#import "NoiseSource.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementDetailTableViewDataSourceTests : SenTestCase
@end

@implementation MeasurementDetailTableViewDataSourceTests
{
    MeasurementDetailTableViewDataSource * sut;
    Measurement *sampleMeasurement;
    UITextField *textField;
}

- (void) setUp
{
    [super setUp];
    sut=[[MeasurementDetailTableViewDataSource alloc] init];
    sampleMeasurement=[[Measurement alloc] init];
    sut.measurement=sampleMeasurement;
}

- (void) tearDown
{
    sut=nil;
    sampleMeasurement=nil;
    textField=nil;
    [super tearDown];
}

- (void) testNumberOfSectionsReturnsOne
{
    assertThatInt([sut numberOfSectionsInTableView:nil],is(equalToInt(1)));
}

- (void) testNumberOfRowsReturnsFivesForFirstSection
{
    assertThatInt([sut tableView:nil numberOfRowsInSection:0],is(equalToInt(8)));
}

- (void) testObjectShouldConformToUITextFieldDelegate
{
    assertThat(sut, conformsTo(@protocol(UITextFieldDelegate)));
}

- (void) testTextFieldDidBeginEditingIsImplemented
{
    assertThatBool([sut respondsToSelector:@selector(textFieldDidBeginEditing:)],is(equalToBool(YES)));
}

- (void) testTextFieldDidEndEditingIsImplemented
{
    assertThatBool([sut respondsToSelector:@selector(textFieldDidEndEditing:)],is(equalToBool(YES)));
}

#pragma mark row 0

- (void) testFirstCellHasTextLabelID
{
    assertThat([[self textLabelForRow:0] text], is(equalTo(@"ID")));
}

- (void) testFirstCellHasTextFieldWithIDPlaceholder
{
    assertThat([[self textFieldForRow:0] placeholder], is(equalTo(@"eg. R5")));
}

- (void) testFirstCellHasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:0]keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testFirstCellHasTextFieldWithReturnKeyNext
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
    assertThat([[sut measurement] ID],is(equalTo(@"R4")));
}

- (void) testIDTextFieldShowsMeasurementID
{
    sut.measurement.ID=@"R2";
    assertThat([[self textFieldForRow:0] text], is(equalTo(@"R2")));
}

#pragma mark row 1

- (void) testSecondCellHasTextLabelName
{
    assertThat([[self textLabelForRow:1] text], is(equalTo(@"Name")));
}

- (void) testSecondCellHasTextFieldWithNamePlaceholder
{
    assertThat([[self textFieldForRow:1] placeholder], is(equalTo(@"eg. compressor")));
}

- (void) testSecondCellHasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:1] keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testSecondCellHasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:1]returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsNameTextFieldDelegate
{
    assertThat([[self textFieldForRow:1] delegate], is(equalTo(sut)));
}

- (void) testChangingNameTextFieldUpdatesMeasurementName
{
    [self updateRow:1 withInsertedSampleText:@"compressor"];
    assertThat([[[sut measurement] noiseSource] name],is(equalTo(@"compressor")));
}

- (void) testNameTextFieldShowsMeasurementName
{
    sut.measurement.noiseSource.name=@"shovel";
    assertThat([[self textFieldForRow:1] text], is(equalTo(@"shovel")));
}

#pragma mark row 2

- (void) testThirdCellHasTextLabelLp
{
    assertThat([[self textLabelForRow:2] text], is(equalTo(@"Lp")));
}

- (void) testThirdCellHasTextFieldWithSoundPressureLevelPlaceholder
{
    assertThat([[self textFieldForRow:2]placeholder], is(equalTo(@"eg. 88")));
}

- (void) testThirdCellHasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:2] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testThirdCellHasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:2] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsLpTextFieldDelegate
{
    assertThat([[self textFieldForRow:2] delegate], is(equalTo(sut)));
}

- (void) testChangingLpTextFieldUpdatesMeasurementLp
{
    [self updateRow:2 withInsertedSampleText:@"88"];
    assertThatFloat([[sut measurement] soundPressureLevel],is(equalToFloat(88.0f)));
}

- (void) testLpTextFieldShowsMeasurementLp
{
    sut.measurement.soundPressureLevel=83.0f;
    assertThat([[self textFieldForRow:2] text], is(equalTo(@"83.0")));
}

#pragma mark row 3

- (void) testFourthCellHasTextLabelType
{
    assertThat([[self textLabelForRow:3] text], is(equalTo(@"Type")));
}

- (void) testChangingTypeSegmentedControlUpdatesMeasurementType
{
    UISegmentedControl * measurementTypeControl=(UISegmentedControl *)[[self cellForRow:3] viewWithTag:10];
    measurementTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:measurementTypeControl];
    assertThat([[sut measurement] type],is(equalTo(@"II.3")));
}

- (void) testTypeSegmentedControlShowsMeasurementType
{
    sut.measurement.type=@"II.3";
    assertThatInt([(UISegmentedControl *)[[self cellForRow:3] viewWithTag:10]selectedSegmentIndex], is(equalToInt(1)));
}

#pragma mark row 4

- (void) testFifthCellHasTextLabelDistance
{
    assertThat([[self textLabelForRow:4] text], is(equalTo(@"Distance")));
}

- (void) testLabelFifthCellIsGreyWhenMeasurementTypeIsNotII2
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:4].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelFifthCellIsBlackWhenMeasurementTypeNotII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:4].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testFifthCellTextFieldIsEnabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:4].enabled, is(equalToBool(YES)));
}

- (void) testFifthCellTextFieldIsDisabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:4].enabled, is(equalToBool(NO)));
}

//- (void) testFifthCellIsHiddenWhenMeasurementTypeIsNotII2
//{
//    sut.measurement.type=@"II.3";
//    assertThatBool([self cellForRow:4].hidden, is(equalToBool(YES)));
//}
//
//- (void) testFifthCellIsNotHiddenWhenMeasurementTypeIsII2
//{
//    sut.measurement.type=@"II.2";
//    assertThatBool([self cellForRow:4].hidden, is(equalToBool(NO)));
//}

- (void) testFifthCellHasTextFieldWithDistancePlaceholder
{
    assertThat([[self textFieldForRow:4] placeholder], is(equalTo(@"in meters")));
}

- (void) testFifthCellHasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:4] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testFifthCellHasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:4] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsDistanceTextFieldDelegate
{
    assertThat([[self textFieldForRow:4] delegate], is(equalTo(sut)));
}

- (void) testChangingDistanceTextFieldUpdatesMeasurementDistance
{
    [self updateRow:4 withInsertedSampleText:@"23"];
    assertThatFloat([[sut measurement] distance],is(equalToFloat(23.0f)));
}

- (void) testDistanceTextFieldShowsMeasurementDistance
{
    sut.measurement.distance=7.0f;
    assertThat([[self textFieldForRow:4] text], is(equalTo(@"7.0")));
}

#pragma mark row 5

- (void) testSixthCellHasTextLabelMeasurementSurface
{
    assertThat([[self textLabelForRow:5] text], is(equalTo(@"Surface")));
}

- (void) testLabelSixthCellIsGreyWhenMeasurementTypeIsNotII3
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:5].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelSixthCellIsBlackWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:5].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testSixthCellTextFieldIsEnabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:5].enabled, is(equalToBool(YES)));
}

- (void) testSixthCellTextFieldIsDisabledWhenMeasurementTypeIsNotII3
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:5].enabled, is(equalToBool(NO)));
}

- (void) testSixthCellHasTextFieldWithSurfacePlaceholder
{
    assertThat([[self textFieldForRow:5] placeholder], is(equalTo(@"in m2")));
}

- (void) testSixthCellHasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:5] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testSixthCellHasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:5] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsSurfaceTextFieldDelegate
{
    assertThat([[self textFieldForRow:5] delegate], is(equalTo(sut)));
}

- (void) testChangingSurfaceTextFieldUpdatesMeasurementSurface
{
    sut.measurement.type=@"II.3";    
    [self updateRow:5 withInsertedSampleText:@"23"];
    assertThatFloat([[sut measurement] surfaceArea],is(equalToFloat(23.0f)));
}

- (void) testSurfaceTextFieldShowsMeasurementSurfaceArea
{
    sut.measurement.surfaceArea=7.0f;
    assertThat([[self textFieldForRow:5] text], is(equalTo(@"7.0")));
}

#pragma mark row 6

- (void) testSeventhCellHasTextLabelMeasurementNearFieldCorrection
{
    assertThat([[self textLabelForRow:6] text], is(equalTo(@"Near f. corr.")));
}

- (void) testLabelSeventhCellIsGreyWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:6].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelSeventhCellIsBlackWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:6].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testSeventhCellSegementedControlIsEnabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:6] viewWithTag:11];
    assertThatBool(segmentedControl.enabled, is(equalToBool(YES)));
}

- (void) testSeventhCellSegmentedControlIsDisabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:6] viewWithTag:11];
    assertThatBool(segmentedControl.enabled, is(equalToBool(NO)));
}

- (void) testObjectShouldBeSetAsNearFieldCorrectionTextFieldDelegate
{
    assertThat([[self textFieldForRow:6] delegate], is(equalTo(sut)));
}

- (void) testChangingNearFieldCorrectionSegmentedControlUpdatesNearFieldCorrection
{
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:6] viewWithTag:11];
    segmentedControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:segmentedControl];
    assertThatInt([[sut measurement] nearFieldCorrection],is(equalToInt(-1)));
}

- (void) testNearFieldCorrectionSegmentedControlShowsNearFieldCorrection
{
    sut.measurement.nearFieldCorrection=-2;
    assertThatInt([(UISegmentedControl *)[[self cellForRow:6] viewWithTag:11]selectedSegmentIndex], is(equalToInt(2)));
}

#pragma mark row 7

- (void) testCell7HasTextLabelSoundPowerLevel
{
    assertThat([[self textLabelForRow:7] text], is(equalTo(@"Lw")));
}

- (void) testCell7HasTextFieldWithLwPlaceholder
{
    assertThat([[self textFieldForRow:7] placeholder], is(equalTo(@"-")));
}

- (void) testSoundPowerLevelTextFieldShowsSoundPowerLevel{
    sut.measurement.soundPowerLevel=83.2;
    assertThat([[self textFieldForRow:7] text], is(equalTo(@"83.2")));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenLpIsUpdated
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=80;
    sut.measurement.type=@"II.2";
    sut.measurement.distance=10;
    [self updateRow:2 withInsertedSampleText:@"50"];
    float myValue =[[(UITextField *)[self textFieldForRow:7] text] floatValue];
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
    UISegmentedControl * measurementTypeControl=(UISegmentedControl *)[[self cellForRow:3] viewWithTag:10];
    measurementTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:measurementTypeControl];  
    float myValue =[[(UITextField *)[self textFieldForRow:7] text] floatValue];
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
    [self updateRow:4 withInsertedSampleText:@"10"];
    float myValue =[[(UITextField *)[self textFieldForRow:7] text] floatValue];
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
    [self updateRow:5 withInsertedSampleText:@"10"];
    float myValue =[[(UITextField *)[self textFieldForRow:7] text] floatValue];
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
    [self updateRow:6 withInsertedSampleText:@"-1"];
    float myValue =[[(UITextField *)[self textFieldForRow:7] text] floatValue];
    assertThatFloat(myValue, is(closeTo(59.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldShowsPlaceholderWhenSPLSmallerOrEqualToZero{
    sut.measurement.soundPowerLevel=0;
    assertThat([[self textFieldForRow:7] text], is(equalTo(@"")));
}

- (void) testSoundPowerLevelTextFieldIsDisabled
{
    UITextField * myTextField=(UITextField *)[self textFieldForRow:7];
     assertThatBool(myTextField.enabled, is(equalToBool(NO)));
}

#pragma mark helper methods

-(UITableViewCell *)cellForRow:(int)row
{
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    return [sut tableView:nil cellForRowAtIndexPath:indexPath];
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
