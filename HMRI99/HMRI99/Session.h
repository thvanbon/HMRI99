#import <Foundation/Foundation.h>
@class Measurement;
@interface Session : NSManagedObject
@property NSString * name;
@property NSDate * date;
@property NSString * location;
@property NSString * engineer;
@property NSDate * creationDate;
@property NSSet * measurements;
- (id)initWithName:(NSString*)newProjectName
                     date:(NSDate *)newDate
                 location:(NSString *)newLocation
                 engineer:(NSString*)newEngineer;

//-(void)addMeasurement:(Measurement *)myMeasurement;
@end
