#import "Measurement.h"

@interface MeasurementII3 : Measurement
@property float surfaceArea;
@property float nearFieldCorrection;
@property float directivityIndex;

-(void) calculateSoundPowerLevel;
@end
