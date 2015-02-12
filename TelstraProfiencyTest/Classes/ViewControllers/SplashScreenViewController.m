//
//  SplashScreenViewController.m
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController (){
    
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
    
    if(self.newsModelArray == nil)
        self.newsModelArray = [[NSMutableArray alloc]init];
    activityIndicatorView = [[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2 - 20, 20, 20)] autorelease];
    
    //[activityIndicatorView setTintColor:[UIColor blueColor]];
    [activityIndicatorView setOpaque:YES];
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"TelstraBG"]]];
    UIImageView *backGroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    [backGroundImage setImage:[UIImage imageNamed:@"TelstraIMAGE.jpg"]];
    //[self.view addSubview:backGroundImage];
    //[backGroundImage release];
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
    
    if(data){
    NSDictionary *array;
    
    array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; // Try to convert your data
    if (!array && error && [error.domain isEqualToString:NSCocoaErrorDomain] && (error.code == NSPropertyListReadCorruptError)) {
        // Encoding issue, try Latin-1
        NSString *jsonString = [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding] autorelease];
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
            [self.newsModelArray addObject:newsModel];
        
    }
    
    
    
    AppHandler *apphandler = [AppHandler sharedManager];
    apphandler.titleString = title;
    apphandler.newsModelArray = [self.newsModelArray retain];
    
    [self performSelector:@selector(presentNext) withObject:nil afterDelay:0.5];
    }
    
    else
    {
    
        UIAlertView *errorAlert = [[[UIAlertView alloc]initWithTitle:@"Error" message:@"An error occured while downloading data for the first time." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil] autorelease];
        [errorAlert show];
        
    
    }
}

-(void)presentNext{
    NewsFeedViewController  *newsFeed = [[[NewsFeedViewController alloc]init] autorelease];
    [activityIndicatorView stopAnimating];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:newsFeed];
    
    [self presentViewController:nav animated:YES completion:nil];
    [nav release];
    nav = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if(buttonIndex == 0)
    {
    [self networkManagerFetchJson];
    }

}


-(void)dealloc {
    [super dealloc];
    

}

@end
