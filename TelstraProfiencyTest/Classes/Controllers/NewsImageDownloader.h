//
//  NewsImageDownloader.h
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

@interface NewsImageDownloader : NSObject
@property (nonatomic, strong) NewsModel *news;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)beginDownload;
- (void)endDownload;

@end
