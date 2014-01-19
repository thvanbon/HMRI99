#import "Session.h"

@implementation Session
@dynamic name,date,location, engineer, measurements,creationDate;

-(void)awakeFromInsert
{
    self.date=[NSDate date];
    self.creationDate=[NSDate date];
}
@end
