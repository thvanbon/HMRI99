#import <UIKit/UIKit.h>

@interface MeasurementDetailViewController : UITableViewController
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> * dataSource;
@end
