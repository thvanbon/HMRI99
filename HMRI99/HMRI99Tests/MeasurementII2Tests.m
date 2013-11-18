    // Class under test
#import "MeasurementII2.h"

    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementII2Tests : SenTestCase
@end

@implementation MeasurementII2Tests
{
    MeasurementII2 * sut;
}

- (void) setUp
{
    [super setUp];
    sut = [[MeasurementII2 alloc] initWithID:@"R4"];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
}

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

- (void) testThatExceptionIsRaisedWhenHemiSphereCorrectionIsSetTo1
{
    STAssertThrows([sut setHemiSphereCorrection:1],
                   @"We expected an exception to be raised when hemisphere correction is not 0 or 2");
}

- (void) testThatExceptionIsRaisedWhenHemiSphereCorrectionIsSetToMinus1
{
    STAssertThrows([sut setHemiSphereCorrection:-1],
                   @"We expected an exception to be raised when hemisphere correction is not 0 or 2");
}

- (void) testCalculateSWLForSPL50AndDistance10Gives81
{
    [self calculateSWLForSPL:50 distance:10 hemiSphereCorrection:0];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(81.0,0.05)));
}

- (void) testCalculateSWLForSPL40AndDistance5Gives81
{
    [self calculateSWLForSPL:40 distance:5 hemiSphereCorrection:0];
    assertThat([NSNumber numberWithFloat: [sut soundPowerLevel]],is(closeTo(65.0,0.05)));
}

- (void) testCalculateSWLForSPL50AndDistance10AndHemiSphereCorrection2Gives79
{
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

@end
