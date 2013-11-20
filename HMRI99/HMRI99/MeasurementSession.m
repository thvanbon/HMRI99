#import "MeasurementSession.h"

@implementation MeasurementSession
@synthesize name,date,location, engineer, measurements;

- (id)initWithName:(NSString*)newName
                     date:(NSDate *)newDate
                 location:(NSString *)newLocation
                 engineer:(NSString *)newEngineer
{
    self = [super init];
    if (self) {
        name=[newName copy];
        date=[newDate copy];
        location=[newLocation copy];
        engineer=[newEngineer copy];
        measurements=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addMeasurement:(Measurement *)myMeasurement
{
    [self.measurements insertObject:myMeasurement atIndex:0];
}


@end
