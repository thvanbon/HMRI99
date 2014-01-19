#import <UIKit/UIKit.h>

@interface SessionDetailsViewController : UIViewController
@property (strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> * dataSource;

@end
