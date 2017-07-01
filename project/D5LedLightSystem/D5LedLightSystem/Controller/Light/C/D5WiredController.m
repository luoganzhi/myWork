//
//  D5WiredController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2017/2/14.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5WiredController.h"
#import "D5TcpManager.h"
#import "AppDelegate.h"

@interface D5WiredController () <UITextFieldDelegate, D5LedCmdDelegate, D5LedZKTListDelegate, D5LedNetWorkErrorDelegate>
@property (weak, nonatomic) IBOutlet UIView *putWiredView;
@property (weak, nonatomic) IBOutlet UIView *sureWifiView;
@property (weak, nonatomic) IBOutlet UIView *wiredView;

@property (weak, nonatomic) IBOutlet UIView *wifiView;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;
// 连接失败界面
@property (weak, nonatomic) IBOutlet UIView *connectedFailedView;
@property (weak, nonatomic) IBOutlet UITextField *wifiPWD;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIButton *wifiName;
/** boxID 
  */
@property (nonatomic, copy) NSString *boxId;

/** boxIp */
@property (nonatomic, copy) NSString *boxIp;

/** bool */
@property (nonatomic, assign) BOOL onceTcpConnect;

/** nexBoxIp */
@property (nonatomic, strong) NSString *nowBoxIp;

/** 已经告知中控切换连接方式 */
@property (nonatomic, assign) BOOL isTellChange;

/** 计时器 */
@property (nonatomic, strong) NSTimer *scanTimer;

@property (nonatomic, assign) NSTimeInterval interval;

/** 是否失败过 */
@property (nonatomic, assign) BOOL isFailed;

/** 是否有找到 */
@property (nonatomic, assign) BOOL isExist;

/** 密码是否正确 */
@property (nonatomic, assign) BOOL isTurePWD;

/** 是否重新连回有线 */
@property (nonatomic, assign) BOOL isReturnConnectWired;

- (IBAction)btnEyeClicked:(UIButton *)sender;
@end

@implementation D5WiredController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.boxId = [D5CurrentBox currentBoxId];
    self.boxIp = [D5CurrentBox currentBoxIP];
    self.onceTcpConnect = NO;
    self.isTellChange = NO;
    self.isFailed = NO;
    self.isExist = NO;
    self.isTurePWD = YES;
    self.isReturnConnectWired  = NO;

    
    [self.wifiName setTitle:[D5NetWork getCurrentWifiName] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectTcp) name:TCP_DISCONNET_MANNGER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectTcpSuccess) name:TCP_CONNECT_SUCCESS object:nil];
}


- (IBAction)changToWifiClick:(id)sender {
    self.wiredView.hidden = YES;
    self.wifiView.hidden = NO;
    self.wifiPWD.delegate = self;
}

- (void)btnEnable {
    _interval += 1;
    
    // 如果密码错误， 需要插入网线，重新搜索，连接中控后，再重新发送密码。
    if (_interval >5 && self.isFailed && !self.isExist) {
        self.isTurePWD = NO;
        self.putWiredView.hidden = NO;
//        self.tipView.hidden = YES;
        self.isTellChange = NO;
        [self.scanTimer invalidate];
        self.scanTimer = nil;
        self.isFailed = NO;
        [[D5LedCommunication sharedLedModule] disConnectTcp:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
        [[D5LedZKTList defaultList] stopSearchBox];
        return;
    }

    if (_interval >= 45) {
        self.finishButton.enabled = YES;
        self.finishButton.backgroundColor = BTN_YELLOW_COLOR;
        [self.scanTimer invalidate];
        self.scanTimer = nil;
        [self stopRotateForImg:self.loadImageView];
        self.tipView.hidden = YES;
        self.wifiPWD.enabled = YES;
        self.connectedFailedView.hidden = NO;
        self.isFailed = YES;
        self.sureWifiView.hidden = YES;
        [[D5LedZKTList defaultList] stopSearchBox];
    } else {
        self.finishButton.enabled = NO;
        self.finishButton.backgroundColor = BTN_DISABLED_COLOR;
        self.wifiPWD.enabled = NO;
    }
}

- (IBAction)finishBtnClick:(id)sender {
    
    self.connectedFailedView.hidden = YES;

    // 特殊情况 ， 输入错误密码且拔了网线
//    if (self.isFailed && !self.isExist) {
//        self.isTurePWD = NO;  // 如果密码错误， 需要插入网线，重新搜索，连接中控后，再重新发送密码。
//        self.putWiredView.hidden = NO;
//        return;
//    }

    
    self.isExist = NO;
    
    self.tipView.hidden = NO;
    [self startRotateForImg:self.loadImageView];
    
    
    
    _interval = 0;
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnEnable) userInfo:nil repeats:YES];
    [_scanTimer fire];
    
    
    if (self.isTellChange) {
        [self startSearchBox];
        return;
    }
    

    if (!self.isFailed) {
        D5DeviceInfo *deviceInfo = [D5CurrentBox currentBoxDeviceInfo];
        if (deviceInfo.connectType != NetConnectTypeWIFI) {
            NSDictionary *dict = @{LED_STR_NETCONNECT : @(NetConnectTypeWIFI),
                                   LED_STR_BSSID :  [D5NetWork getCurrentBssid],
                                   LED_STR_WIFINAME : [D5NetWork getCurrentWifiName],
                                   LED_STR_WIFIPWD : self.wifiPWD.text
                                   };
            
            D5LedNormalCmd *boxSetInfo = [[D5LedNormalCmd alloc] init];
            
            boxSetInfo.remoteLocalTag = tag_remote;
            boxSetInfo.remotePort = [D5CurrentBox currentBoxTCPPort];
            boxSetInfo.remoteIp = [D5CurrentBox currentBoxIP];
            boxSetInfo.strDestMac = [D5CurrentBox currentBoxMac];
            boxSetInfo.receiveDelegate = self;
            
            [boxSetInfo ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Change_Connect withData:dict];

        } else {
        
        }
    
    }
    

}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![self.wifiPWD.text isEqualToString:@""]) {
        self.finishButton.backgroundColor = BTN_YELLOW_COLOR;
        self.finishButton.enabled = YES;
    } else {
        self.finishButton.backgroundColor = BTN_DISABLED_COLOR;
        self.finishButton.enabled = NO;

    }
}

#pragma mark - D5LedCmdDelegate

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict
{
    if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Change_Connect) {
        DLog(@"有线切换无线返回数据 %@", dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.isChangeWifiOrWired = YES;
            self.isTellChange = YES;
            [self startSearchBox];
            self.sureWifiView.hidden = NO;
//            [MBProgressHUD showMessage:@"请拔掉网线" longTime:YES];
        });
    } else if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Get_Info) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SETBOXINFO object:nil];
    }
}

- (void)startSearchBox {
    @autoreleasepool {
                    // 发送广播搜中控
            [[NSUserDefaults standardUserDefaults] setDouble:[D5Date currentTimeStamp] forKey:UM_ADD_DEVICE];
            
            [D5LedZKTList defaultList].delegate = self;
            [[D5LedZKTList defaultList] getZKTListFromServer];
        
    }
}

- (void)ledZKTList:(D5LedZKTList *)zktList searchedZKT:(NSDictionary *)dict
{
    NSString *newBoxId = [dict objectForKey:ZKT_BOX_ID];
    if ([newBoxId isEqualToString:self.boxId]) {  // 找到中控
        self.isExist = YES;
     
        NSString *changeIp = [dict objectForKey:ZKT_BOX_IP];
        int port = [dict[ZKT_BOX_TCP_PORT] intValue];
        
        if (!self.isTurePWD) {  // 密码输入错误， 重新去连接
            self.isTurePWD = YES;
            [[D5LedZKTList defaultList] stopSearchBox];
            D5Tcp *tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:changeIp port:port];
            if (!tcp || !tcp.isConnected) {
                [[D5LedCommunication sharedLedModule] tcpConnect:changeIp port:port];
                self.isReturnConnectWired = YES;
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    D5Tcp *nowTcp = [[D5TcpManager defaultTcpManager] tcpOfServer:changeIp port:port];

                    if (nowTcp) {
                        self.isExist = YES;
                        self.isFailed = NO;
                        [self finishBtnClick:nil];
                    }
                });
                
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (tcp) {
                        self.isExist = YES;
                        self.isFailed = NO;
                        [self finishBtnClick:nil];
                    }
                });

            }
        }
        if (![changeIp isEqualToString:self.boxIp]) { // 已经拔掉网线
            self.nowBoxIp = changeIp;
            DLog(@"当前中控ip变了，更新中控信息重新连接 初始ip%@ 端口 %d  ===> 改变ip%@ 端口%d", self.boxIp,[D5CurrentBox currentBoxTCPPort], self.nowBoxIp, port);
            [[D5LedZKTList defaultList] stopSearchBox];

            D5Tcp *tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
            if (!tcp || !tcp.isConnected) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:dict forKey:SELECTED_ZKT_KEY];
                    [userDefaults synchronize];

                    [self connectTcp];
                });

            } else {
                
                [[D5LedCommunication sharedLedModule] disConnectTcp:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
                [D5CurrentBox setInstanceNil];
                 dispatch_async(dispatch_get_main_queue(), ^{
                    //保存到本地
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:dict forKey:SELECTED_ZKT_KEY];
                    [userDefaults synchronize];
                 });
                
            } 
        
        } else {
            // 没有拔掉网线
            if (self.scanTimer) {
                self.sureWifiView.hidden = NO;
            }
        }
        
        if (!self.scanTimer) {
            self.sureWifiView.hidden = YES;
        }
    
    }
    
}

// 已插入网线
- (IBAction)realPutWiredBtnClick:(id)sender {
    [self startSearchBox];
    self.putWiredView.hidden = YES;
}

- (void)connectTcp {
    if (!self.nowBoxIp ||[self.nowBoxIp isEqualToString:@""]) return;
    D5Tcp *tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:self.nowBoxIp port:[D5CurrentBox currentBoxTCPPort]];
    if (!tcp || !tcp.isConnected) {
        [[D5LedCommunication sharedLedModule] tcpConnect:self.nowBoxIp port:[D5CurrentBox currentBoxTCPPort]];
        
        DLog(@"当前ip %@", self.nowBoxIp);
    }
}

- (void)connectTcpSuccess {
    DLog(@"重新连接成功");
    
    if (self.isReturnConnectWired) {
        self.isReturnConnectWired = NO;
        return;
    }
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isChangeWifiOrWired = NO;
    self.sureWifiView.hidden = YES;
    self.isFailed = NO;
    self.isTurePWD = YES;
    [self getDeviceInfoFromServer];
}

- (void)getDeviceInfoFromServer {
    @autoreleasepool {
        D5LedNormalCmd *normalCmd = [[D5LedNormalCmd alloc] init];
        
        normalCmd.strDestMac = [D5CurrentBox currentBoxMac];
        normalCmd.remoteLocalTag = tag_remote;
        normalCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
        normalCmd.remoteIp = [D5CurrentBox currentBoxIP];
        normalCmd.errorDelegate = self;
        normalCmd.receiveDelegate = self;
        
        [normalCmd ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Get_Info];
    }
}
- (IBAction)changeSecureOrNot:(id)sender {
    self.wifiPWD.secureTextEntry = !self.wifiPWD.secureTextEntry;
}

- (void)dealloc
{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isChangeWifiOrWired = NO;
    [[D5LedZKTList defaultList] stopSearchBox];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)btnEyeClicked:(UIButton *)sender {
    _wifiPWD.secureTextEntry = !_wifiPWD.secureTextEntry;
}
- (IBAction)btnNoWiredClick:(id)sender {
    
    self.sureWifiView.hidden = !self.sureWifiView.hidden;
}

#pragma mark - textfield 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
@end
