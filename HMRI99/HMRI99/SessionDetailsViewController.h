#import <UIKit/UIKit.h>
#import "TDDatePicker.h"
#import "SessionDetailsDataSource.h"
@interface SessionDetailsViewController : UIViewController
@property (strong) IBOutlet UITableView *tableView;
@property (strong) SessionDetailsDataSource <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate,TDDatePickerDelegate> * dataSource;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) TDDatePicker *datePicker;
@end
