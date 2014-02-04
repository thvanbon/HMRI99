#import <Foundation/Foundation.h>
#import "Session.h"

@class SessionSummaryStaticCell;

extern NSString *sessionsTableDidSelectSessionNotification;
extern NSString *sessionsTableDidAddSessionNotification;
extern NSString *sessionsTableDidPressAccessoryDetailButtonNotification;

@interface SessionsTableViewDataSource : NSObject <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (weak) IBOutlet SessionSummaryStaticCell * summaryCell;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@property (weak) UITableView *tableView;

- (void) addSession;
- (Session*) sessionForIndexPath:(NSIndexPath *)myIndexPath;

@end
