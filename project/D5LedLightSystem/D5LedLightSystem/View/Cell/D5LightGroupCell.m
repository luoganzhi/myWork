//
//  D5LightGroupCell.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LightGroupCell.h"
#import "D5LedData.h"

@interface D5LightGroupCell()

@property (nonatomic, strong) NSArray *titleColorsArr;
@property (nonatomic, strong) NSDictionary *colorsDict;
@property (weak, nonatomic) IBOutlet UIView *masterTagView;

@end

@implementation D5LightGroupCell

- (NSArray *)titleColorsArr {
    if (!_titleColorsArr) {
        _titleColorsArr = @[LIGHT_STATUS_RED, LIGHT_STATUS_ORANGE, LIGHT_STATUS_YELLOW, LIGHT_STATUS_GREEN, LIGHT_STATUS_BLUE, LIGHT_STATUS_PURPLE];
    }
    return _titleColorsArr;
}

- (NSDictionary *)colorsDict {
    @autoreleasepool {
        if (!_colorsDict) {
            _colorsDict =      @{LIGHT_STATUS_RED : LIGHT_STATUS_ON_RED,
                                   LIGHT_STATUS_ORANGE : LIGHT_STATUS_ON_ORANCE,
                                   LIGHT_STATUS_YELLOW : LIGHT_STATUS_ON_YELLOW,
                                   LIGHT_STATUS_GREEN : LIGHT_STATUS_ON_GREEN,
                                   LIGHT_STATUS_BLUE : LIGHT_STATUS_ON_BLUE,
                                   LIGHT_STATUS_PURPLE : LIGHT_STATUS_ON_PURPLE,
                                   LIGHT_STATUS_OFF : LIGHT_STATUS_OFF_IMAGE, //关
                                   LIGHT_STATUS_OFFLINE : LIGHT_STATUS_OFF_IMAGE //离线
                                   };
        }
        return _colorsDict;
    }
}

- (void)setData:(D5LedData *)data isEdit:(BOOL)isEdit {
    @autoreleasepool {
        NSInteger lightID = data.lightId; // (1-6)
        if (lightID > 6) {
            return;
        }
        
        DLog(@"lightID = %d", lightID);
        switch (data.onoffStatus) {
            case LedOnOffStatusOn: {//开
                _lightStatusImgView.image = (lightID <= 0) ? LIGHT_STATUS_ON_IMAGE : self.colorsDict[self.titleColorsArr[lightID - 1]];
                _indexLabel.textColor = (lightID <= 0) ? WHITE_COLOR : self.titleColorsArr[lightID - 1];
                _btnSwitch.enabled = YES;
                _btnSwitch.selected = NO;
            }
                break;
            case LedOnOffStatusOffline://离线
                _lightStatusImgView.image = self.colorsDict[LIGHT_STATUS_OFFLINE];
                _indexLabel.textColor = LIGHT_STATUS_OFFLINE;
                _btnSwitch.selected = NO;
                _btnSwitch.enabled = NO;
                break;
            case LedOnOffStatusOff: //关
                _lightStatusImgView.image = self.colorsDict[LIGHT_STATUS_OFF];
                _indexLabel.textColor = (lightID <= 0) ? WHITE_COLOR : self.titleColorsArr[lightID - 1];
                _btnSwitch.enabled = YES;
                _btnSwitch.selected = YES;
                break;
                
            default:
                break;
        }
        
        _indexLabel.text = (lightID <= 0) ? @"" : [NSString stringWithFormat:@"%d", (int)lightID];
        _selectedImg.hidden = !data.isSelectedDelete;
        
        _masterTagView.hidden = (!isEdit || !data.isMaster);
    }
}

@end
