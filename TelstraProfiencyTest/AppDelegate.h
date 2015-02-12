//
//  AppDelegate.h
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashScreenViewController.h"
#import "AppHandler.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SplashScreenViewController *splashScreen;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSMutableArray *newsModelArray;


@end

