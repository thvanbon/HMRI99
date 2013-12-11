#import <UIKit/UIKit.h>

@interface SessionSummaryCell : UITableViewCell

@property (strong) IBOutlet UILabel *nameLabel;
@property (strong) IBOutlet UILabel *dateLabel;
@property (strong) IBOutlet UILabel *locationLabel;
@property (strong) IBOutlet UILabel *engineerLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerTextField;


@end
