#import <Foundation/Foundation.h>

#import "NoiseSource.h"
@interface Measurement : NSObject

@property NSString * ID;
@property float soundPressureLevel;
@property float soundPowerLevel;
@property NoiseSource * noiseSource;
@property NSString * type;

@property float distance;
@property float hemiSphereCorrection;

@property float surfaceArea;
@property float nearFieldCorrection;
@property float directivityIndex;


- (id)initWithID:(NSString*)newID;
-(void)calculateSoundPowerLevel;
-(void)calculateSoundPowerLevelII2;
-(void)calculateSoundPowerLevelII3;

@end
