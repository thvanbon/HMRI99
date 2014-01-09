#import "Measurement.h"

@implementation Measurement
@synthesize ID, type, soundPressureLevel,soundPowerLevel,noiseSource;
@synthesize distance, hemiSphereCorrection;
@synthesize surfaceArea,nearFieldCorrection,directivityIndex;

- (id)initWithID:(NSString*)newID
{
    self = [super init];
    if (self) {
        ID=[newID copy];
        noiseSource=[[NoiseSource alloc] init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        ID=@"";
        noiseSource=[[NoiseSource alloc] init];
    }
    return self;
}

-(void)calculateSoundPowerLevel
{
    if (type) {
        if ([type isEqual:@"II.2"]) {
            [self calculateSoundPowerLevelII2];
        }else
        {
            [self calculateSoundPowerLevelII3];
        }
    }else
    {
//        [NSException raise:@"error"
//                    format:@"type should be set when sound power level is calculated"];
        self.soundPowerLevel=0.0f;
    }
}

#pragma mark II.2

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

-(void)calculateSoundPowerLevelII2
{
    float SWL=self.soundPressureLevel+10*log10f(4*M_PI*pow(distance,2))-self.hemiSphereCorrection;
    self.soundPowerLevel=SWL;
}

#pragma mark II.3

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

-(void)calculateSoundPowerLevelII3
{
    if (surfaceArea==0) {
//        [NSException raise:@"error"
//                    format:@"surface area should be greater than zero when sound power level is calculated"];
         [self setSoundPowerLevel:0.0f];
    }else
    {
        float SWL= self.soundPressureLevel+10*log10f(self.surfaceArea)+self.nearFieldCorrection + self.directivityIndex;
        [self setSoundPowerLevel:SWL];
    }
}


@end
