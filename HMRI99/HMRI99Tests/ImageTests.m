    // Class under test
#import "Image.h"

    // Collaborators

    // Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface ImageTests : XCTestCase
@end

@implementation ImageTests
{
    Image * sut;
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
    NSBundle *bundle;
    NSString *imagePath;
    UIImage *image;
    NSData *imageData;
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
    sut=[NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:ctx];
    
    bundle = [NSBundle bundleForClass:[self class]];
    imagePath = [bundle pathForResource:@"testImage" ofType:@"jpg"];
    image = [UIImage imageWithContentsOfFile:imagePath];
    imageData = UIImagePNGRepresentation(image);
}


- (void)tearDown
{
    bundle=nil;
    imagePath=nil;
    image=nil;
    imageData=nil;
    
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

- (void) testImageHasUrl
{
    sut.url=@"testURL";
    assertThat([sut url], is(equalTo(@"testURL")));
}

- (void) testImageHasImageData
{

    sut.imageData=imageData;
    assertThat([sut imageData], is(equalTo(imageData)));
}

- (void) testImageHasThumbnail
{
    sut.thumbnail=imageData;
    assertThat([sut thumbnail], is(equalTo(imageData)));
}

@end
