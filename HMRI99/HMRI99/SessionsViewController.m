#import "SessionsViewController.h"
#import "Session.h"
#import "MeasurementsTableViewDataSource.h"
#import "MeasurementsViewController.h"
#import "SessionsTableViewDataSource.h"
#import "SessionDetailsViewController.h"
#import "SessionDetailsDataSource.h"
#import <objc/runtime.h>


@implementation SessionsViewController
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
    UIBarButtonItem *mailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectSessionsToSendByMail:)];
    self.navigationItem.leftBarButtonItem = mailButton;
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title=@"Measurement Sessions";
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
                                             selector:@selector(userDidPressDetailDisclosureButtonNotification:)
                                                 name: @"sessionsTableDidPressAccessoryDetailButtonNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object: nil];
}

//added while troubleshooting switching to second vc. Might need later. Works, but not tested yet.
- (void) viewWillAppear:(BOOL)animated {
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sessionsTableDidSelectSessionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sessionsTableDidAddSessionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sessionsTableDidPressAccessoryDetailButtonNotification" object:nil];
    
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
    
    MeasurementsViewController * nextVC = [[MeasurementsViewController alloc] init];
    MeasurementsTableViewDataSource * measurementsDataSource=[[MeasurementsTableViewDataSource alloc]init];
    measurementsDataSource.session=selectedSession;
    SessionsTableViewDataSource *myDataSource= (SessionsTableViewDataSource*)[self dataSource];
    measurementsDataSource.managedObjectContext=myDataSource.managedObjectContext;
    nextVC.dataSource=measurementsDataSource;
    [[self navigationController] pushViewController: nextVC
                                           animated: YES];
}

- (void) insertNewObject: (id)sender
{
    if ([self.tableView.delegate respondsToSelector:@selector(addSession)])
    {
        [(id) self.tableView.delegate addSession];
    }
}

- (void) selectSessionsToSendByMail: (id)sender
{
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMail:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendMail:)];
    self.navigationItem.leftBarButtonItem = doneButton;
    [self.tableView setEditing:YES animated:YES];
    
}

- (void) cancelMail: (id)sender
{
    [self.tableView setEditing:NO animated:YES];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self viewDidLoad];
}

- (void) sendMail: (id)sender
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    
    UIAlertController *popupQuery = [UIAlertController alertControllerWithTitle:@"Attach Images"
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               // Cancel button tappped.
                                                               [window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
                                                           }];
    UIAlertAction *sendWithImages = [UIAlertAction actionWithTitle:@"Send with attached images"
                                                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                    [window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
                                                                    [self sendMailWithImages];
                                                                }];
    UIAlertAction *sendWithoutImages = [UIAlertAction actionWithTitle:@"Send without attached images"
                                                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                    [window.rootViewController dismissViewControllerAnimated:YES completion:^{}];
                                                                    [self sendMailWithoutImages];
                                                                }];
    
    [popupQuery addAction:cancelAction];
    [popupQuery addAction:sendWithImages];
    [popupQuery addAction:sendWithoutImages];
    
    UIPopoverPresentationController *popPresenter = [popupQuery popoverPresentationController];
    UIBarButtonItem *button = (UIBarButtonItem*) sender;
    popPresenter.sourceView = window;
    popPresenter.barButtonItem = button;
    [window.rootViewController presentViewController:popupQuery animated:YES completion:nil];
}

- (void) sendMailWithImages
{
    [self sendMailWithAttachedImages:YES];
}

- (void) sendMailWithoutImages
{
    [self sendMailWithAttachedImages:NO];
}

- (void) sendMailWithAttachedImages:(BOOL)sendImages
{
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    if (selectedRows.count==0) {
        [self cancelMail:nil];
    }
    else
    {
        NSMutableArray * sessionExportStringsArray=[[NSMutableArray alloc] init];
        
        for (NSIndexPath *indexPath in selectedRows) {
            Session * session = [(SessionsTableViewDataSource*)self.dataSource sessionForIndexPath:indexPath];
            [sessionExportStringsArray addObject:[session exportSession]];
        }
        NSString *textFileContentsString=[sessionExportStringsArray componentsJoinedByString:@"\n"];
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:@"Measurement results"];
            [mailViewController setMessageBody:@"results in attachment!" isHTML:NO];
//            NSLog(textFileContentsString);
            NSData * textFileContentsData=[textFileContentsString dataUsingEncoding:NSASCIIStringEncoding];
            [mailViewController addAttachmentData:textFileContentsData mimeType:@"text/plain" fileName:@"data.txt"];
            
            if (sendImages)
            {
                [self addAttachmentsToMailViewController:mailViewController selectedRows:selectedRows];
            }
            
            [self presentViewController:mailViewController animated:YES completion:nil];
        }
        
        else {
            NSLog(@"Device is unable to send email in its current state.");
            [self cancelMail:nil];
        }
    }
}

- (void)addAttachmentsToMailViewController:(MFMailComposeViewController *)mailViewController selectedRows:(NSArray *)selectedRows {
    NSMutableArray * sessionExportImagesArray=[[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in selectedRows) {
        Session * session = [(SessionsTableViewDataSource*)self.dataSource sessionForIndexPath:indexPath];
        [sessionExportImagesArray addObjectsFromArray:[session exportMeasurementImages]];
    }
    
    for (NSArray *imageToBeExported in sessionExportImagesArray) {
        if (![[imageToBeExported objectAtIndex:1] isEqual:nil]) {
            NSData *imageData = UIImageJPEGRepresentation([imageToBeExported objectAtIndex:1], 0.8);
            [mailViewController addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"%@.jpg",[imageToBeExported objectAtIndex:0]]];
        }
    }
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView setEditing:NO animated:YES];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self viewDidLoad];
}

- (void) userDidAddSessionNotification:(NSNotification *)note
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    Session * selectedSession=(Session*) [note object];
    SessionDetailsViewController * nextVC = [[SessionDetailsViewController alloc] init];
    SessionDetailsDataSource * sessionDetailsDataSource=[[SessionDetailsDataSource alloc]init];
    
    sessionDetailsDataSource.session=selectedSession;
    SessionsTableViewDataSource *sessionsDataSource=(SessionsTableViewDataSource*) self.dataSource;
    sessionDetailsDataSource.managedObjectContext= sessionsDataSource.managedObjectContext;
    nextVC.dataSource=sessionDetailsDataSource;
    [[self navigationController] pushViewController: nextVC animated: YES];
    
}

- (void)userDidPressDetailDisclosureButtonNotification:(NSNotification *)note
{
    Session * selectedSession=(Session*) [note object];
    
    SessionDetailsViewController * nextVC = [[SessionDetailsViewController alloc] init];
    SessionDetailsDataSource * sessionDetailsDataSource=[[SessionDetailsDataSource alloc]init];
    sessionDetailsDataSource.session=selectedSession;
    SessionsTableViewDataSource *sessionsDataSource=(SessionsTableViewDataSource*) self.dataSource;
    sessionDetailsDataSource.managedObjectContext= sessionsDataSource.managedObjectContext;
    nextVC.dataSource=sessionDetailsDataSource;
    [[self navigationController] pushViewController: nextVC animated: YES];
}


@end
