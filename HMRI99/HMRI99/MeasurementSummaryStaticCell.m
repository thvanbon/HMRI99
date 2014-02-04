#import "MeasurementSummaryStaticCell.h"

@implementation MeasurementSummaryStaticCell

@synthesize iDLabel, measurementTypeLabel, nameLabel, soundPowerLevelLabel, soundPressureLevelLabel,imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        iDLabel=[[UILabel alloc] init];
        nameLabel=[[UILabel alloc] init];
        soundPressureLevelLabel=[[UILabel alloc] init];
        measurementTypeLabel=[[UILabel alloc] init];
        soundPowerLevelLabel=[[UILabel alloc] init];
        imageView=[[UIImageView alloc] init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
