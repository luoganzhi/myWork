//
//  D5LightController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LightController.h"
#import "D5LedList.h"
#import "D5RuntimeShareInstance.h"
#import "D5LedData.h"

@interface D5LightController ()<D5LedListDelegate>

@property (weak, nonatomic) IBOutlet UIButton *switchBtn;//开关切换

@property (nonatomic, strong) YHSector *sector;

/** 灯当前的开关状态 */
@property (nonatomic, assign) LedOnOffStatus currentStatus;

@end

@implementation D5LightController

#pragma mark --私有方法
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setSlider];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickSelf) name:@"LightClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setViewByStatus) name:Runtime_Info_Update object:nil];
}

- (void)clickSelf {
    [D5LedList sharedInstance].delegate = self;
    [[D5LedList sharedInstance] getLedListByType:LedListTypeHasAdded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setViewByStatus];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [D5LedList sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma  mark -- 用户交互
- (void)initView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = MUSIC_CELL_BLACk;
    
    [self.switchBtn addTarget:self action:@selector(switchLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchBtn setBackgroundColor:BTN_BACK_COLOR forState:UIControlStateNormal];
    [self.switchBtn setTitleColor:BTN_BACK_TITLE_COLOR forState:UIControlStateNormal];
    
    [self.switchBtn setBackgroundColor:BTN_YELLOW_COLOR forState:UIControlStateSelected];
    [self.switchBtn setSelected:NO];
    
    //设置圆角
    [self.switchBtn setViewFillet:(MainScreenWidth-128)*23/286 color:[UIColor clearColor] borderWidth:1.0];
}

//灯组开关
- (IBAction)switchLight:(UIButton*)sender {
    [self setLightSwitch];//开关反转
}

/**
 根据状态设置view
 */
- (void)setViewByStatus {
    @autoreleasepool {
        D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
        
        NSLog(@"%d",(int)instance.lampStatus);
        if (instance) {
            LedOnOffStatus onOffStatus = instance.lampStatus;
            int brightness = instance.brightness;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setLightStatus:onOffStatus];     // 设置灯的开关状态
                [self setLightBrightness:brightness];  // 设置亮度
            });
        }
    }
}

/**
 设置灯的开关状态
 
 @param status
 */
- (void)setLightStatus:(LedOnOffStatus)status {
    _currentStatus = status;
    
    if ([D5LedList sharedInstance].addedLedList.count <= 0) {
        [_switchStatus setText:@"未添灯"];
        [_switchBtn setSelected:NO];
        [_switchBtn setUserInteractionEnabled:YES];
        _switchBtn.adjustsImageWhenHighlighted = NO;
        _mySlider.userInteractionEnabled = NO;
        _mySlider.alpha = 0.5;
        [_switchBtn setBackgroundColor:BTN_GRAY_COLOR forState:UIControlStateNormal];
        
        return;
    }
    
    switch (status) {
        case LedOnOffStatusOn: {    // 已开灯
            [_switchStatus setText:@"已开灯"];
            [_switchBtn setSelected:YES];
            _switchBtn.alpha = 1.0f;
            [_switchBtn setUserInteractionEnabled:YES];
            _switchBtn.adjustsImageWhenHighlighted = YES;
            
            _mySlider.userInteractionEnabled = YES;
            _mySlider.alpha = 1.0;
            [_switchBtn setBackgroundColor:BTN_YELLOW_COLOR forState:UIControlStateNormal];
            
        }
            break;
        case LedOnOffStatusOff: {   // 已关灯
            [_switchBtn setSelected:YES];
            _switchBtn.alpha = 0.5f;
            [_switchStatus setText:@"已关灯"];
            [_switchBtn setUserInteractionEnabled:YES];
            _switchBtn.adjustsImageWhenHighlighted = NO;
            
            _mySlider.userInteractionEnabled = NO;
            _mySlider.alpha = 0.5f;
            [_switchBtn setBackgroundColor:BTN_BACK_COLOR forState:UIControlStateNormal];
            
        }
            break;
        case LedOnOffStatusOffline: {   // 离线
            [_switchStatus setText:@"已离线"];
            [_switchBtn setSelected:NO];
            [_switchBtn setUserInteractionEnabled:YES];
            _switchBtn.adjustsImageWhenHighlighted = NO;
            _mySlider.userInteractionEnabled = NO;
            _mySlider.alpha = 0.5;
            [_switchBtn setBackgroundColor:BTN_GRAY_COLOR forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
}

/**
 设置亮度
 
 @param brightess
 */
- (void)setLightBrightness:(int)brightess {
    if (brightess < 0) {
        return;
    }
    self.brightessProgress.text = [NSString stringWithFormat:@"%d",brightess];
    [self.mySlider setLightBritgressValue:brightess];
}

- (void)setSlider {
    //开始画的角度
    _mySlider.startAngle = M_PI_4 * 3;
    
    [_mySlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    UIColor *greenColor = [UIColor colorWithRed:29.0/255.0 green:207.0/255.0 blue:0.0 alpha:1.0];
    
    _sector= [YHSector sectorWithColor:greenColor maxValue:100];
    
    _sector.tag = 1;
    //起时值
    _sector.minValue=0;
    _sector.maxValue=100;
    
    _sector.startValue = 0;
    //结束值
    _sector.endValue = 100*3/4;
    //圆环数据
    _mySlider.sector = _sector;
    //圆环半径
    _mySlider.sectorsRadius = (MainScreenWidth-128)/2.0f;
    //圆环宽度
    _mySlider.circleLineWidth=4.0f;
    //边框宽度
    _mySlider.lineWidth=1.0f;
    //初始设为离线
    _mySlider.alpha=0.5;
    _mySlider.userInteractionEnabled=NO;
    //led灯至少有一盏灯被打开
    //    [_mySlider setIsSwitch:YES];
}

#pragma mark - 灯列表delegate
- (void)ledList:(D5LedList *)list getFinished:(BOOL)isFinished {
    @autoreleasepool {
        if (isFinished) {
            NSArray *arr = list.addedLedList;
            LedOnOffStatus status = LedOnOffStatusOffline;
            if (arr && arr.count > 0) {
                NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:arr.count];
                //遍历数组获取灯的状态
                for (NSDictionary *dict in arr) {
                    @autoreleasepool {
                        D5LedData *data = [D5LedData dataWithDict:dict];
                        [tempArray addObject:data];
                    }
                }
                
                //灯在线
                status = [self ledStatusFromArr:tempArray];
                
                [self setLightStatus:status];
            }
        }
    }
}

/**
 判断灯列表中是否有灯是开状态
 
 @param array 灯列表
 @return
 */

- (LedOnOffStatus)ledStatusFromArr:(NSArray *)arr {
    @autoreleasepool {
        LedOnOffStatus status = LedOnOffStatusOffline;
        
        if (arr && arr.count > 0) {
            BOOL isHasOn = NO;
            BOOL allOffOrOffline = NO;
            for (D5LedData *data in arr) {
                LedOnOffStatus onoffStatus = data.onoffStatus;
                if (onoffStatus == LedOnOffStatusOn) {
                    isHasOn = YES;
                    allOffOrOffline = NO;
                    break;
                }
                
                if (onoffStatus == LedOnOffStatusOff) {
                    allOffOrOffline = YES;
                    continue;
                }
            }
            
            if (isHasOn) {
                status = LedOnOffStatusOn;
            } else if (allOffOrOffline) {
                status = LedOnOffStatusOff;
            }
        }
        
        return status;
    }
}

/**
 对所有灯的开关操作
 */
- (void)setLightSwitch {
    @autoreleasepool {
        LedOnOffStatus sendStatus = -1;
        
        if (![D5LedList sharedInstance].addedLedList || [D5LedList sharedInstance].addedLedList.count <= 0) {
            [MBProgressHUD showMessage:@"请在 “设置-灯组管理”中添加新灯" toView:self.view];
            return;
        }
        
        switch (_currentStatus) {
            case LedOnOffStatusOff:
                sendStatus = LedOnOffStatusOn;
                break;
            case LedOnOffStatusOn:
                sendStatus = LedOnOffStatusOff;
                break;
            case LedOnOffStatusOffline:
                sendStatus = LedOnOffStatusOffline;
                [MBProgressHUD showMessage:@"请开灯或检查灯是否正确安装" toView:self.view];
                break;
            default:
                return;
        }
        
        [[D5LedList sharedInstance] operateAllAddedLight:LedOperateTypeSwitch parameterDict:@{LED_STR_LEDSWITCH : @(sendStatus)}];
    }
}

- (void)ledListErrorOperateAddedLed:(D5LedList *)list operateType:(LedOperateType)operateType errorType:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage {
    if (operateType == LedOperateTypeSwitch) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [iToast showButtomTitile:@"获取灯的开关状态失败"];
        });
        return;
    }
    
    if (errorType == D5SocketErrorCodeTypeLedInFollowModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:@"请退出多灯随动模式后再试"];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
    }
    
}


#pragma mark --YHArcSlider delegate
//灯的亮度调节
- (void)valueChange:(YHArcSlider *)slder {
    int now = slder.sector.startValue * 100 / 75;//
    
    [MobClick event:UM_BRIGHTNESS attributes:@{@"value" : [NSString stringWithFormat:@"%d", now]}];
    
    [self setLightBrightness:now];
    
    [[D5LedList sharedInstance] operateAllAddedLight:LedOperateTypeBrightness parameterDict:@{LED_STR_BRIGHTNESS : @(now)}];
}

@end
