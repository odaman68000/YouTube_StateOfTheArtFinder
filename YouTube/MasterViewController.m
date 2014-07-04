//
//  MasterViewController.m
//  YouTube
//
//  Created by odaman on 2013/01/27.
//  Copyright (c) 2013年 odaman. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController ()
@property (strong, nonatomic) NSArray *videos;
@end

@implementation MasterViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	[self setSearchKey:@"amiga state of the art"];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString *title = self.videos[indexPath.row][@"media$group"][@"media$title"][@"$t"];
		NSString *detail = [NSString stringWithFormat:@"%@ sec", self.videos[indexPath.row][@"media$group"][@"yt$duration"][@"seconds"]];
		NSString *thumbnail = self.videos[indexPath.row][@"media$group"][@"media$thumbnail"][1][@"url"];
		UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		indicatorView.hidesWhenStopped = YES;
		dispatch_async(dispatch_get_main_queue(), ^{
			cell.textLabel.text = title;
			cell.detailTextLabel.text =  detail;
			[cell.imageView addSubview:indicatorView];
			[indicatorView startAnimating];
			[cell setNeedsLayout];
		});
		NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnail]];
		UIImage *icon = [UIImage imageWithData:data];
		dispatch_async(dispatch_get_main_queue(), ^{
			cell.imageView.image = icon;
			[indicatorView stopAnimating];
			[cell setNeedsLayout];
		});
	});
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![[segue identifier] isEqualToString:@"showDetail"])
		return;
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	NSString *videoUrlStr = self.videos[indexPath.row][@"media$group"][@"media$player"][0][@"url"];
	NSURL *url = [NSURL URLWithString:videoUrlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[[segue destinationViewController] setDetailItem:request];
}

- (void)setSearchKey:(NSString *)key {
	NSString *encodedKey =[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	int maxItem = 50;
	NSString *urlStr = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?max-results=%d&alt=json&q=%@", maxItem, encodedKey];
	NSURL *reqURL = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:reqURL];
	NSOperationQueue *opQueue = [NSOperationQueue currentQueue];
	[NSURLConnection sendAsynchronousRequest:request queue:opQueue completionHandler:^(NSURLResponse *responce, NSData *data, NSError *error) {
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		NSLog(@"%@", json);
		self.videos = json[@"feed"][@"entry"];
		[self.tableView reloadData];
	}];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString *key = self.searchBar.text;
	if (key.length > 0)
		[self setSearchKey:key];
	[self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self.view endEditing:YES];
}
@end
