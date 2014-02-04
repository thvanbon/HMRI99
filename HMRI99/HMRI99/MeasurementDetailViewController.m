#import "MeasurementDetailViewController.h"
#import <objc/runtime.h>

@implementation MeasurementDetailViewController
@synthesize tableView, dataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startMediaBrowserNotification:)
                                                 name: @"startMediaBrowserNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startCameraControllerNotification:)
                                                 name: @"startCameraControllerNotification"
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startMediaBrowserNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startCameraControllerNotification" object:nil];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self.dataSource;
    self.tableView.dataSource=self.dataSource;
    objc_property_t tableViewProperty = class_getProperty([dataSource class], "tableView");
    if (tableViewProperty) {
        [dataSource setValue: tableView forKey: @"tableView"];
    }
    self.navigationItem.title=@"Measurement details";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)registerForKeyboardNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasHidden:)
//                                                 name:UIKeyboardDidHideNotification object:nil];
//}
//
//- (void)keyboardWasShown:(NSNotification *)aNotification {
//    CGRect keyboardBounds;
//    [[aNotification.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
//    keyboardHeight = 190;
//    skekeyboardBounds.size.height;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
//    [UIView commitAnimations];
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[items count] inSection:0]
//                     atScrollPosition:UITableViewScrollPositionMiddle
//                             animated:YES];
//}
//
//- (void)keyboardWasHidden:(NSNotification *)aNotification {
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    tableView.contentInset = UIEdgeInsetsZero;
//    [UIView commitAnimations];
//}

- (void)startMediaBrowserNotification:(NSNotification *)note
{
    [self startMediaBrowserFromViewController: self usingDelegate: self.dataSource];
}

- (void)startCameraControllerNotification:(NSNotification *)note
{
    [self startCameraControllerFromViewController: self usingDelegate: self.dataSource];
}
- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    controller=self;
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController: mediaUI animated: YES completion:nil];
    return YES;
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil ];
    
    return YES;
}


@end
