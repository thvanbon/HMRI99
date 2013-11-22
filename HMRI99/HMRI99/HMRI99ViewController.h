#import <UIKit/UIKit.h>
@interface HMRI99ViewController : UIViewController
@property (strong) UITableView *tableView;
@property (strong) id <UITableViewDataSource, UITableViewDelegate> dataSource;
@end
