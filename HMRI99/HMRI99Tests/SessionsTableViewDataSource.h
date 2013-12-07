#import <Foundation/Foundation.h>
#import "Session.h"

@class SessionSummaryCell;

extern NSString *sessionsTableDidSelectSessionNotification;
extern NSString *sessionsTableDidAddSessionNotification;

@interface SessionsTableViewDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (weak) IBOutlet SessionSummaryCell * summaryCell;
- (void) setSessions:(NSArray *) newSessions;
- (void) addSession;
- (Session*) sessionForIndexPath:(NSIndexPath *)myIndexPath;

@end
