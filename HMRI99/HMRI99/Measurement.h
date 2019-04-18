#import <Foundation/Foundation.h>

#import "NoiseSource.h"
#import "Image.h"
#import "Location.h"

@class Session;

@interface Measurement : NSManagedObject

@property NSString * identification;
@property NSDate * creationDate;
@property float soundPressureLevel;
@property float soundPowerLevel;
@property float backgroundSoundPressureLevel;
@property NSString * backgroundLevelCorrectionType;
@property NSString * backgroundSoundPressureLevelIdentification;
@property float backgroundLevelCorrection;
@property float reflectionCorrection;
@property NSString * remarks;
@property (nonatomic, retain) NoiseSource * noiseSource;
@property NSString * type;

@property NSString * measurementDevice;

@property float distance;
@property float hemiSphereCorrection;

@property int16_t surfaceType;
@property float surfaceArea;
@property float nearFieldCorrection;
@property float directivityIndex;

@property float measurementHeight;

@property (nonatomic, retain) Session *session;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) Location *location;

+(NSString*)exportMeasurementHeader;


-(void)calculateSoundPowerLevel;
-(void)calculateSoundPowerLevelII2;
-(void)calculateSoundPowerLevelII3;

//-(BOOL) validateNearFieldCorrection:(id*)valueRef error:(NSError **)outError;
-(NSString*)exportMeasurement;
@end
