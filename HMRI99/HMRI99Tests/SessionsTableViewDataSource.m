#import "SessionsTableViewDataSource.h"
#import "SessionSummaryStaticCell.h"

NSString * sessionsTableDidSelectSessionNotification=@"sessionsTableDidSelectSessionNotification";
NSString * sessionsTableDidAddSessionNotification=@"sessionsTableDidAddSessionNotification";

@implementation SessionsTableViewDataSource

{
    NSMutableArray * sessions;
}
@synthesize summaryCell;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    return [sessions count];
}

NSString * sessionCellReuseIdentifier=@"Session";

- (SessionSummaryStaticCell *)tableView:(UITableView *)tableView
            cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([sessions count] > [indexPath row]);
    
    if ([sessions count])
    {
        //Session * session = [sessions objectAtIndex: indexPath.row];
        summaryCell =[tableView dequeueReusableCellWithIdentifier: sessionCellReuseIdentifier];
        if (!summaryCell) {
            [[NSBundle bundleForClass: [self class]] loadNibNamed: @"SessionSummaryStaticCell"
                                                            owner: self options: nil];
        }
        
        summaryCell.nameLabel.text=[[self sessionForIndexPath:indexPath] name];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        
        //Optionally for time zone converstions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        
        NSString *stringFromDate = [formatter stringFromDate:[[self sessionForIndexPath:indexPath] date]];
        summaryCell.dateLabel.text=stringFromDate;
        summaryCell.locationLabel.text=[[self sessionForIndexPath:indexPath] location];
        summaryCell.engineerLabel.text=[[self sessionForIndexPath:indexPath] engineer];
    }
    return summaryCell;
}

- (void) setSessions:(NSMutableArray *) newSessions
{
    sessions=newSessions;
}

-(void)addSession
{
    Session *newSession=[[Session alloc]initWithName:@"new Session" date:[NSDate date] location:@"" engineer:@""];
    if ([sessions count]==0) {
        [self setSessions:[NSMutableArray arrayWithObject:newSession]];
    } else{
        [sessions insertObject:newSession atIndex:0];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:sessionsTableDidAddSessionNotification object:newSession];
}

- (Session*) sessionForIndexPath:(NSIndexPath *)myIndexPath
{
    return [sessions objectAtIndex:[myIndexPath row]];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:sessionsTableDidSelectSessionNotification object:[self sessionForIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

@end
