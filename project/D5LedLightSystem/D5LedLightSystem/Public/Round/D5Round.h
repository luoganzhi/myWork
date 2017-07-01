//
//  D5Round.h
//  D5Home
//
//  Created by Pang Dou on 11/3/14.
//  Copyright (c) 2014 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface D5Round : NSObject

+ (void)setRoundForView:(UIView *)view ;
+ (void)setSmallRound:(UIView *)view;
+ (void)setInputBack:(UIView *)view;
+ (void)showCornerWithView:(UIView *)view withColor:(UIColor *)color withRadius:(CGFloat)radius withBoarderWith:(CGFloat)witdh;

@end
