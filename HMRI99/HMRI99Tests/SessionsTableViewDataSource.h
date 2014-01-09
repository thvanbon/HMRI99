#import <Foundation/Foundation.h>
#import "Session.h"

@class SessionSummaryStaticCell;

extern NSString *sessionsTableDidSelectSessionNotification;
extern NSString *sessionsTableDidAddSessionNotification;
extern NSString *sessionsTableDidPressAccessoryDetailButtonNotification;

@interface SessionsTableViewDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (weak) IBOutlet SessionSummaryStaticCell * summaryCell;

- (void) setSessions:(NSArray *) newSessions;
- (void) addSession;
- (Session*) sessionForIndexPath:(NSIndexPath *)myIndexPath;

@end
