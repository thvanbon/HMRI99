#import "MeasurementsViewController.h"

#import "MeasurementsTableViewDataSource.h"
#import "MeasurementDetailTableViewDataSource.h"
#import <objc/runtime.h>
#import "MeasurementDetailViewController.h"
#import "Measurement.h"


@implementation MeasurementsViewController


@synthesize tableView, dataSource, sortBar;

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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObjectWithSender:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title=@"Measurements";
    NSArray *sortItems=[NSArray arrayWithObjects:@"original", @"id", @"name", @"Lw", nil];
    UISegmentedControl *sortControl=[[UISegmentedControl alloc] initWithItems:sortItems];
    sortControl.frame = CGRectMake(0, 0, 200, 30);
    
    sortControl.selectedSegmentIndex = 0;
    UIBarButtonItem *segmentedControlButtonItem = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)sortControl];
    [sortControl addTarget:self
                            action:@selector(sortControlWasUpdated:)
                                              forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *barArray = [NSArray arrayWithObjects: flexibleSpace, segmentedControlButtonItem, flexibleSpace, nil];
    [sortBar setItems:barArray];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidSelectMeasurementNotification:)
                                                 name: @"measurementsTableDidSelectMeasurementNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidAddMeasurementNotification:)
                                                 name: @"measurementsTableDidAddMeasurementNotification"
                                               object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(textDidChange:)
    //                                                 name:UITextFieldTextDidChangeNotification
    //                                               object: nil];
}

//added while troubleshooting switching to second vc. Might need later. Works, but not tested yet.
- (void) viewWillAppear:(BOOL)animated {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:animated];
    [tableView reloadData];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"measurementsTableDidSelectMeasurementNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"measurementsTableDidAddMeasurementNotification" object:nil];
    
    //
    //    [[NSNotificationCenter defaultCenter] removeObserver:self                                                 name:UITextFieldTextDidChangeNotification
    //                                                  object: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDidSelectMeasurementNotification:(NSNotification *)note
{
    Measurement * selectedMeasurement=(Measurement*) [note object];
    
    MeasurementDetailViewController * nextViewController = [[MeasurementDetailViewController alloc] init];
    MeasurementDetailTableViewDataSource * measurementDetailDataSource=[[MeasurementDetailTableViewDataSource alloc]init];
    measurementDetailDataSource.measurement=selectedMeasurement;
    MeasurementsTableViewDataSource *measurementsDataSource=(MeasurementsTableViewDataSource*) self.dataSource;
    measurementDetailDataSource.managedObjectContext= measurementsDataSource.managedObjectContext;
    nextViewController.dataSource=measurementDetailDataSource;
    [[self navigationController] pushViewController: nextViewController
                                           animated: YES];
}

- (void) insertNewObjectWithSender:(id)sender
{
    if ([self.tableView.delegate respondsToSelector:@selector(addMeasurementWithSender:)])
    {
        [(id) self.tableView.delegate addMeasurementWithSender:sender];
    }
}

- (void) userDidAddMeasurementNotification:(NSNotification *)note
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    Measurement * selectedMeasurement =(Measurement *)[note object];
    selectedMeasurement.type=@"II.2";
    MeasurementDetailViewController *nextViewController=[[MeasurementDetailViewController alloc] initWithNibName:nil bundle:nil];
    MeasurementDetailTableViewDataSource * measurementDetailDataSource=[[MeasurementDetailTableViewDataSource alloc] init];
    
    measurementDetailDataSource.measurement=selectedMeasurement;
    MeasurementsTableViewDataSource *measurementsDataSource=(MeasurementsTableViewDataSource*) self.dataSource;
    measurementDetailDataSource.managedObjectContext= measurementsDataSource.managedObjectContext;
    nextViewController.dataSource=measurementDetailDataSource;
    [[self navigationController] pushViewController: nextViewController
                                           animated: YES];
    
}
-(void)sortControlWasUpdated:(UISegmentedControl *)updatedControl
{
    self.dataSource.sortID=(int)updatedControl.selectedSegmentIndex;
    [self.dataSource.tableView reloadData];
}

@end
