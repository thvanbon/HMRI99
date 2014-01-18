#import <Foundation/Foundation.h>
@class Measurement;
@interface Session : NSManagedObject
@property NSString * name;
@property NSDate * date;
@property NSString * location;
@property NSString * engineer;
@property NSDate * creationDate;
@property NSSet * measurements;

@end
