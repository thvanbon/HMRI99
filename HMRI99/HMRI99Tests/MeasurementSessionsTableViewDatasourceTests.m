    // Class under test
#import "MeasurementSessionsTableViewDataSource.h"

    // Collaborators
#import "MeasurementSession.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementSessionsTableViewDatasourceTests : SenTestCase
@end

@implementation MeasurementSessionsTableViewDatasourceTests
{
    MeasurementSessionsTableViewDataSource * sut;
}

- (void) setUp
{
    [super setUp];
    sut=[[MeasurementSessionsTableViewDataSource alloc] init];
}

- (void) tearDown
{
    sut=nil;
    [super tearDown];
}

- (void) testMeasurementSessionsDataSourceCanReceiveAListOfMeasurementSessions
{
    
    MeasurementSession * sampleMeasurementSession=[[MeasurementSession alloc] initWithProjectName:@"CARG.13.01"
                                                                                             date:[NSDate date]
                                                                                         location:@"Zaandam"
                                                                                         engineer:@"HKa"];
    NSArray * MeasurementSessions=[NSArray arrayWithObject:sampleMeasurementSession];
    STAssertNoThrow([sut setMeasurementSessions:MeasurementSessions], @"The data source needs a list of measurement sessions");
}

@end
