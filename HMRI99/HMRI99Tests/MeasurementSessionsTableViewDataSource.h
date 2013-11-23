#import <Foundation/Foundation.h>
#import "MeasurementSession.h"

extern NSString *measurementSessionsTableDidSelectMeasurementSessionNotification;

@interface MeasurementSessionsTableViewDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

- (void) setMeasurementSessions:(NSArray *) newMeasurementSessions;
- (MeasurementSession*) measurementSessionForIndexPath:(NSIndexPath *)myIndexPath;
@end
