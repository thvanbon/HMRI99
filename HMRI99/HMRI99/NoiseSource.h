#import <Foundation/Foundation.h>

@interface NoiseSource : NSManagedObject
@property NSString *name;
@property NSString * operatingConditions;
- (id)initWithName:(NSString *)myName;
@end
