//
//  D5SegMentedControl.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SegMentedControl.h"

@interface D5SegMentedControl()

/**
 *  按钮标题
 */
@property (nonatomic, retain) NSArray *titleArray;

@end

@implementation D5SegMentedControl

- (void)loadTitleArray:(NSArray *)titleArray {
    @autoreleasepool {
        _titleArray = titleArray;
        [self loadBackgroundChangeView];
    }
}


- (void)loadBackgroundChangeView {
    @autoreleasepool {
        if (!_textSeletedColor) {
            _textSeletedColor = _textNormalColor;
        }
        for (int i = 0; i < _titleArray.count; i++) {
            @autoreleasepool {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(i * (CGRectGetWidth(self.frame) / _titleArray.count), 0, CGRectGetWidth(self.frame) / _titleArray.count, CGRectGetHeight(self.frame));
                button.tag = 10 + i;
                button.titleLabel.font = _textFont;
                
                if (i == 0) {
                    button.backgroundColor = _backgroundSeletedColor;
                    [button setTitleColor:_textSeletedColor forState:UIControlStateNormal];
                } else {
                    button.backgroundColor = _backgroundNormalColor;
                    [button setTitleColor:_textNormalColor forState:UIControlStateNormal];
                }
                [button setTitle:_titleArray[i] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
            }
        }
    }
}

- (void)buttonPressed:(UIButton *)sender {
    @autoreleasepool {
        for (int i = 0; i < _titleArray.count; i ++) {
            @autoreleasepool {
                UIButton *button = (UIButton *)[self viewWithTag:i + 10];
                button.backgroundColor = _backgroundNormalColor;
                [button setTitleColor:_textNormalColor forState:UIControlStateNormal];
            }
        }
        
        sender.backgroundColor = _backgroundSeletedColor;
        [sender setTitleColor:_textSeletedColor forState:UIControlStateNormal];
        
        if (_delegate && [_delegate respondsToSelector:@selector(segMentedControl:index:)]){
            [self.delegate segMentedControl:self index:sender.tag - 10];
        }
    }
}
@end
