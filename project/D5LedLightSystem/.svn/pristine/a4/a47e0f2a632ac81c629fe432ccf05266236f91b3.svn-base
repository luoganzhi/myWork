//
//  D5AlarmTableCell.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5AlarmTableCell.h"
#import "D5AlarmData.h"

@interface D5AlarmTableCell()

@property (nonatomic, strong) D5AlarmData *alarmData;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnAlarmSwitch;
@property (nonatomic, weak) id<D5LedCmdDelegate, D5LedNetWorkErrorDelegate> delegate;

- (IBAction)btnAlarmSwitchClicked:(UIButton *)sender;

@end

@implementation D5AlarmTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _btnSelected.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//设置data
- (void)setData:(D5AlarmData *)data isEdit:(BOOL)isEdit delegate:(id<D5LedCmdDelegate,D5LedNetWorkErrorDelegate>)delegate {
    @autoreleasepool {
        _delegate = delegate;
        
        _alarmData = data;
        NSInteger seconds = data.execTime;
        NSString *time = [D5Date hourMinuteStrFromSeconds:seconds];
        _timeLabel.text = time;
        
        _btnAlarmSwitch.hidden = isEdit;
        if (!isEdit) {
            _btnAlarmSwitch.selected = (data.action == LedOperateTaskTypeClose);
        }
        _statusLabel.text = (data.operate == LedTimeTaskLedOperateOn) ? @"开灯" : @"关灯";
        _weekLabel.text = [self weekMessageFromWeek:data.week];
        _btnSelected.hidden = !isEdit;
    }
}

- (NSString *)weekStrByWeek:(Byte)week {
    @autoreleasepool {
        NSMutableString *message = [[NSMutableString alloc] init];
        
        NSArray *strArr = [NSArray arrayWithObjects:@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日", nil];
        for (int i = 0; i < 7; i ++) {
            @autoreleasepool {
                Byte temp = week >> (i + 1);
                
                int result = temp & 0x01;
                if (result == 1) {
                    [message appendString:strArr[i]];
                    [message appendString:@" "];
                }
            }
        }
        
        return message;
    }
}

/**
 根据week组装字符串 周一 周二...
 
 @param week
 @return 组装好的字符串
 */
- (NSString *)weekMessageFromWeek:(int)week {
    @autoreleasepool {
        NSMutableString *message = [[NSMutableString alloc] init];
        if (week == 0) {
            [message appendString:@"一次"];
        } else if (week == EVERY_DAY_REPEAT || week == -2) {//每天 254
            [message appendString:@"每天"];
        } else if (week == WEEK_DAYS_REPEAT) { // 62
            [message appendString:@"周一至周五"];
        } else {
            NSString *str = [self weekStrByWeek:week];
            if ([NSString isValidateString:str]) {
                [message appendString:str];
            }
        }
        return message;
    }
}

- (IBAction)btnAlarmSwitchClicked:(UIButton *)sender {
    @autoreleasepool {
        //禁用 --> 启用 ?
        sender.selected = !sender.isSelected;
        [self modifyTaskEnable:!sender.isSelected];
    }
}

//修改定时任务 -- 是否启用
- (void)modifyTaskEnable:(BOOL)isEnabled {
    @autoreleasepool {
        LedOperateTaskType type = isEnabled ? LedOperateTaskTypeOpen : LedOperateTaskTypeClose;
        
        _alarmData.action = type;
        NSDictionary *sendDict = [D5AlarmData dictWithData:_alarmData];
        
        D5LedNormalCmd *setTask = [[D5LedNormalCmd alloc] init];
        
        setTask.remoteLocalTag = tag_remote;
        setTask.remotePort = [D5CurrentBox currentBoxTCPPort];
        setTask.strDestMac = [D5CurrentBox currentBoxMac];
        setTask.remoteIp = [D5CurrentBox currentBoxIP];
        setTask.errorDelegate = _delegate;
        setTask.receiveDelegate = _delegate;
        
        NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT] * 1000;
        
        NSDictionary *dict = @{LED_STR_TASK : @[sendDict], LED_STR_APPCURRENTTIME : @([D5Date currentLongTimeStamp]), LED_STR_ZONE : @(timeZoneOffset)};
        [setTask ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Set_TimeTask withData:dict];
    }
}

@end
