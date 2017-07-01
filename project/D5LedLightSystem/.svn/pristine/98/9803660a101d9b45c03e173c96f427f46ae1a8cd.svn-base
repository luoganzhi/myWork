//
//  D5FlowButtonView.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5FlowButtonView.h"
#import "D5Round.h"
#import "D5SearchTagData.h"

@implementation D5FlowButtonView

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

- (void)btnClicked:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(flowButtonClicked:)]) {
        [_delegate flowButtonClicked:btn];
    }
}

//
///**
// *  设置self的内容
// *
// *  @param data   内容data
// *  @param height self里面button的高度
// */
//- (void)setData:(D5SearchTagData *)data withBtnHeight:(CGFloat)height {
//    self.btnHeight = height;
//    _dataList = data.contentArr;
//    
//    if (!_dataList || _dataList.count <= 0) {
//        return;
//    }
//    
//    _currentRow = 0;
//    _currentRowWidth = 0;
//    for (int i = 0; i < _dataList.count; i ++) {
//        [self addBtnWithTitle:_dataList[i] atIndex:i];
//    }
//}
//
///**
// *  根据text的字数得到button的宽度
// *
// *  @param text 参数
// *
// *  @return 适应text字数的宽度
// */
//- (CGFloat)buttonWidthWithText:(NSString *)text {
//    @autoreleasepool {
//        CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), self.btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FLOW_BUTTON_FONT} context:nil].size;
//        return textSize.width + 20;
//    }
//}
//
///**
// *  添加button, 在dataList里面索引为index
// *
// *  @param title button的标题
// *  @param index datalist中所在的索引
// */
//- (void)addBtnWithTitle:(NSString *)title atIndex:(int)index {
//    @autoreleasepool {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.titleLabel.font = FLOW_BUTTON_FONT;
//        
//        CGFloat width = [self buttonWidthWithText:title];
//        
//        CGFloat margin = 8;
//        CGFloat x = 0;
//        CGFloat y = 0;
//        
//        // 对第一个Button进行设置
//        CGFloat newAddWidth = width + margin;
//        if (index == 0) {
//            _currentRowWidth += newAddWidth;
//        } else {
//            if (((_currentRowWidth + newAddWidth) >= self.width) && ((_currentRowWidth + newAddWidth - margin) >= self.width)) {
//                _currentRow ++;
//                _currentRowWidth = newAddWidth;
//            } else {
//                x = _currentRowWidth;
//                _currentRowWidth += newAddWidth;
//            }
//        }
//        
//        
//        y = (_currentRow + 1) * margin + _currentRow * self.btnHeight;
//        
//        button.frame = CGRectMake(x, y, width, self.btnHeight);
//        [button setTitle:title forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        [D5Round showCornerWithView:button withColor:FLOW_BUTTON_PURPLE_BORDER withRadius:10 withBoarderWith:1.0f];
//
//        [self addSubview:button];
//        
//        if (index == _dataList.count - 1) {
//            self.height = CGRectGetMaxY(button.frame) + margin;
//        }
//    }
//}

/*
- (void)layoutSubviews {
    @autoreleasepool {
        NSArray *subs = [self subviews];
        if (!subs || subs.count <= 0) {
            self.height = 0;
            self.data.height = 0;
            return;
        }
        
        CGFloat margin = 8;
        
        NSMutableArray *rowFirstButtons = [NSMutableArray array]; // 存放每行的第一个Button
        
        // 对第一个Button进行设置
        UIButton *button0 = subs[0];
        button0.x = 0;
        button0.y = margin;
        [rowFirstButtons addObject:subs[0]];
        
        // 对其他Button进行设置
        int row = 0;
        for (int i = 1; i < subs.count; i++) {
            @autoreleasepool {
                UIButton *button = subs[i];
                
                int sumWidth = 0;
                int start = (int)[subs indexOfObject:rowFirstButtons[row]];
                for (int j = start; j <= i; j++) {
                    @autoreleasepool {
                        UIButton *button = subs[j];
                        sumWidth += (button.width + margin);
                    }
                }
                
                UIButton *lastButton = subs[i - 1];
                if ((sumWidth >= self.width) && ((sumWidth - margin) >= self.width)) {
                    //每一排的最后一个按钮如果去掉右边的margin刚好可以排下，则排下
                    button.x = 0;
                    button.y = CGRectGetMaxY(lastButton.frame) + margin;
                    [rowFirstButtons addObject:button];
                    row ++;
                } else {
                    button.x = sumWidth - button.width - margin;
                    button.y = lastButton.y;
                }
                
            }
        }
        
        
        UIButton *lastButton = subs.lastObject;
        self.height = CGRectGetMaxY(lastButton.frame) + margin;
        
        self.data.height = self.height;
        NSLog(@"layoutSubviews data = %@ height = %f",self.data, self.data.height);
    
 }
}*/
@end
