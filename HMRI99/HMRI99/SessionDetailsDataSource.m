#import "SessionDetailsDataSource.h"
#import "Session.h"
@class TDDatePicker;
@implementation SessionDetailsDataSource

@synthesize session;
@synthesize managedObjectContext;

//@synthesize datePicker;
- (id)init
{
    self = [super init];
    if (self) {
        formatter=[[NSDateFormatter alloc] init];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:nil];
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([indexPath section] == 0) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            textField.adjustsFontSizeToFitWidth = YES;
            textField.textColor = [UIColor blackColor];
            textField.tag = [indexPath row]+1;
            textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            textField.autocapitalizationType = UITextAutocapitalizationTypeSentences; 
            textField.textAlignment = NSTextAlignmentLeft;
            textField.delegate = self;
            
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.textLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:textField];
            [formatter setDateFormat:@"dd-MM-yyyy"];
            switch ([indexPath row]) {
                case 0:
                    cell.textLabel.text = @"Name";
                    textField.placeholder = @"eg. ABC.14.01";
                    //textField.autocorrectionType = UITextAutocorrectionTypeYes;
                    textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
                    textField.keyboardType = UIKeyboardTypeDefault;
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.text=session.name;
                    break;
                case 1:
                    cell.textLabel.text = @"Date";
                    textField.placeholder = @"-";
                    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.enabled=NO;
                    textField.text=[formatter stringFromDate:session.date];
                    break;
                case 2:
                    cell.textLabel.text = @"Location";
                    textField.placeholder = @"eg. Aalsmeer";
                    textField.keyboardType = UIKeyboardTypeDefault;
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.text=session.location;
                    break;
                case 3:
                    cell.textLabel.text = @"Engineer";
                    textField.placeholder = @"eg. ABc";
                    textField.keyboardType = UIKeyboardTypeDefault;
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.enabled=NO;
                    textField.text=session.engineer;
                    break;
                default:
                    break;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self tableView:nil didDeselectRowAtIndexPath:indexPath];
    [self.tableView endEditing:YES];
//    NSLog(@"cell row: %d",indexPath.row);
    if (indexPath.row==3) {
        if(self.togglePick != 1)
        {
            self.togglePick = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bringUpPickerView:" object:nil];
            self.toggleDatePick = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideDatePickerView:" object:nil];
        }
        else
        {
            self.togglePick = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePickerView:" object:nil];
        }
        
    }else if (indexPath.row==1)
    {
        if(self.toggleDatePick != 1)
        {
            self.toggleDatePick = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bringUpDatePickerView:" object:nil];
            self.togglePick = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePickerView:" object:nil];
        }
        else
        {
            self.toggleDatePick = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideDatePickerView:" object:nil];
        }
        
    }
}


-(void)UITextFieldTextDidChange:(NSNotification*)notification
{
    UITextField * textfield = (UITextField*)notification.object;
    NSString * text = textfield.text;
    int tag =[textfield tag];
    switch (tag) {
        case 1:
            session.name=text;
            break;
        case 2:
            session.date=[formatter dateFromString:text];
            break;
        case 3:
            session.location=text;
            break;
        case 4:
            session.engineer=text;
            break;
        default:
            break;
    }
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextFieldTextDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:textField];
}
//
//-(BOOL) textFieldShouldReturn:(UITextField *)textField
//{
//        [self.tableView endEditing:YES];//[textField resignFirstResponder];
//    return NO;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.togglePick = 0;
    NSString * engineer=[self pickerView:pickerView titleForRow:row forComponent:component];
    session.engineer=engineer;
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    }
    UITableViewCell * myCell=[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    for (UIView *view in myCell.contentView.subviews)
    {
        if ([view isKindOfClass:[UITextField class]])
        {
            UITextField* txtField = (UITextField *)view;
            txtField.text=engineer;
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePickerView:" object:nil];
    NSLog(@"row selected:%ld", (long)row);
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray * engineers=[NSArray arrayWithObjects:@"RBa",@"TBo",@"RFl",@"RGi",@"EGr",@"RHa",@"SHo",@"ENi", nil];
    return [NSString stringWithFormat:@"%@", [engineers objectAtIndex:row]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 8;
}

- (void)datePickerChanged:(TDDatePicker *)datePicker newDate:(NSDate *)newDate
{
    session.date=newDate;
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:NO];
}

@end
