//
//  D5ManualColorButton.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/4.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ManualColorButton.h"
#import "UIColor+Image.h"
#import "UIButton+FillColor.h"

#define SELECTED_COLOR [UIColor colorWithRed:1 green:(212.0f/255.0f) blue:0 alpha:1.000]
#define DISABLED_COLOR [UIColor colorWithRed:(49.0f/255.0f) green:(49.0f/255.0f) blue:(49.0f/255.0f) alpha:0.2f]

#define SELECTED_TITLE_COLOR [UIColor whiteColor]
#define DISABLED_TITLE_COLOR [UIColor colorWithRed:(180.0f/255.0f) green:(180.0f/255.0f) blue:(180.0f/255.0f) alpha:1]
#define NORMAL_TITLE_COLOR [UIColor colorWithRed:(80.0f/255.0f) green:(80.0f/255.0f) blue:(80.0f/255.0f) alpha:1]
@implementation D5ManualColorButton


// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setRound];
}

- (void)setRound {
    @autoreleasepool {
        [self layoutIfNeeded];
        [self.layer setCornerRadius:self.bounds.size.width * 0.5];
        self.layer.masksToBounds = YES;
        
        if (self.state == UIControlStateNormal) {
            self.layer.borderColor = [UIColor colorWithRed:(49.0f/255.0f) green:(49.0f/255.0f) blue:(49.0f/255.0f) alpha:1].CGColor;
        } else {
            self.layer.borderColor = [UIColor clearColor].CGColor;
        }
        self.layer.borderWidth = 1;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
       
        //设置不同状态下的背景颜色
        UIColor *normalColor = [UIColor whiteColor];
        [self setBackgroundColor:normalColor forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor highLightedColor:normalColor] forState:UIControlStateHighlighted];
        [self setBackgroundColor:SELECTED_COLOR forState:UIControlStateSelected];
        [self setBackgroundColor:DISABLED_COLOR forState:UIControlStateDisabled];
        
        //设置不同状态下的标题颜色
        [self setTitleColor:SELECTED_TITLE_COLOR forState:UIControlStateSelected];
        [self setTitleColor:DISABLED_TITLE_COLOR forState:UIControlStateDisabled];
        [self setTitleColor:NORMAL_TITLE_COLOR forState:UIControlStateNormal];
    }
    return self;
}


@end
