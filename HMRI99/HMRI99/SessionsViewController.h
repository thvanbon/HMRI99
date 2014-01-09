#import <UIKit/UIKit.h>

@interface SessionsViewController : UIViewController
@property (strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> * dataSource;
- (void)userDidSelectSessionNotification:(NSNotification *)note;
- (void) insertNewObject: (id)sender;
- (void) userDidAddSessionNotification:(NSNotification *)note;
- (void)userDidPressDetailDisclosureButtonNotification:(NSNotification *)note;
@end
