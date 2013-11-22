#import <Foundation/Foundation.h>

@interface MeasurementSessionsTableViewDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

- (void) setMeasurementSessions:(NSArray *) newMeasurementSessions;

@end
