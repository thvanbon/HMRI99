#import <UIKit/UIKit.h>

@interface MeasurementsViewController : UIViewController
@property (strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> * dataSource;
- (void)userDidSelectMeasurementNotification:(NSNotification *)note;
- (void) insertNewObject: (id)sender;
- (void) userDidAddMeasurementNotification:(NSNotification *)note;
@end
