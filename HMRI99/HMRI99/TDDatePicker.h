#import <UIKit/UIKit.h>
//#import "TDDatePickerDelegate.h"

@class TDDatePicker;

@protocol TDDatePickerDelegate

@required
- (void)datePickerChanged:(TDDatePicker *)datePicker newDate:(NSDate *)newDate;

@end

@interface TDDatePicker : UIDatePicker
//- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)dateChanged;

@property (nonatomic, assign) id <TDDatePickerDelegate> delegate;

@end



