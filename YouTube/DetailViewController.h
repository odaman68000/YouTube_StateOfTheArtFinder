//
//  DetailViewController.h
//  YouTube
//
//  Created by odaman on 2013/01/27.
//  Copyright (c) 2013年 odaman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
