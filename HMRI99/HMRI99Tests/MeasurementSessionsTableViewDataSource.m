#import "MeasurementSessionsTableViewDataSource.h"

@implementation MeasurementSessionsTableViewDataSource
{
    NSArray * MeasurementSessions;
}

//@synthesize MeasurementSessions;
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void) setMeasurementSessions:(NSArray *) newMeasurementSessions
{
    MeasurementSessions=newMeasurementSessions;
}


@end
