#import "SessionSummaryStaticCell.h"

@implementation SessionSummaryStaticCell

@synthesize nameLabel;
@synthesize dateLabel;
@synthesize engineerLabel;
@synthesize locationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] init];
        self.dateLabel = [[UILabel alloc] init];
        self.locationLabel = [[UILabel alloc] init];
        self.engineerLabel = [[UILabel alloc] init];

        self.nameLabel.text=@"Project Name";
        self.dateLabel.text=@"Date";
        self.locationLabel.text=@"Location";
        self.engineerLabel.text=@"Engineer";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
