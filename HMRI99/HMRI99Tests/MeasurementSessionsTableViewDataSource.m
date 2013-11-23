#import "MeasurementSessionsTableViewDataSource.h"


NSString * measurementSessionsTableDidSelectMeasurementSessionNotification=@"measurementSessionsTableDidSelectMeasurementSessionNotification";

@implementation MeasurementSessionsTableViewDataSource
{
    NSArray * MeasurementSessions;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSParameterAssert(section == 0);
    return [MeasurementSessions count];
}

NSString * measurementSessionCellReuseIdentifier=@"MeasurementSession";

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([MeasurementSessions count] > [indexPath row]);
    
    UITableViewCell *measurementSessionCell =[tableView dequeueReusableCellWithIdentifier: measurementSessionCellReuseIdentifier];
    if (!measurementSessionCell) {
        measurementSessionCell = [[UITableViewCell alloc]
                                  initWithStyle: UITableViewCellStyleDefault
                                  reuseIdentifier: measurementSessionCellReuseIdentifier];
    }
    measurementSessionCell.textLabel.text=[[self measurementSessionForIndexPath:indexPath] name];
    return measurementSessionCell;
}

- (void) setMeasurementSessions:(NSArray *) newMeasurementSessions
{
    MeasurementSessions=newMeasurementSessions;
}


- (MeasurementSession*) measurementSessionForIndexPath:(NSIndexPath *)myIndexPath
{
    return [MeasurementSessions objectAtIndex:[myIndexPath row]];
}

- (void)tableView: (UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:measurementSessionsTableDidSelectMeasurementSessionNotification object:[self measurementSessionForIndexPath:indexPath]];
}

@end
