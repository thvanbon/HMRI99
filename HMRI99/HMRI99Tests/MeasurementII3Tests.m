// Class under test
#import "MeasurementII3.h"

// Collaborators

// Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementII3Tests : SenTestCase
@end

@implementation MeasurementII3Tests
{
    MeasurementII3 * sut;
}

- (void) setUp
{
    [super setUp];
    sut = [[MeasurementII3 alloc] initWithID:@"R5"];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
}

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

- (void) testThatExceptionIsRaisedWhenNearFieldCorrectionIsSetToNonNegativeValue
{
    STAssertThrows([sut setNearFieldCorrection:2],
                   @"We expected an exception to be raised when near field correction is set to positive value");
}

- (void) testThatExceptionIsRaisedWhenNearFieldCorrectionIsBelowMinusThree
{
    STAssertThrows([sut setNearFieldCorrection:-4],
                   @"We expected an exception to be raised when near field correction is below -3");
}

- (void) testThatExceptionIsRaisedWhenNearFieldCorrectionIsNotInteger
{
    STAssertThrows([sut setNearFieldCorrection:-2.2],
                   @"We expected an exception to be raised when near field correction is not integer");
}

- (void) testMeasurementHasDirectivityIndex
{
    [sut setDirectivityIndex:1];
    assertThat([NSNumber numberWithFloat:[sut directivityIndex]], is(equalToFloat(1)));
}

- (void) testThatExceptionIsRaisedWhenSoundPowerLevelIsCalculatedAndSurfaceAreaIsZero
{
    [sut setSurfaceArea:0];
    STAssertThrows([sut calculateSoundPowerLevel],
                   @"We expected an exception to be raised when sound power level is calculated and surface area is not greater than zero");
}

- (void) testCalculateSWLForSPL50AndSurface10AndNearFieldMinus1Gives59
{
    [self calculateSWLForSPL:50 surfaceArea:10 nearFieldCorrection:-1];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(59.0,0.05)));
}

- (void) testCalculateSWLForSPL50AndSurface100AndNearFieldMinus1Gives69
{
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
