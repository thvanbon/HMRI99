//
//  main.m
//  HMRI99
//
//  Created by Thijs van Bon on 11/17/13.
//  Copyright (c) 2013 Thijs van Bon. All rights reserved.
//

// 2018-11-04 modified to stop running AppDelegate during tests
// see: https://qualitycoding.org/ios-app-delegate-testing/

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        Class appDelegateClass = NSClassFromString(@"TestingAppDelegate");
        if (!appDelegateClass)
            appDelegateClass = [AppDelegate class];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
        
    }
}
