#import "NoiseSource.h"

@implementation NoiseSource
@synthesize name, operatingConditions;

- (id)initWithName:(NSString *)myName
{
    self = [super init];
    if (self) {
        name=myName;
    }
    return self;
}

@end
