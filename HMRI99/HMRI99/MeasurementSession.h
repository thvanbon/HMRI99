#import <Foundation/Foundation.h>
@class Measurement;
@interface MeasurementSession : NSObject
@property NSString * projectName;
@property NSDate * date;
@property NSString * location;
@property NSString * engineer;
@property NSMutableArray * measurements;
- (id)initWithProjectName:(NSString*)newProjectName
                     date:(NSDate *)newDate
                 location:(NSString *)newLocation
                 engineer:(NSString*)newEngineer;

-(void)addMeasurement:(Measurement *)myMeasurement;
@end
