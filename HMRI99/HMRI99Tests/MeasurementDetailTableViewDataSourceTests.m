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

- (void)testThatEnvironmentWorks
{
    XCTAssertNotNil(store, @"no persistent store");
}

- (void) testNumberOfSectionsReturnsOne
{
    assertThatInt((int) [sut numberOfSectionsInTableView:sut.tableView],is(equalToInt(1)));
}

- (void) testNumberOfRowsReturnsNineForFirstSection
{
    assertThatInt((int) [sut tableView:[[UITableView alloc] init] numberOfRowsInSection:0],is(equalToInt(9)));
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

- (void) testRow1HasTextLabelName
{
    assertThat([[self textLabelForRow:1] text], is(equalTo(@"Name")));
}

- (void) testRow1HasTextFieldWithNamePlaceholder
{
    assertThat([[self textFieldForRow:1] placeholder], is(equalTo(@"eg. compressor")));
}

- (void) testRow1HasTextFieldWithDefaultKeyboard
{
    assertThatInt([[self textFieldForRow:1] keyboardType], is(equalToInt(UIKeyboardTypeDefault)));
}

- (void) testRow1HasTextFieldWithReturnKeyNext
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

- (void) testRow2HasTextLabelImage
{
    assertThat([[self textLabelForRow:2] text], is(equalTo(@"Image")));
}

- (void) testRow2TextFieldIsDisabled
{
    UITextField * myTextField=(UITextField *)[self textFieldForRow:2];
    assertThatBool(myTextField.enabled, is(equalToLong(NO)));
}

- (void) testRow2ContainsAButtonWithHeight60
{
    UITableViewCell *imageCell=[self cellForRow:2];
    UIButton *imageButton=(UIButton*)[imageCell viewWithTag:333];
    assertThatFloat(imageButton.frame.size.height, is(equalToFloat(60.0f)));
}

- (void) testRow2HasHeightGreaterThanImageButtonHeight
{
    UITableViewCell *imageCell=[self cellForRow:2];
    UIButton *imageButton=(UIButton*)[imageCell viewWithTag:333];
    assertThat([NSNumber numberWithFloat: imageButton.frame.size.height], is(lessThan([NSNumber numberWithFloat:(float)[sut tableView:sut.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]])));
}

- (void) testRow2ButtonClickedSendsAlert
{
}

- (void) testRow2ButtonShowsSelectedImage
{
}



#pragma mark row 3

- (void) testRow3HasTextLabelLp
{
    assertThat([[self textLabelForRow:3] text], is(equalTo(@"Lp")));
}

- (void) testRow3HasTextFieldWithSoundPressureLevelPlaceholder
{
    assertThat([[self textFieldForRow:3]placeholder], is(equalTo(@"eg. 88")));
}

- (void) testRow3HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:3] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow3HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:3] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsLpTextFieldDelegate
{
    assertThat([[self textFieldForRow:3] delegate], is(equalTo(sut)));
}

- (void) testChangingLpTextFieldUpdatesMeasurementLp
{
    [self updateRow:3 withInsertedSampleText:@"88"];
    assertThatFloat([[sut measurement] soundPressureLevel],is(equalToFloat(88.0f)));
}

- (void) testLpTextFieldShowsMeasurementLp
{
    sut.measurement.soundPressureLevel=83.0f;
    assertThat([[self textFieldForRow:3] text], is(equalTo(@"83.0")));
}

#pragma mark row 4

- (void) testRow4HasTextLabelType
{
    assertThat([[self textLabelForRow:4] text], is(equalTo(@"Type")));
}

- (void) testChangingTypeSegmentedControlUpdatesMeasurementType
{
    UISegmentedControl * measurementTypeControl=(UISegmentedControl *)[[self cellForRow:4] viewWithTag:10];
    measurementTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:measurementTypeControl];
    assertThat([[sut measurement] type],is(equalTo(@"II.3")));
}

- (void) testTypeSegmentedControlShowsMeasurementType
{
    sut.measurement.type=@"II.3";
    assertThatInt((int) [(UISegmentedControl *)[[self cellForRow:4] viewWithTag:10]selectedSegmentIndex], is(equalToInt(1)));
}

#pragma mark row 5

- (void) testRow5HasTextLabelDistance
{
    assertThat([[self textLabelForRow:5] text], is(equalTo(@"Distance")));
}

- (void) testLabelRow5IsGreyWhenMeasurementTypeIsNotII2
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:5].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow5IsBlackWhenMeasurementTypeNotII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:5].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow5TextFieldIsEnabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:5].enabled, is(equalToLong(YES)));
}

- (void) testRow5TextFieldIsDisabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:5].enabled, is(equalToLong(NO)));
}

//- (void) testRow5IsHiddenWhenMeasurementTypeIsNotII2
//{
//    sut.measurement.type=@"II.3";
//    assertThatBool([self cellForRow:5].hidden, is(equalToLong(YES)));
//}
//
//- (void) testRow5IsNotHiddenWhenMeasurementTypeIsII2
//{
//    sut.measurement.type=@"II.2";
//    assertThatBool([self cellForRow:5].hidden, is(equalToLong(NO)));
//}

- (void) testRow5HasTextFieldWithDistancePlaceholder
{
    assertThat([[self textFieldForRow:5] placeholder], is(equalTo(@"in meters")));
}

- (void) testRow5HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:5] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow5HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:5] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsDistanceTextFieldDelegate
{
    assertThat([[self textFieldForRow:5] delegate], is(equalTo(sut)));
}

- (void) testChangingDistanceTextFieldUpdatesMeasurementDistance
{
    [self updateRow:5 withInsertedSampleText:@"23"];
    assertThatFloat([[sut measurement] distance],is(equalToFloat(23.0f)));
}

- (void) testDistanceTextFieldShowsMeasurementDistance
{
    sut.measurement.distance=7.0f;
    assertThat([[self textFieldForRow:5] text], is(equalTo(@"7.0")));
}

#pragma mark row 6

- (void) testRow6HasTextLabelMeasurementSurface
{
    assertThat([[self textLabelForRow:6] text], is(equalTo(@"Surface")));
}

- (void) testLabelRow6IsGreyWhenMeasurementTypeIsNotII3
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:6].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow6IsBlackWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:6].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow6TextFieldIsEnabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThatBool([self textFieldForRow:6].enabled, is(equalToLong(YES)));
}

- (void) testRow6TextFieldIsDisabledWhenMeasurementTypeIsNotII3
{
    sut.measurement.type=@"II.2";
    assertThatBool([self textFieldForRow:6].enabled, is(equalToLong(NO)));
}

- (void) testRow6HasTextFieldWithSurfacePlaceholder
{
    assertThat([[self textFieldForRow:6] placeholder], is(equalTo(@"in m2")));
}

- (void) testRow6HasTextFieldWithNumericKeyboard
{
    assertThatInt([[self textFieldForRow:6] keyboardType], is(equalToInt(UIKeyboardTypeNumbersAndPunctuation)));
}

- (void) testRow6HasTextFieldWithReturnKeyNext
{
    assertThatInt([[self textFieldForRow:6] returnKeyType], is(equalToInt(UIReturnKeyNext)));
}

- (void) testObjectShouldBeSetAsSurfaceTextFieldDelegate
{
    assertThat([[self textFieldForRow:6] delegate], is(equalTo(sut)));
}

- (void) testChangingSurfaceTextFieldUpdatesMeasurementSurface
{
    sut.measurement.type=@"II.3";    
    [self updateRow:6 withInsertedSampleText:@"23"];
    assertThatFloat([[sut measurement] surfaceArea],is(equalToFloat(23.0f)));
}

- (void) testSurfaceTextFieldShowsMeasurementSurfaceArea
{
    sut.measurement.surfaceArea=7.0f;
    assertThat([[self textFieldForRow:6] text], is(equalTo(@"7.0")));
}

#pragma mark row 7

- (void) testRow7HasTextLabelMeasurementNearFieldCorrection
{
    assertThat([[self textLabelForRow:7] text], is(equalTo(@"Near f. corr.")));
}

- (void) testLabelRow7IsGreyWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    assertThat([self textLabelForRow:7].textColor, is(equalTo([UIColor grayColor])));
}

- (void) testLabelRow7IsBlackWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    assertThat([self textLabelForRow:7].textColor, is(equalTo([UIColor blackColor])));
}

- (void) testRow7SegementedControlIsEnabledWhenMeasurementTypeIsII3
{
    sut.measurement.type=@"II.3";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:7] viewWithTag:11];
    assertThatBool(segmentedControl.enabled, is(equalToLong(YES)));
}

- (void) testRow7SegmentedControlIsDisabledWhenMeasurementTypeIsII2
{
    sut.measurement.type=@"II.2";
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:7] viewWithTag:11];
    assertThatBool(segmentedControl.enabled, is(equalToLong(NO)));
}

- (void) testObjectShouldBeSetAsNearFieldCorrectionTextFieldDelegate
{
    assertThat([[self textFieldForRow:7] delegate], is(equalTo(sut)));
}

- (void) testChangingNearFieldCorrectionSegmentedControlUpdatesNearFieldCorrection
{
    UISegmentedControl * segmentedControl=(UISegmentedControl *)[[self cellForRow:7] viewWithTag:11];
    segmentedControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:segmentedControl];
    assertThatInt([[sut measurement] nearFieldCorrection],is(equalToInt(-1)));
}

- (void) testNearFieldCorrectionSegmentedControlShowsNearFieldCorrection
{
    sut.measurement.nearFieldCorrection=-2;
    assertThatInt((int) [(UISegmentedControl *)[[self cellForRow:7] viewWithTag:11]selectedSegmentIndex], is(equalToInt(2)));
}

#pragma mark row 8

- (void) testRow8HasTextLabelSoundPowerLevel
{
    assertThat([[self textLabelForRow:8] text], is(equalTo(@"Lw")));
}

- (void) testRow8HasTextFieldWithLwPlaceholder
{
    assertThat([[self textFieldForRow:8] placeholder], is(equalTo(@"-")));
}

- (void) testSoundPowerLevelTextFieldShowsSoundPowerLevel{
    sut.measurement.soundPowerLevel=83.2;
    assertThat([[self textFieldForRow:8] text], is(equalTo(@"83.2")));
}

- (void) testSoundPowerLevelTextFieldIsUpdatedWhenLpIsUpdated
{
    sut.measurement.soundPowerLevel=75.1;
    sut.measurement.soundPressureLevel=80;
    sut.measurement.type=@"II.2";
    sut.measurement.distance=10;
    [self updateRow:3 withInsertedSampleText:@"50"];
    float myValue =[[(UITextField *)[self textFieldForRow:8] text] floatValue];
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
    UISegmentedControl * measurementTypeControl=(UISegmentedControl *)[[self cellForRow:4] viewWithTag:10];
    measurementTypeControl.selectedSegmentIndex=1;
    [sut measurementSegmentedControlWasUpdated:measurementTypeControl];  
    float myValue =[[(UITextField *)[self textFieldForRow:8] text] floatValue];
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
    [self updateRow:5 withInsertedSampleText:@"10"];
    float myValue =[[(UITextField *)[self textFieldForRow:8] text] floatValue];
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
    [self updateRow:6 withInsertedSampleText:@"10"];
    float myValue =[[(UITextField *)[self textFieldForRow:8] text] floatValue];
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
    [self updateRow:7 withInsertedSampleText:@"-1"];
    float myValue =[[(UITextField *)[self textFieldForRow:8] text] floatValue];
    assertThatFloat(myValue, is(closeTo(59.0,0.05)));
}

- (void) testSoundPowerLevelTextFieldShowsPlaceholderWhenSPLSmallerOrEqualToZero{
    sut.measurement.soundPowerLevel=0;
    assertThat([[self textFieldForRow:8] text], is(equalTo(@"")));
}

- (void) testSoundPowerLevelTextFieldIsDisabled
{
    UITextField * myTextField=(UITextField *)[self textFieldForRow:8];
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
