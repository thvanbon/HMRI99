#import <Foundation/Foundation.h>

#import "NoiseSource.h"
#import "Image.h"
@class Session;
//@class Image;
@interface Measurement : NSManagedObject

@property NSString * identification;
@property NSDate * creationDate;
@property float soundPressureLevel;
@property float soundPowerLevel;
@property (nonatomic, retain) NoiseSource * noiseSource;
@property NSString * type;

@property float distance;
@property float hemiSphereCorrection;

@property float surfaceArea;
@property float nearFieldCorrection;
@property float directivityIndex;
@property (nonatomic, retain) Session *session;
@property (nonatomic, retain) Image *image;

-(void)calculateSoundPowerLevel;
-(void)calculateSoundPowerLevelII2;
-(void)calculateSoundPowerLevelII3;

//-(BOOL) validateNearFieldCorrection:(id*)valueRef error:(NSError **)outError;
-(NSString*)exportMeasurement;
@end
