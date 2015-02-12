//
//  NewsModel.h
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
{
    NSString *title;
    NSString *description;
    NSString *imageReference;
}

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *description;
@property (nonatomic,strong)NSString *imageReference;

@end
