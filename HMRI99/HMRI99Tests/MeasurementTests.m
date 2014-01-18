    // Class under test
#import "Measurement.h"

    // Collaborators
#import "NoiseSource.h"
    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementTests : SenTestCase
@end

@implementation MeasurementTests
{
    Measurement * sut;
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
}

- (void)setUp
{
    [super setUp];
    model = [NSManagedObjectModel mergedModelFromBundles: nil];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] init];
    [ctx setPersistentStoreCoordinator: coord];
    sut=[NSEntityDescription insertNewObjectForEntityForName:@"Measurement"
                                      inManagedObjectContext:ctx];
}

- (void)tearDown
{
    sut=nil;
    ctx = nil;
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
    [super tearDown];
}

- (void) testMeasurementHasID
{
    [sut setIdentification:@"R3"];
    assertThat([sut identification], is(equalTo(@"R3")));
}

- (void) testMeasurementHasMeasurementType
{
    [sut setType:@"II.2"];
    assertThat([sut type], is(equalTo(@"II.2")));
}

- (void) testMeasurementHasSoundPressureLevel
{
    [sut setSoundPressureLevel:86.3];
    assertThat([NSNumber numberWithFloat:[sut soundPressureLevel]], is(equalToFloat(86.3)));
}

- (void) testMeasurementHasSoundPowerLevel
{
    [sut setSoundPowerLevel:103.3];
    assertThat([NSNumber numberWithFloat:[sut soundPowerLevel]], is(equalToFloat(103.3)));
}

- (void) testMeasurementHasNoiseSource
{
    NoiseSource * myNoiseSource=[NSEntityDescription insertNewObjectForEntityForName:@"NoiseSource"
                                                              inManagedObjectContext:ctx];
    myNoiseSource.name=@"pump";
    myNoiseSource.measurement=sut;

    assertThat([[sut noiseSource] name], is(equalTo(@"pump")));
}

- (void) testThatCalculateSoundPowerLevelReturnsZeroWhenTypeIsNotSet
{
    [sut setType:nil];
    [sut calculateSoundPowerLevel];
    assertThatFloat([sut soundPowerLevel],is(equalToFloat(0.0f)));
}

                    
#pragma mark II.2

- (void) testMeasurementHasDistance
{
    [sut setDistance:7.3];
    assertThat([NSNumber numberWithFloat:[sut distance]], is(equalToFloat(7.3)));
}

- (void) testMeasurementHasHemiSphereCorrection
{
    [sut setHemiSphereCorrection:2];
    assertThat([NSNumber numberWithFloat:[sut hemiSphereCorrection]], is(equalToFloat(2)));
}

//- (void) testThatExceptionIsRaisedWhenHemiSphereCorrectionIsSetTo1
//{
//    STAssertThrows([sut setHemiSphereCorrection:1],
//                   @"We expected an exception to be raised when hemisphere correction is not 0 or 2");
//}
//
//- (void) testThatExceptionIsRaisedWhenHemiSphereCorrectionIsSetToMinus1
//{
//    STAssertThrows([sut setHemiSphereCorrection:-1],
//                   @"We expected an exception to be raised when hemisphere correction is not 0 or 2");
//}

- (void) testCalculateSWLForSPL50AndDistance10Gives81
{
    sut.type=@"II.2";
    [self calculateSWLForSPL:50 distance:10 hemiSphereCorrection:0];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(81.0,0.05)));
}

- (void) testCalculateSWLForSPL40AndDistance5Gives81
{
    [sut setType:@"II.2"];
    [self calculateSWLForSPL:40 distance:5 hemiSphereCorrection:0];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(65.0,0.05)));
}

- (void) testCalculateSWLForSPL50AndDistance10AndHemiSphereCorrection2Gives79
{
    [sut setType:@"II.2"];    
    [self calculateSWLForSPL:50 distance:10 hemiSphereCorrection:2];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(79.0,0.05)));
}

- (void)calculateSWLForSPL: (float)SPL distance:(float) distance hemiSphereCorrection:(float) hemiSphereCorrection
{
    [sut setDistance:distance];
    [sut setSoundPressureLevel:SPL];
    [sut setHemiSphereCorrection:hemiSphereCorrection];
    [sut calculateSoundPowerLevel];
}

#pragma mark II.3

- (void) testMeasurementHasSurfaceArea
{
    [sut setSurfaceArea:21.5];
    assertThat([NSNumber numberWithFloat:[sut surfaceArea]], is(equalToFloat(21.5)));
}

- (void) testMeasurementHasNearFieldCorrection
{
    [sut setNearFieldCorrection:-2];
    assertThat([NSNumber numberWithFloat:[sut nearFieldCorrection]], is(equalToFloat(-2)));
}
//
//- (void) testThatNearFieldCorrectionIsNotValidatedWhenSetToNonNegativeValue
//{
//    NSNumber * number=[NSNumber numberWithFloat:2.0f];
//    assertThatBool([sut validateNearFieldCorrection:number error:nil], is(equalToBool(NO)));
//}
//
//- (void) testThatExceptionIsRaisedWhenNearFieldCorrectionIsBelowMinusThree
//{
//    STAssertThrows([sut setNearFieldCorrection:-4],
//                   @"We expected an exception to be raised when near field correction is below -3");
//}
//
//- (void) testThatExceptionIsRaisedWhenNearFieldCorrectionIsNotInteger
//{
//    STAssertThrows([sut setNearFieldCorrection:-2.2],
//                   @"We expected an exception to be raised when near field correction is not integer");
//}
//
- (void) testMeasurementHasDirectivityIndex
{
    [sut setDirectivityIndex:1];
    assertThat([NSNumber numberWithFloat:[sut directivityIndex]], is(equalToFloat(1)));
}

- (void) testThatCalculateSoundPowerLevelReturnsZeroWhenSurfaceAreaIsZero
{
    [sut setType:@"II.3"];
    [sut setSurfaceArea:0];
    [sut calculateSoundPowerLevel];
    assertThatFloat([sut soundPowerLevel],is(equalToFloat(0.0f)));
}

- (void) testCalculateSWLForSPL50AndSurface10AndNearFieldMinus1Gives59
{
    [sut setType:@"II.3"];
    [self calculateSWLForSPL:50 surfaceArea:10 nearFieldCorrection:-1];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(59.0,0.05)));
}

- (void) testCalculateSWLForSPL50AndSurface100AndNearFieldMinus1Gives69
{
    [sut setType:@"II.3"];
    [self calculateSWLForSPL:50 surfaceArea:100 nearFieldCorrection:-1];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(69.0,0.05)));
}

- (void)calculateSWLForSPL: (float)SPL surfaceArea:(float) surfaceArea nearFieldCorrection:(float) nearFieldCorrection
{
    [sut setSurfaceArea:surfaceArea];
    [sut setSoundPressureLevel:SPL];
    [sut setNearFieldCorrection:nearFieldCorrection];
    [sut calculateSoundPowerLevel];
}
                    
               
@end
