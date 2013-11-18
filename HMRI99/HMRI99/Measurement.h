#import <Foundation/Foundation.h>

@class NoiseSource;
@interface Measurement : NSObject

@property NSString * ID;


@property float soundPressureLevel;
@property float soundPowerLevel;
@property NoiseSource * noiseSource;

- (id)initWithID:(NSString*)newID;

@end
