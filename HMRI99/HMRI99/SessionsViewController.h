#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SessionsViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> * dataSource;
- (void)userDidSelectSessionNotification:(NSNotification *)note;
- (void) insertNewObject: (id)sender;
- (void) userDidAddSessionNotification:(NSNotification *)note;
- (void)userDidPressDetailDisclosureButtonNotification:(NSNotification *)note;
@end
