//
//  DetailViewController.m
//  YouTube
//
//  Created by odaman on 2013/01/27.
//  Copyright (c) 2013年 odaman. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        [self configureView];
    }
}

- (void)configureView {
	if (self.detailItem) {
		[self.webView loadRequest:self.detailItem];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
