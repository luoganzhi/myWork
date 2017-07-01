//
//  D5WheelView.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIANS(d) ((d) * M_PI / 180)  //180-->PI
#define RADIANS_TO_DEGREES(d) ((d) * 180 / M_PI)  //PI-->180

@class D5WheelItem;
@class D5WheelView;

@protocol D5WheelViewDelegate <NSObject>

/**
 *  view中的色块数
 *
 *  @param wheelView 目标wheelview
 *
 *  @return 目标wheelview中的色块数
 */
- (NSInteger)numberOfItemsInWheelView:(D5WheelView *)wheelView;
@optional
/**
 *  将wheelview旋转到index处的色块
 *
 *  @param wheelView 目标wheelview
 *  @param index     目标index
 */
- (void)wheelView:(D5WheelView *)wheelView didSelectedItemAtIndex:(NSInteger)index;

@end

@interface D5WheelView : UIView

@property (nonatomic, weak) id<D5WheelViewDelegate> delegate;
@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, retain, readonly) D5WheelItem *baseWheelItem;
@property (nonatomic, assign, readonly) NSInteger numberOfItems;

@end
