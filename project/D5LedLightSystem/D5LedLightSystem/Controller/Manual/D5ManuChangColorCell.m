//
//  D5ManuChangColorCell.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ManuChangColorCell.h"
#import "D5LedData.h"
#import "D5ManuSwitchCell.h"

#define CELL_CORNER (MainScreenWidth - 105.0f) / 6.0f

@interface D5ManuChangColorCell()

@property (nonatomic, strong) NSArray *colorsArr, *colorStrArr;

@end

@implementation D5ManuChangColorCell

- (NSArray *)colorsArr { //存的UIColor
    if (!_colorsArr) {
        _colorsArr = @[light_white, light_red, light_orange, light_yellow, light_green, light_cyan, light_blue, light_purple, light_gray];
    }
    return _colorsArr;
}

- (NSArray *)colorStrArr { //存的color的字符串 如"white"
    if (!_colorStrArr) {
        _colorStrArr = @[WHITE_COLOR_STR, RED_COLOR_STR, ORANGE_COLOR_STR, YELLOW_COLOR_STR, GREEN_COLOR_STR, CYAN_COLOR_STR, BLUE_COLOR_STR, PURPLE_COLOR_STR, GRAY_COLOR_STR];
    }
    return _colorStrArr;
}

- (void)initArr {
    for (int i = 0; i < _btnArray.count; i ++) {
        @autoreleasepool {
            UIButton *btn = _btnArray[i];
            [btn setBackgroundColor:light_not_add forState:UIControlStateNormal];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //每一行的颜色列表
    _btnArray = @[_bt1, _bt2, _bt3, _bt4, _bt5, _bt6];

    for (UIButton *btn in _btnArray) {
        @autoreleasepool {
            [btn setBackgroundColor:light_not_add forState:UIControlStateNormal];
        }
    }
}

- (void)setDatas:(NSArray *)datas inSection:(NSInteger)section { //section 1-9
    @autoreleasepool {
        [self initArr];
        _section = section - 1; //0-8
        
        if (section > 0 && section <= self.colorsArr.count) {
            [self setcolor:self.colorsArr[_section] withData:datas];
        }
        
    }
}

//颜色
- (void)setcolor:(UIColor*)color withData:(NSArray *)datas {
    if (!datas || [datas isEqual:[NSNull null]] || datas.count == 0) {
        return;
    }
    
    _color = color;
    for (D5LedData *ledData in datas) {
        @autoreleasepool {
            NSInteger lightID = ledData.lightId;
            if (lightID > 0) {
                LedOnOffStatus onoffStatus = ledData.onoffStatus;
                UIButton *btn = _btnArray[lightID - 1];
                if (onoffStatus == LedOnOffStatusOffline) {
                    [btn setBackgroundColor:light_off_offline forState:UIControlStateNormal];
                } else {
                    [btn setBackgroundColor:color forState:UIControlStateNormal];
                }
            }
        }
    }
    
//    [_bt1 setBackgroundColor:color forState:UIControlStateNormal];
//    [_bt2 setBackgroundColor:color forState:UIControlStateNormal];
//    [_bt3 setBackgroundColor:color forState:UIControlStateNormal];
//    [_bt4 setBackgroundColor:color forState:UIControlStateNormal];
//    [_bt5 setBackgroundColor:color forState:UIControlStateNormal];
//    [_bt6 setBackgroundColor:color forState:UIControlStateNormal];
}

//画圆
- (void)setcoordius:(CGFloat)height {
    [_bt1 setcordius:height];
    [_bt2 setcordius:height];
    [_bt3 setcordius:height];
    [_bt4 setcordius:height];
    [_bt5 setcordius:height];
    [_bt6 setcordius:height];
}

- (IBAction)colorChange:(UIButton *)sender {
    _changeColor(_color, sender.tag - 2000, _section);
}

@end
