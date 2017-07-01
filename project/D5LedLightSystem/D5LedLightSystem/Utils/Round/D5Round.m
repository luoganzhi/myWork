//
//  D5Round.m
//  D5Home
//
//  Created by Pang Dou on 11/3/14.
//  Copyright (c) 2014 anthonyxoing. All rights reserved.
//

#import "D5Round.h"

@implementation D5Round

+ (void)setRoundForView:(UIView *)view borderColor:(UIColor *)color {
    [view layoutIfNeeded];
    [view.layer setCornerRadius:view.bounds.size.width * 0.5];
    view.layer.masksToBounds = YES;
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 1;
}

+ (void)setSmallRound:(UIView *)view {
    [view layoutIfNeeded];
    [view.layer setCornerRadius:5.0f];
    view.layer.masksToBounds = YES;
}

+ (void)setInputBack:(UIView *)view {
    [view layoutIfNeeded];
    [view.layer setCornerRadius:2.0f];
    view.layer.masksToBounds = YES;
    
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 1;
}

+ (void)showCornerWithView:(UIView *)view withColor:(UIColor *)color withRadius:(CGFloat)radius withBoarderWith:(CGFloat)witdh {
    [view layoutIfNeeded];
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = witdh;
    view.layer.borderColor = color.CGColor;
}

+ (void)setBorderWidth:(CGFloat)width color:(UIColor *)color forView:(UIView *)view {
    @autoreleasepool {
        [view layoutIfNeeded];
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = width;
        view.layer.borderColor = color.CGColor;
    }
}
@end