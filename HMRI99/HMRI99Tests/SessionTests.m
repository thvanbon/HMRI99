    // Class under test
#import "Session.h"

    // Collaborators
#import "Measurement.h"
#import "NoiseSource.h"
#import "Image.h"
    // Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface SessionTests : XCTestCase
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
    ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
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
    XCTAssertTrue([coord removePersistentStore: store error: &error],
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
    assertThat([NSNumber numberWithInteger:[[sut measurements] count]], is(equalTo(@0)));
}

- (void) testThatMeasurementCanBeAdded
{
    Measurement *newMeasurement=(Measurement*)[NSEntityDescription insertNewObjectForEntityForName:@"Measurement"         inManagedObjectContext:ctx];
    newMeasurement.session=sut;
    assertThat([NSNumber numberWithInteger:[[sut measurements] count]], is(equalTo(@1)));
}

- (void) testSessionHasExportMethod
{
    assertThatBool([sut respondsToSelector:@selector(exportSession)],is(equalToLong(YES)));
}

- (void) testExportSessionGivesFullOutputForOneMeasurement
{
    Measurement *newMeasurement;
    newMeasurement = [self addMeasurement];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString=[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:1]];
    NSString *exportNoiseSource=[newMeasurement.noiseSource exportNoiseSource];
    NSString *expectedExportString=[NSString stringWithFormat:@"name\tdate\tlocation\tengineer\tnoise source name\toperating conditions\tcoordinates\taddress\tidentification\tmeasurement time\ttype\tLp\tLw\tLambient\tdistance\themi. correction\tsurface area\tnear field correction\tdirectivity index\tremarks\nCARG.13.01\t%@\tZaandam\tAlfred Brooks\t%@\t43.2, 45.1\tVught\tR1\t\tII.2\t80.0\t100.0\t2.2\t5.0\t0\t\t\t\t\"some remarks\"",dateString, exportNoiseSource];
    assertThat([sut exportSession],is(equalTo(expectedExportString)));
}

- (void) testExportSessionGivesFullOutputForTwoMeasurements
{
    Measurement * measurement1 = [self addMeasurement];
    [self addMeasurement];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString=[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:1]];
    NSString *exportNoiseSource=[measurement1.noiseSource exportNoiseSource];
    NSString *headerString=@"name\tdate\tlocation\tengineer\tnoise source name\toperating conditions\tcoordinates\taddress\tidentification\tmeasurement time\ttype\tLp\tLw\tLambient\tdistance\themi. correction\tsurface area\tnear field correction\tdirectivity index\tremarks";
    NSString *expectedExportMeasurementString=[NSString stringWithFormat:@"CARG.13.01\t%@\tZaandam\tAlfred Brooks\t%@\t43.2, 45.1\tVught\tR1\t\tII.2\t80.0\t100.0\t2.2\t5.0\t0\t\t\t\t\"some remarks\"",dateString, exportNoiseSource];
    NSString *expectedExportString=@"";
    expectedExportString=[headerString stringByAppendingString:[NSString stringWithFormat:@"\n%@",expectedExportMeasurementString]];
    expectedExportString=[expectedExportString stringByAppendingString:[NSString stringWithFormat:@"\n%@",expectedExportMeasurementString]];
                                            
    assertThat([sut exportSession],is(equalTo(expectedExportString)));
}

- (void) testSessionHasExportMeasurementImagesMethod
{
    assertThatBool([sut respondsToSelector:@selector(exportMeasurementImages)],is(equalToLong(YES)));
}


- (void) testExportMeasurementImagesGivesImageName
{
    Measurement * newMeasurement = [self addMeasurement];
    
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSString * imagePath = [bundle pathForResource:@"testImage" ofType:@"jpg"];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    NSData * imageData = UIImagePNGRepresentation(image);
    Image *newImage=(Image*)[NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:ctx];
    newImage.imageData=imageData;
    newMeasurement.image=newImage;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString=[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:1]];
    NSString *expectedImageNameString=[NSString stringWithFormat:@"CARG.13.01-%@-Zaandam-Alfred Brooks-%@-%@",dateString, newMeasurement.identification, newMeasurement.noiseSource.name];

    NSArray * imagesToBeExported=[sut exportMeasurementImages];
    NSArray * firstImageToBeExported=(NSArray *)[imagesToBeExported objectAtIndex:0];
    NSString *imageNameString=(NSString*)[firstImageToBeExported objectAtIndex:0];
    assertThat(imageNameString,is(equalTo(expectedImageNameString)));
}

#pragma mark helper methods

- (Measurement *)addMeasurement
{
    Measurement *newMeasurement=(Measurement*)[NSEntityDescription insertNewObjectForEntityForName:@"Measurement"         inManagedObjectContext:ctx];
    newMeasurement.session=sut;
    newMeasurement.noiseSource=[NSEntityDescription insertNewObjectForEntityForName:@"NoiseSource"
                                                             inManagedObjectContext:ctx];
    newMeasurement.location=[NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                             inManagedObjectContext:ctx];
    newMeasurement.location.coordinates=@"43.2, 45.1";
    newMeasurement.location.address=@"Vught";
    newMeasurement.noiseSource.name=@"pump";
    newMeasurement.noiseSource.operatingConditions=@"idle";
    newMeasurement.type=@"II.2";
    newMeasurement.identification=@"R1";
    newMeasurement.soundPressureLevel=80.0f;
    newMeasurement.soundPowerLevel=100.0f;
    newMeasurement.backgroundSoundPressureLevel=2.25f;
    newMeasurement.distance=5.0f;
    newMeasurement.hemiSphereCorrection=0.0f;
    newMeasurement.remarks=@"some remarks";
    return newMeasurement;
}
@end
