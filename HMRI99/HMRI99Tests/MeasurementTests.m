    // Class under test
#import "Measurement.h"

    // Collaborators
#import "NoiseSource.h"
    // Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementTests : XCTestCase
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
    ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [ctx setPersistentStoreCoordinator: coord];
    sut=[NSEntityDescription insertNewObjectForEntityForName:@"Measurement"
                                      inManagedObjectContext:ctx];
}

- (void)tearDown
{
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

- (void) testThatCalculateSoundPowerLevelReturnsZeroWhenBackgroundNoiseLevelIsGreaterThanLp
{
    [sut setBackgroundSoundPressureLevel:80.0f];
    [sut setSoundPressureLevel:70.0f];
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
//    XCTAssertThrows([sut setHemiSphereCorrection:1],
//                   @"We expected an exception to be raised when hemisphere correction is not 0 or 2");
//}
//
//- (void) testThatExceptionIsRaisedWhenHemiSphereCorrectionIsSetToMinus1
//{
//    XCTAssertThrows([sut setHemiSphereCorrection:-1],
//                   @"We expected an exception to be raised when hemisphere correction is not 0 or 2");
//}

- (void) testCalculateSWLForSPL50AndDistance10Gives81
{
    sut.type=@"II.2";
    [self calculateSWLForSPL:50 distance:10 hemiSphereCorrection:0];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(81.0,0.05)));
}

- (void) testCalculateSWLForSPL40AndDistance5Gives65
{
    [sut setType:@"II.2"];
    [self calculateSWLForSPL:40 distance:5 hemiSphereCorrection:0];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(65.0,0.05)));
}

- (void) testCalculateSWLForSPL40AndDistance5AndLambient40Gives65
{
    [sut setType:@"II.2"];
    [self calculateSWLForSPL:40 distance:5 hemiSphereCorrection:0 Lambient:37];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(62.0,0.05)));
}

- (void) testCalculateSWLForSPL40AndDistance5AndReflectionCorrection2_5Gives62_5
{
    [sut setType:@"II.2"];
    [self calculateSWLForSPL:40 distance:5 hemiSphereCorrection:0 reflectionCorrection:2.5];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(62.5,0.05)));
}

- (void) testCalculateSWLForSPL40AndDistance5AndReflectionCorrection2_5AndAmbientCorrection2Gives60_5
{
    [sut setType:@"II.2"];
    [sut setBackgroundLevelCorrection:2];
    [sut setBackgroundLevelCorrectionType:@"Correction"];
    [self calculateSWLForSPL:40 distance:5 hemiSphereCorrection:0 reflectionCorrection:2.5];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(60.5,0.05)));
}


- (void) testCalculateSWLForSPL50AndDistance10AndHemiSphereCorrection2Gives79
{
    [sut setType:@"II.2"];    
    [self calculateSWLForSPL:50 distance:10 hemiSphereCorrection:-2];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(79.0,0.05)));
}

- (void)calculateSWLForSPL: (float)SPL distance:(float) distance hemiSphereCorrection:(float) hemiSphereCorrection
{
    [sut setDistance:distance];
    [sut setSoundPressureLevel:SPL];
    [sut setHemiSphereCorrection:hemiSphereCorrection];
    [sut calculateSoundPowerLevel];
}

- (void)calculateSWLForSPL: (float)SPL distance:(float) distance hemiSphereCorrection:(float) hemiSphereCorrection Lambient:(float)lAmbient
{
    [sut setDistance:distance];
    [sut setSoundPressureLevel:SPL];
    [sut setHemiSphereCorrection:hemiSphereCorrection];
    [sut setBackgroundSoundPressureLevel:lAmbient];
    [sut calculateSoundPowerLevel];
}

- (void)calculateSWLForSPL: (float)SPL distance:(float) distance hemiSphereCorrection:(float) hemiSphereCorrection reflectionCorrection:(float)reflectionCorrection
{
    [sut setDistance:distance];
    [sut setSoundPressureLevel:SPL];
    [sut setHemiSphereCorrection:hemiSphereCorrection];
    [sut setReflectionCorrection:reflectionCorrection];
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
//    assertThatBool([sut validateNearFieldCorrection:number error:nil], is(equalToLong(NO)));
//}
//
//- (void) testThatExceptionIsRaisedWhenNearFieldCorrectionIsBelowMinusThree
//{
//    XCTAssertThrows([sut setNearFieldCorrection:-4],
//                   @"We expected an exception to be raised when near field correction is below -3");
//}
//
//- (void) testThatExceptionIsRaisedWhenNearFieldCorrectionIsNotInteger
//{
//    XCTAssertThrows([sut setNearFieldCorrection:-2.2],
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

- (void) testCalculateSWLForSPL50AndSurface100AndNearFieldMinus1AndLambient50Gives66
{
    [sut setType:@"II.3"];
    [self calculateSWLForSPL:50 surfaceArea:100 nearFieldCorrection:-1 Lambient:47];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(66.0,0.05)));
}

- (void) testCalculateSWLForSPL50AndSurface100AndNearFieldMinus1AndLambient50AndReflectionCorrection3_5Gives63_5
{
    [sut setType:@"II.3"];
    [sut setReflectionCorrection:2.5];
    [self calculateSWLForSPL:50 surfaceArea:100 nearFieldCorrection:-1 Lambient:47];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(63.5,0.05)));
}

- (void) testCalculateSWLForSPL50AndSurface100AndNearFieldMinus1AndAmbientCorrection2Gives67
{
    [sut setType:@"II.3"];
    [sut setBackgroundLevelCorrectionType:@"Correction"];
    [sut setBackgroundLevelCorrection:2];
    [self calculateSWLForSPL:50 surfaceArea:100 nearFieldCorrection:-1];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(67.0,0.05)));
}

- (void)calculateSWLForSPL: (float)SPL surfaceArea:(float) surfaceArea nearFieldCorrection:(float) nearFieldCorrection
{
    [sut setSurfaceArea:surfaceArea];
    [sut setSoundPressureLevel:SPL];
    [sut setNearFieldCorrection:nearFieldCorrection];
    [sut calculateSoundPowerLevel];
}

- (void)calculateSWLForSPL: (float)SPL surfaceArea:(float) surfaceArea nearFieldCorrection:(float) nearFieldCorrection Lambient:(float)lAmbient
{
    [sut setSurfaceArea:surfaceArea];
    [sut setSoundPressureLevel:SPL];
    [sut setNearFieldCorrection:nearFieldCorrection];
    [sut setBackgroundSoundPressureLevel:lAmbient];
    [sut calculateSoundPowerLevel];
}


- (void) testMeasurementHasExportMethod
{
    assertThatBool([sut respondsToSelector:@selector(exportMeasurement)],is(equalToLong(YES)));
}


- (void) testMeasurementHasExportMeasurementHeaderMethod
{
    assertThatBool([Measurement respondsToSelector:@selector(exportMeasurementHeader)],is(equalToLong(YES)));
}


- (void) testExportMeasurementGivesFullOutputForTypeII2ForAmbientLevelCorrection
{
    sut.noiseSource=[NSEntityDescription insertNewObjectForEntityForName:@"NoiseSource"
                                      inManagedObjectContext:ctx];
    sut.location=[NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                  inManagedObjectContext:ctx];
    sut.noiseSource.name=@"pump";
    sut.noiseSource.subname=@"P-2340";
    sut.measurementHeight=4.5;
    sut.noiseSource.operatingConditions=@"idle";
    sut.location.address=@"Aalsmeer";
    sut.location.coordinates=@"54.3, 23.4";
    sut.type=@"II.2";
    sut.identification=@"R1";
    sut.soundPressureLevel=80.0f;
    sut.soundPowerLevel=100.0f;
    sut.distance=5.0f;
    sut.hemiSphereCorrection=0.0f;
    sut.backgroundSoundPressureLevel=3.0f;
    sut.backgroundLevelCorrectionType=@"Level";
    sut.backgroundSoundPressureLevelIdentification=@"R43";
    sut.reflectionCorrection=3.0f;
    sut.creationDate=[NSDate date];
    sut.remarks=@"some remarks";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    
    NSString *exportCreationDate = [formatter stringFromDate:sut.creationDate];

    NSString *exportNoiseSource=[sut.noiseSource exportNoiseSource];
    NSString *expectedExportString=[NSString stringWithFormat:@"%@\t54.3, 23.4\tAalsmeer\tR1\t%@\tII.2\t80.0\t100.0\t3.0\tR43\t\t3.0\t5.0\t4.5\t0\t\t\t\t\"some remarks\"", exportNoiseSource, exportCreationDate];
    assertThat([sut exportMeasurement],is(equalTo(expectedExportString)));
}




- (void) testExportMeasurementGivesFullOutputForTypeII3AmbientCorrection
{
    sut.noiseSource=[NSEntityDescription insertNewObjectForEntityForName:@"NoiseSource"
                                                  inManagedObjectContext:ctx];
    sut.location=[NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                               inManagedObjectContext:ctx];
    
    sut.noiseSource.name=@"pump";
    sut.noiseSource.subname=@"P-2340";
    sut.noiseSource.operatingConditions=@"idle";
    sut.location.address=@"Aalsmeer";
    sut.location.coordinates=@"54.3, 23.4";
    sut.type=@"II.3";
    sut.identification=@"R1";
    sut.soundPressureLevel=80.0f;
    sut.soundPowerLevel=97.0f;
    sut.backgroundSoundPressureLevel=3.4f;
    sut.backgroundLevelCorrection=3.0f;
    sut.backgroundLevelCorrectionType=@"Correction";
    sut.reflectionCorrection=3.0f;
    sut.surfaceArea=10.0f;
    sut.nearFieldCorrection=-2.0f;
    sut.directivityIndex=0.0f;
    sut.remarks=@"some remarks";
    
    NSString *exportNoiseSource=[sut.noiseSource exportNoiseSource];
    NSString *expectedExportString=[NSString stringWithFormat:@"%@\t54.3, 23.4\tAalsmeer\tR1\t\tII.3\t80.0\t97.0\t\t\t3.0\t3.0\t\t\t\t10.0\t-2\t0\t\"some remarks\"", exportNoiseSource];
    assertThat([sut exportMeasurement],is(equalTo(expectedExportString)));
}

- (void) testMeasurementHasMeasurementHeight
{
    [sut setMeasurementHeight:5];
    assertThat([NSNumber numberWithFloat:[sut measurementHeight]], is(equalToFloat(5)));
}

- (void) testMeasurementHasAmbientLevelCorrectionType
{
    [sut setBackgroundLevelCorrectionType:@"Level"];
    assertThat([sut backgroundLevelCorrectionType], is(equalTo(@"Level")));
}

- (void) testMeasurementHasBackgroundSoundPressureLevelIdentification
{
    [sut setBackgroundSoundPressureLevelIdentification:@"R43"];
    assertThat([sut backgroundSoundPressureLevelIdentification], is(equalTo(@"R43")));
}

- (void) testMeasurementHasBackgroundLevelCorrection
{
    [sut setBackgroundLevelCorrection:2.5];
    assertThat([NSNumber numberWithFloat:[sut backgroundLevelCorrection]], is(equalToFloat(2.5)));
}

- (void) testMeasurementHasReflectionCorrection
{
    [sut setReflectionCorrection:2];
    assertThat([NSNumber numberWithFloat:[sut reflectionCorrection]], is(equalToFloat(2)));
}

- (void) testMeasurementHasSurfaceType
{
    [sut setSurfaceType:8];
    assertThat([NSNumber numberWithInt:[sut surfaceType]], is(equalToInt(8)));
}

- (void) testExportMeasurementHeaderGivesCompleteHeader
{
    NSString *expectedExportHeaderString=@"noise source name\tnoise source subname\tsource height\toperating conditions\tcoordinates\taddress\tidentification\tmeasurement time\ttype\tLp\tLw\tLambient\tLambient identification\tCambient\tCreflection\tdistance\tmeasurement height\themi. correction\tsurface area\tnear field correction\tdirectivity index\tremarks";
    assertThat([Measurement exportMeasurementHeader],is(equalTo(expectedExportHeaderString)));
}

@end
