#import "HMRI99ViewController.h"
#import "Session.h"
#import "MeasurementsTableViewDataSource.h"
#import "SessionsTableViewDataSource.h"
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
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    

}

-(void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidSelectSessionNotification:)
                                                 name: @"sessionsTableDidSelectSessionNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidAddSessionNotification:)
                                                 name: @"sessionsTableDidAddSessionNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object: nil];
    
    
    
}

//added while troubleshooting switching to second vc. Might need later. Works, but not tested yet.
- (void) viewWillAppear:(BOOL)animated {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sessionsTableDidSelectSessionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sessionsTableDidAddSessionNotification" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self                                                 name:UITextFieldTextDidChangeNotification
                                               object: nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userDidSelectSessionNotification:(NSNotification *)note
{
    Session * selectedSession=(Session*) [note object];
    
    HMRI99ViewController * nextViewController = [[HMRI99ViewController alloc] init];
    MeasurementsTableViewDataSource * measurementsDataSource=[[MeasurementsTableViewDataSource alloc]init];
    measurementsDataSource.session=selectedSession;
    nextViewController.dataSource=measurementsDataSource;
    [[self navigationController] pushViewController: nextViewController
                                           animated: YES];
}

- (void) insertNewObject: (id)sender
{
    if ([self.tableView.delegate respondsToSelector:@selector(addSession)])
    {
        [(id) self.tableView.delegate addSession];
    }
}

- (void) userDidAddSessionNotification:(NSNotification *)note
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    Session * selectedSession=(Session*) [note object];

    HMRI99ViewController * nextViewController = [[HMRI99ViewController alloc] init];
    MeasurementsTableViewDataSource * measurementsDataSource=[[MeasurementsTableViewDataSource alloc]init];
    measurementsDataSource.session=selectedSession;
    nextViewController.dataSource=measurementsDataSource;
    [[self navigationController] pushViewController: nextViewController
                                           animated: YES];

}

-(void) textDidChange: (id) sender
{
    UITextField * myTextField= (UITextField *) [sender object];
    NSLog(@"text did change, textfield %@", myTextField.text);
}

@end
