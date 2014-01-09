#import "SessionSummaryCell.h"

@implementation SessionSummaryCell

@synthesize nameTextField, dateTextField, locationTextField, engineerTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameTextField = [[UITextField alloc] init];
        self.dateTextField = [[UITextField alloc] init];
        self.locationTextField = [[UITextField alloc] init];
        self.engineerTextField = [[UITextField alloc] init];
        
        self.nameTextField.placeholder=@"Project Name";
        self.dateTextField.placeholder=@"Date";
        self.locationTextField.placeholder=@"Location";
        self.engineerTextField.placeholder=@"Engineer";        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
    