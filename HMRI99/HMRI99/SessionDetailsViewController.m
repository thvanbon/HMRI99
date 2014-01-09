#import "SessionDetailsViewController.h"
#import <objc/runtime.h>

@implementation SessionDetailsViewController

@synthesize dataSource,tableView;
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
    tableView.dataSource=dataSource;
    tableView.delegate=dataSource;
    objc_property_t tableViewProperty = class_getProperty([dataSource class], "tableView");
    if (tableViewProperty) {
        [dataSource setValue: tableView forKey: @"tableView"];
    }
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title=@"Session details";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
