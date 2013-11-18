#import "MeasurementSession.h"

@implementation MeasurementSession
@synthesize projectName,date,location, engineer, measurements;

- (id)initWithProjectName:(NSString*)newProjectName
                     date:(NSDate *)newDate
                 location:(NSString *)newLocation
                 engineer:(NSString *)newEngineer
{
    self = [super init];
    if (self) {
        projectName=[newProjectName copy];
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
