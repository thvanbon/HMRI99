#import "HMRI99ViewController.h"
#import "MeasurementSession.h"
#import "MeasurementsTableViewDataSource.h"
#import <objc/runtime.h>


@implementation HMRI99ViewController
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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidSelectMeasurementSessionNotification:)
                                                 name: @"measurementSessionsTableDidSelectMeasurementSessionNotification"
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"measurementSessionsTableDidSelectMeasurementSessionNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDidSelectMeasurementSessionNotification:(NSNotification *)note
{
    MeasurementSession * selectedMeasurementSession=(MeasurementSession*) [note object];
    HMRI99ViewController * nextViewController = [[HMRI99ViewController alloc] init];
    MeasurementsTableViewDataSource * measurementsDataSource=[[MeasurementsTableViewDataSource alloc]init];
    measurementsDataSource.MeasurementSession=selectedMeasurementSession;
    nextViewController.dataSource=measurementsDataSource;
    [[self navigationController] pushViewController: nextViewController
                                           animated: YES];
}

@end
