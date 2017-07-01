//
//  D5Popovercontroller.h
//  MyPopOver
//
//  Created by 熊少云 on 15/6/18.
//  Copyright (c) 2015年 D5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class D5Popovercontroller;

@protocol D5PopoverControllerDelegate <NSObject>

@optional
- (void)d5popoverControllerWillDismiss:(D5Popovercontroller *)popcontroller;

@end

typedef enum _popovercontroller_arrow_direction{ 
    D5PopoverArrowDirectionup = 1, //箭头向上
    D5PopoverArrowDirectionDown//箭头向下
}D5PopoverArrowDirection;

typedef enum _popovercontroller_content_alignment{
    D5PopovercontrollerAlignmentToSourceViewNone = 0,
    D5PopovercontrollerAlignmentToSourceViewLeft,
    D5PopovercontrollerAlignmentToSourceViewRight,
    D5PopovercontrollerAlignmentToSourceViewCenter,//垂直或者水平居中
    D5PopovercontrollerAlignmentToSourceViewTop,// no use
    D5PopovercontrollerAlignmentToSourceViewBottom // no use
}D5PopovercontrollerContentAlignment;

@interface D5Popovercontroller : UIWindow

@property (weak,nonatomic) id<D5PopoverControllerDelegate> popOverdelegate;
@property (retain, nonatomic) UIColor *bgColor;
@property (retain, nonatomic) UIColor *borderColor;
@property (nonatomic, assign) BOOL isClickDismiss;

- (instancetype)initWithRootViewController:(UIViewController *)vc;
- (void)presentController:(UIViewController *)contentController
                sourceView:(UIView *)fromView
         arrowDirecttion:(D5PopoverArrowDirection)direction
        contentAlignment:(D5PopovercontrollerContentAlignment)alignment;

- (void)hideArrow;
- (void)dismiss;
- (void)setRadius:(CGFloat)radius;
- (void)setContentSize:(CGSize)size;
@end
