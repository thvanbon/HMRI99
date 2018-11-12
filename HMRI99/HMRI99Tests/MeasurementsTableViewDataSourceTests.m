// Class under test
#import "MeasurementsTableViewDataSource.h"

// Collaborators
#import "Session.h"
#import "Measurement.h"
#import "MeasurementSummaryStaticCell.h"
//#import "SessionSummaryCell.h"
#import "MeasurementsViewController.h"

// Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>


@interface MeasurementsTableViewDataSourceTests : XCTestCase
@end

@implementation MeasurementsTableViewDataSourceTests
{
    MeasurementsTableViewDataSource * sut;
    Session * session;
    Measurement *newMeasurement1;
    NSDate * myDate;
    NSDateFormatter *formatter;
    NSIndexPath * firstIndexPath;
    NSIndexPath * firstIndexPathSecondSection;
    NSIndexPath * firstIndexPathThirdSection;
    MeasurementSummaryStaticCell *firstCell;
    
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *ctx;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
    
    NSNotification * receivedNotification;
}

- (void) setUp
{
    [super setUp];
    sut= [[MeasurementsTableViewDataSource alloc] init];
    model = [NSManagedObjectModel mergedModelFromBundles: nil];
    coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
    store = [coord addPersistentStoreWithType: NSInMemoryStoreType
                                configuration: nil
                                          URL: nil
                                      options: nil
                                        error: NULL];
    ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [ctx setPersistentStoreCoordinator: coord];
    sut.managedObjectContext=ctx;

    myDate=[NSDate dateWithTimeIntervalSinceNow:0.0f];
    formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    session=[NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:ctx];
    session.name=@"CARG.13.01";
    session.date=myDate;
    session.location=@"Zaandam";
    session.engineer=@"Alfred Brooks";
//    session.creationDate=[NSDate date];
    newMeasurement1=[NSEntityDescription
                                 insertNewObjectForEntityForName:@"Measurement"
                                 inManagedObjectContext:ctx];
    
    newMeasurement1.identification=@"R1";
    newMeasurement1.session=session;
    sut.session=session;
    firstIndexPath = [NSIndexPath indexPathForRow: 0 inSection: 0];
    firstIndexPathSecondSection = [NSIndexPath indexPathForRow: 0 inSection: 1];
    firstIndexPathThirdSection= [NSIndexPath indexPathForRow: 0 inSection: 2];
    firstCell = (MeasurementSummaryStaticCell *)[sut tableView: sut.tableView cellForRowAtIndexPath: firstIndexPath];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveNotification:)
                                                 name: measurementsTableDidSelectMeasurementNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveNotification:)
                                                 name: measurementsTableDidAddMeasurementNotification
                                               object: nil];
}

- (void) tearDown
{
    sut=nil;
    session=nil;
    newMeasurement1=nil;
    myDate=nil;
    formatter=nil;
    firstIndexPath=nil;
    firstIndexPathSecondSection=nil;
    firstIndexPathThirdSection=nil;
    firstCell=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    receivedNotification=nil;
    ctx = nil;
    NSError *error = nil;
    XCTAssertTrue([coord removePersistentStore: store error: &error],
                 @"couldn't remove persistent store: %@", error);
    store = nil;
    coord = nil;
    model = nil;
    [super tearDown];
}

- (void)testSessionWithOneMeasurementsResultsInOnlyOneRowInTheTable
{
    assertThatInt((int) [sut tableView: sut.tableView numberOfRowsInSection: 0], is(equalTo(@1)));
}

- (void)testSessionWithMeasurementsResultsInOneRowPerMeasurementInTheTable
{
    Measurement *newMeasurement2=[NSEntityDescription
                              insertNewObjectForEntityForName:@"Measurement"
                              inManagedObjectContext:ctx];
    newMeasurement2.session=session;
    assertThatInt((int) [sut tableView: sut.tableView numberOfRowsInSection: 0], is(equalTo(@2)));
}

- (void) testCellAccessoryTypeIsDisclosureIndicator
{
    Measurement *newMeasurement=[NSEntityDescription
                                 insertNewObjectForEntityForName:@"Measurement"
                                 inManagedObjectContext:ctx];
    newMeasurement.session=session;
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:sut.tableView cellForRowAtIndexPath:firstIndexPath];
    assertThatInt(cell.accessoryType, is(equalToInt(UITableViewCellAccessoryDisclosureIndicator)));
}

- (void)testCellIDIsTheSameAsTheMeasurementID
{
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:sut.tableView cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.iDLabel.text, is(equalTo(@"R1")));
}

- (void)testCellTypeIsTheSameAsTheMeasurementType
{
    newMeasurement1.type=@"II.2";
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:sut.tableView cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.measurementTypeLabel.text, is(equalTo(@"II.2")));
}

- (void)testCellNameIsTheSameAsTheMeasurementName
{
    newMeasurement1.noiseSource=[NSEntityDescription
                                 insertNewObjectForEntityForName:@"NoiseSource"
                                 inManagedObjectContext:ctx];
    newMeasurement1.noiseSource.name=@"shovel";
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:sut.tableView cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.nameLabel.text, is(equalTo(@"shovel")));
}

- (void)testCellLpIsTheSameAsTheMeasurementLp
{
    newMeasurement1.soundPressureLevel=83.0f;
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:sut.tableView cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.soundPressureLevelLabel.text, is(equalTo(@"Lp = 83.0 dB(A)")));
}

- (void)testCellLwIsTheSameAsTheMeasurementLw
{
    newMeasurement1.soundPowerLevel=105.0f;
    MeasurementSummaryStaticCell * cell=(MeasurementSummaryStaticCell*) [sut tableView:sut.tableView cellForRowAtIndexPath:firstIndexPath];
    assertThat(cell.soundPowerLevelLabel.text, is(equalTo(@"Lw = 105.0 dB(A)")));
}

- (void)testDataSourceDoesNotCreateMoreCellsThanMeasurements
{
    XCTAssertThrows([sut tableView:sut.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow: 1 inSection: 0]], @"Data source will not prepare more cells than Measurements");
}

-(void)testDataSourceSendsNotificationWhenMeasurementIsSelected
{
    NSIndexPath * selection=[NSIndexPath indexPathForRow:0 inSection:1];
    [sut tableView:sut.tableView didSelectRowAtIndexPath:selection];
    assertThat([receivedNotification name], is(equalTo(measurementsTableDidSelectMeasurementNotification)));
}

-(void)testDataSourceSendsNotificationWithMeasurementWhenMeasurementIsSelected
{
    [sut tableView:sut.tableView didSelectRowAtIndexPath:firstIndexPath];
    assertThat([(Measurement *)[receivedNotification object] identification], is(equalTo(@"R1")));
}

- (void) testMeasurementCanBeAddedToDataSource
{
    XCTAssertNoThrow([sut addMeasurement], @"The data source should be able to receive an extra measurement");
}

-(void)testDataSourceSendsNotificationWhenMeasurementIsAdded
{
    [sut addMeasurement];
    assertThat([receivedNotification name], is(equalTo(measurementsTableDidAddMeasurementNotification)));
}
-(void)testDataSourceSendsNotificationWithMeasurementWhenMeasurementIsAdded
{
    [sut addMeasurement];
//    assertThat([(Measurement *)[receivedNotification object] ID], is(equalTo(@"")));
}

- (void)testHeightOfAMeasurementRowIsAtLeastTheSameAsTheHeightOfTheCell
{
//    [session addMeasurement: measurement1];
    NSInteger height = [sut tableView: sut.tableView heightForRowAtIndexPath: firstIndexPathSecondSection];
    MeasurementSummaryStaticCell * firstCellSecondSection=(MeasurementSummaryStaticCell*) [sut tableView:sut.tableView cellForRowAtIndexPath:firstIndexPathSecondSection];
    assertThatFloat(height,is(greaterThanOrEqualTo([NSNumber numberWithFloat:firstCellSecondSection.frame.size.height])));
}

#pragma mark helper methods

- (void) didReceiveNotification:(NSNotification *) myNote
{
    receivedNotification=myNote;
}

- (NSString *)formatDate:(NSDate *)myNewDate
{
    NSString *stringFromDate = [formatter stringFromDate:myNewDate];
    return stringFromDate;
}

@end
