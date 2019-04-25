#import "NoiseSource.h"

@implementation NoiseSource
@dynamic name, subname, operatingConditions, height, measurement;

-(void)awakeFromInsert
{
    self.name=@"";
    self.subname=@"";
    self.operatingConditions=@"";
}
-(NSString*)exportNoiseSource
{
    NSString* exportHeight=@"";
    if (self.height)
    {
        exportHeight=[NSString stringWithFormat:@"%0.1f", self.height];
    }

    NSArray *noiseSourceStringsArray=[NSArray arrayWithObjects:
                                  self.name,
                                  self.subname,
                                  exportHeight,
                                  self.operatingConditions,
                                  nil];
    NSString *exportString=[noiseSourceStringsArray componentsJoinedByString:@"\t"];
    return exportString;
}
@end
