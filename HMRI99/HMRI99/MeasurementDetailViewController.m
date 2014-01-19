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
@end
