#import "TDDatePicker.h"

@implementation TDDatePicker

@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}
- (void)dateChanged {
    [delegate datePickerChanged:self newDate:self.date];
}

- (void)dealloc {
    [self removeTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
}


@end
