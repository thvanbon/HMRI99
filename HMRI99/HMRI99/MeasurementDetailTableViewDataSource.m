#import "MeasurementDetailTableViewDataSource.h"
#import "Measurement.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <Photos/Photos.h>

@implementation MeasurementDetailTableViewDataSource

@synthesize tableView;
@synthesize measurement;
@synthesize managedObjectContext;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            if ([indexPath row] != 21) {
                UITextField *measurementTextField = [[UITextField alloc] initWithFrame:CGRectMake(300, 10, 400, 30)];
                UISegmentedControl *measurementTypeControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(300, 10, 185, 30)];
                measurementTextField.adjustsFontSizeToFitWidth = YES;
                measurementTextField.textColor = [UIColor blackColor];
                measurementTextField.tag = [indexPath row]+1;
                measurementTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
                measurementTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                measurementTextField.textAlignment = NSTextAlignmentLeft;
                measurementTextField.delegate = self;
                
                measurementTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
                [cell.contentView addSubview:measurementTextField];
                CGRect frame=CGRectMake(300, 5, 60, 60);
                UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                imageButton.frame=frame;
                imageButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
                imageButton.tag=333;
                imageButton.hidden=YES;
                imageButton.enabled=NO;
                [cell.contentView addSubview:imageButton];
                
                switch ([indexPath row]) {
                    case 0:
                        cell.textLabel.text = @"ID";
                        measurementTextField.placeholder = @"eg. R5";
                        measurementTextField.keyboardType = UIKeyboardTypeDefault;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        measurementTextField.text=measurement.identification;
                        break;
                    case 1:
                        cell.textLabel.text = @"Device";
                        measurementTextField.placeholder = @"eg. Rion NA28 - 41";
                        measurementTextField.keyboardType = UIKeyboardTypeDefault;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        measurementTextField.text=measurement.measurementDevice;
                        break;
                    case 2:
                        cell.textLabel.text = @"Name";
                        measurementTextField.placeholder = @"eg. compressor";
                        measurementTextField.keyboardType = UIKeyboardTypeDefault;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        measurementTextField.text=measurement.noiseSource.name;
                        break;
                    case 3:
                        cell.textLabel.text = @"Subname";
                        measurementTextField.placeholder = @"eg. C-1000";
                        measurementTextField.keyboardType = UIKeyboardTypeDefault;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        measurementTextField.text=measurement.noiseSource.subname;
                        break;
                    case 4:
                        cell.textLabel.text=@"Image";
                        measurementTextField.enabled=NO;
                        if (measurement.image.thumbnail==nil)
                        {
                            imageButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                            imageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                            [imageButton setTitle:@"change\nimage" forState:UIControlStateNormal];
                            imageButton.titleLabel.font = [UIFont systemFontOfSize:12];
                            [imageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                            imageButton.layer.borderWidth = 1.0f;
                            imageButton.layer.borderColor = [UIColor grayColor].CGColor;
                        }else
                        {
                            [imageButton setImage:[UIImage imageWithData:measurement.image.thumbnail] forState: UIControlStateNormal];
                        }
                        [imageButton addTarget: self  action:@selector(imageAddButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
                        imageButton.hidden=NO;
                        imageButton.enabled=YES;
                        break;
                    case 5:
                        cell.textLabel.text = @"Source height";
                        measurementTextField.placeholder = @"in meters";
                        measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        if (measurement.noiseSource.height!=0){
                            measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.noiseSource.height];
                        }
                        break;
                    case 6:
                        cell.textLabel.text = @"Coordinates";
                        measurementTextField.placeholder = @"eg. 52.370216, 4.895168";
                        measurementTextField.keyboardType = UIKeyboardTypeDefault;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        measurementTextField.text=measurement.location.coordinates;
                        break;
                    case 7:
                        cell.textLabel.text = @"Address";
                        measurementTextField.placeholder = @"eg. Visserstraat 50, Aalsmeer, NL";
                        measurementTextField.keyboardType = UIKeyboardTypeDefault;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        measurementTextField.text=measurement.location.address;
                        break;
                    case 8:
                        cell.textLabel.text = @"Conditions";
                        measurementTextField.placeholder = @"eg. 1000 rpm";
                        measurementTextField.keyboardType = UIKeyboardTypeDefault;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        measurementTextField.text=measurement.noiseSource.operatingConditions;
                        break;
                    case 9:
                        cell.textLabel.text = @"Lp";
                        measurementTextField.placeholder = @"eg. 88";
                        measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        float Lp=measurement.soundPressureLevel;
                        if (Lp>0) {
                            measurementTextField.text=[NSString stringWithFormat:@"%0.1f", Lp];
                        }
                        break;
                    case 10:
                        measurementTextField.enabled=NO;
                        cell.textLabel.text = @"Ambient noise correction type";
                        [cell.contentView addSubview:measurementTypeControl];
                        [measurementTypeControl insertSegmentWithTitle:@"Level" atIndex:0 animated:NO];
                        [measurementTypeControl insertSegmentWithTitle:@"Correction" atIndex:1 animated:NO];
                        
                        [measurementTypeControl addTarget:self
                                                   action:@selector(measurementSegmentedControlWasUpdated:)
                                         forControlEvents:UIControlEventValueChanged];
                        if (measurement.backgroundLevelCorrectionType==0) {
                            measurementTypeControl.selectedSegmentIndex=0;
                        }
                        else {
                            measurementTypeControl.selectedSegmentIndex=1;
                        }
                        measurementTypeControl.tag=337;
                        break;
                    case 11:
                        cell.textLabel.text = @"Ambient noise correction";
                        measurementTextField.placeholder = @"eg. 2";
                        measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        float Corr=measurement.backgroundLevelCorrection;
                        if (Corr>0) {
                            measurementTextField.text=[NSString stringWithFormat:@"%0.1f", Corr];
                        }
                        [self updateActivationOfCell: cell atRow:11 matchingBackgroundCorrectionType:@"Correction"];
                        break;
                    case 12:
                        cell.textLabel.text = @"Lambient";
                        measurementTextField.placeholder = @"eg. 75";
                        measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        float Lambient=measurement.backgroundSoundPressureLevel;
                        if (Lambient>0) {
                            measurementTextField.text=[NSString stringWithFormat:@"%0.1f", Lambient];
                        }
                        [self updateActivationOfCell: cell atRow:12 matchingBackgroundCorrectionType:@"Level"];
                        break;
                    case 13:
                        cell.textLabel.text = @"Lambient ID";
                        measurementTextField.placeholder = @"eg. R9";
                        measurementTextField.keyboardType = UIKeyboardTypeDefault;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        measurementTextField.text=measurement.backgroundSoundPressureLevelIdentification;
                        [self updateActivationOfCell: cell atRow:13 matchingBackgroundCorrectionType:@"Level"];
                        break;
                    case 14:
                        measurementTextField.enabled=NO;
                        cell.textLabel.text = @"Type";
                        [cell.contentView addSubview:measurementTypeControl];
                        [measurementTypeControl insertSegmentWithTitle:@"II.2" atIndex:0 animated:NO];
                        [measurementTypeControl insertSegmentWithTitle:@"II.3" atIndex:1 animated:NO];
                        
                        [measurementTypeControl addTarget:self
                                                   action:@selector(measurementSegmentedControlWasUpdated:)
                                         forControlEvents:UIControlEventValueChanged];
                        if ([measurement.type isEqual:@"II.3"]) {
                            measurementTypeControl.selectedSegmentIndex=1;
                        }else
                            measurementTypeControl.selectedSegmentIndex=0;
                        measurementTypeControl.tag=334;
                        break;
                    case 15:
                        cell.textLabel.text = @"Distance";
                        measurementTextField.placeholder = @"in meters";
                        measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        if (measurement.distance>0){
                            measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.distance];
                        }
                        [self updateActivationOfCell: cell atRow:15 matchingType: @"II.2"];
                        break;
                    case 16:
                        measurementTextField.enabled=NO;
                        cell.textLabel.text = @"Hemi. corr.";
                        [cell.contentView addSubview:measurementTypeControl];
                        [measurementTypeControl insertSegmentWithTitle:@"0" atIndex:0 animated:NO];
                        [measurementTypeControl insertSegmentWithTitle:@"-2" atIndex:1 animated:NO];
                        
                        [measurementTypeControl addTarget:self
                                                   action:@selector(measurementSegmentedControlWasUpdated:)
                                         forControlEvents:UIControlEventValueChanged];
                        if (measurement.nearFieldCorrection==0) {
                            measurementTypeControl.selectedSegmentIndex=0;
                        }
                        else {
                            measurementTypeControl.selectedSegmentIndex=1;
                        }
                        measurementTypeControl.tag=336;
                        [self updateActivationOfCell:cell atRow:16 matchingType:@"II.2"];
                        break;
                    case 17:
                        cell.textLabel.text = @"Measurement height";
                        measurementTextField.placeholder = @"in meters";
                        measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        if (measurement.measurementHeight!=0){
                            measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.measurementHeight];
                        }
                        [self updateActivationOfCell:cell atRow:17 matchingType:@"II.2"];
                        break;
                    case 18:
                        break;
                    case 19:
                        cell.textLabel.text = @"Surface";
                        measurementTextField.placeholder = @"in m2";
                        measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                        measurementTextField.returnKeyType = UIReturnKeyNext;
                        [self updateActivationOfCell:cell atRow:19 matchingType: @"II.3"];
                        if (measurement.surfaceArea>0){
                            measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.surfaceArea];
                        }
                        break;
                    case 20:
                        measurementTextField.enabled=NO;
                        cell.textLabel.text = @"Near f. corr.";
                        [cell.contentView addSubview:measurementTypeControl];
                        [measurementTypeControl insertSegmentWithTitle:@"0" atIndex:0 animated:NO];
                        [measurementTypeControl insertSegmentWithTitle:@"-1" atIndex:1 animated:NO];
                        [measurementTypeControl insertSegmentWithTitle:@"-2" atIndex:2 animated:NO];
                        [measurementTypeControl insertSegmentWithTitle:@"-3" atIndex:3 animated:NO];
                        
                        [measurementTypeControl addTarget:self
                                                   action:@selector(measurementSegmentedControlWasUpdated:)
                                         forControlEvents:UIControlEventValueChanged];
                        measurementTypeControl.selectedSegmentIndex=-measurement.nearFieldCorrection;
                        measurementTypeControl.tag=335;
                        [self updateActivationOfCell:cell atRow:20 matchingType:@"II.3"];
                        break;
                    case 22:
                        cell.textLabel.text = @"Lw";
                        measurementTextField.placeholder = @"-";
                        measurementTextField.enabled=NO;
                        [self updateSoundPowerLevelTextFieldInCell:cell atRow:22];
                        break;
                    default:
                        break;
                }
            }
            else{ //row=21
                UITextView *measurementTextView = [[UITextView alloc] initWithFrame:CGRectMake(120, 10, 400, 130)];
                measurementTextView.font=[UIFont systemFontOfSize:17];
                measurementTextView.scrollEnabled = NO;
                measurementTextView.textColor = [UIColor blackColor];
                measurementTextView.tag = [indexPath row]+1;
                measurementTextView.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
                measurementTextView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
                measurementTextView.textAlignment = NSTextAlignmentLeft;
                measurementTextView.delegate = self;
                [cell.contentView addSubview:measurementTextView];
                cell.textLabel.text = @"Remarks";
                //                measurementTextView.placeholder = @"eg. measured in front of facade";
                measurementTextView.keyboardType = UIKeyboardTypeDefault;
                measurementTextView.returnKeyType = UIReturnKeyNext;
                measurementTextView.text=measurement.remarks;
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
    return 23;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4) {
        return 70;
    }
    if (indexPath.row==18) {
        return 0;
    }
    if (indexPath.row==21) {
        return 144;
    }
    if ([measurement.type isEqual:@"II.2"]){
        if (indexPath.row==19 || indexPath.row==20){
            return 0;
        }
    }
    if ([measurement.type isEqual:@"II.3"]){
        if (indexPath.row==15 || indexPath.row==16 || indexPath.row==17){
            return 0;
        }
    }
    if ([measurement.backgroundLevelCorrectionType isEqual:@"Level"]){
        if (indexPath.row==11){
            return 0;
        }
    }
    if ([measurement.backgroundLevelCorrectionType isEqual:@"Correction"]){
        if (indexPath.row==12 || indexPath.row==13){
            return 0;
        }
    }
    return 44;
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
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UITextViewTextDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:textView];
}

-(void)UITextFieldTextDidChange:(NSNotification*)notification
{
    UITextField * textfield = (UITextField*)notification.object;
    NSString * text = textfield.text;
    int tag =(int)[textfield tag];
    switch (tag) {
        case 1:
            measurement.identification=text;
            break;
        case 2:
            measurement.measurementDevice=text;
            break;
        case 3:
            measurement.noiseSource.name=text;
            break;
        case 4:
            measurement.noiseSource.subname=text;
            break;
        case 5:
            break;
        case 6:
            measurement.noiseSource.height=[text floatValue];
            break;
        case 7:
            measurement.location.coordinates=text;
            break;
        case 8:
            measurement.location.address=text;
            break;
        case 9:
            measurement.noiseSource.operatingConditions=text;
            break;
        case 10:
            measurement.soundPressureLevel=[text floatValue];
            [self updateTableView];
            break;
        case 11:
            break;
        case 12:
            measurement.backgroundLevelCorrection=[text floatValue];
            [self updateTableView];
            break;
        case 13:
            measurement.backgroundSoundPressureLevel=[text floatValue];
            [self updateTableView];
            break;
        case 14:
            measurement.backgroundSoundPressureLevelIdentification=text;
            break;
        case 15:
            break;
        case 16:
            measurement.distance=[text floatValue];
            [self updateTableView];
            break;
        case 17:
            measurement.hemiSphereCorrection=[text floatValue];
            [self updateTableView];
            break;
        case 18:
            measurement.measurementHeight=[text floatValue];
            break;
        case 19:
            break;
        case 20:
            measurement.surfaceArea=[text floatValue];
            [self updateTableView];
            break;
        case 21:
            measurement.nearFieldCorrection=[text floatValue];
            [self updateTableView];
            break;
        case 22:
            break;
        case 23:
            break;
        default:
            break;
    }
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    }
}

-(void)UITextViewTextDidChange:(NSNotification*)notification
{
    UITextView * textView = (UITextView*)notification.object;
    NSString * text = textView.text;
    measurement.remarks=text;
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    }
}

-(void)measurementSegmentedControlWasUpdated:(UISegmentedControl *)updatedControl
{
    if (updatedControl.tag==334)
    {
        if (updatedControl.selectedSegmentIndex==0)
        {
            measurement.type=@"II.2";
        } else
            measurement.type=@"II.3";
    } else if (updatedControl.tag==335)
    {
        measurement.nearFieldCorrection=-updatedControl.selectedSegmentIndex;
    } else if (updatedControl.tag==336)
    {
        switch (updatedControl.selectedSegmentIndex) {
            case 0:
                measurement.hemiSphereCorrection=0;
                break;
            case 1:
                measurement.hemiSphereCorrection=-2;
                break;
            default:
                break;
        }
    } else if (updatedControl.tag==337)
    {
        if (updatedControl.selectedSegmentIndex==0)
        {
            measurement.backgroundLevelCorrectionType=@"Level";
        } else
            measurement.backgroundLevelCorrectionType=@"Correction";
    } else
    {
        NSLog(@"Unknown tag for segmented control");
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
    NSIndexPath * IndexPath11 = [NSIndexPath indexPathForRow:11 inSection:0];
    UITableViewCell * cell11=[tableView cellForRowAtIndexPath:IndexPath11];
    NSIndexPath * IndexPath12 = [NSIndexPath indexPathForRow:12 inSection:0];
    UITableViewCell * cell12=[tableView cellForRowAtIndexPath:IndexPath12];
    NSIndexPath * IndexPath13 = [NSIndexPath indexPathForRow:13 inSection:0];
    UITableViewCell * cell13=[tableView cellForRowAtIndexPath:IndexPath13];
    
    NSIndexPath * IndexPath15 = [NSIndexPath indexPathForRow:15 inSection:0];
    UITableViewCell * cell15=[tableView cellForRowAtIndexPath:IndexPath15];
    NSIndexPath * IndexPath16 = [NSIndexPath indexPathForRow:16 inSection:0];
    UITableViewCell * cell16=[tableView cellForRowAtIndexPath:IndexPath16];
    NSIndexPath * IndexPath17 = [NSIndexPath indexPathForRow:17 inSection:0];
    UITableViewCell * cell17=[tableView cellForRowAtIndexPath:IndexPath17];
    NSIndexPath * IndexPath19 = [NSIndexPath indexPathForRow:19 inSection:0];
    UITableViewCell * cell19=[tableView cellForRowAtIndexPath:IndexPath19];
    NSIndexPath * IndexPath20 = [NSIndexPath indexPathForRow:20 inSection:0];
    UITableViewCell * cell20=[tableView cellForRowAtIndexPath:IndexPath20];
    NSIndexPath * IndexPath22 = [NSIndexPath indexPathForRow:22 inSection:0];
    UITableViewCell * cell22=[tableView cellForRowAtIndexPath:IndexPath22];
    
    [self updateActivationOfCell:cell11 atRow:11 matchingBackgroundCorrectionType:@"Correction"];
    [self updateActivationOfCell:cell12 atRow:12 matchingBackgroundCorrectionType:@"Level"];
    [self updateActivationOfCell:cell13 atRow:13 matchingBackgroundCorrectionType:@"Level"];
    
    [self updateActivationOfCell:cell15 atRow:15 matchingType:@"II.2"];
    [self updateActivationOfCell:cell16 atRow:16 matchingType:@"II.2"];
    [self updateActivationOfCell:cell17 atRow:17 matchingType:@"II.2"];
    [self updateActivationOfCell:cell19 atRow:19 matchingType:@"II.3"];
    [self updateActivationOfCell:cell20 atRow:20 matchingType:@"II.3"];
    [self updateSoundPowerLevelTextFieldInCell:cell22 atRow:22];
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (void)activateCell:(UITableViewCell*)cell atRow:(int)row
{
    UITextField * textField=(UITextField *) [cell viewWithTag:row+1];
    if (row!=16 && row!=20) {
        textField.enabled=YES;
        textField.hidden=NO;
    }
    else if (row==20)
    {
        UISegmentedControl * segmentedControl=(UISegmentedControl *) [cell viewWithTag:335];
        segmentedControl.enabled=YES;
        segmentedControl.hidden=NO;
    }
    else{
        UISegmentedControl * segmentedControl=(UISegmentedControl *) [cell viewWithTag:336];
        segmentedControl.enabled=YES;
        segmentedControl.hidden=NO;
    }
    cell.textLabel.textColor=[UIColor blackColor];
}

- (void)deActivateCell:(UITableViewCell*)cell atRow:(int)row
{
    UITextField * textField=(UITextField *) [cell viewWithTag:row+1];
    if (row!=20&& row!=16) {
        textField.enabled=NO;
        textField.hidden=YES;
    } else if (row==20)
    {
        UISegmentedControl * segmentedControl=(UISegmentedControl *) [cell viewWithTag:335];
        segmentedControl.enabled=NO;
        segmentedControl.hidden=YES;
    }
    else{
        UISegmentedControl * segmentedControl=(UISegmentedControl *) [cell viewWithTag:336];
        segmentedControl.enabled=NO;
        segmentedControl.hidden=YES;
    }
    
    cell.textLabel.textColor=[UIColor grayColor];
}

- (void)updateActivationOfCell:(UITableViewCell*) cell atRow:(int)row matchingType:(NSString *)type
{
    if ([measurement.type isEqual:type])
        [self activateCell:cell atRow:row];
    else
        [self deActivateCell:cell atRow:row];
}

- (void)updateActivationOfCell:(UITableViewCell*) cell atRow:(int)row matchingBackgroundCorrectionType:(NSString *)type
{
    if ([measurement.backgroundLevelCorrectionType isEqual:type])
        [self activateCell:cell atRow:row];
    else
        [self deActivateCell:cell atRow:row];
}

- (void)updateSoundPowerLevelTextFieldInCell:(UITableViewCell*)cell atRow:(int)row
{
    NSIndexPath * IndexPath = [NSIndexPath indexPathForRow:22 inSection:0];
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

//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//
//}

-(void)imageAddButtonClicked: (UIButton *) button
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    //UIView *topView = window.rootViewController.view;
    
    UIAlertController *popupQuery = [UIAlertController alertControllerWithTitle:@"Image"
                                                                        message:@"Change measurement image."
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               // Cancel button tappped.
                                                               [window.rootViewController dismissViewControllerAnimated:YES completion:^{
                                                               }];
                                                           }];
    UIAlertAction *removeImageAction = [UIAlertAction actionWithTitle:@"Remove image"
                                                                style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                                                    self.measurement.image.imageData=nil;
                                                                    self.measurement.image.thumbnail=nil;
                                                                    self.measurement.image.url=nil;
                                                                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                                }];
    UIAlertAction *choosePhotoAction = [UIAlertAction actionWithTitle:@"Choose photo"
                                                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"startMediaBrowserNotification" object:nil];
                                                                }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take photo"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"startCameraControllerNotification" object:nil];
                                                              }];
    UIAlertAction *showPhotoAction = [UIAlertAction actionWithTitle:@"Show photo"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"showPhotoNotification" object:self->measurement];
                                                              }];
    
    [popupQuery addAction:cancelAction];
    [popupQuery addAction:removeImageAction];
    [popupQuery addAction:choosePhotoAction];
    [popupQuery addAction:takePhotoAction];
    [popupQuery addAction:showPhotoAction];
    
    //        [window.rootViewController presentViewController:popupQuery animated:YES completion:nil];
    UIPopoverPresentationController *popPresenter = [popupQuery
                                                     popoverPresentationController];
    popPresenter.sourceView = button;
    popPresenter.sourceRect = button.bounds;
    [window.rootViewController presentViewController:popupQuery animated:YES completion:nil];
}


// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)askPermissionToSaveImageToPhotoLibrary:(NSDictionary * _Nonnull)info picker:(UIImagePickerController * _Nonnull)picker {
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
         {
             switch (status) {
                 case PHAuthorizationStatusNotDetermined:{
                     NSLog(@"PHAuthorizationStatusAuthorized");
                     //Save the new image (original or edited) to the Camera Roll
                     [self saveToLibrary];
                     [self saveReloadAndDismissViewController:picker];
                     break;
                 }
                 case PHAuthorizationStatusAuthorized: {
                     NSLog(@"PHAuthorizationStatusAuthorized");
                     //Save the new image (original or edited) to the Camera Roll
                     [self saveToLibrary];
                     [self saveReloadAndDismissViewController:picker];
                     break;}
                 case PHAuthorizationStatusRestricted:
                     NSLog(@"PHAuthorizationStatusRestricted");
                     break;
                 case PHAuthorizationStatusDenied:
                     NSLog(@"PHAuthorizationStatusDenied");
                     break;
                 default:
                     break;
             }
         }];
    }
    else
    {
        url=(NSURL*)[info objectForKey:@"UIImagePickerControllerReferenceURL"];
        [self saveReloadAndDismissViewController:picker];
    }
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo)
    {
        editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        
        [self askPermissionToSaveImageToPhotoLibrary:info picker:picker];
        
    }
}


-(UIImage *)scaleImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)saveToLibrary {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self->imageToUse];
    }completionHandler:^(BOOL success, NSError *error) {
        if(success){
            NSLog(@"Image saved to library");
        }else{
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)saveReloadAndDismissViewController:(UIImagePickerController *)picker
{
    
    float aspectRatio;
    aspectRatio=imageToUse.size.height/imageToUse.size.width;
    float height=90;
    float width=90;
    
    if (aspectRatio>1)
        width=width/aspectRatio;
    else
        height=height*aspectRatio;
    
    UIImage *resizedImage=[self scaleImage:imageToUse scaledToSize:CGSizeMake(width, height)];
    NSData *thumbnail = UIImagePNGRepresentation(resizedImage);
    NSData *imageData = UIImagePNGRepresentation(imageToUse);
    measurement.image.imageData=imageData;
    measurement.image.thumbnail=thumbnail;
    
    NSError *error=nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@",error);
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    }
    
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
