#import "MeasurementsTableViewDataSource.h"

#import "Session.h"
#import "MeasurementSummaryStaticCell.h"
#import "Measurement.h"

@implementation MeasurementsTableViewDataSource

@synthesize session;
@synthesize summaryCell;
@synthesize tableView;
@synthesize managedObjectContext;
@synthesize sortID;

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
        if(measurement.image.thumbnail!=nil)
        {
            summaryCell.imageView.image=[UIImage imageWithData:measurement.image.thumbnail];
            summaryCell.imageView.contentMode=UIViewContentModeScaleAspectFit;
        }
        else{
            UILabel *noImageLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 6, 90, 90)];
            noImageLabel.text=@"no image";
            noImageLabel.textAlignment=NSTextAlignmentLeft;
            noImageLabel.textColor=[UIColor grayColor];
            [summaryCell.imageView addSubview:noImageLabel];
        }
        summaryCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
    Location *newLocation=(Location*)[NSEntityDescription
                                               insertNewObjectForEntityForName:@"Location"
                                               inManagedObjectContext:[self managedObjectContext]];
    Image *newImage=(Image*)[NSEntityDescription
                             insertNewObjectForEntityForName:@"Image"
                             inManagedObjectContext:[self managedObjectContext]];
//    [[self sortMeasurements ] objectAtIndex:[indexPath row]]
//    newMeasurement.measurementDevice=;
    newMeasurement.creationDate=[NSDate date];
    newMeasurement.identification=[self nextMeasurementID];
    newMeasurement.measurementDevice=[self currentMeasurementDevice];
    newMeasurement.session=session;
    newMeasurement.noiseSource=newNoiseSource;
    newMeasurement.image=newImage;
    newMeasurement.location=newLocation;
    NSManagedObjectContext *ctx=[self managedObjectContext];
    NSError *error=nil;
    if (![ctx save:&error]) {
        NSLog(@"Error: %@", error);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:measurementsTableDidAddMeasurementNotification object:newMeasurement];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101.0f;
}

- (NSArray *)sortMeasurements
{
    NSArray *measurements= [session.measurements allObjects];
    NSString *sortKey;
    BOOL ascending=NO;
    switch (self.sortID) {
        case 0:
            sortKey=@"creationDate";
            break;
        case 1:
            sortKey=@"identification";
            ascending=YES;
            break;
        case 2:
            sortKey=@"noiseSource.name";
            ascending=YES;
            break;
        case 3:
            sortKey=@"soundPowerLevel";
            break;
        default:
            break;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
    measurements = [measurements sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return measurements;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *ctx=[self managedObjectContext];
        NSArray *measurements = [self sortMeasurements];
        Measurement *measurementToDelete=[measurements objectAtIndex:indexPath.row];
        [ctx deleteObject:measurementToDelete.noiseSource];
        [ctx deleteObject:measurementToDelete.image];
        [ctx deleteObject:measurementToDelete];
        NSError *error=nil;
        if (![ctx save:&error]) {
            NSLog(@"Error: %@", error);
        }
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (NSString*) nextMeasurementID
{
    int sortID=self.sortID;
    self.sortID=0;
    NSArray* measurements=[self sortMeasurements];
    
    Measurement* lastMeasurement=[measurements firstObject];
    NSInteger lastID = [self extractNumberFromText:[lastMeasurement identification]];
    
    self.sortID=sortID;
    return [NSString stringWithFormat: @"R%ld", lastID+1];
}

- (NSString*) currentMeasurementDevice
{
    int sortID=self.sortID;
    self.sortID=0;
    NSArray* measurements=[self sortMeasurements];
    
    Measurement* lastMeasurement=[measurements firstObject];
    self.sortID=sortID;
    return lastMeasurement.measurementDevice;
}

- (NSInteger)extractNumberFromText:(NSString *)text
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString* string = [[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    return [string integerValue];
}

@end
