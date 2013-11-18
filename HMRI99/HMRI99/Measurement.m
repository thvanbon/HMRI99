#import "Measurement.h"

@implementation Measurement
@synthesize ID, soundPressureLevel,soundPowerLevel,noiseSource;

- (id)initWithID:(NSString*)newID
{
    self = [super init];
    if (self) {
        ID=[newID copy];
    }
    return self;
}


@end
