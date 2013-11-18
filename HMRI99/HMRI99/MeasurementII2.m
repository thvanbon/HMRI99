#import "MeasurementII2.h"

@implementation MeasurementII2
@synthesize distance, hemiSphereCorrection;

- (void)setHemiSphereCorrection:(float)myHemiSphereCorrection
{
    if (myHemiSphereCorrection!=0 && myHemiSphereCorrection!=2) {
        [NSException raise:@"error"
                    format:@"hemisphere correction should be 0 or 2"];
    }else
        hemiSphereCorrection=myHemiSphereCorrection;
        
}

-(float)hemiSphereCorrection
{
    return hemiSphereCorrection;
}

-(void)calculateSoundPowerLevel
{
    float SWL=self.soundPressureLevel+10*log10f(4*M_PI*pow(distance,2))-self.hemiSphereCorrection;
    self.soundPowerLevel=SWL;
}

@end
