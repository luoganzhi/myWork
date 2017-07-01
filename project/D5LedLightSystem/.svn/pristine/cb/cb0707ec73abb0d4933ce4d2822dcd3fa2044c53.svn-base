//
//  D5ManuSwitchCell.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ManuSwitchCell.h"
#import "D5LedData.h"

#define LABEL_START_TAG 2001

//const NSString *WHITE_COLOR_STR = @"white";
//const NSString *RED_COLOR_STR = @"red";
//const NSString *ORANGE_COLOR_STR = @"orange";
//const NSString *YELLOW_COLOR_STR = @"yellow";
//const NSString *GREEN_COLOR_STR = @"green";
//const NSString *CYAN_COLOR_STR = @"cyan";
//const NSString *BLUE_COLOR_STR = @"blue";
//const NSString *PURPLE_COLOR_STR = @"purple";
//const NSString *GRAY_COLOR_STR = @"gray";


@interface D5ManuSwitchCell()

@property (nonatomic, strong) NSArray *btnArray;
@property (nonatomic, strong) NSArray *labelArr;

@property (nonatomic, strong) NSArray *colorsArr, *colorStrArr;

@end

@implementation D5ManuSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //增加按钮的热点响应区域
     [_light1 setEnlargeEdgeWithTop:10 right:13.0 bottom:10 left:13.0];
     [_light2 setEnlargeEdgeWithTop:10 right:13.0 bottom:10 left:13.00];
     [_light3 setEnlargeEdgeWithTop:10 right:13.0 bottom:10 left:13.0];
     [_light4 setEnlargeEdgeWithTop:10 right:13.0 bottom:10 left:13.0];
     [_light5 setEnlargeEdgeWithTop:10 right:13.0 bottom:10 left:13.0];
     [_light6 setEnlargeEdgeWithTop:10 right:13.0 bottom:10 left:13.0];
    _btnArray = @[_light1, _light2, _light3, _light4, _light5, _light6];
    _labelArr = @[_index1, _index2, _index3, _index4, _index5, _index6];
}

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
            UILabel *label = _labelArr[i];
            
            label.textColor = light_not_add;
            [btn setImage:[self imageWithColorStr:NOT_ADD_COLOR_STR] forState:UIControlStateNormal];
        }
    }
}

//根据颜色的index获取图片
- (UIImage *)imageWithIndex:(NSInteger)index {
    @autoreleasepool {
        if (index < self.colorsArr.count) {
            NSString *colorStr = self.colorStrArr[index];
            return [self imageWithColorStr:colorStr];
        }
        return nil;
    }
}

- (UIImage *)imageWithColorStr:(NSString *)colorStr {
    return [UIImage imageNamed:IMAGE_WITH_COLOR(colorStr)];
}

- (void)setDatas:(NSArray *)datas {
    @autoreleasepool {
        [self initArr];
        if (!datas || [datas isEqual:[NSNull null]] || datas.count == 0) {
            return;
        }
        
        for (D5LedData *ledData in datas) {
            @autoreleasepool {
                LedOnOffStatus onoffStatus = ledData.onoffStatus;
//                NSInteger lightIndex = ledData.lightId; //1-6 -- 索引
//                DLog(@"datas里面currentColorIndex  %ld号灯-- %ld", lightIndex, (long)ledData.currentColorIndex);
//                
//                if (lightIndex <= 0 || lightIndex > 6) {
//                    return;
//                }
//                
//                UIButton *btn = _btnArray[lightIndex - 1]; //灯泡btn
//                UILabel *label = _labelArr[lightIndex - 1]; //索引label
//                switch (onoffStatus) {
//                    case LedOnOffStatusOn: { //开
//                        NSInteger colorIndex = ledData.currentColorIndex;
//                        if (colorIndex == -1) {
//                            label.textColor = light_warm;
//                            [btn setImage:[self imageWithColorStr:WARM_COLOR_STR] forState:UIControlStateNormal];
//                        } else {
//                            if (colorIndex < self.colorsArr.count) {
//                                label.textColor = self.colorsArr[colorIndex];
//                                [btn setImage:[self imageWithIndex:colorIndex] forState:UIControlStateNormal];
//                            }
//                        }
//                    }
//                        break;
//                        
//                    default: { //关/离线
//                        label.textColor = light_off_offline;
//                        [btn setImage:[self imageWithColorStr:OFF_OFFLINE_COLOR_STR] forState:UIControlStateNormal];
//                    }
//                        break;
//                }
  
            }
        }
        
    }
}

//打开单灯开关
- (IBAction)switchopen:(UIButton*)sender {
    _switchOpen(sender, sender.tag - 1000); //tag = 1001 ---- 1006
}

@end
