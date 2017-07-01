//
//  D5DatePicker.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5DatePicker.h"

#define MINUTE ( 1 )
#define HOUR ( 0 )

#define SELECTED_FONT [UIFont systemFontOfSize:30]
#define NORMAL_FONT [UIFont systemFontOfSize:20]

#define COMPONENT_MARGIN 20

#define NORMAL_TEXT_COLOR [UIColor colorWithRed:(165.0f/255.0f) green:(165.0f/255.0f) blue:(165.0f/255.0f) alpha:1]

// Identifies for component views
#define LABEL_TAG 43

@interface D5DatePicker ()

@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *hours;
@property (nonatomic, strong) NSArray *minutes;

@property (nonatomic, assign) NSInteger minHour;
@property (nonatomic, assign) NSInteger maxHour;

@end

@implementation D5DatePicker

const NSInteger bigRowCount = 1000;
const NSInteger numberOfComponents = 2;

#pragma mark - Properties
- (UIFont *)leftFont {
    if (!_leftFont) {
        _leftFont = NORMAL_FONT;
    }
    return _leftFont;
}

- (UIFont *)rightFont {
    if (!_rightFont) {
        _rightFont = NORMAL_FONT;
    }
    return _rightFont;
}

- (UIFont *)leftSelectedFont {
    if (!_leftSelectedFont) {
        _leftSelectedFont = SELECTED_FONT;
    }
    return _leftSelectedFont;
}

- (UIFont *)rightSelectedFont {
    if (!_rightSelectedFont) {
        _rightSelectedFont = SELECTED_FONT;
    }
    return _rightSelectedFont;
}

- (UIColor *)leftSelectedTextColor {
    if (!_leftSelectedTextColor) {
        _leftSelectedTextColor = WHITE_COLOR;
    }
    return _leftSelectedTextColor;
}

- (UIColor *)rightSelectedTextColor {
    if (!_rightSelectedTextColor) {
        _rightSelectedTextColor = WHITE_COLOR;
    }
    return _rightSelectedTextColor;
}

- (UIColor *)leftTextColor {
    if (!_leftTextColor) {
        _leftTextColor = NORMAL_TEXT_COLOR;
    }
    return _leftTextColor;
}

- (UIColor *)rightTextColor {
    if (!_rightTextColor) {
        _rightTextColor = NORMAL_TEXT_COLOR;
    }
    return _rightTextColor;
}

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        [self loadDefaultsParameters];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultsParameters];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self loadDefaultsParameters];
    }
    return self;
}

#pragma mark - picker delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return [self componentWidth];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.rowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    @autoreleasepool {
//        BOOL selected = YES;
//        if (component == MINUTE) {
//            NSInteger count = self.minutes.count;
//            NSString *title = [self.minutes objectAtIndex:(row % count)];
//            NSString *currentTitle = [self currentMinuteStr];
//            //DLog(@"row = %d title = %@ currenttitle = %@", row, title, currentTitle);
//            if ([title isEqualToString:currentTitle]) {
//                selected = YES;
//            }
//        } else {
//            NSInteger count = self.hours.count;
//            NSString *title = [self.hours objectAtIndex:(row % count)];
//            NSString *currentTitle = [self currentHourStr];
//            if ([title isEqualToString:currentTitle]) {
//                selected = YES;
//            }
//        }
        
        UIButton *returnView = nil;
        if (view.tag == LABEL_TAG) {
            returnView = (UIButton *)view;
        } else {
            returnView = [self labelForComponent:component];
        }
        
//        returnView.titleLabel.font = selected ? [self selectedFontForComponent:component] : [self fontForComponent:component];
//        returnView.titleLabel.textColor = selected ? [self selectedColorForComponent:component] : [self colorForComponent:component];
        
        returnView.titleLabel.font = [self selectedFontForComponent:component];
        returnView.titleLabel.textColor = [self selectedColorForComponent:component];
        
        NSString *title = [self titleForRow:row forComponent:component];
        returnView.titleLabel.text = title;
        [returnView setTitle:title forState:UIControlStateNormal];
        return returnView;
    }
}

#pragma mark - picker datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == MINUTE) {
        return [self bigRowMinuteCount];
    }
    
    return [self bigRowHourCount];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_dvDelegate && [_dvDelegate respondsToSelector:@selector(d5DatePicker:didSelectedDate:)]) {
        [_dvDelegate d5DatePicker:self didSelectedDate:[self date]];
    }
}

#pragma mark - Util
//当前选择器的时间
- (NSDate *)date {
    @autoreleasepool {
        NSInteger hourCount = self.hours.count;
        NSString *hour = [self.hours objectAtIndex:([self selectedRowInComponent:HOUR] % hourCount)];
        
        NSInteger minuteCount = self.minutes.count;
        NSString *minute = [self.minutes objectAtIndex:([self selectedRowInComponent:MINUTE] % minuteCount)];
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"zh_CN"]];
        
        NSString *ymd = [formatter stringFromDate:[NSDate date]];
        NSString *hourAndMinute = [NSString stringWithFormat:@" %@:%@", hour, minute];
        NSString *ymdhm = [ymd stringByAppendingString:hourAndMinute];
        
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        
        NSDate *date = [formatter dateFromString:ymdhm];
        return date;
    }
}

//默认当前时间选中
- (void)selectCurrentDate {
    [self selectRow:self.todayIndexPath.row inComponent:MINUTE animated:NO];
    [self selectRow:self.todayIndexPath.section inComponent:HOUR animated:NO];
}

//分钟的最大行数
- (NSInteger)bigRowMinuteCount {
    return self.minutes.count * bigRowCount;
}

//小时的最大行数
- (NSInteger)bigRowHourCount {
    return self.hours.count * bigRowCount;
}

//组件宽度
- (CGFloat)componentWidth {
    return self.bounds.size.width / numberOfComponents;
}

//00-59
- (NSArray *)minutes {
    @autoreleasepool {
        if (!_minutes) {
            NSMutableArray *mutableArr = [NSMutableArray array];
            for (int i = 0; i < 60; i ++) {
                [mutableArr addObject:[NSString stringWithFormat:@"%02d", i]];
            }
            
            
            _minutes = [NSArray arrayWithArray:mutableArr];
        }
        
        return _minutes;
    }
}

//00-23
- (NSArray *)hours {
    @autoreleasepool {
        if (!_hours) {
            NSMutableArray *mutableArr = [NSMutableArray array];
            for (int i = 0; i < 24; i ++) {
                [mutableArr addObject:[NSString stringWithFormat:@"%02d", i]];
            }
            
            _hours = [NSArray arrayWithArray:mutableArr];
        }
        return _hours;
    }
}

//row行显示的标题
- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    @autoreleasepool {
        if (component == MINUTE) {
            NSInteger minuteCount = self.minutes.count;
            return [self.minutes objectAtIndex:(row % minuteCount)];
        }
        NSInteger hourCount = self.hours.count;
        return [self.hours objectAtIndex:(row % hourCount)];
    }
}

//当前时间所在的indexpath
- (NSIndexPath *)todayIndexPath {
    return [self selectIndexPathWithHour:[self currentHourStr] withMinute:[self currentMinuteStr]];
}

//将时间date转为formatter形式的dateStr
- (NSString *)dateStrWithFormatter:(NSString *)formatter withDate:(NSDate *)date {
    @autoreleasepool {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:formatter];
        
        return [dateFormatter stringFromDate:date];
    }
}

//将当前时间转为formatter形式的dateStr
- (NSString *)currentDateWithFormatter:(NSString *)formatter {
    return [self dateStrWithFormatter:formatter withDate:[NSDate date]];
}

//当前时间的分钟
- (NSString *)currentMinuteStr {
    return [self currentDateWithFormatter:@"mm"];
}

//当前时间的小时
- (NSString *)currentHourStr {
    return [self currentDateWithFormatter:@"HH"];
}

//组件选中的字体颜色
- (UIColor *)selectedColorForComponent:(NSInteger)component {
    @autoreleasepool {
        if (component == MINUTE) {
            return self.rightSelectedTextColor;
        }
        return self.leftSelectedTextColor;
    }
}

//未选中的字体颜色
- (UIColor *)colorForComponent:(NSInteger)component {
    @autoreleasepool {
        if (component == MINUTE) {
            return self.rightTextColor;
        }
        return self.leftTextColor;
    }
}

//组件选中的字体
- (UIFont *)selectedFontForComponent:(NSInteger)component {
    @autoreleasepool {
        if (component == MINUTE) {
            return self.rightSelectedFont;
        }
        return self.leftSelectedFont;
    }
}

//未选中的字体
- (UIFont *)fontForComponent:(NSInteger)component {
    @autoreleasepool {
        if (component == MINUTE) {
            return self.rightFont;
        }
        return self.leftFont;
    }
}

//组件中显示时间的button
- (UIButton *)labelForComponent:(NSInteger)component {
    @autoreleasepool {
        CGFloat width = [self componentWidth];
        CGRect frame = CGRectMake(0, 0, width, self.rowHeight);
        UIButton *label = [[UIButton alloc] initWithFrame:frame];
        
        label.backgroundColor = [UIColor clearColor];
        UIEdgeInsets insets = (component == MINUTE) ? UIEdgeInsetsMake(0, 0, 0, width / 3) : UIEdgeInsetsMake(0, width / 3, 0, 0);
        
        label.titleEdgeInsets = insets;
        label.userInteractionEnabled = NO;
        label.tag = LABEL_TAG;
        
        return label;
    }
}

#pragma mark - 设置参数
- (void)loadDefaultsParameters {
    @autoreleasepool {
        self.rowHeight = 54;
        
        self.delegate = self;
        self.dataSource = self;
        
        [self selectCurrentDate];
    }
}

//hour和minute所在的indexpath
- (NSIndexPath *)selectIndexPathWithHour:(NSString *)hour withMinute:(NSString *)minute {
    @autoreleasepool {
        CGFloat row = 0.0f;
        CGFloat section = 0.0f;
        
        for (NSString *cellMinute in self.minutes) {
            @autoreleasepool {
                if ([cellMinute isEqualToString:minute]) {
                    row = [self.minutes indexOfObject:cellMinute];
                    row += [self bigRowMinuteCount] / 2;
                    break;
                }
            }
        }
        
        for (NSString *cellHour in self.hours) {
            @autoreleasepool {
                if ([cellHour isEqualToString:hour]) {
                    section = [self.hours indexOfObject:cellHour];
                    section += [self bigRowHourCount] / 2;
                    break;
                }
            }
        }
        
        return [NSIndexPath indexPathForRow:row inSection:section];
    }
}

- (NSString *)selectMinuteStr:(NSDate *)date {
     return [self dateStrWithFormatter:@"mm" withDate:date];
}

- (NSString *)selectHourStr:(NSDate *)date {
    return [self dateStrWithFormatter:@"HH" withDate:date];
}

- (void)selectDate:(NSDate *)date {
    @autoreleasepool {
        NSIndexPath *selectIndexPath = [self selectIndexPathWithHour:[self selectHourStr:date] withMinute:[self selectMinuteStr:date]];
        
        [self selectRow:selectIndexPath.row inComponent:MINUTE animated:NO];
        [self selectRow:selectIndexPath.section inComponent:HOUR animated:NO];
        
        [self pickerView:self didSelectRow:selectIndexPath.row inComponent:MINUTE];
        [self pickerView:self didSelectRow:selectIndexPath.row inComponent:HOUR];
    }
}

@end
