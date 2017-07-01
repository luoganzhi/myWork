//
//  D5ConnectZKTViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ConnectZKTViewController.h"
#import "D5PrepareConnectViewController.h"
#import "D5ConnectedViewController.h"
#import "D5WebViewController.h"
#import "D5LedZKTList.h"
#import "D5HLedReachability.h"
#import "D5LightGroupManagerViewController.h"

#define PREPARE_CONNECT_TITLE @"第一步：准备连接"
#define CONNECT_TITLE @"第二步：连接中控"
#define NEXT_STR @"下一步"
//#define CONNECT_STR @"连接"
#define DONE_STR @"完成"

#define RESCAN_STR  @"重新搜索"

#define BTN_DISABLED_COLOR [UIColor colorWithWhite:0.086 alpha:1.000]

@interface D5ConnectZKTViewController() <D5ConnectedViewControllerDelegate, D5LedZKTListDelegate>

/** 准备链接VC */
@property (nonatomic, strong) D5PrepareConnectViewController *prepareVC;

/** 链接中控vc */
@property (nonatomic, strong) D5ConnectedViewController *connectedVC;

/** 当前VC */
@property (nonatomic, assign) UIViewController *currentVC;

/** 搜索状态 */
@property (nonatomic, assign) ZKTAddStatus addStatus;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isFinish;

@property (nonatomic, copy) NSString *wifiName;

/** 下一步/连接按钮 */
@property (weak, nonatomic) IBOutlet UIButton *btnBottom;
- (IBAction)btnBottomClicked:(UIButton *)sender;

@end

@implementation D5ConnectZKTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addNotification]; //添加通知
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [D5LedZKTList defaultList].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 注册通知 -- 蓝牙和WIFI状态改变
- (void)addNotification {
    // 网络变化时，改变view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged) name:NETWORK_STATUS_CHANGED object:nil];
    
    // APP ACTIVE的时候，搜索界面继续转圈
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(active) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/**
 搜索界面如果没有完成搜索，继续转圈
 */
- (void)active {
    __weak D5ConnectZKTViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.currentVC == weakSelf.prepareVC) {
            [weakSelf.prepareVC setWIFIView];
        } else if (weakSelf.currentVC == weakSelf.connectedVC) {
            if (!weakSelf.isFinish) {
                [weakSelf startRotateForImg:weakSelf.connectedVC.loadingImgView];
            }
        }
    });
}

/**
 * WiFi连接状态改变
 */
- (void)networkChanged {
    @autoreleasepool {
        __weak D5ConnectZKTViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL isConnectWifi = [weakSelf.prepareVC isConnectWIFI];
            if (weakSelf.prepareVC && (weakSelf.currentVC == weakSelf.prepareVC)) {
                [weakSelf.prepareVC setWIFIView];
                
                [weakSelf setBtnEnable:weakSelf.btnBottom enable:isConnectWifi];
                
                //                BOOL isOpenBlue = _prepareVC.isOpenBlueTooth;
                
                // 只有WiFi和蓝牙都开了才能enable
                //                [self setBtnEnable:_btnBottom enable:(isOpenWifi && isOpenBlue)];
            } else if (weakSelf.connectedVC && (weakSelf.currentVC == weakSelf.connectedVC) && !isConnectWifi) {
                [weakSelf scrollPrepareVC];
            }
        });
    }
}

#pragma mark - 初始化view
- (void)initView {
    @autoreleasepool {
        // 标题
        self.title = PREPARE_CONNECT_TITLE;
        
        // 不能右滑
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        [self initScrollView];
        [self initBottomBtn];
    }
}

/**
 * 初始化下一步/连接按钮
 */
- (void)initBottomBtn {
    [D5Round showCornerWithView:_btnBottom withColor:BTN_DISABLED_COLOR withRadius:CGRectGetHeight(_btnBottom.frame) / 2 withBoarderWith:1]; // 加边框、圆角
    
    [self setBtnEnable:_btnBottom enable:[D5HLedReachability isWifiCanUse]];
}

/**
 * 初始化scrollview
 */
- (void)initScrollView {
    @autoreleasepool {
        [self.view layoutIfNeeded];
        
        // 设置scrollview的contentSize
        CGSize scrollSize = _scrollView.frame.size;
        _scrollView.contentSize = CGSizeMake(scrollSize.width * 2, 1);
        
        // 初始化vc在scrollview的位置
        [self initPrepareVC:scrollSize];
        [self initConnectVC:scrollSize];
    }
}

/**
 * 初始化scrollview的子vc
 */
- (void)initPrepareVC:(CGSize)size {
    @autoreleasepool {
        self.title = PREPARE_CONNECT_TITLE;
        if (!_prepareVC) {
            _prepareVC = [self.storyboard instantiateViewControllerWithIdentifier:PREPARE_CONNECT_VC_ID];
        }
        
        _currentVC = _prepareVC;
        _prepareVC.view.backgroundColor = [UIColor clearColor];
        [_prepareVC.view setFrame:CGRectMake(0, 0, size.width, size.height)];
        [_scrollView addSubview:_prepareVC.view];
    }
}

- (void)initConnectVC:(CGSize)size {
    if (!_connectedVC) {
        _connectedVC = [self.storyboard instantiateViewControllerWithIdentifier:CONNECTED_VC_ID];
    }
    
    _connectedVC.delegate = self;
    _connectedVC.height = size.height - 64;
    _prepareVC.view.backgroundColor = [UIColor clearColor];
    
    [_connectedVC.view setFrame:CGRectMake(size.width, 0, size.width, size.height)];
    [_scrollView addSubview:_connectedVC.view];
}

#pragma mark - 设置view的显示状态
- (void)showViewForStatus:(ZKTAddStatus)status {
    _addStatus = status;
    switch (status) {
        case ZKTAddStatusSuccess: // 成功
            [self setBtnTitle:DONE_STR forBtn:_btnBottom];
            if (_connectedVC) {
                [_connectedVC searchBoxSuccess];
                //                    _connectedVC.canEditPwdTF = YES;
                
                // 有选中的中控 才能点击连接按钮
                [self setBtnEnable:_btnBottom enable:[NSString isValidateString:_connectedVC.selectedIdentify]];
            }
            break;
            
        case ZKTAddStatusFailed: // 失败
            [self setBtnTitle:RESCAN_STR forBtn:_btnBottom];
            [self setBtnEnable:_btnBottom enable:YES];
            if (_connectedVC) {
                //                    _connectedVC.canEditPwdTF = YES;
                [_connectedVC searchBoxFailed];
            }
            break;
            
        case ZKTAddStatusSearched: // 搜索到中控，但还在搜索
            [self setBtnTitle:DONE_STR forBtn:_btnBottom];
            [self setBtnEnable:_btnBottom enable:[NSString isValidateString:_connectedVC.selectedIdentify]];
            if (_connectedVC) {
                //                    _connectedVC.canEditPwdTF = NO;
                [_connectedVC searchBoxSearched];
            }
            break;
            
        default: // ZKTAddStatusIng
            [self setBtnTitle:DONE_STR forBtn:_btnBottom];
            [self setBtnEnable:_btnBottom enable:NO];
            if (_connectedVC) {
                [_connectedVC searchBoxIng];
                //                    _connectedVC.canEditPwdTF = NO;
            }
            break;
    }
}

#pragma mark - 连接中控VC的代理方法

/**
 还没开始搜索时，根据WIFI密码是否输入完成来设置连接按钮的enable属性
 
 @param isFinished 密码是否输入完成
 */
- (void)enterPwdFinish:(BOOL)isFinished {
    @autoreleasepool {
        if (_addStatus == 0) { //只有在未连接前才设置下面按钮的属性
            [self setBtnEnable:_btnBottom enable:isFinished];
        }
    }
}

/**
 从搜索出来的列表中选择了一个中控
 
 @param selectedIdentify 选中的中控IDENTIFY
 */
- (void)selectedBoxChanged:(NSString *)selectedIdentify {
    @autoreleasepool {
        if (_addStatus == ZKTAddStatusSearched || _addStatus == ZKTAddStatusSuccess) { //搜索出来中控，根据是否选中中控来设置btn的enable属性
            [self setBtnEnable:_btnBottom enable:[NSString isValidateString:selectedIdentify]];
        }
    }
}

- (void)addGuideTipWithFrame:(CGRect)labelFrame {
    @autoreleasepool {
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTipAndGesture:)];
        //        [self.view addGestureRecognizer:tap];
        //        CGRect frame = [_connectedVC.tableView convertRect:labelFrame toView:self.view];
        CGFloat x = CGRectGetMinX(labelFrame) + CGRectGetMinX(_connectedVC.tableView.frame);
        CGFloat y = CGRectGetMaxY(labelFrame) + CGRectGetMinY(_connectedVC.tableView.frame) + 64;
        
        // 添加悬浮提示
        [self addGuideViewWithPoint:CGPointMake(x, y) tipStr:@"中控名称与中控盒子\n背面的名称一致" direction:GuideBgDirectionLeft];
    }
}

/**
 跳转到连接帮助
 */
- (void)helpClick {
    @autoreleasepool {
        D5WebViewController *webVC = [[UIStoryboard storyboardWithName:@"Web" bundle:nil] instantiateViewControllerWithIdentifier:WEB_VC_ID];
        if (webVC) {
            webVC.titleStr = @"连接帮助";
            webVC.htmlFileName = ZKT_HELP_HTML_NAME;
            webVC.url = ADD_BOX_HELP_URL;
            
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

#pragma mark - 切换界面

/**
 滑动到scroll的指定的子VC,改变当前VC的view显示
 
 @param vc 指定的子VC
 */
- (void)scrollToVC:(UIViewController *)vc {
    @autoreleasepool {
        _currentVC = vc;
        self.title = (_currentVC == _prepareVC) ? PREPARE_CONNECT_TITLE : CONNECT_TITLE; // 改变navigation标题
        
        if (_currentVC == _prepareVC) {
            self.navigationItem.leftBarButtonItem = nil; // 准备连接界面没有返回键
            [self resignGuideTip];
            [self connectVCDidDisAppearance];
        } else {
            [self connectVCWillAppearance];
            [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(scrollPrepareVC)];
        }
        [self setBtnTitle: (_currentVC == _prepareVC) ? NEXT_STR : DONE_STR forBtn:_btnBottom]; //设置btnBottom的标题
        
        [_scrollView scrollRectToVisible:_currentVC.view.frame animated:YES];
    }
}

/**
 准备连接 --> 连接中控界面，初始化连接中控VC中的View和数据
 */
- (void)connectVCWillAppearance {
    @autoreleasepool {
        _addStatus = ZKTAddStatusIng;
        
        _wifiName = [D5NetWork getCurrentWifiName];
        DLog(@"wifi初始化 %@", _wifiName);
        if (_connectedVC) {
            //            BOOL isEnable = NO;
            //
            //            NSString *str = _connectedVC.wifiPwdTF.text;
            //            if ([NSString isValidateString:str] && str.length >= 8) {
            //                isEnable = YES;
            //            }
            
            [self setBtnEnable:_btnBottom enable:NO]; // 完成
            
            //            _connectedVC.canEditPwdTF = YES;
            
            [_connectedVC initBottomView];                 // 初始化搜索view
            [_connectedVC initConnectScrollView];
        }
    }
}

/**
 连接中控 --> 准备连接界面，清空数据
 */
- (void)connectVCDidDisAppearance {
    @autoreleasepool {
        if (_connectedVC) {
            [_connectedVC.zktBoxArr removeAllObjects]; // 清空搜到的中控
            [_connectedVC.tableView reloadData];
            
            _connectedVC.selectedIdentify = nil;       // 清空选择的中控
            //            [_connectedVC.wifiPwdTF resignFirstResponder];
            //
            //            [_connectedVC changeConstraint];
        }
        
        [D5LedZKTList defaultList].delegate = nil;
        [self networkChanged];
    }
}

/**
 跳转到准备连接界面
 */
- (void)scrollPrepareVC {
    [self scrollToVC:_prepareVC];
}

#pragma mark - 开始搜索中控
/**
 开始搜索中控
 */
- (void)startSearchBox {
    @autoreleasepool {
        [self showViewForStatus:ZKTAddStatusIng]; // 设置view的显示状态
        
        if (_connectedVC) {
            // 发送广播搜中控
            [[NSUserDefaults standardUserDefaults] setDouble:[D5Date currentTimeStamp] forKey:UM_ADD_DEVICE];
            
            [D5LedZKTList defaultList].delegate = self;
            [[D5LedZKTList defaultList] getZKTListFromServer];
        }
    }
}

#pragma mark - 搜索结果
- (void)ledZKTList:(D5LedZKTList *)zktList countDownInterval:(NSTimeInterval)interval {
    if (_connectedVC) {
        __weak D5ConnectZKTViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *currentWifiName = [D5NetWork getCurrentWifiName];
            if (![currentWifiName isEqualToString:_wifiName]) {
                DLog(@"wifi改变 %@", currentWifiName);
                [weakSelf.connectedVC.zktBoxArr removeAllObjects];
                [weakSelf.connectedVC searchBoxIng];
                [weakSelf resignGuideTip];
                
                [weakSelf setBtnEnable:weakSelf.btnBottom enable:NO];
                [weakSelf.connectedVC.tableView reloadData];
                
                weakSelf.wifiName = currentWifiName;
            }
            
            if (!weakSelf.connectedVC.countDownView.isHidden) {
                weakSelf.connectedVC.countDownView.progress = interval;
            }
        });
    }
}

/**
 搜索到中控了
 
 @param zktList
 @param dict (包括：name,type,id,ip,mac)
 */
- (void)ledZKTList:(D5LedZKTList *)zktList searchedZKT:(NSDictionary *)dict {
    @autoreleasepool {
        if (!dict) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_connectedVC) {
                return;
            }
            
            // 判断该中控是否已存在并显示
            NSString *boxID = dict[ZKT_BOX_ID];
            __block BOOL isExist = NO;
            if (_connectedVC.zktBoxArr.count > 0) {
                [_connectedVC.zktBoxArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    @autoreleasepool {
                        NSString *existBoxID = obj[ZKT_BOX_ID]; // 已存在的中控的id
                        // 该中控已存在
                        if ([NSString isValidateString:boxID] && [boxID isEqualToString:existBoxID]) {
                            isExist = YES;
                            if (![dict isEqualToDictionary:obj]) {  // 有变动
                                [_connectedVC.zktBoxArr replaceObjectAtIndex:idx withObject:dict]; // 替换已存在的
                            }
                            *stop = YES;
                        }
                    }
                }];
            }
            
            // 不存在
            if (!isExist) {
                [_connectedVC.zktBoxArr addObject:dict];
                
                [_connectedVC.tableView reloadData]; //界面显示
                [self showViewForStatus:ZKTAddStatusSearched];
            }
        });
    }
}

/**
 搜索是否完成（搜索30s后才算完成)
 
 @param zktList
 @param flag 是否完成
 */
- (void)ledZKTList:(D5LedZKTList *)zktList getFinished:(BOOL)flag {
    dispatch_async(dispatch_get_main_queue(), ^{
        _isFinish = YES;
        if (flag) { // 显示搜索结果
            [self showViewForStatus:(_connectedVC.zktBoxArr.count == 0) ? ZKTAddStatusFailed : ZKTAddStatusSuccess];
        } else {
            [self showViewForStatus:ZKTAddStatusFailed];
        }
    });
    
}

- (NSDictionary *)zktDictById:(NSString *)boxId {
    @autoreleasepool {
        if (!_connectedVC.zktBoxArr || _connectedVC.zktBoxArr.count <= 0) {
            return nil;
        }
        
        for (NSMutableDictionary *dict in _connectedVC.zktBoxArr) {
            @autoreleasepool {
                if ([dict[ZKT_BOX_ID] isEqualToString:boxId]) {
                    return dict;
                }
            }
        }
        
        return nil;
    }
}

#pragma mark - 点击事件
- (IBAction)btnBottomClicked:(UIButton *)sender {
    @autoreleasepool {
        if (_currentVC == _prepareVC) {  //下一步
            [self scrollToVC:_connectedVC];
            
            _isFinish = NO;
            [self startSearchBox];
        } else {  // 连接界面 -- 分为连接和完成
            if ([RESCAN_STR isEqualToString:sender.currentTitle]) { // 连接
                _isFinish = NO;
                [self startSearchBox];
            } else { // 完成
                [self stopRotateForImg:_connectedVC.loadingImgView];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSString *selectedIdentify = _connectedVC.selectedIdentify;
                    NSDictionary *dict = [self zktDictById:selectedIdentify];
                    
                    //保存到本地
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:dict forKey:SELECTED_ZKT_KEY];
                    [userDefaults synchronize];
                    
                    [D5CurrentBox currentBox];
                    
                    [D5LedZKTList defaultList].loginStatus = LedLoginStatusNotLogin;
                    
                    NSString *ip = dict[ZKT_BOX_IP];
                    int port = [dict[ZKT_BOX_TCP_PORT] intValue];
                    DLog(@"完成连接中控 去练TCP %@, %d", ip, port);
                    [[D5LedCommunication sharedLedModule] tcpConnect:ip port:port];
                });
                
                [MBProgressHUD showMessage:@"已成功连接到中控"];
                
                NSTimeInterval startTime = [[NSUserDefaults standardUserDefaults] doubleForKey:UM_ADD_DEVICE];
                if (startTime > 0) {
                    NSTimeInterval timeValue = [D5Date currentTimeStamp] - startTime;
                    
                    double limitTime = 150;
                    if (timeValue > limitTime) {
                        timeValue = limitTime;
                    }
                    
                    [MobClick event:UM_ADD_DEVICE durations:(int)timeValue];
                }
                
                dispatch_after(1, dispatch_get_main_queue(), ^{ // 停留1s进入
                    [self pushToLightGroupManagerVC]; // 跳转到灯组编号
                });
            }
        }
    }
}

#pragma mark - 跳转事件
- (void)pushToLightGroupManagerVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:LIGHTGROUP_STORYBOARD_ID bundle:nil];
        D5LightGroupManagerViewController *managerVC = [sb instantiateViewControllerWithIdentifier:LIGHT_GROUP_MANAGER_VC_ID];
        if (managerVC) {
            managerVC.from = PushFromZKT;
            [self.navigationController pushViewController:managerVC animated:YES];
        }
    }
}

@end
