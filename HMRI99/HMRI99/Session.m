#import "Session.h"

@implementation Session
@dynamic name,date,location, engineer, measurements,creationDate;

- (id)initWithName:(NSString*)newName
                     date:(NSDate *)newDate
                 location:(NSString *)newLocation
                 engineer:(NSString *)newEngineer
{
    self = [super init];
    if (self) {
        self.name=[newName copy];
        self.date=[newDate copy];
        self.location=[newLocation copy];
        self.engineer=[newEngineer copy];
//        self.measurements=[[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.name=[[NSString alloc] init];
        self.date=[[NSDate alloc] init];
        self.location=[[NSString alloc] init];
        self.engineer=[[NSString alloc] init];
//        self.measurements=[[NSMutableArray alloc] init];
    }
    return self;
}

//-(void)addMeasurement:(Measurement *)myMeasurement
//{
////    [self.measurements insertObject:myMeasurement atIndex:0];
//    [self.measurements addObject:myMeasurement];
//    
//}

@end
