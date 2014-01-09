// Class under test
#import "MeasurementSummaryStaticCell.h"

// Collaborators

// Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementSummaryStaticCellTests : SenTestCase
@end

@implementation MeasurementSummaryStaticCellTests
{
    MeasurementSummaryStaticCell * sut;
}

- (void) setUp
{
    [super setUp];
    sut=[[MeasurementSummaryStaticCell alloc] init];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
}
- (void) testIDLabelShouldBeConnected
{
    assertThat([sut iDLabel], is(notNilValue()));
}

- (void) testNameLabelShouldBeConnected
{
    assertThat([sut nameLabel], is(notNilValue()));
}

- (void) testSoundPressureLevelLabelShouldBeConnected
{
    assertThat([sut soundPressureLevelLabel], is(notNilValue()));
}

- (void) testMeasurementTypeLabelShouldBeConnected
{
    assertThat([sut measurementTypeLabel], is(notNilValue()));
}

- (void) testSoundPowerLevelLabelShouldBeConnected
{
    assertThat([sut soundPowerLevelLabel], is(notNilValue()));
}

@end
