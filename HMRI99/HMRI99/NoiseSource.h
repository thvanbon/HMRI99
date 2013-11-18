#import <Foundation/Foundation.h>

@interface NoiseSource : NSObject
@property NSString *name;
@property NSString * operatingConditions;
- (id)initWithName:(NSString *)myName;
@end
