//
//  D5InfoViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/2.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5InfoViewController.h"
#import "D5ConnectZKTViewController.h"
#import "D5LoadingViewController.h"
#import "D5TcpManager.h"
#import "D5DeviceInfo.h"
#import "D5ChangeNameViewController.h"
#import "D5CheckUpdate.h"
#import "D5BtLightUpdateViewController.h"
#import "D5RuntimeShareInstance.h"
#import "D5MusicListInstance.h"
#import "D5DisconnectTipView.h"
#import "AppDelegate.h"

#define LOADING_VC_ID @"LOADING_VC"

#define NOT_UPDATE_CELL_HEIGHT 55.0f
#define UPDATE_ING_CELL_HEIGHT 80.0f

#define DOWNLOAD_ING_TIP_STR(progress) [NSString stringWithFormat:@"下载中...%d%%", progress]
#define UPDATE_ING_TIP_STR @"升级中..."

@interface D5InfoViewController () <D5LedNetWorkErrorDelegate, D5LedCmdDelegate, D5ChangeNameViewControllerDelegate, D5LedListDelegate>

@property (weak, nonatomic) IBOutlet UILabel *productModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *macAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (weak, nonatomic) IBOutlet UIView *upgradeView;
@property (weak, nonatomic) IBOutlet UIButton *btnUpgrade;
@property (weak, nonatomic) IBOutlet UILabel *upgradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *boxVersionLabel;
@property (weak, nonatomic) IBOutlet UIView *resetView;

- (IBAction)btnCancelClicked:(UIButton *)sender;
- (IBAction)btnSureClicked:(UIButton *)sender;
- (IBAction)btnUpgradeClicked:(UIButton *)sender;

/** 升级 */
@property (weak, nonatomic) IBOutlet UIImageView *redPointImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateCellHeight;
@property (weak, nonatomic) IBOutlet UILabel *updateTipLabel;

/** 蓝牙灯升级的红点img */
@property (weak, nonatomic) IBOutlet UIImageView *btRedPointImgView;
@property (weak, nonatomic) IBOutlet UILabel *btVerLabel;

@property (nonatomic, copy) NSString *updateURL;

@property (nonatomic, assign) BOOL boxIsUpdating;

@property (nonatomic, assign) BOOL allOffline, noLight;

- (IBAction)btnBlueToothUpdateClicked:(UIButton *)sender;

/** D5ChangeNameViewController */
@property (nonatomic, strong) D5ChangeNameViewController *changNameVC;

@end

@implementation D5InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"中控管理";
    
    _upgradeView.hidden = YES;
    
    [self addLeftBarItem];
    [self resetBtnSet];
    [self initView];
}

/**
 发送命令获取1-4的基础信息
 */
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

- (void)setBoxUpdateDataByIsNeed:(BOOL)isNeed {
    dispatch_async(dispatch_get_main_queue(), ^{
        _redPointImgView.hidden = !isNeed;
        
        _updateURL = nil;
        if (isNeed) {
            D5UpdateModel *boxUpdate =  [D5CheckUpdate sharedInstance].boxUpdate;
            if (boxUpdate) {
                _updateURL = boxUpdate.updateUrl;
            }
        }
    });
}
- (void)setBtUpdateDataByIsNeed:(BOOL)isNeed isLatest:(BOOL)isLatest {
    dispatch_async(dispatch_get_main_queue(), ^{
        _btRedPointImgView.hidden = !isNeed;
        
        if (!isNeed && !isLatest) {
            _btVerLabel.text = @"";
        } else {
            D5DeviceInfo *deviceInfo = [D5CurrentBox currentBoxDeviceInfo];
            _btVerLabel.text = deviceInfo.btVerText;
        }
    });
}

- (void)isNeedShowUpdateBy:(BOOL)allOffline hasLight:(BOOL)hasLight {
    @autoreleasepool {
        _allOffline = allOffline;
        _noLight = !hasLight;
        
        D5CheckUpdate *check = [D5CheckUpdate sharedInstance];
        
        BOOL isNeedBox = NO;
        if (check.boxStatus == CheckUpdateStatusIng) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBoxFinish:) name:CHECK_UPDATE_BOX_FINISH_PUSH_NAME object:nil];
        } else {
            D5UpdateModel *boxUpdate = check.boxUpdate;
            if (boxUpdate) {
                isNeedBox = boxUpdate.isNeedUpdate;
            }
            [self setBoxUpdateDataByIsNeed:isNeedBox];
        }
        
        BOOL isNeedBt = NO;
        if (allOffline || !hasLight) {
            [self setBtUpdateDataByIsNeed:isNeedBt isLatest:NO];
            return;
        }
        
        if (check.btStatus == CheckUpdateStatusIng) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkBtFinish:) name:CHECK_UPDATE_BT_FINISH_PUSH_NAME object:nil];
        } else {
            D5UpdateModel *bluetoothUpdate = check.bluetoothUpdate;
            if (bluetoothUpdate) {
                isNeedBt = bluetoothUpdate.isNeedUpdate;
            }
            [self setBtUpdateDataByIsNeed:isNeedBt isLatest:YES];
        }
    }
}

- (void)checkBoxFinish:(NSNotification *)notificaiton {
    @autoreleasepool {
        NSDictionary *dict = notificaiton.userInfo;
        BOOL isNeed = [dict[CHECK_UPDATE_ISNEED] boolValue];
        [self setBoxUpdateDataByIsNeed:isNeed];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CHECK_UPDATE_BOX_FINISH_PUSH_NAME object:nil];
    }
}

- (void)checkBtFinish:(NSNotification *)notificaiton {
    @autoreleasepool {
        NSDictionary *dict = notificaiton.userInfo;
        BOOL isNeed = [dict[CHECK_UPDATE_ISNEED] boolValue];
        [self setBtUpdateDataByIsNeed:isNeed isLatest:YES];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:CHECK_UPDATE_BT_FINISH_PUSH_NAME object:nil];
    }
}

- (void)resetBtnSet {
    self.resetButton.layer.cornerRadius = 18;
    self.resetButton.layer.masksToBounds = YES;
}

- (void)addLeftBarItem {
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    D5LedList *ledList = [D5LedList sharedInstance];
    ledList.delegate = self;
    
    [self judgeNeedShowUpdateByLedList:ledList];       // 检查更新完成
    [self getDeviceInfoFromServer]; // 获取蓝牙基础信息
}

- (void)judgeNeedShowUpdateByLedList:(D5LedList *)list {
    @autoreleasepool {
        BOOL allOffline = list.allOffline;
        
        NSArray *array = list.addedLedList;
        BOOL hasLight = (array && array.count > 0);
        
        [self isNeedShowUpdateBy:allOffline hasLight:hasLight];
    }
}

- (void)ledList:(D5LedList *)list getFinished:(BOOL)isFinished {
    if (isFinished) {
        [self judgeNeedShowUpdateByLedList:list];
    }
}

- (void)initView {
    @autoreleasepool {
        D5DeviceInfo *deviceInfo = [D5CurrentBox currentBoxDeviceInfo];
        self.productModelLabel.text = deviceInfo.boxName;
        self.versionLabel.text = deviceInfo.modelName;
        self.macAddressLabel.text = [D5CurrentBox currentBoxId];
        
        [self setViewByUpdateIng:NO];
        _boxVersionLabel.text = [@"V " stringByAppendingFormat:@"%@", deviceInfo.versionText];
        DLog(@"检查 initview  %@", deviceInfo.btVerText);
//        _btVerLabel.text = deviceInfo.btVerText;
        _btRedPointImgView.hidden = YES;
    }
}

- (void)setViewByUpdateIng:(BOOL)isUpdateIng {
    @autoreleasepool {
        _boxIsUpdating = isUpdateIng;
        if (isUpdateIng) {
            _redPointImgView.hidden = YES;
        }
        
        [self.view layoutIfNeeded];
        _updateCellHeight.constant = isUpdateIng ? UPDATE_ING_CELL_HEIGHT : NOT_UPDATE_CELL_HEIGHT;
        _updateTipLabel.hidden = !isUpdateIng;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [D5LedList sharedInstance].delegate = self;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 修改名称成功
- (void)finishChangeName:(NSString *)name {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.productModelLabel.text = name;
    });
}

#pragma mark - <MyDelegate>
- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    @autoreleasepool {
        if (errorType == D5SocketErrorCodeTypeTimeOut) {
            //DLog(@"超时:%d->%d",header->cmd,header->subCmd);
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"changeNameIdentifier"]) {
        
        self.changNameVC = segue.destinationViewController;
        self.changNameVC.delegate = self;
        
        self.changNameVC.name = self.productModelLabel.text;
        
    }
}

#pragma mark - 点击事件
- (IBAction)btnUpgradeClicked:(UIButton *)sender {
    if (_boxIsUpdating) {
        return;
    }
    
    if (![D5CheckUpdate sharedInstance].boxUpdate || ![NSString isValidateString:_updateURL]) {
        [MBProgressHUD showMessage:@"您的中控盒子固件是最新的" toView:self.view];
        return;
    }
    _upgradeView.hidden = NO;
}

- (IBAction)btnCancelClicked:(UIButton *)sender {
    _upgradeView.hidden = YES;
}

- (IBAction)btnSureClicked:(UIButton *)sender {
    _upgradeView.hidden = YES;
    
    //升级 -- 去更新中控
    if (![NSString isValidateString:_updateURL]) {
        return;
    }
    
    [self setViewByUpdateIng:YES];
    _boxVersionLabel.text = DOWNLOAD_ING_TIP_STR(0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tcpDisconnected:) name:TCP_DISCONNET object:nil];
    
    [self sendUpgradeBox];
}

- (void)tcpDisconnected:(NSNotification *)notification {
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:TCP_DISCONNET object:nil];
        
        D5Tcp *tcp = (D5Tcp *)notification.object;
        if ([D5TcpManager isCurrentBoxTcp:tcp]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBoxSuccess:) name:UPDATE_BOX_SUCCESS object:nil];
            
            [[D5LedCommunication sharedLedModule] udpConnect:LED_BOX_SEND_PORT];
        }
    }
}

- (void)updateBoxSuccess:(NSNotification *)notification {
    @autoreleasepool {
        DLog(@"升级---updateBoxSuccess");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATE_BOX_SUCCESS object:nil];
        [[D5LedCommunication sharedLedModule] disConnectUdp:LED_BOX_SEND_PORT];
        
        NSDictionary *dict = notification.userInfo;
        if (!dict) {
            return;
        }
        
        NSDictionary *bodyDict = dict[@"body"];
        if (!bodyDict) {
            return;
        }
        
        NSDictionary *data = bodyDict[LED_STR_DATA];
        if (!data) {
            return;
        }
        
        NSDictionary *deviceInfo = data[LED_STR_DEVICEINFO];
        if (deviceInfo) {
            NSString *versionStr = deviceInfo[LED_STR_VERSIONTEXT];
            dispatch_async(dispatch_get_main_queue(), ^{
                _boxVersionLabel.text = [@"V " stringByAppendingFormat:@"%@", versionStr];
                
                [D5CheckUpdate sharedInstance].boxUpdate = nil;
                [self setViewByUpdateIng:NO];
                
                D5DisconnectTipView *tipView = [D5DisconnectTipView sharedDisconnectTipView];
                
                if (tipView.status == ConnectStatusNotReConnect) {  // 没有重连才自动去重连
                    [tipView reConnectTCP];
                }
            });
        }
    }
}

- (IBAction)closeBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 重置中控
- (IBAction)resetLedBoxBtnClick:(id)sender {
    self.resetView.hidden = !self.resetView.hidden;
}

- (IBAction)sureRestView:(id)sender {
    self.resetView.hidden = YES;
    
    // 断开tcp
    [[D5LedCommunication sharedLedModule] disConnectTcp:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
    
    [D5CurrentBox setInstanceNil];
    [[D5RuntimeShareInstance sharedInstance] clear];
    [[D5MusicListInstance sharedInstance] clear];
    [D5LedCommunication sharedLedModule].cmds = nil; // 将所有代理对象清空
    
    [D5LedList sharedInstance].addedLedList = nil;
    
    [self pushToConnectVC];
    
}
- (IBAction)notRestView:(id)sender {
    self.resetView.hidden = YES;
}

- (void)pushToConnectVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:ZKTSOFTWARE_STORYBOARD_ID bundle:nil];
        D5ConnectZKTViewController *connectZKTVC = [sb instantiateViewControllerWithIdentifier:CONNECT_ZKT_VC_ID];
        if (connectZKTVC) {
            [self.navigationController pushViewController:connectZKTVC animated:YES];
        }
    }
}

#pragma mark - 更新中控
- (void)sendUpgradeBox {
    @autoreleasepool {
        D5UpdateModel *boxUpdate = [D5CheckUpdate sharedInstance].boxUpdate;
        if (boxUpdate) {
            D5LedNormalCmd *updateBox = [[D5LedNormalCmd alloc] init];
            
            updateBox.strDestMac = [D5CurrentBox currentBoxMac];
            updateBox.remoteLocalTag = tag_remote;
            updateBox.remotePort = [D5CurrentBox currentBoxTCPPort];
            updateBox.remoteIp = [D5CurrentBox currentBoxIP];
            updateBox.errorDelegate = self;
            updateBox.receiveDelegate = self;
            
            NSDictionary *sendDict = @{LED_STR_IUPDATETYPE : @(LedBoxUpdateTypeDevice),
                                       LED_STR_URL : _updateURL,
                                       LED_STR_VERCODE :@(boxUpdate.freshVerCode),
                                       LED_STR_VERTEXT : boxUpdate.freshverText};
            [updateBox ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Update withData:sendDict];
            
            D5LedSpecialCmd *progressCmd = [[D5LedSpecialCmd alloc] init];
            
            progressCmd.receiveDelegate = self;
            progressCmd.errorDelegate = self;
            
            [progressCmd headerForCmd:Cmd_IO_Operate withSubCmd:SubCmd_File_Update_Progress];
            [progressCmd startCmd];
        }
    }
}

#pragma mark - 更新中控结果
- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    @autoreleasepool {
        if (!dict) {
            return;
        }
        
        if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Update) {
            DLog(@"更新结果 %@", dict[LED_STR_MSG]);
        }
        
        if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Get_Info) {
            NSDictionary *data = dict[LED_STR_DATA];
            if (!data) {
                return;
            }
            
            [D5CurrentBox setCurrentBoxDeviceInfo:data];
            D5DeviceInfo *deviceInfo = [D5CurrentBox currentBoxDeviceInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.productModelLabel.text = deviceInfo.boxName;
//                _btVerLabel.text = deviceInfo.btVerText;


            });
        }
        
        if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Update_Progress) {
            DLog(@"下载进度--%@", dict[LED_STR_MSG]);
            NSDictionary *data = dict[LED_STR_DATA];
            if (!data) {
                return;
            }
            
            UpdateFileType type = [data[LED_STR_TYPE] intValue];
            if (type != UpdateFileTypeBox) {
                return;
            }
            
            UpdateDownloadStatus status = [data[LED_STR_STATUS] intValue];
            int progress = [data[LED_STR_PROGRESS] intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case UpdateDownloadStatusIng: {
                        _boxVersionLabel.text = DOWNLOAD_ING_TIP_STR(progress);
                    }
                        break;
                    case UpdateDownloadStatusSuccess: {
                        _boxVersionLabel.text = UPDATE_ING_TIP_STR;
                    }
                        break;
                        
                    default:
                        break;
                }
            });
        }
    }
}

- (IBAction)btnBlueToothUpdateClicked:(UIButton *)sender {
    D5CheckUpdate *check = [D5CheckUpdate sharedInstance];
    D5UpdateModel *btUpdate = check.bluetoothUpdate;
    
    if ([D5CurrentBox currentBoxDeviceInfo].btVerCode <= 0 || _allOffline || _noLight) {
        if (_noLight) {
            [MBProgressHUD showMessage:@"请在“设置-灯组管理”中添加新灯" toView:self.view];
        } else {
            [MBProgressHUD showMessage:@"请开灯或检查灯是否正确安装" toView:self.view];
        }
    } else if (btUpdate && btUpdate.isNeedUpdate) {
        [[D5ToastViewController shareView] setLabelWithTitle:@"有新的蓝牙灯升级包，确定要升级吗？" LeftBtn:nil RightBtn:@"确定"];
        [[D5ToastViewController shareView] showView];
        
        __weak typeof(self) weakSelf = self;
        
        [[D5ToastViewController shareView] setRightBtnClickBlock:^{
            [weakSelf pushToBtUpdateVC];
        }];
    } else {
        [MBProgressHUD showMessage:@"您的蓝牙灯版本是最新的" toView:self.view];
    }
}

- (void)pushToBtUpdateVC {
    @autoreleasepool {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.btIsPush = YES;
        
        D5BtLightUpdateViewController *btVC = [[UIStoryboard storyboardWithName:MAIN_STORYBOARD_ID bundle:nil] instantiateViewControllerWithIdentifier:BTLIGHT_UPDATE_VC_ID];
        if (btVC) {
            btVC.from = BtUpdatePushFromSetting;
            [self.navigationController pushViewController:btVC animated:NO];
        }
    }
}
@end
