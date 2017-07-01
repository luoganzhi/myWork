//
//  D5NewManualViewController.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class D5ColorPickerView;

#define NewManualVC @"D5NewManualViewController"

@interface D5NewManualViewController : D5BaseViewController

/** 是否开启手动模式 */
@property (nonatomic, assign) BOOL isOpenManualMode;

@property (weak, nonatomic) IBOutlet D5ColorPickerView *colorPickerView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerWidth;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerHeight;

@end
