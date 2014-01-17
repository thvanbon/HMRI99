#import <Foundation/Foundation.h>

#import "NoiseSource.h"
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
@property (nonatomic, retain) NSManagedObject *session;
//@property NSManagedObjectContext * managedObjectContext;

- (id)initWithID:(NSString*)newID;
-(void)calculateSoundPowerLevel;
-(void)calculateSoundPowerLevelII2;
-(void)calculateSoundPowerLevelII3;

@end
 