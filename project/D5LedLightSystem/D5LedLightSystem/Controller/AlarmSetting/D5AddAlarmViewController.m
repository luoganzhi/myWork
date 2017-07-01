//
//  D5AddAlarmViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5AddAlarmViewController.h"
#import "D5DatePicker.h"

#define SELECTED_COLOR [UIColor colorWithRed:1 green:(212.0f/255.0f) blue:0 alpha:1.000]
#define NORMAL_COLOR [UIColor clearColor]

#define WEEK_NORMAL_COLOR [UIColor colorWithRed:(49.0f/255.0f) green:(49.0f/255.0f) blue:(49.0f/255.0f) alpha:1.000]

#define SELECTED_TITLE_COLOR [UIColor colorWithRed:(26.0f/255.0f) green:(26.0f/255.0f) blue:(26.0f/255.0f) alpha:1.000]

@interface D5AddAlarmViewController() <D5LedCmdDelegate, D5LedNetWorkErrorDelegate, D5DatePickerDelegate> {
    int repeat;
}
/*开灯*/
@property (weak, nonatomic) IBOutlet UIButton *btnOpen;
- (IBAction)btnOpenClicked:(UIButton *)sender;

/*关灯*/
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
- (IBAction)btnCloseClicked:(UIButton *)sender;

@property (nonatomic, assign) LedTimeTaskLedOperate type;

//记录才进来时的--看是否有变化
@property (nonatomic, assign)  Byte originalRepeat;
@property (nonatomic, assign)  LedTimeTaskLedOperate originalType;
@property (nonatomic, strong)  NSDate *originalDate;
@property (nonatomic, assign)  BOOL isDefaultAlarm;

/*时间选择器*/
@property (weak, nonatomic) IBOutlet D5DatePicker *datePicker;

/*周期*/
@property (weak, nonatomic) IBOutlet UIButton *btnMon;
@property (weak, nonatomic) IBOutlet UIButton *btnTue;
@property (weak, nonatomic) IBOutlet UIButton *btnWes;
@property (weak, nonatomic) IBOutlet UIButton *btnThu;
@property (weak, nonatomic) IBOutlet UIButton *btnFri;
@property (weak, nonatomic) IBOutlet UIButton *btnSat;
@property (weak, nonatomic) IBOutlet UIButton *btnSun;

- (IBAction)btnWeekClicked:(UIButton *)sender;

/*确认退出添加alarm的view*/
@property (weak, nonatomic) IBOutlet UIView *sureView;
- (IBAction)btnCancelClicked:(UIButton *)sender;
- (IBAction)btnSaveClicked:(UIButton *)sender;

/**/
@end

@implementation D5AddAlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

//初始化
- (void)initView {
    @autoreleasepool {
        _sureView.hidden = YES;
        
        self.title = @"添加定时设置";
        
        [self addBarItem];
        [self initPicker];
        [self initBtn];
        [self initWeekBtn];
        
        _isDefaultAlarm = !_modifyTaskData;
        if (_modifyTaskData) {
            [self setView];
        }
        [self enableRightItem];
    }
}

- (void)initBtn {
    @autoreleasepool {
        [D5Round setRoundForView:_btnOpen borderColor:SELECTED_COLOR];
        [_btnOpen setBackgroundColor:NORMAL_COLOR forState:UIControlStateNormal];
        [_btnOpen setBackgroundColor:SELECTED_COLOR forState:UIControlStateSelected];
        
        [D5Round setRoundForView:_btnClose borderColor:SELECTED_COLOR];
        [_btnClose setBackgroundColor:NORMAL_COLOR forState:UIControlStateNormal];
        [_btnClose setBackgroundColor:SELECTED_COLOR forState:UIControlStateSelected];
        
        _btnOpen.selected = YES;
        
        _originalType = LedTimeTaskLedOperateOn;
        _type = _originalType;
    }
}

- (void)initWeekBtn {
    @autoreleasepool {
        for (int i = 10001; i <= 10007; i ++) {
            @autoreleasepool {
                UIButton *btn = [self.view viewWithTag:i];
                if (i <= 10005) {
                    btn.selected = YES;
                }
                
                [D5Round setRoundForView:btn borderColor:NORMAL_COLOR];
                [btn setBackgroundColor:WEEK_NORMAL_COLOR forState:UIControlStateNormal];
                [btn setBackgroundColor:SELECTED_COLOR forState:UIControlStateSelected];
            }
        }
        
        //周一到周五 开灯 初始repeat
        _originalRepeat = WEEK_DAYS_REPEAT;
        repeat = _originalRepeat;
    }
}

//如果修改定时任务  先显示view的值
- (void)setView {
    @autoreleasepool {
        for (int i = 10001; i <= 10007; i ++) {
            @autoreleasepool {
                UIButton *btn = [self.view viewWithTag:i];
                btn.selected = NO;
            }
        }
        
        _type = _modifyTaskData.operate;
        
        _btnOpen.selected = (_type == LedTimeTaskLedOperateOn);
        _btnClose.selected = !_btnOpen.selected;
        
        repeat = _modifyTaskData.week;
        [self setWeekBtn:repeat];
        
        NSInteger seconds = _modifyTaskData.execTime;
        NSDate *date = [D5Date dateFromSeconds:seconds];
        [_datePicker selectDate:date];
        
        _originalRepeat = repeat;
        _originalDate = date;
        _originalType = _type;
    }
}

- (void)setWeekBtnByWeek:(Byte)week {
    @autoreleasepool {
        NSArray *btnArr = [NSArray arrayWithObjects:_btnMon, _btnTue, _btnWes, _btnThu, _btnFri, _btnSat, _btnSun, nil];
        for (int i = 0; i < 7; i ++) {
            @autoreleasepool {
                Byte temp = week >> (i + 1);
                
                int result = temp & 0x01;
                if (result == 1) {
                    UIButton *btn = btnArr[i];
                    btn.selected = YES;
                }
            }
        }
    }
}

//设置周期按钮的选中状态
- (void)setWeekBtn:(Byte)week {
    @autoreleasepool {
        if (week == EVERY_DAY_REPEAT) {//每天 254
            _btnMon.selected = YES;
            _btnTue.selected = YES;
            _btnWes.selected = YES;
            _btnThu.selected = YES;
            _btnFri.selected = YES;
            _btnSat.selected = YES;
            _btnSun.selected = YES;
        } else {
            [self setWeekBtnByWeek:week];
        }
        
        //        Byte mask = 1;
        //        if (week == 127) {//每天
        //            _btnMon.selected = YES;
        //            _btnTue.selected = YES;
        //            _btnWes.selected = YES;
        //            _btnThu.selected = YES;
        //            _btnFri.selected = YES;
        //            _btnSat.selected = YES;
        //            _btnSun.selected = YES;
        //        } else {
        //            if ((week & mask) != 0) {
        //                _btnMon.selected = YES;
        //            }
        //
        //            mask = mask << 1;
        //            if ((week & mask) != 0) {
        //                _btnTue.selected = YES;
        //            }
        //
        //            mask = mask << 1;
        //            if ((week & mask) != 0) {
        //                _btnWes.selected = YES;
        //            }
        //
        //            mask = mask << 1;
        //            if ((week & mask) != 0) {
        //                _btnThu.selected = YES;
        //            }
        //
        //            mask = mask << 1;
        //            if ((week & mask) != 0) {
        //                _btnFri.selected = YES;
        //            }
        //
        //            mask = mask << 1;
        //            if ((week & mask) != 0) {
        //                _btnSat.selected = YES;
        //            }
        //
        //            mask = mask << 1;
        //            if ((week & mask) != 0) {
        //                _btnSun.selected = YES;
        //            }
        //        }
    }
}

- (void)initPicker {
    @autoreleasepool {
        _datePicker.dvDelegate = self;
        _originalDate = _datePicker.date;
    }
}

//添加baritem
- (void)addBarItem {
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
    [D5BarItem addRightBarItemWithText:@"保存" color:WHITE_COLOR target:self action:@selector(saveAlarm)];
}

- (void)back {
    if (_originalRepeat != repeat || ![_originalDate isEqualToDate:_datePicker.date] || _originalType != _type) { //有改动
        _sureView.hidden = NO;
    } else {
        [super back];
    }
}

#pragma mark - 判断右上角的保存按钮是否enable
- (void)enableRightItem {
    @autoreleasepool {
        if (_isDefaultAlarm) {
            [self changeRightBarItemEnabled:YES];
        } else {
            BOOL isUpdate = _originalRepeat != repeat || ![_originalDate isEqualToDate:_datePicker.date] || _originalType != _type; //有改动
            [self changeRightBarItemEnabled:isUpdate];
        }
    }
}

#pragma mark - 添加定时任务
- (void)addTimeTask:(NSArray *)arr {
    @autoreleasepool {
        D5LedNormalCmd *timeTask = [[D5LedNormalCmd alloc] init];
        
        timeTask.remoteLocalTag = tag_remote;
        timeTask.remotePort = [D5CurrentBox currentBoxTCPPort];
        timeTask.strDestMac = [D5CurrentBox currentBoxMac];
        timeTask.remoteIp = [D5CurrentBox currentBoxIP];
        timeTask.errorDelegate = self;
        timeTask.receiveDelegate = self;
        
        NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT] * 1000;
        
        NSDictionary *sendDict = @{LED_STR_TASK : arr, LED_STR_APPCURRENTTIME : @([D5Date currentLongTimeStamp]), LED_STR_ZONE : @(timeZoneOffset)};
        [timeTask ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Set_TimeTask withData:sendDict];
    }
}

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    @autoreleasepool {
        if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Set_TimeTask) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
                [super back];
            });
        }
    }
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Set_TimeTask) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view];
        });
    }
    //    //DLog(@"添加定时任务errortype = %d", (int)errorType);
}

#pragma mark - 点击事件
//取消保存
- (IBAction)btnCancelClicked:(UIButton *)sender {
    _sureView.hidden = YES;
    [super back];
}

//保存
- (IBAction)btnSaveClicked:(UIButton *)sender {
    _sureView.hidden = YES;
    [self saveAlarm];
}

//开灯
- (IBAction)btnOpenClicked:(UIButton *)sender {
    @autoreleasepool {
        if (sender.isSelected) {
            return;
        }
        _btnClose.selected = NO;
        
        sender.selected = !sender.isSelected;
        _type = sender.isSelected ? LedTimeTaskLedOperateOn : -1;
        
        if (sender.isSelected) { //选中 -- 是否选周期
            [self setRepeat];
        }
        
        [self enableRightItem];
    }
}

//关灯
- (IBAction)btnCloseClicked:(UIButton *)sender {
    @autoreleasepool {
        if (sender.isSelected) {
            return;
        }
        
        _btnOpen.selected = NO;
        
        sender.selected = !sender.isSelected;
        _type = sender.isSelected ? LedTimeTaskLedOperateOff : -1;
        
        if (sender.isSelected) { //选中 -- 是否选周期
            [self setRepeat];
        }
        [self enableRightItem];
    }
}

- (void)d5DatePicker:(D5DatePicker *)picker didSelectedDate:(NSDate *)date {
    @autoreleasepool {
        [self enableRightItem];
    }
}

//周期选择
- (IBAction)btnWeekClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    [self setRepeat];
    [self enableRightItem];
}

//保存定时任务
- (void)saveAlarm {
    @autoreleasepool {
        NSInteger minutes =  [D5Date secondsFromDate:[_datePicker date]];
        LedOperateTaskType type = LedOperateTaskTypeCreate;
        int alarmId = 0;
        if (_modifyTaskData) {
            type = LedOperateTaskTypeUpdate;
            alarmId = _modifyTaskData.alarmId;
        }
        
        D5AlarmData *alarmData = [[D5AlarmData alloc] init];
        alarmData.alarmId = alarmId;
        alarmData.action = type;
        alarmData.lookType = LedTimeTaskCycleTypeCustomWeek;
        alarmData.week = repeat;
        alarmData.execTime = minutes;
        alarmData.operate = _type;
        
        NSDictionary *sendDict = [D5AlarmData dictWithData:alarmData];
        [self addTimeTask:@[sendDict]];
        
        [MBProgressHUD showLoading:@"" toView:self.view];
    }
}

#pragma mark - 设置周期
- (void)setRepeat {
    @autoreleasepool {
        Byte rep = 0;
        
        if (_btnMon.isSelected) {
            rep = rep | 0x02;
        }
        
        if (_btnTue.isSelected) {
            rep = rep | 0x04;
        }
        
        if (_btnWes.isSelected) {
            rep = rep | 0x08;
        }
        
        if (_btnThu.isSelected) {
            rep = rep | 0x10;
        }
        
        if (_btnFri.isSelected) {
            rep = rep | 0x20;
        }
        
        if (_btnSat.isSelected) {
            rep = rep | 0x40;
        }
        
        if (_btnSun.isSelected) {
            rep = rep | 0x80;
        }
        
        
        
        //        mask = mask << 1;
        //        rep += [_btnMon isSelected] ? mask : 0;
        //
        //        mask = mask << 1;
        //        rep += [_btnTue isSelected] ? mask : 0;
        //
        //        mask = mask << 1;
        //        rep += [_btnWes isSelected] ? mask : 0;
        //        
        //        mask = mask << 1;
        //        rep += [_btnThu isSelected] ? mask : 0;
        //        
        //        mask = mask << 1;
        //        rep += [_btnFri isSelected] ? mask : 0;
        //        
        //        mask = mask << 1;
        //        rep += [_btnSat isSelected] ? mask : 0;
        //        
        //        mask = mask << 1;
        //        rep += [_btnSun isSelected] ? mask : 0;
        
        
        
        repeat = rep;
    }
}

@end
