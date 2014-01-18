#import "Measurement.h"

@implementation Measurement
@dynamic identification, creationDate, type, soundPressureLevel,soundPowerLevel,noiseSource;
@dynamic distance, hemiSphereCorrection;
@dynamic surfaceArea,nearFieldCorrection,directivityIndex;
@dynamic session;


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


-(BOOL) validateHemiSphereCorrection:(id*)valueRef error:(NSError **)outError
{
    if  (*valueRef==nil)
        return YES;
    
    float correctionToValidate=[*valueRef floatValue];
    if (correctionToValidate!=0 & correctionToValidate!=-2)
    {
        NSString * errorStr =@"Hemisphere correction should be 0 or 2";
        NSDictionary *errorDict=[NSDictionary dictionaryWithObject:errorStr forKey:NSLocalizedDescriptionKey];
        NSError * newError=[[NSError alloc] initWithDomain:@"HMRI99" code:100 userInfo:errorDict];
        *outError=newError;
        return NO;
    }
    
    return YES;
    
}


-(void)calculateSoundPowerLevelII2
{
    float SWL=self.soundPressureLevel+10*log10f(4*M_PI*pow(self.distance,2))-self.hemiSphereCorrection;
    self.soundPowerLevel=SWL;
}

#pragma mark II.3

-(BOOL) validateNearFieldCorrection:(id*)valueRef error:(NSError **)outError
{
    if  (*valueRef==nil)
        return YES;
    
    float correctionToValidate=[*valueRef floatValue];
    if (correctionToValidate!=0 & correctionToValidate!=-1 &correctionToValidate!=-2 & correctionToValidate!=-3 )
    {
        NSString * errorStr =@"Near field correction should be 0, -1, -2 or -3";
        NSDictionary *errorDict=[NSDictionary dictionaryWithObject:errorStr forKey:NSLocalizedDescriptionKey];
        NSError * newError=[[NSError alloc] initWithDomain:@"HMRI99" code:100 userInfo:errorDict];
        *outError=newError;
        return NO;
    }
    
    return YES;
    
}

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


