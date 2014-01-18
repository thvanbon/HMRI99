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
    Session * sut;
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
    ctx = [[NSManagedObjectContext alloc] init];
    [ctx setPersistentStoreCoordinator: coord];
    sut=[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:ctx];
    
    sut.name=@"CARG.13.01";
    sut.date=[NSDate dateWithTimeIntervalSinceReferenceDate:1];
    sut.location=@"Zaandam";
    sut.engineer=@"Alfred Brooks";
}

- (void)tearDown
{
    sut=nil;
    ctx = nil;
    NSError *error = nil;
    STAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
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
    assertThat([sut measurements],is(instanceOf([NSSet class])));
}

- (void) testThatListOfMeasurementsIsInitiallyEmpty
{
    assertThat([NSNumber numberWithInt:[[sut measurements] count]], is(equalTo(@0)));
}

@end
