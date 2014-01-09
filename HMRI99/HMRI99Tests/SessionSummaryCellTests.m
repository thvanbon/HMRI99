    // Class under test
#import "SessionSummaryCell.h"

    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface SessionSummaryCellTests : SenTestCase
@end

@implementation SessionSummaryCellTests
{
    SessionSummaryCell * sut;
}

- (void) setUp
{
    [super setUp];
    sut=[[SessionSummaryCell alloc] init];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
}

- (void) testNameTextFieldShouldBeConnected
{
    assertThat([sut nameTextField], is(notNilValue()));
}

- (void) testDateTextFieldShouldBeConnected
{
    assertThat([sut dateTextField], is(notNilValue()));
}

- (void) testLocationTextFieldShouldBeConnected
{
    assertThat([sut locationTextField], is(notNilValue()));
}

- (void) testEngineereTextFieldShouldBeConnected
{
    assertThat([sut engineerTextField], is(notNilValue()));
}

- (void) testNameTextFieldShouldHavePlaceholder
{
    assertThat([[sut nameTextField] placeholder], is(equalTo(@"Project Name")));
}

- (void) testDateTextFieldShouldHavePlaceholder
{
    assertThat([[sut dateTextField] placeholder], is(equalTo(@"Date")));
}

- (void) testLocationTextFieldShouldHavePlaceholder
{
    assertThat([[sut locationTextField] placeholder], is(equalTo(@"Location")));
}

- (void) testEngineerTextFieldShouldHavePlaceholder
{
    assertThat([[sut engineerTextField] placeholder], is(equalTo(@"Engineer")));
}

@end
