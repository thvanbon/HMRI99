#import "MeasurementSessionsTableViewDataSource.h"

@implementation MeasurementSessionsTableViewDataSource
{
    NSArray * MeasurementSessions;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
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
        measurementSessionCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                                        reuseIdentifier: measurementSessionCellReuseIdentifier];
    }
    measurementSessionCell.textLabel.text=[[MeasurementSessions objectAtIndex:[indexPath row]] name];
    return measurementSessionCell;
}

- (void) setMeasurementSessions:(NSArray *) newMeasurementSessions
{
    MeasurementSessions=newMeasurementSessions;
}


@end
