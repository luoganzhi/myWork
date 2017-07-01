//
//  D5LedWelcomeViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedWelcomeViewController.h"

const int WELCOME_IMAGE_COUNT = 3;

@interface D5LedWelcomeViewController()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation D5LedWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarHidden:YES];
    
    CGSize viewSize = self.view.bounds.size;
    
    _scrollView.contentSize = CGSizeMake(WELCOME_IMAGE_COUNT * viewSize.width, 0);
    
    for (int i = 0; i < WELCOME_IMAGE_COUNT; i ++) {
        [self addImageViewAtIndex:i inView:_scrollView];
    }
}


- (void)addImageViewAtIndex:(int)index inView:(UIView * )view {
    @autoreleasepool {
        CGSize viewSize = self.view.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = (CGRect) {{index * viewSize.width, 0} , viewSize};
        
        NSString *name = [NSString stringWithFormat:@"welcome%d.jpg", index + 1];
        imageView.image = [UIImage imageNamed:name];
        
        [view addSubview:imageView];
        
        if (index == WELCOME_IMAGE_COUNT -  1) {
            [self addBtnInView:imageView];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)addBtnInView:(UIView * )view {
    @autoreleasepool {
        CGSize viewSize = self.view.frame.size;
        view.userInteractionEnabled = YES;
        UIButton *start = nil;
        UIView *v = [view viewWithTag:10000];
        if (v) {
            start = (UIButton *)v;
        } else {
            start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            start.tag = 10000;
        }
        [view addSubview:start];
        
        start.backgroundColor = [UIColor redColor];
        start.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        start.center = CGPointMake(viewSize.width * 0.5, viewSize.height * 0.78);
        start.bounds = CGRectMake(0, 0, viewSize.width * 0.3, viewSize.height * 0.1);
        
        [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)start {
    if (_delegate && [_delegate respondsToSelector:@selector(welcome)]) {
        [_delegate welcome];
    }
}

@end
