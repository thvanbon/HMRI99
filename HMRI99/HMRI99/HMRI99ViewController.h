#import <UIKit/UIKit.h>
@interface HMRI99ViewController : UIViewController
@property (strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> * dataSource;
- (void)userDidSelectSessionNotification:(NSNotification *)note;
- (void) insertNewObject: (id)sender;
@end
