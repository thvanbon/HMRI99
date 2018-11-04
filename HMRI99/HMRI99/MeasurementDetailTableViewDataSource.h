#import <Foundation/Foundation.h>

@class Measurement;
@interface MeasurementDetailTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
    {
        UIImage *imageToUse;
        NSURL *url;
    }
    
    @property Measurement *measurement;
    @property (weak) UITableView *tableView;
    @property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
    
-(void)measurementSegmentedControlWasUpdated:(UISegmentedControl *)updatedControl;
    
-(void) updateTableView;
-(BOOL) textFieldShouldReturn:(UITextField *)textField;
-(UIImage *) scaleImage:(UIImage *)image scaledToSize:(CGSize)newSize;
    @end
