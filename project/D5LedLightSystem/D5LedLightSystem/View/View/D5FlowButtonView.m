//
//  D5FlowButtonView.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5FlowButtonView.h"
#import "D5SearchTagData.h"

@implementation D5FlowButtonView

#pragma mark - 将buttonlist中的button添加到self中
- (void)setData:(NSMutableArray *)buttonList withDelegate:(id<D5FlowButtonViewDelegate>)delegate {
    if (!buttonList || buttonList.count <= 0) {
        return;
    }
    
    _delegate = delegate;
    
    for (UIButton *button in buttonList) {
        @autoreleasepool {
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    
}

#pragma mark - 按钮的点击事件
- (void)btnClicked:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(flowButtonClicked:)]) {
        [_delegate flowButtonClicked:btn];
    }
}

@end
