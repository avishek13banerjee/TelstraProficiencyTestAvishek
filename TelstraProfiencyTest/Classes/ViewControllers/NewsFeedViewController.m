//
//  NewsFeedViewController.m
//  TelstraProfiencyTest
//
//  Created by Avishek Banerjee on 12/02/2015.
//  Copyright (c) 2015 Cognizant. All rights reserved.
//

#import "NewsFeedViewController.h"

static NSString *CellIdentifier = @"NewsCell";
static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
@interface NewsFeedViewController (){
    UIRefreshControl *refreshControl;
    NSMutableArray *newsModelArray;
    
}
// the set of NewsImageDownloader objects for each NewsObject
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
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
    
    [newsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [newsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:PlaceholderCellIdentifier];
    
}


-(void)refresh{
    //[newsTable reloadData];
    
    self.jsonDownload = [NSMutableData data];
    
    if (newsModelArray == nil) {
        newsModelArray = [[NSMutableArray alloc]init];
        
    }
    
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/g41ldl6t0afw9dv/facts.json"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    
    //request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/qo72c8fcolsqmq6/facts%20%282%29.json?dl=0"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.jsonConnection = conn;
    [conn start];
    
    
    
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
    
    maximumLabelSize = CGSizeMake(200,9999);
    if(!(newsModel.description == (id)[NSNull null] || newsModel.description.length == 0 )){
        
        expectedAnotherSize =[newsModel.description sizeWithFont:font1
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    float totalHeight;
    if(expectedLabelSize.height!=0){
        totalHeight = expectedAnotherSize.height + expectedLabelSize.height+30.0f;
        if(totalHeight >110.0)
            return (totalHeight+20);
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
    
    
    if(cell == nil)
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
    
    maximumLabelSize = CGSizeMake(200,9999);
    if(!(news.description == (id)[NSNull null] || news.description.length == 0 )){
        expectedAnotherSize =[news.description sizeWithFont:font1
                                          constrainedToSize:maximumLabelSize
                                              lineBreakMode:NSLineBreakByWordWrapping];
        
        
    }

    

    
    
    if([cell.contentView viewWithTag:1] == nil){
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, cell.frame.size.width-40, expectedLabelSize.height)];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [titleLabel setTextColor:[UIColor blueColor]];
    titleLabel.tag = 1;
        if(!(news.title == (id)[NSNull null] || news.title.length == 0 ))
            [titleLabel setText:news.title];
        
        
        [cell.contentView addSubview:titleLabel];
        
    }
    
    else {
    
        [(UILabel *)[cell.contentView viewWithTag:1] setText:news.title];
        [(UILabel *)[cell.contentView viewWithTag:1] setFrame:CGRectMake(10, 5, cell.frame.size.width-40, expectedLabelSize.height)];
        
        
        
    
    }
    
    

    if([cell.contentView viewWithTag:2] == nil){
    UILabel *descriptionLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, [cell.contentView viewWithTag:1 ].frame.origin.y + [cell.contentView viewWithTag:1 ].frame.size.height+10, cell.frame.size.width-130, expectedAnotherSize.height+20.0)];
    
        [descriptionLabel setBackgroundColor:[UIColor clearColor]];
        
    [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    if(!(news.description == (id)[NSNull null] || news.description.length == 0 ))
        [descriptionLabel setText:news.description];
    else
        [descriptionLabel setText:@"No Description Available"];
    
    [descriptionLabel setFont:font1];
    [descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [descriptionLabel setNumberOfLines:500];
     descriptionLabel.tag = 2;
        

        [cell.contentView addSubview:descriptionLabel];
    }
    
    else{
        
        if(!(news.description == (id)[NSNull null] || news.description.length == 0 ))
            [(UILabel *)[cell.contentView viewWithTag:2] setText:news.description];
        
        else
            [(UILabel *)[cell.contentView viewWithTag:2] setText:@"No Description"];
             
        [(UILabel *)[cell.contentView viewWithTag:2] setFrame:CGRectMake(10, [cell.contentView viewWithTag:1 ].frame.origin.y + [cell.contentView viewWithTag:1 ].frame.size.height+10, cell.frame.size.width-130, expectedAnotherSize.height+20.0)];
        
    
    }
    
    UIImageView *imageView;
    
    if([cell.contentView viewWithTag:3] == nil){
        imageView  = [[UIImageView alloc]initWithFrame:CGRectMake([cell.contentView viewWithTag:2].frame.origin.x + [cell.contentView viewWithTag:2].frame.size.width+10, 30, 100, 100)];
        imageView.tag = 3;
        
        [cell.contentView addSubview:imageView];
        
    }
    
    
        
    if(news.newsImage){
    
        [(UIImageView *)[cell.contentView viewWithTag:3] setImage:news.newsImage];
        [[cell.contentView viewWithTag:3] setHidden:NO];
    
    }
    else{
    
        if((news.imageReference == (id)[NSNull null] || news.imageReference.length == 0 ))
           [[cell.contentView viewWithTag:3] setHidden:YES];
        
        else{
    
        
            
        //if (self.newsTable.dragging == NO && self.newsTable.decelerating == NO)
        {
            [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"placeholder"]];
            [self startIconDownload:news forIndexPath:indexPath];
            if(news.hasNewsImageDownloadFailed)
             [(UIImageView *)[cell.contentView viewWithTag:3] setImage:[UIImage imageNamed:@"placeholderFailed"]];
        }
        }
        
    }
    
    [[cell.contentView viewWithTag:3] setBackgroundColor:[UIColor clearColor]];
    
    

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return  cell;
}

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(NewsModel *)news forIndexPath:(NSIndexPath *)indexPath
{
    NewsImageDownloader *newsImageDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (newsImageDownloader == nil)
    {
        newsImageDownloader = [[NewsImageDownloader alloc] init];
        newsImageDownloader.news = news;
        [newsImageDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [newsTable cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            [(UIImageView *)[cell.contentView viewWithTag:3] setImage:news.newsImage];
            [(UIImageView *)[cell.contentView viewWithTag:3] setHidden:NO];
            
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = newsImageDownloader;
        [newsImageDownloader beginDownload];
    }
}


#pragma mark - NSURLConnectionDelegate

// -------------------------------------------------------------------------------
//	Downloading Data and appending to image
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.jsonDownload appendData:data];
}

// -------------------------------------------------------------------------------
//	reflush
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Clear the activeDownload property to allow later attempts
    self.jsonDownload = nil;
    
    // Release the connection now that it's finished
    
    [self.jsonDownload release];
    self.jsonDownload = nil;


    
    
   
    
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    NSError *error = nil;
    
    NSDictionary *array =[[NSDictionary alloc]init];
    array = [NSJSONSerialization JSONObjectWithData:self.jsonDownload options:NSJSONReadingMutableContainers error:&error]; // Try to convert your data
    if (!array && error && [error.domain isEqualToString:NSCocoaErrorDomain] && (error.code == NSPropertyListReadCorruptError)) {
        // Encoding issue, try Latin-1
        NSString *jsonString = [[NSString alloc] initWithData:self.jsonDownload encoding:NSISOLatin1StringEncoding];
        if (jsonString) {
            // Need to re-encode as UTF8 to parse
            array = [NSJSONSerialization JSONObjectWithData:
                     [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]
                                                    options:0 error:&error];
        }
    }
    
    NSString *title = [array objectForKey:@"title"];
    
    NSArray *rows = [array objectForKey:@"rows"];
    
    if (rows.count>0) {
        [newsModelArray removeAllObjects];
    
    for (int i = 0; i<rows.count; i++) {
        NSDictionary *detailDictionary = [rows objectAtIndex:i];
        NewsModel *newsModel = [[NewsModel alloc]init];
        newsModel.title = [detailDictionary objectForKey:@"title"];
        newsModel.description = [detailDictionary objectForKey:@"description"];
        newsModel.imageReference = [detailDictionary objectForKey:@"imageHref"];
        
        if(!(newsModel.imageReference == (id)[NSNull null] || newsModel.imageReference.length == 0 ) || !(newsModel.title == (id)[NSNull null] || newsModel.title.length == 0 ) || !(newsModel.description == (id)[NSNull null] || newsModel.description.length == 0 ))
            [newsModelArray addObject:newsModel];
        
    }
    
    
    
    apphandler = [AppHandler sharedManager];
    apphandler.titleString = title;
    apphandler.newsModelArray = [newsModelArray retain];

    }
    
    
    
    
    //self.jsonDownload = nil;
    
    [self.newsTable reloadData];
    
    
    
    
    
}






-(void)dealloc{
    [super dealloc];
    if(refreshControl != nil)
        [refreshControl release];
    refreshControl  = nil;
}




@end
