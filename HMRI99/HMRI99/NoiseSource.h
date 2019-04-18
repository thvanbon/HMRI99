#import <Foundation/Foundation.h>
@class Measurement;

@interface NoiseSource : NSManagedObject
@property NSString *name;
@property NSString *subname;
@property NSString * operatingConditions;
@property float height;

@property (nonatomic, retain) Measurement * measurement;
-(NSString*)exportNoiseSource;
@end
