#import <Foundation/Foundation.h>

@class MeasurementSession;
@class MeasurementSummaryCell;

@interface MeasurementsTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong) MeasurementSession * measurementSession;
@property (weak) IBOutlet MeasurementSummaryCell *summaryCell;
@property (weak) UITableView *tableView;
@end
