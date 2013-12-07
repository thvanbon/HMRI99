#import "SessionSummaryCell.h"

@implementation SessionSummaryCell

@synthesize nameLabel;
@synthesize dateLabel;
@synthesize engineerLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] init];
        self.dateLabel = [[UILabel alloc] init];
        self.engineerLabel = [[UILabel alloc] init];
        self.nameTextField = [[UITextField alloc] init];
        self.dateTextField = [[UITextField alloc] init];
        self.engineerTextField = [[UITextField alloc] init];
        
        self.nameLabel.text=@"Project Name";
        self.dateLabel.text=@"Date";
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
    