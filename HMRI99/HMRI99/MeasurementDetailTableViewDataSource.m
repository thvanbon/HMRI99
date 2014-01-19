#import "MeasurementDetailTableViewDataSource.h"
#import "Measurement.h"

@implementation MeasurementDetailTableViewDataSource

@synthesize tableView;
@synthesize measurement;
@synthesize managedObjectContext;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([indexPath section] == 0) {
            UITextField *measurementTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            UISegmentedControl *measurementTypeControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            measurementTextField.adjustsFontSizeToFitWidth = YES;
            measurementTextField.textColor = [UIColor blackColor];
            measurementTextField.tag = [indexPath row]+1;
            measurementTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            measurementTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            measurementTextField.textAlignment = NSTextAlignmentLeft;
            measurementTextField.delegate = self;
            
            measurementTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            [cell.contentView addSubview:measurementTextField];            
            switch ([indexPath row]) {
                case 0:
                    cell.textLabel.text = @"ID";
                    measurementTextField.placeholder = @"eg. R5";
                    measurementTextField.keyboardType = UIKeyboardTypeDefault;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    measurementTextField.text=measurement.identification;
                    break;
                case 1:
                    cell.textLabel.text = @"Name";
                    measurementTextField.placeholder = @"eg. compressor";
                    measurementTextField.keyboardType = UIKeyboardTypeDefault;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    measurementTextField.text=measurement.noiseSource.name;
                    break;
                case 2:
                    cell.textLabel.text = @"Lp";
                    measurementTextField.placeholder = @"eg. 88";
                    measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    float Lp=measurement.soundPressureLevel;
                    if (Lp>0) {
                        measurementTextField.text=[NSString stringWithFormat:@"%0.1f", Lp];
                    }
                    break;
                case 3:
                    measurementTextField.enabled=NO;
                    cell.textLabel.text = @"Type";
                    [cell.contentView addSubview:measurementTypeControl];
                    [measurementTypeControl insertSegmentWithTitle:@"II.2" atIndex:0 animated:NO];
                    [measurementTypeControl insertSegmentWithTitle:@"II.3" atIndex:1 animated:NO];
                    measurementTypeControl.segmentedControlStyle=UISegmentedControlStylePlain;
                    [measurementTypeControl addTarget:self
                                               action:@selector(measurementSegmentedControlWasUpdated:)
                                     forControlEvents:UIControlEventValueChanged];
                    if ([measurement.type isEqual:@"II.3"]) {
                        measurementTypeControl.selectedSegmentIndex=1;
                    }else
                        measurementTypeControl.selectedSegmentIndex=0;
                    measurementTypeControl.tag=10;
                    break;
                case 4:
                    cell.textLabel.text = @"Distance";
                    measurementTextField.placeholder = @"in meters";
                    measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    if (measurement.distance>0){
                        measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.distance];
                    }
                    [self updateActivationOfCell: cell atRow:4 forType: @"II.2"];
                    break;
                case 5:
                    cell.textLabel.text = @"Surface";
                    measurementTextField.placeholder = @"in m2";
                    measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    [self updateActivationOfCell:cell atRow:5 forType: @"II.3"];
                    if (measurement.surfaceArea>0){
                        measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.surfaceArea];
                    }
                    break;
                case 6:
                    measurementTextField.enabled=NO;
                    cell.textLabel.text = @"Near f. corr.";
                    [cell.contentView addSubview:measurementTypeControl];
                    [measurementTypeControl insertSegmentWithTitle:@"0" atIndex:0 animated:NO];
                    [measurementTypeControl insertSegmentWithTitle:@"-1" atIndex:1 animated:NO];
                    [measurementTypeControl insertSegmentWithTitle:@"-2" atIndex:2 animated:NO];
                    [measurementTypeControl insertSegmentWithTitle:@"-3" atIndex:3 animated:NO];
                    measurementTypeControl.segmentedControlStyle=UISegmentedControlStylePlain;
                    [measurementTypeControl addTarget:self
                                               action:@selector(measurementSegmentedControlWasUpdated:)
                                     forControlEvents:UIControlEventValueChanged];
                    measurementTypeControl.selectedSegmentIndex=-measurement.nearFieldCorrection;
                    measurementTypeControl.tag=11;
                    [self updateActivationOfCell:cell atRow:6 forType:@"II.3"];
                    break;
                case 7:
                    cell.textLabel.text = @"Lw";
                    measurementTextField.placeholder = @"-";
                    measurementTextField.enabled=NO;
                    [self updateSoundPowerLevelTextFieldInCell:cell atRow:7];
                    break;
                default:
                    break;
            }
        }
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
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

-(void)UITextFieldTextDidChange:(NSNotification*)notification
{
    UITextField * textfield = (UITextField*)notification.object;
    NSString * text = textfield.text;
    int tag =[textfield tag];
    switch (tag) {
        case 1:
            measurement.identification=text;
            break;
        case 2:
            measurement.noiseSource.name=text;
            break;
        case 3:
            measurement.soundPressureLevel=[text floatValue];
            [self updateTableView];
            break;
        case 4:
            break;
        case 5:
            measurement.distance=[text floatValue];
            [self updateTableView];
            break;
        case 6:
            measurement.surfaceArea=[text floatValue];
            [self updateTableView];
            break;
        case 7:
            measurement.nearFieldCorrection=[text floatValue];
            [self updateTableView];
            break;
        default:
            break;
    }
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    }
}

-(void)measurementSegmentedControlWasUpdated:(UISegmentedControl *)updatedControl
{
    if (updatedControl.tag==10)
    {
        if (updatedControl.selectedSegmentIndex==0)
        {
            measurement.type=@"II.2";
        } else
            measurement.type=@"II.3";
    } else
    {
        measurement.nearFieldCorrection=-updatedControl.selectedSegmentIndex;
    }
    [self updateTableView];
}

-(void)updateTableView
{
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    }
    [measurement calculateSoundPowerLevel];
    NSIndexPath * IndexPath4 = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell * cell4=[tableView cellForRowAtIndexPath:IndexPath4];
    NSIndexPath * IndexPath5 = [NSIndexPath indexPathForRow:5 inSection:0];
    UITableViewCell * cell5=[tableView cellForRowAtIndexPath:IndexPath5];
    NSIndexPath * IndexPath6 = [NSIndexPath indexPathForRow:6 inSection:0];
    UITableViewCell * cell6=[tableView cellForRowAtIndexPath:IndexPath6];
     NSIndexPath * IndexPath7 = [NSIndexPath indexPathForRow:7 inSection:0];
     UITableViewCell * cell7=[tableView cellForRowAtIndexPath:IndexPath7];
    
    [self updateActivationOfCell:cell4 atRow:4 forType:@"II.2"];
    [self updateActivationOfCell:cell5 atRow:5 forType:@"II.3"];
    [self updateActivationOfCell:cell6 atRow:6 forType:@"II.3"];
    [self updateSoundPowerLevelTextFieldInCell:cell7 atRow:7];
}

- (void)activateCell:(UITableViewCell*)cell atRow:(int)row
{
    UITextField * textField=(UITextField *) [cell viewWithTag:row+1];
    if (row!=6) {
        textField.enabled=YES;
    } else
    {
        UISegmentedControl * segmentedControl=(UISegmentedControl *) [cell viewWithTag:11];
        segmentedControl.enabled=YES;
    }
    cell.textLabel.textColor=[UIColor blackColor];    
}

- (void)deActivateCell:(UITableViewCell*)cell atRow:(int)row
{
    UITextField * textField=(UITextField *) [cell viewWithTag:row+1];
    if (row!=6) {
        textField.enabled=NO;
    } else
    {
        UISegmentedControl * segmentedControl=(UISegmentedControl *) [cell viewWithTag:11];
        segmentedControl.enabled=NO;
    }

    cell.textLabel.textColor=[UIColor grayColor];
}

- (void)updateActivationOfCell:(UITableViewCell*) cell atRow:(int)row forType:(NSString *)type
{
    if ([measurement.type isEqual:type])
        [self activateCell:cell atRow:row];
    else
        [self deActivateCell:cell atRow:row];
}

- (void)updateSoundPowerLevelTextFieldInCell:(UITableViewCell*)cell atRow:(int)row
{
    NSIndexPath * IndexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    UITextField *measurementTextField= (UITextField*)[cell viewWithTag:[IndexPath row]+1];
    if (measurement.soundPowerLevel>0) {
        measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.soundPowerLevel];
    } else
        measurementTextField.text=@"";
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


@end
