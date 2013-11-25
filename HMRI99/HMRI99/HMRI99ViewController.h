#import <UIKit/UIKit.h>
@interface HMRI99ViewController : UIViewController
@property (strong) UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> * dataSource;
- (void)userDidSelectMeasurementSessionNotification:(NSNotification *)note;

@end
