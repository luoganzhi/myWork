//
//  D5FlowButtonView.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
@class D5SearchTagData;

@protocol D5FlowButtonViewDelegate <NSObject>

- (void)flowButtonClicked:(UIButton *)button;

@end

@interface D5FlowButtonView : UIView

@property (nonatomic, assign) id<D5FlowButtonViewDelegate> delegate;

/**
 *  通过传入一组按钮填充D5FlowButtonView
 *
 *  @param buttonList 按钮数组
 */
- (void)setData:(NSMutableArray *)buttonList withDelegate:(id<D5FlowButtonViewDelegate>)delegate ;

@end
