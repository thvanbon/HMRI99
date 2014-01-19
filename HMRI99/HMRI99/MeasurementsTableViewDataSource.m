#import "MeasurementsTableViewDataSource.h"

#import "Session.h"
#import "MeasurementSummaryStaticCell.h"
#import "Measurement.h"

@implementation MeasurementsTableViewDataSource

@synthesize session;
@synthesize summaryCell;
@synthesize tableView;
@synthesize managedObjectContext;


NSString * measurementsTableDidSelectMeasurementNotification=@"measurementsTableDidSelectMeasurementNotification";

NSString * measurementsTableDidAddMeasurementNotification=@"measurementsTableDidAddMeasurementNotification";

- (NSInteger)tableView:(UITableView *)atableView numberOfRowsInSection:(NSInteger)section
{
    return [[session measurements] count];
}

- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
        NSParameterAssert([session.measurements count]>=[indexPath row]);

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

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[self tableView] endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:measurementsTableDidSelectMeasurementNotification object:[[self sortMeasurements ] objectAtIndex:[indexPath row]]];
}

- (void)addMeasurement
{
    Measurement *newMeasurement=(Measurement*)[NSEntityDescription
                                         insertNewObjectForEntityForName:@"Measurement"
                                         inManagedObjectContext:[self managedObjectContext]];
    NoiseSource *newNoiseSource=(NoiseSource*)[NSEntityDescription
                                               insertNewObjectForEntityForName:@"NoiseSource"
                                               inManagedObjectContext:[self managedObjectContext]];
    
    newMeasurement.creationDate=[NSDate date];
    newMeasurement.session=session;
    newMeasurement.noiseSource=newNoiseSource;
    [[NSNotificationCenter defaultCenter] postNotificationName:measurementsTableDidAddMeasurementNotification object:newMeasurement];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101.0f;
}

- (NSArray *)sortMeasurements
{
    NSArray *measurements= [session.measurements allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    measurements = [measurements sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return measurements;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *ctx=[self managedObjectContext];
        NSArray *measurements = [self sortMeasurements];
        Measurement *measurementToDelete=[measurements objectAtIndex:indexPath.row];
        [ctx deleteObject:measurementToDelete];
        NSError *error=[[NSError alloc]init];
        if (![ctx save:&error]) {
            NSLog(@"Error: %@", error);
        }
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
@end
