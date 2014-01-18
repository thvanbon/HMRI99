#import <Foundation/Foundation.h>
@class Measurement;

@interface NoiseSource : NSManagedObject
@property NSString *name;
@property NSString * operatingConditions;
@property (nonatomic, retain) Measurement * measurement;

@end
