//
//  DetailViewController.h
//  HMRI99
//
//  Created by Thijs van Bon on 11/17/13.
//  Copyright (c) 2013 Thijs van Bon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
