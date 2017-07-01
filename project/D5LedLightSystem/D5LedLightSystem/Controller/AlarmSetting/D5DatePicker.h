//
//  D5DatePicker.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class D5DatePicker;

@protocol D5DatePickerDelegate <NSObject>

@optional
- (void)d5DatePicker:(D5DatePicker *)picker didSelectedDate:(NSDate *)date;

@end

@interface D5DatePicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) id<D5DatePickerDelegate> dvDelegate;

@property (nonatomic, strong) UIColor *leftSelectedTextColor;
@property (nonatomic, strong) UIColor *leftTextColor;

@property (nonatomic, strong) UIColor *rightSelectedTextColor;
@property (nonatomic, strong) UIColor *rightTextColor;

@property (nonatomic, strong) UIFont *rightSelectedFont;
@property (nonatomic, strong) UIFont *rightFont;

@property (nonatomic, strong) UIFont *leftSelectedFont;
@property (nonatomic, strong) UIFont *leftFont;

@property (nonatomic, assign) NSInteger rowHeight;

/**
 *  查看datePicker当前选择的时间
 */
@property (nonatomic, strong, readonly) NSDate *date;

/**
 *  datePicker显示当前时间
 */
- (void)selectCurrentDate;

/**
 *  datePicker显示date
 */
- (void)selectDate:(NSDate *)date;
@end
