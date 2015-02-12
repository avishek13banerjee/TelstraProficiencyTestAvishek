//
//  AppHandler.h
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHandler : NSObject

@property (nonatomic,strong) NSString *titleString;
@property (nonatomic,strong) NSMutableArray *newsModelArray;

+ (id) sharedManager;
- (id) initWithValues;


@end