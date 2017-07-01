//
//  D5DisconnectTipView.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5DisconnectTipView.h"
#import "D5ConnectZKTViewController.h"
#import "D5TcpManager.h"
#import "D5RuntimeShareInstance.h"
#import "D5MusicListInstance.h"

static D5DisconnectTipView *instance = nil;

@interface D5DisconnectTipView()

/** 连接断开 */
@property (weak, nonatomic) IBOutlet UILabel *connectTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnReConnect;
- (IBAction)btnReConnectClicked:(UIButton *)sender;

/** 重连定时器 */
@property (nonatomic, strong) NSTimer *reConnectTimer;

/** 是否显示了断开连接的界面 */
@property (nonatomic, assign) BOOL isShowDisConnect;

@end

@implementation D5DisconnectTipView

#pragma mark - 实例化
+ (instancetype)sharedDisconnectTipView {
    @autoreleasepool {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            instance.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
        });
        return instance;
    }
}

- (void)layoutSubviews {
    [self addLineToBtn:_btnReConnect];
}

#pragma mark - 重连
/**
 根据重连状态显示view
 
 @param status 重连状态
 */
- (void)showConnectViewByStatus:(ConnectStatus)status {
    _status = status;
    
    _btnReConnect.hidden = (status == ConnectStatusReConnectIng);
    _connectTipLabel.text = (status == ConnectStatusReConnectIng) ? @"重连中…" : @"中控已断开连接";
}

- (void)showView {
    _isShow = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"need_end_refresh" object:nil];
    
    [super showView];
    [self showConnectViewByStatus:ConnectStatusNotReConnect];
}

- (IBAction)btnReConnectClicked:(UIButton *)sender {
    [self reConnectTCP];
}

- (void)reConnectTCP {
    @autoreleasepool {
        [self showConnectViewByStatus:ConnectStatusReConnectIng];
        
        [self addConnecResultNotification];
        
        // 连接超时定时器
        _reConnectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reConnectTimeOut) userInfo:nil repeats:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 连接TCP
            [[D5LedCommunication sharedLedModule] tcpConnect:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
        });
    }
}

/**
 重连成功
 
 @param notification 成功的通知
 */
- (void)reConnectSuccess:(NSNotification *)notification {
    D5Tcp *tcp = notification.object;
    DLog(@"reConnectSuccess   %@",tcp);
    if ([D5TcpManager isCurrentBoxTcp:tcp]) {
        _status = ConnectStatusReConnectSuccess;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reConnectResultHandle];
        });
    }
}

/**
 重连失败
 
 @param notification 失败的通知
 */
- (void)reConnectFailed:(NSNotification *)notification { // 不能检测object -- 自定义超时时传的参数为空
    DLog(@"reConnectFailed");
    _status = ConnectStatusReConnectFailed;
    [[D5TcpManager defaultTcpManager] deleteTcp:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reConnectResultHandle];
        [D5CurrentBox setInstanceNil];
        [[D5RuntimeShareInstance sharedInstance] clear];
        [[D5MusicListInstance sharedInstance] clear];
        [D5LedCommunication sharedLedModule].cmds = nil;
        
        [D5LedList sharedInstance].addedLedList = nil;
        
        [self pushToConnectVC];
    });
}

- (void)reConnectResultHandle {
    _isShow = NO;
    [self hideTipView];
    
    [self stopConnectTimer];
    
    [self removeNotification];
}

- (void)dealloc {
    [self removeNotification];
}

/**
 重连超时
 */
- (void)reConnectTimeOut {
    [self reConnectFailed:nil];
}

/**
 关闭定时器
 */
- (void)stopConnectTimer {
    if (_reConnectTimer) {
        [_reConnectTimer invalidate];
        _reConnectTimer = nil;
    }
}

/**
 添加重连结果的通知
 */
- (void)addConnecResultNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectSuccess:) name:TCP_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectFailed:) name:TCP_CONNECT_FAILED object:nil];
}

/**
 移除通知
 */
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 显示指定的view
- (void)pushToConnectVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:ZKTSOFTWARE_STORYBOARD_ID bundle:nil];
        D5ConnectZKTViewController *connectZKTVC = [sb instantiateViewControllerWithIdentifier:CONNECT_ZKT_VC_ID];
        MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:connectZKTVC];
        
        UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            if (connectZKTVC) {
                [((UINavigationController *)vc) presentViewController:nav animated:NO completion:nil];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            }
        }
    }
}


@end
