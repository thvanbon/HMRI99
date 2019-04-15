#import <UIKit/UIKit.h>
@class MeasurementsTableViewDataSource;
@interface MeasurementsViewController : UIViewController
@property (strong) IBOutlet UITableView *tableView;
@property (strong) MeasurementsTableViewDataSource <UITableViewDataSource, UITableViewDelegate> * dataSource;
- (void)userDidSelectMeasurementNotification:(NSNotification *)note;
- (void) insertNewObject: (id)sender;
- (void) userDidAddMeasurementNotification:(NSNotification *)note;
@property (strong, nonatomic) IBOutlet UIToolbar *sortBar;
@end
