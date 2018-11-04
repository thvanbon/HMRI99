#import "SessionDetailsViewController.h"
#import <objc/runtime.h>
#import "Session.h"
@implementation SessionDetailsViewController

@synthesize dataSource,tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        //self.toggle = 0;
//        self.pickerView = [[UIPickerView alloc] initWithFrame:(CGRect){{0, 0}, 320, 480}];
//        self.pickerView.delegate = dataSource;
//        self.pickerView.dataSource = dataSource;
//        self.pickerView.showsSelectionIndicator=YES;
//        self.pickerView.center = (CGPoint){160, 640};
//        self.pickerView.hidden = YES;
       // [self.view addSubview:self.pickerView];
//        self.datePicker = [[TDDatePicker alloc] initWithFrame:(CGRect){{0, 0}, 320, 480}];
//        self.datePicker.delegate = dataSource;
//        self.datePicker.center = (CGPoint){160, 640};
//        self.datePicker.datePickerMode=UIDatePickerModeDate;
//        self.datePicker.hidden = YES;
//        [self.view addSubview:self.datePicker];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bringUpPickerView:)
                                                 name: @"bringUpPickerView:"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hidePickerView:)
                                                 name: @"hidePickerView:"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bringUpDatePickerView:)
                                                 name: @"bringUpDatePickerView:"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideDatePickerView:)
                                                 name: @"hideDatePickerView:"
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bringUpPickerView:" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidePickerView:" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bringUpDatePickerView:" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideDatePickerView:" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource=self.dataSource;
    self.tableView.delegate=self.dataSource;
    objc_property_t tableViewProperty = class_getProperty([dataSource class], "tableView");
    if (tableViewProperty) {
        [dataSource setValue: tableView forKey: @"tableView"];
    }
    self.navigationItem.title=@"Session details";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)bringUpPickerView:(NSNotification *)note
{
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.pickerView.hidden = NO;
         self.pickerView.center =(CGPoint){160,self.tableView.frame.size.height-108};
     }
                     completion:nil];
}

- (void)hidePickerView:(NSNotification *)note
{
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.pickerView.center = (CGPoint){160, 800};
     }
                     completion:^(BOOL finished)
     {
         self.pickerView.hidden = YES;
     }];
}

- (void)bringUpDatePickerView:(NSNotification *)note
{
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.datePicker.hidden = NO;
         self.datePicker.date=self.dataSource.session.date;
         self.datePicker.center =(CGPoint){160,self.tableView.frame.size.height-108};
     }
                     completion:nil];
}

- (void)hideDatePickerView:(NSNotification *)note
{
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.datePicker.center = (CGPoint){160, 800};
     }
                     completion:^(BOOL finished)
     {
         self.datePicker.hidden = YES;
     }];
}
@end
