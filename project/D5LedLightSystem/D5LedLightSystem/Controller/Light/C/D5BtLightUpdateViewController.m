//
//  D5BtLightUpdateViewController.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/12/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BtLightUpdateViewController.h"
#import "D5BtLightViewCell.h"
#import "D5InfoViewController.h"
#import "D5CheckUpdate.h"
#import "D5MainViewController.h"
#import "AppDelegate.h"

#define CELL_HEIGHT 124

#define DOWNLOAD_ING_STR            @"正在下载升级包…"
#define INIT_TIP_STR                @"升级过程中请不要关闭此页面"
#define FAILED_TIP_STR(failedStr)   [NSString stringWithFormat:@"%@号灯升级失败，请重新升级", failedStr]

#define ALL_SUCCESS_TIP_STR         @"升级完成"
#define ALL_FAILED_TIP_STR          @"升级失败，请重新升级"

@interface D5BtLightUpdateViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, D5LedCmdDelegate, D5LedNetWorkErrorDelegate>

/** 提示label */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *lightCollectionView;

/** 升级的灯列表 */
@property (nonatomic, strong) NSMutableArray *lightsArr;

/** 升级失败灯列表 */
@property (nonatomic, strong) NSMutableArray *failedArr;

/** 是否已经返回过进度 */
@property (nonatomic, assign) BOOL hasReturn;

/** 灯编号--升级状态 的dict */
@property (nonatomic, strong) NSMutableDictionary *updateStatusDict;

/** 完成/重新升级按钮 */
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;
- (IBAction)btnBottomClicked:(UIButton *)sender;

@end

@implementation D5BtLightUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateBt];
    
    [self initNavigation];
    [self initView];
}

/**
 初始化标题、隐藏返回键
 */
- (void)initNavigation {
    self.navigationItem.hidesBackButton = YES;
    self.title = @"蓝牙灯升级";
}

/**
 初始化view
 */
- (void)initView {
    [self setLeftBarItem:NO];
    
    // 完成--不可点击，直到全部升级完成
    [self setBtnTitle:DONE_STR forBtn:_btnBottom];
    [self setBtnEnable:_btnBottom enable:NO];
    
    _tipLabel.text = DOWNLOAD_ING_STR;
    
    [MBProgressHUD showLoading:@"" toView:self.view];
}

- (NSMutableArray *)lightsArr {
    if (!_lightsArr) {
        _lightsArr = [NSMutableArray array];
    }
    return _lightsArr;
}

/**
 升级蓝牙灯
 */
- (void)updateBt {
    @autoreleasepool {
        if (_from == BtUpdatePushFromSetting) {
            [self sendUpdateBT:LedBoxUpdateTypeBlueTooth];
        }
        
        D5LedSpecialCmd *progressCmd = [[D5LedSpecialCmd alloc] init];
        
        progressCmd.receiveDelegate = self;
        progressCmd.errorDelegate = self;
        
        [progressCmd headerForCmd:Cmd_IO_Operate withSubCmd:SubCmd_File_Bt_Update_Progress];
        [progressCmd startCmd];
    }
}

- (void)sendUpdateBT:(LedBoxUpdateType)updateType {
    @autoreleasepool {
        D5UpdateModel *btUpdate = [D5CheckUpdate sharedInstance].bluetoothUpdate;
        if (btUpdate) {
            D5LedNormalCmd *updateAPP = [[D5LedNormalCmd alloc] init];
            
            updateAPP.strDestMac = [D5CurrentBox currentBoxMac];
            updateAPP.remoteLocalTag = tag_remote;
            updateAPP.remotePort = [D5CurrentBox currentBoxTCPPort];
            updateAPP.remoteIp = [D5CurrentBox currentBoxIP];
            updateAPP.errorDelegate = self;
            updateAPP.receiveDelegate = self;
            
            NSDictionary *sendDict = @{LED_STR_IUPDATETYPE : @(updateType),
                                       LED_STR_URL : btUpdate.updateUrl ? : @"",
                                       LED_STR_VERCODE :@(btUpdate.freshVerCode),
                                       LED_STR_VERTEXT : btUpdate.freshverText ? : @""};
            
            [updateAPP ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Update withData:sendDict];
        }
    }
}

- (NSMutableDictionary *)updateStatusDict {
    if (!_updateStatusDict) {
        _updateStatusDict = [NSMutableDictionary dictionary];
    }
    return _updateStatusDict;
}

/**
 根据dict中的所有values(升级状态）判断升级结果
 
 @param dict
 */
- (void)judgeUpdateFinish:(NSDictionary *)dict {
    @autoreleasepool {
        NSArray *allValues = [dict allValues];
        DLog(@"allvale = %@", allValues);
        if (allValues && allValues.count > 0) {
            // 有未升级的
            BOOL hasNotUpdate = [allValues containsObject:@(BtUpdateStatusNotUpdate)];
            
            // 有正在升级的
            BOOL hasUpdatIng = [allValues containsObject:@(BtUpdateStatusUpdating)];
            DLog(@"hasNotUpdate = %d, hasUpdatIng = %d", hasNotUpdate, hasUpdatIng);
            
            if (!hasNotUpdate && !hasUpdatIng) {    // 全部有升级结果了
                // 有升级失败的
                BOOL hasFailed = [allValues containsObject:@(BtUpdateStatusUpdateError)];
                
                // 没有升级成功的--全部失败
                BOOL allFailed = ![allValues containsObject:@(BtUpdateStatusCompleted)] && ![allValues containsObject:@(BtUpdateStatusLightOffline)];
                
                // 全部离线
                BOOL allOffline = ![allValues containsObject:@(BtUpdateStatusCompleted)] && ![allValues containsObject:@(BtUpdateStatusUpdateError)];
                [self setBtnByResult:hasFailed allFailed:allFailed allOffline:allOffline];    // 是否有升级失败的
            }
        }
    }
}

/**
 添加/移除返回按钮
 */
- (void)setLeftBarItem:(BOOL)isAdd {
    @autoreleasepool {
        if (self.navigationItem.leftBarButtonItem) {    // 有返回按钮
            if (!isAdd) {
                self.navigationItem.leftBarButtonItem = nil;
            }
        } else {
            if (isAdd) {
                [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(back)];
            }
        }
    }
}

- (void)back {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.btIsPush = NO;
    [super back];
}

/**
 根据升级结果来设置提示信息，以及按钮的标题

 @param hasFailed 是否有升级失败的
 @param allFailed 是否全部升级失败
 */
- (void)setBtnByResult:(BOOL)hasFailed allFailed:(BOOL)allFailed allOffline:(BOOL)allOffline {
    @autoreleasepool {
        [self setBtnTitle:hasFailed ? REUPDATE_STR : DONE_STR forBtn:_btnBottom];
        [self setBtnEnable:_btnBottom enable:YES];
        
        if (!hasFailed) {
            _tipLabel.text = ALL_SUCCESS_TIP_STR;
            
            // 待修改  灯恢复在线时，ledalloffline没有改变
            if (allOffline) {
                [D5LedList sharedInstance].allOffline = YES;
            } else {
                // 没有失败的
                D5UpdateModel *model = [D5CheckUpdate sharedInstance].bluetoothUpdate;
                if (model) {
                    model.isNeedUpdate = NO;
                }
            }
        } else {
            if (allFailed) {
                _tipLabel.text = ALL_FAILED_TIP_STR;
            } else {
                [self changeTipByArr:self.failedArr];
            }
            [self setLeftBarItem:YES];
        }
    }
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    @autoreleasepool {
        if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Update) {
            if (errorType == -1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view];
                    [self setBtnByResult:YES allFailed:YES allOffline:NO];
                });
            }
        }

    }
}

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    @autoreleasepool {
        if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Update) {
            DLog(@"更新蓝牙灯返回 %@", dict);
        }
        
        if (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Bt_Update_Progress) {
            DLog(@"更新蓝牙灯进度返回 %@", dict);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
                [self setBtnTitle:DONE_STR forBtn:_btnBottom];
                [self setBtnEnable:_btnBottom enable:NO];
                [self setLeftBarItem:NO];
                if (!dict) {
                    return;
                }
                
                NSDictionary *data = dict[LED_STR_DATA];
                if (!data) {
                    return;
                }
                
                [self.lightsArr removeAllObjects];
                [self.failedArr removeAllObjects];
                [self.updateStatusDict removeAllObjects];
                
                _tipLabel.text = INIT_TIP_STR;
                NSArray *updatIngLights = data[LED_STR_DATA];
                if (updatIngLights && updatIngLights.count > 0) {
                    for (NSDictionary *dict in updatIngLights) {
                        @autoreleasepool {
                            D5BTUpdateLightData *lightData = [D5BTUpdateLightData mj_objectWithKeyValues:dict];
                            self.updateStatusDict[@(lightData.lightID)] = @(lightData.updateStatus);
                            
                            if (lightData.updateStatus == BtUpdateStatusUpdateError) {
                                if (![self.failedArr containsObject:@(lightData.lightID)]) {
                                    [self.failedArr addObject:@(lightData.lightID)];
                                }
                            }
                            
                            [self.lightsArr addObject:lightData];
                        }
                    }
                    
                    [self judgeUpdateFinish:self.updateStatusDict];
                }
                
                self.lightsArr = [NSMutableArray arraySortedByLightIDFromUpdate:self.lightsArr ascending:YES];         // 排序
                [self.lightCollectionView reloadData];
            });
        }
    }
}

- (NSMutableArray *)failedArr {
    if (!_failedArr) {
        _failedArr = [NSMutableArray array];
    }
    return _failedArr;
}

/**
 根据升级失败灯的编号来进行提示

 @param arr 升级失败的灯编号
 */
- (void)changeTipByArr:(NSArray *)arr {
    @autoreleasepool {
        if (!arr || arr.count == 0) {
            return;
        }
        
        NSString *tipStr = INIT_TIP_STR;
        NSString *numberStr = @"";
        for (int i = 0; i < arr.count; i ++) {
            @autoreleasepool {
                if (i > 0) {
                    numberStr = [numberStr stringByAppendingString:@"、"];
                }
                NSNumber *number = [arr objectAtIndex:i];
                numberStr = [numberStr stringByAppendingFormat:@"%d", [number intValue]];
            }
        }
        
        tipStr = FAILED_TIP_STR(numberStr);
        _tipLabel.text = tipStr;
    }
}

#pragma mark - collection代理和数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lightsArr ? self.lightsArr.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5BtLightViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BTLIGHT_CELL_ID forIndexPath:indexPath];
        if(self.lightsArr.count > 0) {
            NSInteger row = indexPath.row;
            if (row < self.lightsArr.count) {
                [cell setData:self.lightsArr[row]];
            
            }
        }
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat width = screenWidth / 3;
        return CGSizeMake(width, CELL_HEIGHT);
    }
}

/**
 点击事件--重新升级/完成

 @param sender 按钮
 */
- (IBAction)btnBottomClicked:(UIButton *)sender {
    @autoreleasepool {
        if ([DONE_STR isEqualToString:sender.currentTitle]) {   // 完成
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [self.navigationController popViewControllerAnimated:YES];
            delegate.btIsPush = NO;
//            [self pushToVC];
        } else {                    // 重新升级
            [self sendUpdateBT:LedBoxUpdateTypeRetry];
            [self initView];
        }
    }
}

//#pragma mark - 跳转界面
- (void)pushToVC {
    @autoreleasepool {
        Class class = [D5MainViewController class];
        switch (_from) {
            case BtUpdatePushFromSetting:
                class = [D5InfoViewController class];
                break;
                
            default:
                break;
        }
        
        UIViewController *visibleVC = [self.navigationController visibleViewController];
        if ([visibleVC isKindOfClass:class]) {
            return;
        }
        
        NSArray *childVCs = self.navigationController.childViewControllers;
        if (childVCs && childVCs.count > 0) {
            
            __weak D5BtLightUpdateViewController *weakSelf = self;
            [childVCs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @autoreleasepool {
                    UIViewController *vc = (UIViewController *)obj;
                    if ([vc isKindOfClass:class]) {
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        *stop = YES;
                    }
                }
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MUSIC_LIST object:nil];
    });
}
@end
