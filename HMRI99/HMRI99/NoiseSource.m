#import "NoiseSource.h"

@implementation NoiseSource
@dynamic name, operatingConditions;

- (id)initWithName:(NSString *)myName
{
    self = [super init];
    if (self) {
        self.name=myName;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.name=[[NSString alloc] init];
    }
    return self;
}

@end
