//
//  D5UseGudieViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5UseGudieViewController.h"

#define USE_GUIDE_HTML  @"zhinan"

@interface D5UseGudieViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *useGuideWebView;

@end

@implementation D5UseGudieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用指南";
    
    [self addLeftBarItem];
    
    [self setWebView];
    


}

- (void)setWebView {
    NSString *path = [[NSBundle mainBundle] pathForResource:USE_GUIDE_HTML ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    
    // 设置webView透明
    [self.useGuideWebView setOpaque:NO];
    
    self.useGuideWebView.delegate = self;
    
    [self.useGuideWebView loadRequest:request];
    
    self.useGuideWebView.backgroundColor = [UIColor colorWithRed:25 / 255.0 green:26 / 255.0 blue:27 / 255.0 alpha:1];

}

- (void)addLeftBarItem {
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
}


#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(`body`)[0].style.background=`#1B1B1B`"];

}




- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
