#import <UIKit/UIKit.h>

@interface HMRI99ViewController : UIViewController
@property (strong) UITableView *tableView;
@property (strong) id <UITableViewDataSource> dataSource;
// http://stackoverflow.com/questions/10549374/can-a-delegate-property-support-multiple-protocols
@property (strong) id <UITableViewDelegate> tableViewDelegate;
@end
