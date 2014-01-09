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

@end
