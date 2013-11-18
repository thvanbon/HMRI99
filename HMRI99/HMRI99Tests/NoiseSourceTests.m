    // Class under test
#import "NoiseSource.h"

    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface NoiseSourceTests : SenTestCase
@end

@implementation NoiseSourceTests
{
    NoiseSource * sut;
}

- (void) setUp
{
    [super setUp];
    sut = [[NoiseSource alloc] initWithName:@"compressor"];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
}

- (void) testNoiseSourceHasName
{
    assertThat([sut name], is(equalTo(@"compressor")));
}

- (void) testNoiseSourceCanHaveOperatingConditions
{
    [sut setOperatingConditions:@"2000 rpm"];
    assertThat([sut operatingConditions], is(equalTo(@"2000 rpm")));
}
@end
