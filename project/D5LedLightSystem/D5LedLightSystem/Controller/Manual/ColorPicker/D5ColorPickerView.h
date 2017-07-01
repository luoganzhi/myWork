//
//  D5ColorPickerView.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2017/1/9.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D5ColorPickerView : UIControl

/**
 色盘
 */
@property (nonatomic, strong) UIImageView *colourDiskView;

/**
 光标
 */
@property (nonatomic, strong) UIImageView *cursorView;

@property (nonatomic, assign) HSVType currentHSV;

@end
