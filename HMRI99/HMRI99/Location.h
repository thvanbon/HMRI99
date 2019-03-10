#import <Foundation/Foundation.h>
@class Measurement;

@interface Location : NSManagedObject

@property NSString *coordinates;
@property NSString *subThoroughfare;
@property NSString *thoroughfare;
@property NSString *locality;
@property NSString *administrativeArea;
@property NSString *isoCountryCode;
@property NSString *address;

@property float latitude;
@property float longitude;

@property (nonatomic, retain) Measurement * measurement;
-(NSString*)exportLocation;
@end
