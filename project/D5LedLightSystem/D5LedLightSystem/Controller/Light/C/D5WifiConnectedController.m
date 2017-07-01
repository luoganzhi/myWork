//
//  D5WifiConnectedController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2017/2/14.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5WifiConnectedController.h"
#import "D5TcpManager.h"
#import "AppDelegate.h"

@interface D5WifiConnectedController () <D5LedCmdDelegate, D5LedZKTListDelegate, D5LedNetWorkErrorDelegate>
@property (weak, nonatomic) IBOutlet UIView *wifiView;
@property (weak, nonatomic) IBOutlet UIView *wiredView;
@property (weak, nonatomic) IBOutlet UIView *tipLabelView;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIImageView *loadImageView;
/** boxID
 */
@property (nonatomic, copy) NSString *boxId;

/** boxIp */
@property (nonatomic, copy) NSString *boxIp;

/** bool */
@property (nonatomic, assign) BOOL onceTcpConnect;

/** nexBoxIp */
@property (nonatomic, copy) NSString *nowBoxIp;

@property (weak, nonatomic) IBOutlet UIView *sureWiredView;

/** 已经告知中控切换连接方式 */
@property (nonatomic, assign) BOOL isTellChange;

/** 计时器 */
@property (nonatomic, strong) NSTimer *scanTimer;

@property (nonatomic, assign) NSTimeInterval interval;


@end

@implementation D5WifiConnectedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.boxId = [D5CurrentBox currentBoxId];
    self.boxIp = [D5CurrentBox currentBoxIP];
    self.onceTcpConnect = NO;
    self.isTellChange = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectTcp) name:TCP_DISCONNET_MANNGER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectTcpSuccess) name:TCP_CONNECT_SUCCESS object:nil];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isChangeWifiOrWired = YES;



}


- (IBAction)changeToWiredClick:(id)sender {
    self.wifiView.hidden = YES;
    self.wiredView.hidden = NO;
}

/*
 LED_STR_BSSID : nil,
 LED_STR_WIFINAME : nil,
 LED_STR_WIFIPWD : nil
*/

- (void)btnEnable{
    _interval += 1;
    if (_interval >= 45) {
        self.finishButton.enabled = YES;
        self.finishButton.backgroundColor = BTN_YELLOW_COLOR;
        
        [self.scanTimer invalidate];
        self.scanTimer = nil;
        [self stopRotateForImg:self.loadImageView];
        self.tipLabelView.hidden = YES;
        self.sureWiredView.hidden = YES;
        [MBProgressHUD showMessage:@"连接超时，请检查网线是否插好"];

    } else {
        self.finishButton.enabled = NO;
        self.finishButton.backgroundColor = BTN_DISABLED_COLOR;
    }
}

- (IBAction)sureWiredBtnClick:(id)sender {
    self.sureWiredView.hidden = !self.sureWiredView.hidden;
}

- (IBAction)finishToWiredClick:(id)sender {
    self.tipLabelView.hidden = NO;
    [self startRotateForImg:self.loadImageView];
    
    _interval = 0;
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(btnEnable) userInfo:nil repeats:YES];
    [_scanTimer fire];

//    if (self.isTellChange) {
        [self startSearchBox];
//        return;
//    }
    
    
//    D5Tcp *tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
//    if (!tcp || !tcp.isConnected) {
//        [self startSearchBox];
//        return;
//    }
    
    D5DeviceInfo *deviceInfo = [D5CurrentBox currentBoxDeviceInfo];
    if (deviceInfo.connectType != NetConnectTypeWired) {
        NSDictionary *dict = @{LED_STR_NETCONNECT : @(NetConnectTypeWired)
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

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict
{
    if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Change_Connect) {
        DLog(@"无线切有线返回数据 %@", dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.isChangeWifiOrWired = YES;
            self.isTellChange = YES;
            self.sureWiredView.hidden = NO;
//            [self startSearchBox];
//            [MBProgressHUD showMessage:@"请插上网线"];

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
    if ([newBoxId isEqualToString:self.boxId]) {
        NSString * changeIp= [dict objectForKey:ZKT_BOX_IP];
        int port = [dict[ZKT_BOX_TCP_PORT] intValue];

        if (![changeIp isEqualToString:self.boxIp]) {
            self.nowBoxIp = changeIp;

            [[D5LedZKTList defaultList] stopSearchBox];
            DLog(@"当前中控ip变了，更新中控信息重新连接 初始ip%@ 端口 %d  ===> 改变ip%@ 端口%d", self.boxIp,[D5CurrentBox currentBoxTCPPort], self.nowBoxIp, port);

            D5Tcp *tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
            if (!tcp || !tcp.isConnected) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    [D5CurrentBox setInstanceNil];

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
            
        } else {  // 没有插入网线
            if (self.scanTimer) {
                self.sureWiredView.hidden = NO;
            }
            
        }
        
        if (!self.scanTimer) {
            self.sureWiredView.hidden = YES;
        }
    }
}


            

- (void)connectTcp {
        if (!self.nowBoxIp ||[self.nowBoxIp isEqualToString:@""]) return;
        
        self.onceTcpConnect = YES;
    D5Tcp *tcp = [[D5TcpManager defaultTcpManager] tcpOfServer:self.nowBoxIp port:[D5CurrentBox currentBoxTCPPort]];
    if (!tcp || !tcp.isConnected) {

    [[D5LedCommunication sharedLedModule] tcpConnect:self.nowBoxIp port:[D5CurrentBox currentBoxTCPPort]];
        DLog(@"当前ip %@", self.nowBoxIp);
    }
}

- (void)connectTcpSuccess {
    DLog(@"重新连接成功");
    self.sureWiredView.hidden = YES;
    [self getDeviceInfoFromServer];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isChangeWifiOrWired = NO;
}

- (void)getDeviceInfoFromServer {
    @autoreleasepool {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            D5LedNormalCmd *normalCmd = [[D5LedNormalCmd alloc] init];
            
            normalCmd.strDestMac = [D5CurrentBox currentBoxMac];
            normalCmd.remoteLocalTag = tag_remote;
            normalCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
            normalCmd.remoteIp = [D5CurrentBox currentBoxIP];
            normalCmd.errorDelegate = self;
            normalCmd.receiveDelegate = self;
            
            [normalCmd ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Get_Info];

            
        });
    }
}

- (void)dealloc
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.isChangeWifiOrWired = NO;
    [[D5LedZKTList defaultList] stopSearchBox];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
