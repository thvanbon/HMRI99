#import "Measurement.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation Measurement{
    float lAmbient;
}
@dynamic identification, creationDate, type, soundPressureLevel, soundPowerLevel, noiseSource, backgroundSoundPressureLevel, remarks;
@dynamic distance, hemiSphereCorrection;
@dynamic surfaceArea, nearFieldCorrection, directivityIndex;
@dynamic session, image;
@dynamic measurementDevice;
@dynamic location;

-(void)calculateSoundPowerLevel
{
    if (self.type && self.backgroundSoundPressureLevel<self.soundPressureLevel) {
        if (self.backgroundSoundPressureLevel){
            lAmbient= self.backgroundSoundPressureLevel;
        } else {
            lAmbient = -99.0f;
        }

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
    float SWL=10*log10f(pow(10,self.soundPressureLevel/10)-pow(10,lAmbient/10))+10*log10f(4*M_PI*pow(self.distance,2))+self.hemiSphereCorrection;
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
        float SWL= 10*log10f(pow(10,self.soundPressureLevel/10)-pow(10,lAmbient/10))+10*log10f(self.surfaceArea)+self.nearFieldCorrection + self.directivityIndex;
        [self setSoundPowerLevel:SWL];
    }
}

#pragma mark export function
-(NSString*)exportMeasurement
{
    NSString *exportNoiseSource=[self.noiseSource exportNoiseSource];
    NSString *exportLocation=[self.location exportLocation];
    NSString *exportDistance=@"";
    NSString *exportHemiSphereCorrection=@"";
    NSString *exportSurfaceArea=@"";
    NSString *exportNearFieldCorrection=@"";
    NSString *exportDirectivityIndex=@"";
    NSString *exportsoundPressureLevel=[NSString stringWithFormat:@"%0.1f", self.soundPressureLevel];
    NSString *exportsoundPowerLevel=[NSString stringWithFormat:@"%0.1f", self.soundPowerLevel];
    NSString *exportBackgroundSoundPressureLevel=[NSString stringWithFormat:@"%0.1f", self.backgroundSoundPressureLevel];
    NSString *exportRemarks=self.remarks;
    
    if ([self.type isEqual:@"II.2"])
    {
        exportDistance=[NSString stringWithFormat:@"%0.1f", self.distance];
        exportHemiSphereCorrection=[NSString stringWithFormat:@"%0.0f", self.hemiSphereCorrection];
    } else if ([self.type isEqual:@"II.3"])
    {
        exportSurfaceArea=[NSString stringWithFormat:@"%0.1f", self.surfaceArea];
        exportNearFieldCorrection=[NSString stringWithFormat:@"%0.0f", self.nearFieldCorrection];
        exportDirectivityIndex=[NSString stringWithFormat:@"%0.0f", self.directivityIndex];
    }
    
    NSArray *measurementStringsArray=[NSArray arrayWithObjects:
                                exportNoiseSource,
                                exportLocation,
                                self.identification,
                                self.type,
                                exportsoundPressureLevel,
                                exportsoundPowerLevel,
                                exportBackgroundSoundPressureLevel,
                                exportDistance,
                                exportHemiSphereCorrection,
                                exportSurfaceArea,
                                exportNearFieldCorrection,
                                exportDirectivityIndex,
                                exportRemarks,
                                nil];
    NSString *exportString=[measurementStringsArray componentsJoinedByString:@"\t"];
    return exportString;
}

+(NSString*)exportMeasurementHeader
{
    NSArray *exportMeasurementHeaderArray=[NSArray arrayWithObjects:@"noise source name", @"operating conditions", @"coordinates", @"address", @"identification", @"type", @"Lp", @"Lw", @"Lambient", @"distance", @"hemi. correction", @"surface area", @"near field correction", @"directivity index", @"remarks", nil];
    NSString *exportMeasurementHeader=[exportMeasurementHeaderArray componentsJoinedByString:@"\t"];

    return exportMeasurementHeader;
}
    
@end


