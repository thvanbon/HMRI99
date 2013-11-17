//
//  MasterViewController.h
//  HMRI99
//
//  Created by Thijs van Bon on 11/17/13.
//  Copyright (c) 2013 Thijs van Bon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
