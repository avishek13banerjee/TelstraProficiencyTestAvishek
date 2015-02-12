//
//  SplashScreenViewController.m
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController (){
    NSMutableArray *newsModelArray;
    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation SplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(newsModelArray == nil)
        newsModelArray = [[NSMutableArray alloc]init];
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2 - 20, 20, 20)];
    
    //[activityIndicatorView setTintColor:[UIColor blueColor]];
    [activityIndicatorView setOpaque:YES];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TelstraIMAGE.jpg"]]];
    UIImageView *backGroundImage = [[UIImageView alloc]initWithFrame:self.view.frame];
    [backGroundImage setImage:[UIImage imageNamed:@"TelstraIMAGE.jpg"]];
    [self.view addSubview:backGroundImage];
    [backGroundImage release];
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    [self networkManagerFetchJson];
}

-(void)networkManagerFetchJson {
    
    NSError* error = nil;
    NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/g41ldl6t0afw9dv/facts.json"];
   // url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/qo72c8fcolsqmq6/facts%20%282%29.json?dl=0"];
    
    NSStringEncoding encoding;
    NSString *urlContents = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&error
                             ];
    if(urlContents)
    {
        NSLog(@"urlContents %@", urlContents);
    } else {
        // only check or print out err if urlContents is nil
        NSLog(@"err %@",error);
    }
    NSData* data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    NSDictionary *array =[[NSDictionary alloc]init];
    array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; // Try to convert your data
    if (!array && error && [error.domain isEqualToString:NSCocoaErrorDomain] && (error.code == NSPropertyListReadCorruptError)) {
        // Encoding issue, try Latin-1
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        if (jsonString) {
            // Need to re-encode as UTF8 to parse
            array = [NSJSONSerialization JSONObjectWithData:
                     [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]
                                                    options:0 error:&error];
        }
    }
    
    NSString *title = [array objectForKey:@"title"];
    
    NSArray *rows = [array objectForKey:@"rows"];
    
    for (int i = 0; i<rows.count; i++) {
        NSDictionary *detailDictionary = [rows objectAtIndex:i];
        NewsModel *newsModel = [[NewsModel alloc]init];
        newsModel.title = [detailDictionary objectForKey:@"title"];
        newsModel.description = [detailDictionary objectForKey:@"description"];
        newsModel.imageReference = [detailDictionary objectForKey:@"imageHref"];
        
        if(!(newsModel.imageReference == (id)[NSNull null] || newsModel.imageReference.length == 0 ) || !(newsModel.title == (id)[NSNull null] || newsModel.title.length == 0 ) || !(newsModel.description == (id)[NSNull null] || newsModel.description.length == 0 ))
            [newsModelArray addObject:newsModel];
        
    }
    
    
    
    AppHandler *apphandler = [AppHandler sharedManager];
    apphandler.titleString = title;
    apphandler.newsModelArray = [newsModelArray retain];
    
    [self performSelector:@selector(presentNext) withObject:nil afterDelay:0.5];
}

-(void)presentNext{
    NewsFeedViewController  *newsFeed = [[NewsFeedViewController alloc]init];
    [activityIndicatorView stopAnimating];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:newsFeed];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [super dealloc];
    if(activityIndicatorView != nil)
        [activityIndicatorView release];
    activityIndicatorView = nil;
}

@end
