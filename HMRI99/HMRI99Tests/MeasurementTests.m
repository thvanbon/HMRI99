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
}

- (void) setUp
{
    [super setUp];
    sut = [[Measurement alloc] initWithID:@"R4"];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
}

- (void) testMeasurementHasID
{
    assertThat([sut ID], is(equalTo(@"R4")));
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
    NoiseSource * myNoiseSource=[[NoiseSource alloc] initWithName:@"pump"];
    [sut setNoiseSource:myNoiseSource];
    assertThat([[sut noiseSource] name], is(equalTo(@"pump")));
}
               
@end
