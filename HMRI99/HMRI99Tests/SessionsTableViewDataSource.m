#import "SessionsTableViewDataSource.h"
#import "SessionSummaryStaticCell.h"

NSString * sessionsTableDidSelectSessionNotification=@"sessionsTableDidSelectSessionNotification";
NSString * sessionsTableDidAddSessionNotification=@"sessionsTableDidAddSessionNotification";
NSString * sessionsTableDidPressAccessoryDetailButtonNotification=@"sessionsTableDidPressAccessoryDetailButtonNotification";

@implementation SessionsTableViewDataSource

@synthesize summaryCell;
@synthesize managedObjectContext;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    NSError *error=nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"error: %@", error);
        abort();
    }
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
}

NSString * sessionCellReuseIdentifier=@"Session";

- (SessionSummaryStaticCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Session *session = [self sessionForIndexPath:indexPath];
    
        summaryCell =[tableView dequeueReusableCellWithIdentifier: sessionCellReuseIdentifier];
        if (!summaryCell) {
            [[NSBundle bundleForClass: [self class]] loadNibNamed: @"SessionSummaryStaticCell"
                                                            owner: self options: nil];
        }
        
        summaryCell.nameLabel.text=[session name];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        
        //Optionally for time zone converstions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        
        NSString *stringFromDate = [formatter stringFromDate:[session date]];
        summaryCell.dateLabel.text=stringFromDate;
        summaryCell.locationLabel.text=[session location];
        summaryCell.engineerLabel.text=[session engineer];
        [summaryCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

    return summaryCell;
}


-(void)addSession
{
    Session *newSession=(Session*)[NSEntityDescription insertNewObjectForEntityForName:@"Session"
                                                                inManagedObjectContext:[self managedObjectContext]];
    //newSession.creationDate=[NSDate date];
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:sessionsTableDidAddSessionNotification object:newSession];
}

- (Session*) sessionForIndexPath:(NSIndexPath *)myIndexPath
{
    return [self.fetchedResultsController objectAtIndexPath:myIndexPath];

}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:sessionsTableDidSelectSessionNotification object:[self sessionForIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:sessionsTableDidPressAccessoryDetailButtonNotification object:[self sessionForIndexPath:indexPath]];
}

#pragma mark - Fetched results controller

-(NSFetchedResultsController*) fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session"
                                              inManagedObjectContext: managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    _fetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate=self;
    return _fetchedResultsController;
}

@end
