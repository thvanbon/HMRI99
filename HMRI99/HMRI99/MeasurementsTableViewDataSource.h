#import <Foundation/Foundation.h>

@class Session;
@class Measurement;
@class MeasurementSummaryStaticCell;
@class SessionSummaryCell;

extern NSString * measurementsTableDidSelectMeasurementNotification;
extern NSString * measurementsTableDidAddMeasurementNotification;

@interface MeasurementsTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong) Session * session;
@property (weak) IBOutlet MeasurementSummaryStaticCell *summaryCell;
@property (weak) IBOutlet SessionSummaryCell *sessionSummaryCell;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;


@property (weak) UITableView *tableView;
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

//- (void) setMeasurements: (NSMutableOrderedSet *)measurements;
- (void) addMeasurement;
@end
