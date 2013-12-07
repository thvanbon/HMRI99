    // Class under test
#import "Session.h"

    // Collaborators
#import "Measurement.h"
    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface SessionTests : SenTestCase
@end

@implementation SessionTests
{
    Session *sut;
}

- (void) setUp
{
    [super setUp];
    sut=[[Session alloc] initWithName:@"CARG.13.01"
                                                   date:[NSDate dateWithTimeIntervalSinceReferenceDate:1]
                                               location:@"Zaandam"
                                               engineer:@"Alfred Brooks"];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
    
}
- (void) testThatSessionExists{
    assertThat(sut,notNilValue());
}

- (void) testThatSessionHasName
{
    assertThat([sut name], is(equalTo(@"CARG.13.01")));
}

- (void) testThatSessionHasDate
{
    assertThat([sut date], is(equalTo([NSDate dateWithTimeIntervalSinceReferenceDate:1])));
}

- (void) testThatSessionHasLocation
{
    assertThat([sut location], is(equalTo(@"Zaandam")));
}

- (void) testThatSessionHasEngineer
{
    assertThat([sut engineer], is(equalTo(@"Alfred Brooks")));
}

- (void) testThatSessionHasListOfMeasurements
{
    assertThat([sut measurements],is(instanceOf([NSMutableArray class])));
}

- (void) testThatListOfMeasurementsIsInitiallyEmpty
{
    assertThat([NSNumber numberWithInt:[[sut measurements] count]], is(equalTo(@0)));
}

- (void) testThatMeasurementCanBeAddedToListOfMeasurements
{
    Measurement * myMeasurement=[[Measurement alloc] init];
    [sut addMeasurement:myMeasurement];
    assertThat([NSNumber numberWithInt:[[sut measurements] count]], is(equalTo(@1)));

}

@end
