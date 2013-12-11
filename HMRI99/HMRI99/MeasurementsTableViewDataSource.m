#import "MeasurementsTableViewDataSource.h"

#import "Session.h"
#import "MeasurementSummaryCell.h"
#import "Measurement.h"
#import "SessionSummaryCell.h"

@implementation MeasurementsTableViewDataSource

@synthesize session;
@synthesize summaryCell;
@synthesize tableView;
@synthesize sessionSummaryCell;

NSString * measurementsTableDidSelectMeasurementNotification=@"measurementsTableDidSelectMeasurementNotification";

NSString * measurementsTableDidAddMeasurementNotification=@"measurementsTableDidAddMeasurementNotification";

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else
        return [[session measurements] count] ?:1;
    
}
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSParameterAssert([indexPath section]<3);
    if ([indexPath section]==1) {
        NSParameterAssert([session.measurements count]>=[indexPath row]);
    }
    switch ([indexPath section])
    {
        case 0:
        {
//            SessionSummaryCell * sessionSummaryCell=[[SessionSummaryCell alloc] init];
            sessionSummaryCell = [tableView dequeueReusableCellWithIdentifier: @"session"];
            if (!sessionSummaryCell) {
                [[NSBundle bundleForClass: [self class]] loadNibNamed: @"SessionSummaryCell"
                                                                owner: self options: nil];
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd-MM-yyyy"];
            sessionSummaryCell.nameTextField.text=session.name;
            sessionSummaryCell.dateTextField.text=[formatter stringFromDate:session.date];
            sessionSummaryCell.locationTextField.text=session.location;
            sessionSummaryCell.engineerTextField.text=session.engineer;            cell=sessionSummaryCell;
            sessionSummaryCell=nil;
            break;
        }
        case 1:
        {
            if ([session.measurements count])
            {
                Measurement * measurement = [session.measurements objectAtIndex: indexPath.row];
                summaryCell = [tableView dequeueReusableCellWithIdentifier: @"measurement"];
                if (!summaryCell) {
                    [[NSBundle bundleForClass: [self class]] loadNibNamed: @"MeasurementSummaryCell"
                                                                    owner: self options: nil];
                }
                summaryCell.iDLabel.text = measurement.ID;
                cell = summaryCell;
                summaryCell = nil;
            }
            break;
        }
        case 2:
        {
            if (![session.measurements count])
                cell = [tableView dequeueReusableCellWithIdentifier: @"placeholder"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                              reuseIdentifier: @"placeholder"];
            }
            cell.textLabel.text= @"No Measurements yet!";
            break;
        }
        default:
        {
            break;
        }
    }
    return cell;
}

- (void) setMeasurements: (NSMutableArray *)measurements
{
    [session setMeasurements:measurements];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self tableView] endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:measurementsTableDidSelectMeasurementNotification object:nil];
}

- (void)addMeasurement
{
    [[NSNotificationCenter defaultCenter] postNotificationName:measurementsTableDidAddMeasurementNotification object:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 139.0f;
}

@end
