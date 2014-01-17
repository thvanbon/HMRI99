#import "SessionDetailsDataSource.h"
#import "Session.h"
@implementation SessionDetailsDataSource

@synthesize session;
@synthesize managedObjectContext;
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([indexPath section] == 0) {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            textField.adjustsFontSizeToFitWidth = YES;
            textField.textColor = [UIColor blackColor];
            textField.tag = [indexPath row]+1;
            textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
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
                    textField.keyboardType = UIKeyboardTypeDefault;
                    textField.returnKeyType = UIReturnKeyNext;
                    textField.text=session.name;
                    break;
                case 1:
                    cell.textLabel.text = @"Date";
                    textField.placeholder = @"-";
                    textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    textField.returnKeyType = UIReturnKeyNext;
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
                    textField.text=session.engineer;
                    break;
                default:
                    break;
            }
        }
    }
    return cell;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:textField];
}

@end
