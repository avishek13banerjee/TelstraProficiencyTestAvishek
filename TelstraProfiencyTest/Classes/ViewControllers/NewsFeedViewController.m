//
//  NewsFeedViewController.m
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "NewsFeedViewController.h"

@interface NewsFeedViewController (){
    UIRefreshControl *refreshControl;
}
@end

@implementation NewsFeedViewController
@synthesize newsTable;

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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    newsTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-0)];
    [newsTable setDelegate:self];
    [newsTable setDataSource:self];
    [self.view addSubview:newsTable];
    apphandler = [AppHandler sharedManager];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [newsTable addSubview:refreshControl];
    
    self.title = apphandler.titleString;
    
}


-(void)refresh{
    [newsTable reloadData];
    [refreshControl endRefreshing];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma marlk TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    apphandler = [AppHandler sharedManager];
    return apphandler.newsModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsModel *newsModel = [apphandler.newsModelArray objectAtIndex:indexPath.row];
    CGSize maximumLabelSize = CGSizeMake(self.newsTable.frame.size.width,400);
    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:16.0f];
    CGSize expectedLabelSize = CGSizeMake(0, 0);
    CGSize expectedAnotherSize =  CGSizeMake(0, 0);
    
    if(!(newsModel.title == (id)[NSNull null] || newsModel.title.length == 0 )){
        expectedLabelSize = [newsModel.title sizeWithFont:font1
                                        constrainedToSize:maximumLabelSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    maximumLabelSize = CGSizeMake(200,400);
    if(!(newsModel.description == (id)[NSNull null] || newsModel.description.length == 0 )){
        
        expectedAnotherSize =[newsModel.description sizeWithFont:font1
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    float totalHeight;
    if(expectedLabelSize.height!=0){
        totalHeight = expectedAnotherSize.height + expectedLabelSize.height+30.0f;
        if(totalHeight >110.0)
            return totalHeight;
        else {
            if((!(newsModel.imageReference == (id)[NSNull null] || newsModel.imageReference.length == 0 )))
                return 150.0f;
        }
        
    }
    
    return totalHeight;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsCell"];
        cell.backgroundColor =  [UIColor clearColor];
    }
    NewsModel *news = [apphandler.newsModelArray objectAtIndex:indexPath.row];
    CGSize maximumLabelSize = CGSizeMake(self.newsTable.frame.size.width,400);
    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:16.0f];
    CGSize expectedLabelSize = CGSizeMake(0, 0);
    CGSize expectedAnotherSize =  CGSizeMake(0, 0);
    
    if(!(news.title == (id)[NSNull null] || news.title.length == 0 )){
        expectedLabelSize = [news.title sizeWithFont:[UIFont systemFontOfSize:18.0]
                                   constrainedToSize:maximumLabelSize
                                       lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    maximumLabelSize = CGSizeMake(200,400);
    if(!(news.description == (id)[NSNull null] || news.description.length == 0 )){
        expectedAnotherSize =[news.description sizeWithFont:font1
                                          constrainedToSize:maximumLabelSize
                                              lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    if(expectedLabelSize.height!=0){
        float totalHeight = expectedAnotherSize.height + expectedLabelSize.height;
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, cell.frame.size.width-40, expectedLabelSize.height)];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [titleLabel setTextColor:[UIColor blueColor]];
    
    if(!(news.title == (id)[NSNull null] || news.title.length == 0 ))
        [titleLabel setText:news.title];
    
    UILabel *descriptionLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height+10, cell.frame.size.width-120, expectedAnotherSize.height+20.0)];
    
    [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    if(!(news.description == (id)[NSNull null] || news.description.length == 0 ))
        [descriptionLabel setText:news.description];
    else
        [descriptionLabel setText:@"No Description Available"];
    
    [descriptionLabel setFont:font1];
    [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [descriptionLabel setNumberOfLines:500];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(descriptionLabel.frame.origin.x + descriptionLabel.frame.size.width, 30, 100, 100)];
    if(!(news.imageReference == (id)[NSNull null] || news.imageReference.length == 0 ))
        
        
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:descriptionLabel];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return  cell;
}

-(void)dealloc{
    [super dealloc];
    if(refreshControl != nil)
        [refreshControl release];
    refreshControl  = nil;
}

@end
