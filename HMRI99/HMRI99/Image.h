#import <Foundation/Foundation.h>
@class Measurement;
@interface Image : NSManagedObject

@property NSString * url;
@property NSData * imageData;
@property NSData * thumbnail;
@property (nonatomic, retain) Measurement *measurement;
@end
