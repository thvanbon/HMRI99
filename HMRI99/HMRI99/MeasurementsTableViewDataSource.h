#import <Foundation/Foundation.h>

@class Session;
@class Measurement;
@class MeasurementSummaryCell;
@class SessionSummaryCell;

extern NSString * measurementsTableDidSelectMeasurementNotification;
extern NSString * measurementsTableDidAddMeasurementNotification;

@interface MeasurementsTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong) Session * session;
@property (weak) IBOutlet MeasurementSummaryCell *summaryCell;
@property (weak) IBOutlet SessionSummaryCell *sessionSummaryCell;

@property (weak) UITableView *tableView;

- (void) setMeasurements: (NSMutableArray *)measurements;
- (void) addMeasurement;
@end
