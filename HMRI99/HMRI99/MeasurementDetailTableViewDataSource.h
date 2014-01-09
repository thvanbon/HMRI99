#import <Foundation/Foundation.h>

@class Measurement;
@interface MeasurementDetailTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property Measurement *measurement;
@property (weak) UITableView *tableView;
-(void)measurementSegmentedControlWasUpdated:(UISegmentedControl *)updatedControl;

-(void) updateTableView;
-(BOOL) textFieldShouldReturn:(UITextField *)textField;
@end
