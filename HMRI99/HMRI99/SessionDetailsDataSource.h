#import <Foundation/Foundation.h>
@class Session;
#import "TDDatePicker.h"
@interface SessionDetailsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate,TDDatePickerDelegate>
{
    NSDateFormatter * formatter;
}
@property (strong) Session * session;
@property (weak) UITableView *tableView;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property NSInteger togglePick;
@property NSInteger toggleDatePick;

@end
