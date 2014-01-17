#import "Measurement.h"

@implementation Measurement
@dynamic identification, creationDate, type, soundPressureLevel,soundPowerLevel,noiseSource;
@dynamic distance, hemiSphereCorrection;
@dynamic surfaceArea,nearFieldCorrection,directivityIndex;
@dynamic session;
//@synthesize managedObjectContext;

- (id)initWithID:(NSString*)newID
{
    self = [super init];
    if (self) {
        self.identification=[newID copy];
        self.noiseSource=[[NoiseSource alloc] init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.identification=@"";
        self.noiseSource=[[NoiseSource alloc] init];
    }
    return self;
}

-(void)calculateSoundPowerLevel
{
    if (self.type) {
        if ([self.type isEqual:@"II.2"]) {
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

//- (void)setHemiSphereCorrection:(float)myHemiSphereCorrection
//{
//    if (myHemiSphereCorrection!=0 && myHemiSphereCorrection!=2) {
//        [NSException raise:@"error"
//                    format:@"hemisphere correction should be 0 or 2"];
//    }else
//        self.hemiSphereCorrection=myHemiSphereCorrection;
//    
//}
//
//-(float)hemiSphereCorrection
//{
//    return self.hemiSphereCorrection;
//}

-(void)calculateSoundPowerLevelII2
{
    float SWL=self.soundPressureLevel+10*log10f(4*M_PI*pow(self.distance,2))-self.hemiSphereCorrection;
    self.soundPowerLevel=SWL;
}

#pragma mark II.3

//- (void)setNearFieldCorrection:(float)myNearFieldCorrection
//{
//    if (myNearFieldCorrection==0 || myNearFieldCorrection==-1 || myNearFieldCorrection==-2 || myNearFieldCorrection==-3 ) {
//        self.nearFieldCorrection=myNearFieldCorrection;
//    }else
//        [NSException raise:@"error"
//                    format:@"near field correction should be 0, -1, -2 or -3"];
//}
//
//-(float)nearFieldCorrection
//{
//    return self.nearFieldCorrection;
//}

-(void)calculateSoundPowerLevelII3
{
    if (self.surfaceArea==0) {
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
