//
//  MainPageViewController.m
//  News
//
//  Created by Igal Kreichman on 10/22/13.
//  Copyright (c) 2013 Skycure. All rights reserved.
//

#import "MainPageViewController.h"

#import "Article.h"
#import "ArticleView.h"
#import "MainArticleView.h"
#import "ArticleViewController.h"

@interface MainPageViewController ()

@property (strong, nonatomic) NSArray *articles;
@property (strong, nonatomic) Article *selected;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSNumber *statusCode;
@property (strong, nonatomic) NSURLConnection *connection;

@end

@implementation MainPageViewController

- (NSMutableData *)receivedData
{
    if (!_receivedData) {
        _receivedData = [NSMutableData data];
    }
    return _receivedData;
}

- (IBAction)removeCache:(id)sender {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad
{
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.refreshControl];
 
    CGPoint frame = ((UIScrollView *)self.view).contentOffset;
    frame.y = -100;
    ((UIScrollView *)self.view).contentOffset = frame;
    [self.refreshControl beginRefreshing];
    [self refreshView:self.refreshControl];
    [self fetchArticles];
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    [self fetchArticles];
}

- (void)fetchArticles
{
    NSURL *serverUrl = [NSURL URLWithString:@"http://skycure-journal.herokuapp.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverUrl];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
    
    self.statusCode = [NSNumber numberWithInteger:[(NSHTTPURLResponse*)response statusCode]];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    @synchronized(self) {
        if (self.connection) {
            self.connection = nil;
            
            // Handle errors?!
            [self.refreshControl endRefreshing];
        }
    }
}

- (NSString *)decodeHTMLEntities:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"%22" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
    string = [string stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"%27" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"%28" withString:@"("];
    string = [string stringByReplacingOccurrencesOfString:@"%29" withString:@")"];
    string = [string stringByReplacingOccurrencesOfString:@"%2C" withString:@","];
    string = [string stringByReplacingOccurrencesOfString:@"%2F" withString:@"/"];
    string = [string stringByReplacingOccurrencesOfString:@"%3A" withString:@":"];
    string = [string stringByReplacingOccurrencesOfString:@"%3B" withString:@";"];
    string = [string stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
    string = [string stringByReplacingOccurrencesOfString:@"%40" withString:@"@"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];

    return string;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @synchronized(self) {
        if (self.connection) {
            self.connection = nil;
            
            NSError *parseError = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:&parseError];
            
            NSArray *jsonArticles = (NSArray *)json[@"articles"];
            NSMutableArray *articles = [NSMutableArray new];
            for (NSDictionary *article in jsonArticles) {
                NSString *title = [self decodeHTMLEntities:article[@"title"]];
                NSString *subtitle = article[@"subtitle"];
                NSURL *image = article[@"image"] != NULL ? [NSURL URLWithString:article[@"image"]] : NULL;
                NSString *content = [self decodeHTMLEntities:article[@"content"]];
                [articles addObject:[[Article alloc] initWithTitle:title subtitle:subtitle image:image content:content]];
            }
            self.articles = articles;
            
            [self.refreshControl endRefreshing];
            [(UITableView *)self.view reloadData];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Article *article = self.articles[indexPath.row];
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [[MainArticleView alloc] initWithArticle:article];
    } else {
        cell = [[ArticleView alloc] initWithArticle:article];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selected = self.articles[indexPath.row];
    [self performSegueWithIdentifier:@"ShowArticle" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ArticleViewController *articleVC = segue.destinationViewController;
    articleVC.article = self.selected;
}

@end
