//
//  D5PrepareConnectViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5PrepareConnectViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "D5HLedReachability.h"

#define NOT_YET @"未"
#define HAS @"已"
#define WIFI_OPEN @"连接Wi-Fi"
#define BLUETOOTH_OPEN @"开启蓝牙"

#define CONNECT @"连接"
#define OPEN @"开启"


#define WIFI_URL @"prefs:root=WIFI"
#define BLUETOOTH_URL @"prefs:root=Bluetooth"

#define BLACK_TITLE_COLOR [UIColor colorWithWhite:0.106 alpha:1.000]
#define WHITE_COLOR [UIColor whiteColor]

@interface D5PrepareConnectViewController() //<CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;

@property (weak, nonatomic) IBOutlet UILabel *openWIFILable;
//@property (weak, nonatomic) IBOutlet UILabel *openBlueToothLable;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenWIFI;
//@property (weak, nonatomic) IBOutlet UIButton *btnOpenBluetooth;

- (IBAction)btnOpenWIFIClicked:(UIButton *)sender;
//- (IBAction)btnOpenBluetoothClicked:(UIButton *)sender;
@end

@implementation D5PrepareConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    @autoreleasepool {
        [D5Round setBorderWidth:1 color:BTN_YELLOW_COLOR forView:_btnOpenWIFI];
//        [D5Round setBorderWidth:1 color:BTN_YELLOW_COLOR forView:_btnOpenBluetooth];
        
        [self setWIFIView];
//        [self initBlueTooth];
    }
}

- (BOOL)isConnectWIFI {
    BOOL result = [D5HLedReachability isWifiCanUse];
    DLog(@"是否连接WIFI %d", result);
    return result;
}

- (void)initBlueTooth {
//    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)setWIFIView {
    [self setLabelText:self.isConnectWIFI tpye:WIFI_OPEN forLabel:_openWIFILable];
    [self setWIFIButton:self.isConnectWIFI];
}

- (void)setBlueToothView {
//    [self setLabelText:_isOpenBlueTooth tpye:BLUETOOTH_OPEN forLabel:_openBlueToothLable];
//    [self setBlueToothButton:_isOpenBlueTooth];
}

/**
 *  根据打开状态设置label的text
 *
 *  @param isOpened 打开状态
 *  @param type     蓝牙还是WiFi  （传WIFI_OPEN / BLUETOOTH_OPEN）
 *  @param label    显示的label
 */
- (void)setLabelText:(BOOL)isOpened tpye:(NSString *)type forLabel:(UILabel *)label {
    if (isOpened) {
        label.text = [D5NetWork getCurrentWifiName];
    } else {
        label.text = [NOT_YET stringByAppendingString:type];
    }
}

/**
 *  根据打开状态设置button的标题和背景颜色
 *
 *  @param isOpened wifi打开状态
 *  @param btn
 */
- (void)setWIFIButton:(BOOL)isOpened {
    _btnOpenWIFI.enabled = !isOpened;
    [self setBtnTitle:isOpened ? [HAS stringByAppendingString:CONNECT] : CONNECT forBtn:_btnOpenWIFI];
    _btnOpenWIFI.backgroundColor = isOpened ? [UIColor clearColor] : BTN_YELLOW_COLOR;
    [_btnOpenWIFI setTitleColor:isOpened ? WHITE_COLOR : BLACK_TITLE_COLOR forState:UIControlStateNormal];
}

/**
 *  根据打开状态设置蓝牙button的标题和背景颜色
 *
 *  @param isOpened 蓝牙打开状态
 *  @param btn
 */
- (void)setBlueToothButton:(BOOL)isOpened {
//    _btnOpenBluetooth.enabled = !isOpened;
//    [self setBtnTitle:isOpened ? [HAS stringByAppendingString:OPEN] : OPEN forBtn:_btnOpenBluetooth];
//    _btnOpenBluetooth.backgroundColor = isOpened ? [UIColor clearColor] : BTN_YELLOW_COLOR;
//    [_btnOpenBluetooth setTitleColor:isOpened ? WHITE_COLOR : BLACK_TITLE_COLOR forState:UIControlStateNormal];
}

#pragma mark - 蓝牙状态代理 -- 蓝牙状态改变
//- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
//    @autoreleasepool {
//        _isOpenBlueTooth = (central.state == CBCentralManagerStatePoweredOn);
//        [self setBlueToothView];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:STATUS_CHANGED object:nil];
//        });
//    }
//}

#pragma mark - 打开WIFI/蓝牙
- (void)openSetting:(NSString *)urlstr {
    @autoreleasepool {
        BOOL isVersion10 = [D5String systemVersionAtLeast10];
        if (isVersion10) {
            urlstr = UIApplicationOpenSettingsURLString; //IOS10跳转至设置主页面
        }
        
        NSURL *url = [NSURL URLWithString:urlstr];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (isVersion10) {
                [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @(NO)} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

#pragma mark - 点击事件
- (IBAction)btnOpenWIFIClicked:(UIButton *)sender {
    [self openSetting:WIFI_URL];
}

- (IBAction)btnOpenBluetoothClicked:(UIButton *)sender {
    [self openSetting:BLUETOOTH_URL];
}
@end
