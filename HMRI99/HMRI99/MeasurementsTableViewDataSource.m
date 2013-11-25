#import "MeasurementsTableViewDataSource.h"

#import "MeasurementSession.h"
#import "MeasurementSummaryCell.h"
#import "Measurement.h"
@implementation MeasurementsTableViewDataSource

@synthesize measurementSession;
@synthesize summaryCell;
@synthesize tableView;

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section {
    return [[measurementSession measurements] count] ?:1;
}
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([measurementSession.measurements count])
    {
        Measurement * measurement = [measurementSession.measurements objectAtIndex: indexPath.row];
        summaryCell = [tableView dequeueReusableCellWithIdentifier: @"measurement"];
        if (!summaryCell) {
            [[NSBundle bundleForClass: [self class]] loadNibNamed: @"MeasurementSummaryCell"
                                                            owner: self options: nil];
        }
        summaryCell.iDLabel.text = measurement.ID;
        cell = summaryCell;
        summaryCell = nil;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier: @"placeholder"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                          reuseIdentifier: @"placeholder"];
        }
        cell.textLabel.text= @"No Measurements yet!";
    }
    return cell;
        
}


@end
