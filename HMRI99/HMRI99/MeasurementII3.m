#import "MeasurementII3.h"

@implementation MeasurementII3
@synthesize surfaceArea,nearFieldCorrection,directivityIndex;

- (void)setNearFieldCorrection:(float)myNearFieldCorrection
{
    if (myNearFieldCorrection==0 || myNearFieldCorrection==-1 || myNearFieldCorrection==-2 || myNearFieldCorrection==-3 ) {
        nearFieldCorrection=myNearFieldCorrection;
    }else
        [NSException raise:@"error"
                    format:@"near field correction should be 0, -1, -2 or -3"];
}

-(float)nearFieldCorrection
{
    return nearFieldCorrection;
}

-(void)calculateSoundPowerLevel
{
    if (surfaceArea==0) {
            [NSException raise:@"error"
                        format:@"surface area should be greater than zero when sound power level is calculated"];
    }else
    {
        float SWL= self.soundPressureLevel+10*log10f(self.surfaceArea)+self.nearFieldCorrection + self.directivityIndex;
        [self setSoundPowerLevel:SWL];
    }
}

@end
