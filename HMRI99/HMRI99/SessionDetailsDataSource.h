#import <Foundation/Foundation.h>
@class Session;
@interface SessionDetailsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSDateFormatter * formatter;
}
@property (strong) Session * session;
@property (weak) UITableView *tableView;
@end
