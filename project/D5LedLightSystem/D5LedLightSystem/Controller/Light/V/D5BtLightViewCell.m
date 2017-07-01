//
//  D5BtLightViewCell.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/12/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BtLightViewCell.h"

#define RED_TEXTCOLOR [UIColor colorWithRed:(245.0f/255.0f) green:(73.0f/255.0f) blue:(73.0f/255.0f) alpha:1]

@interface D5BtLightViewCell()

/** 灯icon图片 */
@property (weak, nonatomic) IBOutlet UIImageView *lightIconImgView;

/** 灯编号 */
@property (weak, nonatomic) IBOutlet UILabel *lightIndexLabel;

/** 状态label */
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) NSArray *titleColorsArr;
@property (nonatomic, strong) NSDictionary *colorsDict;

@property (nonatomic, strong) NSDictionary *statusDict;

@end

@implementation D5BtLightViewCell

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
                                 LIGHT_STATUS_OFFLINE : LIGHT_STATUS_OFF_IMAGE //离线
                                 };
        }
        return _colorsDict;
    }
}

- (NSDictionary *)statusDict {
    @autoreleasepool {
        if (!_statusDict) {
            _statusDict = @{
                            @(BtUpdateStatusCompleted) : @"已升级",
                            @(BtUpdateStatusNotUpdate) : @"未升级",
                            @(BtUpdateStatusUpdateError) : @"升级失败",
                            @(BtUpdateStatusLightOffline) : @"离线"
                            };
        }
        return _statusDict;
    }
}

- (void)setData:(D5BTUpdateLightData *)data {
    @autoreleasepool {
        if (!data) {
            return;
        }
       
        int lightID = data.lightID;
        if (lightID <= 0) {
            return;
        }
        
        BtUpdateStatus status = data.updateStatus;        
        _lightIndexLabel.text = [NSString stringWithFormat:@"%d", lightID];
        
        _statusLabel.textColor = (status != BtUpdateStatusUpdateError) ? WHITE_COLOR : RED_TEXTCOLOR;
        
        if (status == BtUpdateStatusUpdating) {
            _statusLabel.text = [NSString stringWithFormat:@"%d%%", data.progress];
        } else {
            _statusLabel.text = self.statusDict[@(status)];
        }
        
        if (status == BtUpdateStatusLightOffline) {
            _lightIconImgView.image = self.colorsDict[LIGHT_STATUS_OFFLINE];
            _lightIndexLabel.textColor = LIGHT_STATUS_OFFLINE;
        } else {
            _lightIconImgView.image = self.colorsDict[self.titleColorsArr[lightID - 1]];
            _lightIndexLabel.textColor = self.titleColorsArr[lightID - 1];
        }
    }
}


@end
