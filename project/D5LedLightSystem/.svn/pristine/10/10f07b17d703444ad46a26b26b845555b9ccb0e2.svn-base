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
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation D5SegMentedControl

//必须放在初始化segment的最后
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
        
        if (!_textFont) {
            _textFont = [UIFont systemFontOfSize:16];
        }
        
        if (!_backgroundSeletedColor) {
            _backgroundSeletedColor = [UIColor colorWithRed:(93.0f/255.0f) green:(19.0f/255.0f) blue:(178.0f/255.0f) alpha:0.8f];
        }
        
        if (!_backgroundNormalColor) {
            _backgroundNormalColor = [UIColor colorWithRed:(93.0f/255.0f) green:(19.0f/255.0f) blue:(178.0f/255.0f) alpha:0.4f];
        }
        
        if (!_textSeletedColor) {
            _textSeletedColor = [UIColor colorWithRed:255/255.0 green:212/255.0 blue:0 alpha:1];
        }
        
        if (!_textNormalColor) {
            _textNormalColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
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
