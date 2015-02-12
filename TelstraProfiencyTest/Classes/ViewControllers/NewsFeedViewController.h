//
//  NewsFeedViewController.h
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppHandler.h"
#import "NewsModel.h"
#import "NewsImageDownloader.h"


@interface NewsFeedViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *newsTable ;
    AppHandler *apphandler;
}

@property (nonatomic,strong) UITableView *newsTable;

@end
