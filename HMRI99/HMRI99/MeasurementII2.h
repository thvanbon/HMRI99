#import "Measurement.h"

@interface MeasurementII2 : Measurement

@property float distance;
@property float hemiSphereCorrection;

-(void)calculateSoundPowerLevel;
@end
