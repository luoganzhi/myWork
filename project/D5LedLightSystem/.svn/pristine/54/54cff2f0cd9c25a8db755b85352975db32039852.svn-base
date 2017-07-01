//
//  D5WebViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/26.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5WebViewController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "RealReachability.h"

#define BAIDU_URL "www.baidu.com"

@interface D5WebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) UIButton *closeItem;

@end

@implementation D5WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![NSString isValidateString:_titleStr]) {
        return;
    }
    
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
    
    [self initUrl];
    
    self.webView.delegate = self;
}

- (void)back {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        self.closeItem.hidden = NO;
    }else{
        [super back];
    }
}


- (void)initUrl {
    @autoreleasepool {
        __block NSURL *url = nil;
        [GLobalRealReachability startNotifier];
        [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
            switch (status) {
                case NotReachable: {
                    if ([NSString isValidateString:_htmlFileName]) {
                        NSString *path = [[NSBundle mainBundle] pathForResource:_htmlFileName ofType:@"html"];
                        url = [NSURL fileURLWithPath:path];
                    }
                    break;
                }
                    
                case ReachableViaWiFi: {
                    if ([NSString isValidateString:_url]) {
                        url = [NSURL URLWithString:_url];
                    }
                    break;
                }
                    
                case ReachableViaWWAN: {
                    if ([NSString isValidateString:_url]) {
                        url = [NSURL URLWithString:_url];
                    }
                    break;
                }
                    
                default:
                    break;
            }
            
            [GLobalRealReachability stopNotifier];
            
            if (!url) {
                return;
            }
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView setOpaque:NO];
                [self.webView loadRequest:request];
            });
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <delegate> 设置了webview的最上面一层的颜色
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName(`body`)[0].style.background=`#1B1B1B`"];
   
    //获取网页title
    NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = titleHtmlInfo;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    DLog(@"url: %@", request.URL.absoluteURL.description);
    if (self.webView.canGoBack) {
        self.closeItem.hidden = NO;
    }
    return YES;
}

@end
