#import "Location.h"

@implementation Location
@dynamic coordinates, subThoroughfare, thoroughfare, locality, administrativeArea, isoCountryCode,longitude, latitude, address, measurement;

-(void)awakeFromInsert
{
}

-(NSString*)exportLocation
    {
        NSString * coords=@"";
        if (self.coordinates)
            coords=self.coordinates;
        NSString * address=@"";
        if (self.address)
            address=self.address;
            
        NSArray *LocationStringsArray=[NSArray arrayWithObjects:
                                          coords,
                                          address,
                                          nil];
        NSString *exportString=[LocationStringsArray componentsJoinedByString:@"\t"];
        return exportString;
    }

@end
