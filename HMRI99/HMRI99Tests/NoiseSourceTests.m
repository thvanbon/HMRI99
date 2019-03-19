    // Class under test
#import "NoiseSource.h"

    // Collaborators

    // Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface NoiseSourceTests : XCTestCase
@end

@implementation NoiseSourceTests

{
    NoiseSource * sut;
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
    ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [ctx setPersistentStoreCoordinator: coord];
    sut=[NSEntityDescription insertNewObjectForEntityForName:@"NoiseSource" inManagedObjectContext:ctx];
}

- (void)tearDown
{
    sut=nil;
    ctx = nil;
    NSError *error = nil;
    XCTAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
    [super tearDown];
}


- (void) testNoiseSourceHasName
{
    sut.name=@"compressor";
    assertThat([sut name], is(equalTo(@"compressor")));
}

- (void) testNoiseSourceCanHaveOperatingConditions
{
    [sut setOperatingConditions:@"2000 rpm"];
    assertThat([sut operatingConditions], is(equalTo(@"2000 rpm")));
}

- (void) testNoiseSourceHasExportMethod
{
    assertThatBool([sut respondsToSelector:@selector(exportNoiseSource)],is(equalToLong(YES)));
}

- (void) testExportNoiseSourceGivesFullOutput
{
    sut.name=@"pump";
    sut.operatingConditions=@"idle";
    NSString *expectedExportString=@"pump\tidle";
    assertThat([sut exportNoiseSource],is(equalTo(expectedExportString)));
}
- (void) testExportNoiseSourceGivesFullOutputWithMissingID
{

    sut.operatingConditions=@"idle";
    NSString *expectedExportString=@"\tidle";
    assertThat([sut exportNoiseSource],is(equalTo(expectedExportString)));
}

@end
