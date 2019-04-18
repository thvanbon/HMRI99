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
    NSArray *noiseSourceStringsArray=[NSArray arrayWithObjects:
                                  self.name,
                                  self.subname,
                                  self.height,
                                  self.operatingConditions,
                                  nil];
    NSString *exportString=[noiseSourceStringsArray componentsJoinedByString:@"\t"];
    return exportString;
}
@end
