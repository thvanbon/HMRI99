#import "NoiseSource.h"

@implementation NoiseSource
@dynamic name, operatingConditions, measurement;

-(void)awakeFromInsert
{
    self.operatingConditions=@"";
}
-(NSString*)exportNoiseSource
{
    NSArray *noiseSourceStringsArray=[NSArray arrayWithObjects:
                                  self.name,
                                  self.operatingConditions,
                                  nil];
    NSString *exportString=[noiseSourceStringsArray componentsJoinedByString:@"\t"];
    return exportString;
}
@end
