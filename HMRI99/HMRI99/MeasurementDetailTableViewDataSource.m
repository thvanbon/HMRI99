#import "MeasurementDetailTableViewDataSource.h"
#import "Measurement.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

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
            UITextField *measurementTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            UISegmentedControl *measurementTypeControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            measurementTextField.adjustsFontSizeToFitWidth = YES;
            measurementTextField.textColor = [UIColor blackColor];
            measurementTextField.tag = [indexPath row]+1;
            measurementTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            measurementTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            measurementTextField.textAlignment = NSTextAlignmentLeft;
            measurementTextField.delegate = self;
            
            measurementTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            [cell.contentView addSubview:measurementTextField];
            CGRect frame=CGRectMake(110, 5, 60, 60);
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
                    cell.textLabel.text = @"Name";
                    measurementTextField.placeholder = @"eg. compressor";
                    measurementTextField.keyboardType = UIKeyboardTypeDefault;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    measurementTextField.text=measurement.noiseSource.name;
                    break;
                case 2:
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
                    [imageButton addTarget: self  action:@selector(imageAddButtonClicked) forControlEvents: UIControlEventTouchUpInside];
                    imageButton.hidden=NO;
                    imageButton.enabled=YES;
                    break;
                case 3:
                    cell.textLabel.text = @"Lp";
                    measurementTextField.placeholder = @"eg. 88";
                    measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    float Lp=measurement.soundPressureLevel;
                    if (Lp>0) {
                        measurementTextField.text=[NSString stringWithFormat:@"%0.1f", Lp];
                    }
                    break;
                case 4:
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
                case 5:
                    cell.textLabel.text = @"Distance";
                    measurementTextField.placeholder = @"in meters";
                    measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    if (measurement.distance>0){
                        measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.distance];
                    }
                    [self updateActivationOfCell: cell atRow:5 forType: @"II.2"];
                    break;
                case 6:
                    cell.textLabel.text = @"Surface";
                    measurementTextField.placeholder = @"in m2";
                    measurementTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    measurementTextField.returnKeyType = UIReturnKeyNext;
                    [self updateActivationOfCell:cell atRow:6 forType: @"II.3"];
                    if (measurement.surfaceArea>0){
                        measurementTextField.text=[NSString stringWithFormat:@"%0.1f", measurement.surfaceArea];
                    }
                    break;
                case 7:
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
                    [self updateActivationOfCell:cell atRow:7 forType:@"II.3"];
                    break;
                case 8:
                    cell.textLabel.text = @"Lw";
                    measurementTextField.placeholder = @"-";
                    measurementTextField.enabled=NO;
                    [self updateSoundPowerLevelTextFieldInCell:cell atRow:8];
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
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        return 70;
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
        case 4:
            measurement.soundPressureLevel=[text floatValue];
            [self updateTableView];
            break;
        case 5:
            break;
        case 6:
            measurement.distance=[text floatValue];
            [self updateTableView];
            break;
        case 7:
            measurement.surfaceArea=[text floatValue];
            [self updateTableView];
            break;
        case 8:
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
    NSIndexPath * IndexPath5 = [NSIndexPath indexPathForRow:5 inSection:0];
    UITableViewCell * cell5=[tableView cellForRowAtIndexPath:IndexPath5];
    NSIndexPath * IndexPath6 = [NSIndexPath indexPathForRow:6 inSection:0];
    UITableViewCell * cell6=[tableView cellForRowAtIndexPath:IndexPath6];
    NSIndexPath * IndexPath7 = [NSIndexPath indexPathForRow:7 inSection:0];
    UITableViewCell * cell7=[tableView cellForRowAtIndexPath:IndexPath7];
    NSIndexPath * IndexPath8 = [NSIndexPath indexPathForRow:8 inSection:0];
    UITableViewCell * cell8=[tableView cellForRowAtIndexPath:IndexPath8];
    
    [self updateActivationOfCell:cell5 atRow:5 forType:@"II.2"];
    [self updateActivationOfCell:cell6 atRow:6 forType:@"II.3"];
    [self updateActivationOfCell:cell7 atRow:7 forType:@"II.3"];
    [self updateSoundPowerLevelTextFieldInCell:cell8 atRow:78];
}

- (void)activateCell:(UITableViewCell*)cell atRow:(int)row
{
    UITextField * textField=(UITextField *) [cell viewWithTag:row+1];
    if (row!=7) {
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
    if (row!=7) {
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
    NSIndexPath * IndexPath = [NSIndexPath indexPathForRow:8 inSection:0];
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

-(void)imageAddButtonClicked
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = window.rootViewController.view;
    
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Image" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:@"Remove image" otherButtonTitles:@"Choose photo", @"Take photo", @"Show photo",nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:topView];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSError *error=nil;
    switch (buttonIndex) {
        case 0:
            //Remove photo
            measurement.image.imageData=nil;
            measurement.image.thumbnail=nil;
            measurement.image.url=nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Error: %@",error);
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case 1:
            //Choose photo
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startMediaBrowserNotification" object:nil];
            break;
        case 2:
            //Take photo
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startCameraControllerNotification" object:nil];
            break;
        case 3:
            //Show photo
            break;
        case 4:
            //Cancel
            break;
    }
    
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
        
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
            //Save the new image (original or edited) to the Camera Roll
            ALAssetsLibrary *al = [[ALAssetsLibrary alloc] init];
            ALAssetOrientation orientation;
            NSString *infoOrientation = [[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"Orientation"];
            switch ([infoOrientation integerValue]) {
                case 3:
                    orientation = ALAssetOrientationUp;
                    break;
                case 6:
                    orientation = ALAssetOrientationRight;
                    break;
                default:
                    orientation = ALAssetOrientationDown;
                    break;
            }
            [al writeImageToSavedPhotosAlbum:[imageToUse CGImage] orientation:orientation completionBlock:^(NSURL *assetURL, NSError *error) {
                if (error == nil) {
                    NSLog(@"saved");
                    url = assetURL;
                    [self saveReloadAndDismissViewController:picker];
                }
                else
                {
                    NSLog(@"error");
                }
            }];
        }  else
        {
            url=(NSURL*)[info objectForKey:@"UIImagePickerControllerReferenceURL"];
            [self saveReloadAndDismissViewController:picker];
        }
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
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [picker dismissViewControllerAnimated:YES completion:nil];        
    }
    
}

@end
