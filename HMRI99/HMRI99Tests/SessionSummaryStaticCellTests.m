    // Class under test
#import "SessionSummaryStaticCell.h"

    // Collaborators

    // Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface SessionSummaryStaticCellTests : XCTestCase
@end

@implementation SessionSummaryStaticCellTests
{
    SessionSummaryStaticCell * sut;
}

- (void) setUp
{
    [super setUp];
        sut=[[SessionSummaryStaticCell alloc] init];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
}
- (void) testNameLabelShouldBeConnected
{
    assertThat([sut nameLabel], is(notNilValue()));
}

- (void) testDateLabelShouldBeConnected
{
    assertThat([sut dateLabel], is(notNilValue()));
}

- (void) testLocationLabelShouldBeConnected
{
    assertThat([sut locationLabel], is(notNilValue()));
}

- (void) testEngineerLabelShouldBeConnected
{
    assertThat([sut engineerLabel], is(notNilValue()));
}

- (void) testNameLabelShouldBeNamedProjectName
{
    assertThat([[sut nameLabel] text], is(equalTo(@"Project Name")));
}

- (void) testDateLabelShouldBeNamedDate
{
    assertThat([[sut dateLabel] text], is(equalTo(@"Date")));
}

- (void) testLocationLabelShouldBeNamedLocation
{
    assertThat([[sut locationLabel] text], is(equalTo(@"Location")));
}

- (void) testEngineerLabelShouldBeNamedEngineer
{
    assertThat([[sut engineerLabel] text], is(equalTo(@"Engineer")));
}
@end
