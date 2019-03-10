#import "Session.h"
#import "Measurement.h"
@implementation Session
@dynamic name, date, location, engineer, measurements, creationDate, numberOfMeasurements;

-(void)awakeFromInsert
{
    self.date=[NSDate date];
    self.creationDate=[NSDate date];
}

-(NSString*)exportSession
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSArray *sessionStringsArray=[NSArray arrayWithObjects:
                                  self.name,
                                  [formatter stringFromDate:self.date],
                                  self.location,
                                  self.engineer,
                                  nil];
    NSString *exportSessionString=[sessionStringsArray componentsJoinedByString:@"\t"];
    
    NSArray *exportSessionHeaderArray=[NSArray arrayWithObjects:@"name", @"date", @"location", @"engineer", nil];
    NSString *exportSessionHeader=[exportSessionHeaderArray componentsJoinedByString:@"\t"];
    
    NSMutableArray*measurementsStringArray=[[NSMutableArray alloc] init];
    [measurementsStringArray addObject:[NSString stringWithFormat:@"%@\t%@", exportSessionHeader, [Measurement exportMeasurementHeader]]];
    for (Measurement *measurement in self.measurements)
    {
        NSString *exportMeasurementString=[measurement exportMeasurement];
        [measurementsStringArray addObject:[NSString stringWithFormat:@"%@\t%@",exportSessionString,exportMeasurementString]];
    }
    NSString *exportString=[measurementsStringArray componentsJoinedByString:@"\n"];
    return exportString;
}

-(NSArray*)exportMeasurementImages
{
    NSMutableArray *imagesToBeExported=[[NSMutableArray alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    for (Measurement *measurement in self.measurements)
    {
        if (measurement.image.imageData!=nil)
        {
            NSArray *imageNameArray=[NSArray arrayWithObjects:
                                     self.name,
                                     [formatter stringFromDate:self.date],
                                     self.location,
                                     self.engineer,
                                     measurement.identification,
                                     measurement.noiseSource.name,
                                     nil];
            NSString *imageName=[imageNameArray componentsJoinedByString:@"-"];
            NSArray * imageAndName=[NSArray arrayWithObjects:imageName, [UIImage imageWithData:measurement.image.imageData], nil];
            [imagesToBeExported addObject:imageAndName];
        }
    }
    return imagesToBeExported;
}

-(void) countMeasurements
{
    self.numberOfMeasurements = [self.measurements count];
    return ;
}
@end
