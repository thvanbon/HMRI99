#import <UIKit/UIKit.h>

@interface MeasurementDetailViewController : UITableViewController
{
    UIImagePickerController *cameraUI;
    UIImagePickerController *mediaUI;
}
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> * dataSource;

@end
