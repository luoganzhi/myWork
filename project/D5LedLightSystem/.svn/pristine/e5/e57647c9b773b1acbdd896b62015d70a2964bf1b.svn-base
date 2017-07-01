//
//  D5BarItem.m
//  D5Home_new
//
//  Created by 黄斌 on 15/12/16.
//  Copyright © 2015年 com.pangdou.d5home. All rights reserved.
//

#import "D5BarItem.h"

@implementation D5BarItem

+ (void)addRightBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    @autoreleasepool {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [button setImage:image forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        UIViewController *controller = target;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        controller.navigationItem.rightBarButtonItem = item;
    }
}

+ (void)addRightBarItemWithText:(NSString *)text color:(UIColor *)color target:(id)target action:(SEL)action {
    @autoreleasepool {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [button setTitle:text forState:UIControlStateNormal];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateDisabled];
        
        button.titleLabel.font = [UIFont systemFontOfSize:VC_TITLE_FONT_SIZE];
        UIViewController *controller = target;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        controller.navigationItem.rightBarButtonItem = item;
        
//        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:target action:action];
//        UIViewController *controller = target;
//        [item1 setImageInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//        [item1 setTintColor:color];
//        controller.navigationItem.rightBarButtonItem = item1;
//        [controller.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:VC_TITLE_FONT_SIZE], NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
}

+ (void)setLeftBarItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [button setImage:image forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setEnlargeEdgeWithTop:5 right:10 bottom:10 left:10];
    UIViewController *controller = target;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [controller.navigationItem setLeftBarButtonItem:item];
}

+ (void)setLeftBarItemWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)action {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    UIViewController *controller = target;
    [item setTintColor:color];
    [controller.navigationItem setLeftBarButtonItem:item animated:YES];
    [controller.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:VC_TITLE_FONT_SIZE], NSFontAttributeName, nil] forState:UIControlStateNormal];
}

@end
