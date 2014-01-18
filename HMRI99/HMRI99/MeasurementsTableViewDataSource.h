#import <Foundation/Foundation.h>

@class Session;
@class Measurement;
@class MeasurementSummaryStaticCell;


extern NSString * measurementsTableDidSelectMeasurementNotification;
extern NSString * measurementsTableDidAddMeasurementNotification;

@interface MeasurementsTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong) Session * session;
@property (weak) IBOutlet MeasurementSummaryStaticCell *summaryCell;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (weak) UITableView *tableView;

- (void) addMeasurement;
@end
