#import "MeasurementsTableViewDataSource.h"

#import "Session.h"
#import "MeasurementSummaryStaticCell.h"
#import "Measurement.h"
#import "SessionSummaryCell.h"

@implementation MeasurementsTableViewDataSource

@synthesize session;
@synthesize summaryCell;
@synthesize tableView;
@synthesize sessionSummaryCell;
@synthesize managedObjectContext;


NSString * measurementsTableDidSelectMeasurementNotification=@"measurementsTableDidSelectMeasurementNotification";

NSString * measurementsTableDidAddMeasurementNotification=@"measurementsTableDidAddMeasurementNotification";

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section {

////    switch (section) {
////        case 0:
////            return 1;
////            break;
////        case 1:
            return [[session measurements] count];
////            break;
////        case 2:
////            //        {
////            //            if ([[session measurements] count]>0)
////            //            {
////            //                return 0;
////            //            }
////            //            else
////            //            {
////            //                return 1;
////            //            }
////            //            //return [[session measurements] count]?0:1;
////            //            break;
////            //        }
////            return 1;
////        default:
////            return 0;
////            break;
////    }
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
//    NSParameterAssert([indexPath section]<3);
//    if ([indexPath section]==0) {
        NSParameterAssert([session.measurements count]>=[indexPath row]);
//    }
//    switch ([indexPath section])
//    {
//        case 0:
//        {
//            sessionSummaryCell = [tableView dequeueReusableCellWithIdentifier: @"session"];
//            if (!sessionSummaryCell) {
//                [[NSBundle bundleForClass: [self class]] loadNibNamed: @"SessionSummaryCell"
//                                                                owner: self options: nil];
//            }
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"dd-MM-yyyy"];
//            sessionSummaryCell.nameTextField.delegate=self;
//            sessionSummaryCell.dateTextField.delegate=self;
//            sessionSummaryCell.locationTextField.delegate=self;
//            sessionSummaryCell.engineerTextField.delegate=self;
//            sessionSummaryCell.nameTextField.text=session.name;
//            sessionSummaryCell.dateTextField.text=[formatter stringFromDate:session.date];
//            sessionSummaryCell.locationTextField.text=session.location;
//            sessionSummaryCell.engineerTextField.text=session.engineer;
//            cell=sessionSummaryCell;
//            sessionSummaryCell=nil;
//            break;
//        }
//        case 1:
//        {
            if ([session.measurements count])
            {
                NSArray *measurements = [self sortMeasurements];
                Measurement * measurement = [measurements objectAtIndex:indexPath.row];
                summaryCell = [tableView dequeueReusableCellWithIdentifier: @"measurement"];
                if (!summaryCell) {
                    [[NSBundle bundleForClass: [self class]] loadNibNamed: @"MeasurementSummaryStaticCell"
                                                                    owner: self options: nil];
                }
                summaryCell.iDLabel.text = measurement.identification;
                summaryCell.measurementTypeLabel.text=measurement.type;
                summaryCell.nameLabel.text=measurement.noiseSource.name;
                float Lp=measurement.soundPressureLevel;
                if (Lp>0) {
                    summaryCell.soundPressureLevelLabel.text=[NSString stringWithFormat:@"Lp = %0.1f dB(A)",Lp];
                } else
                {
                    summaryCell.soundPressureLevelLabel.text=@"";
                }
                float Lw=measurement.soundPowerLevel;
                if (Lw>0) {
                    summaryCell.soundPowerLevelLabel.text=[NSString stringWithFormat:@"Lw = %0.1f dB(A)",Lw];
                } else
                {
                    summaryCell.soundPowerLevelLabel.text=@"";
                }
                summaryCell.AccessoryType=UITableViewCellAccessoryDisclosureIndicator;
                cell = summaryCell;
                summaryCell = nil;
            }
//            break;
//        }
//        case 2:
//        {
//            cell = [tableView dequeueReusableCellWithIdentifier: @"placeholder"];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
//                                              reuseIdentifier: @"placeholder"];
//            }
//            if (![session.measurements count])
//            {
//                cell.textLabel.text= @"No measurements yet!";
//            }
//            else
//                cell.textLabel.text= @"";
//            break;
//        }
//        default:
//        {
//            break;
//        }
//    }
    return cell;
}

//- (void) setMeasurements: (NSMutableOrderedSet *)measurements
//{
//    [session setMeasurements:measurements];
//}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self tableView] endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:measurementsTableDidSelectMeasurementNotification object:[[self sortMeasurements ] objectAtIndex:[indexPath row]]];
}

- (void)addMeasurement
{
//    Measurement *newMeasurement=[[Measurement alloc] init];
    Measurement *newMeasurement=(Measurement*)[NSEntityDescription
                                         insertNewObjectForEntityForName:@"Measurement"
                                         inManagedObjectContext:[self managedObjectContext]];
    NoiseSource *newNoiseSource=(NoiseSource*)[NSEntityDescription
                                               insertNewObjectForEntityForName:@"NoiseSource"
                                               inManagedObjectContext:[self managedObjectContext]];
   // newMeasurement.managedObjectContext=[self managedObjectContext];
    //[session addMeasurement:newMeasurement];
    
    newMeasurement.creationDate=[NSDate date];
    newMeasurement.session=session;
    newMeasurement.noiseSource=newNoiseSource;
    [[NSNotificationCenter defaultCenter] postNotificationName:measurementsTableDidAddMeasurementNotification object:newMeasurement];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height=44.0f;
//    switch (indexPath.section) {
//        case 0:
//            height=147.0f;
//            break;
//        case 1:
            height=101.0f;
//            break;
//        default:
//            break;
//    }
    return height;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(UITextFieldTextDidChange:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:textField];
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UITextFieldTextDidChangeNotification
//                                                  object:textField];
//}

//- (void) UITextFieldTextDidChange:(NSNotification*)notification
//{
//    
//    UITextField * textfield = (UITextField*)notification.object;
//    NSString * text = textfield.text;
//    int tag =[textfield tag];
//    switch (tag) {
//        case 0:
//            session.name=text;
//            break;
//        case 1:
//        {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"dd-MM-yyyy"];
//            session.date=[formatter dateFromString:text];
//            break;
//        }
//        case 2:
//            session.location=text;
//            break;
//        case 3:
//            session.engineer=text;
//            break;
//        default:
//            break;
//    }
//    
//    
//}

- (NSArray *)sortMeasurements
{
    NSArray *measurements= [session.measurements allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    measurements = [measurements sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return measurements;
}



@end
