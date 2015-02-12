//
//  AppHandler.m
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "AppHandler.h"
@implementation AppHandler

+ (id)sharedManager {
    
    static AppHandler *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] initWithValues];
    });
    
    return sharedMyManager;
}

-(id)initWithValues{
    self = [super init];
    if (self) {
      self.newsModelArray = [[[NSMutableArray alloc]init] autorelease];
    }
    return  self;
}


-(void)dealloc{

    
    [super dealloc];
    
    
    
    

}

@end
