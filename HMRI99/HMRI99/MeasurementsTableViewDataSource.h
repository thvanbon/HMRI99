#import <Foundation/Foundation.h>

@class Session;
@class MeasurementSummaryCell;

@interface MeasurementsTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong) Session * session;
@property (weak) IBOutlet MeasurementSummaryCell *summaryCell;
@property (weak) UITableView *tableView;
@end
