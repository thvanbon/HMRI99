#import <UIKit/UIKit.h>

@interface MeasurementDetailViewController : UIViewController
@property (strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> * dataSource;
@end
