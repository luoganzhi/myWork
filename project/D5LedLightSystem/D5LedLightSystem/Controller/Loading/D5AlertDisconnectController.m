//
//  D5AlertDisconnectController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/10/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5AlertDisconnectController.h"
#import "D5ConnectZKTViewController.h"
#import "D5LoadingViewController.h"
#import "D5TcpManager.h"
#import "D5HLedReachability.h"

#define LOADING_VC_ID @"LOADING_VC"

#define ReConnetTimeVal 10 //重连时间

@interface D5AlertDisconnectController () <D5TcpDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *buttomView;

@property (nonatomic, strong) NSTimer *reConnectTimer;

@property(nonatomic,assign)BOOL isConnecting;//正在重连

@end

@implementation D5AlertDisconnectController


-(void)removeView {
    [self.view removeFromSuperview];
}

#pragma mark --重新连接
- (IBAction)reConnect:(UIButton *)sender {
    if(![D5HLedReachability isWifiCanUse]) {
        [iToast showCentreTitile:@"请连接Wi-Fi"];
        return;
    }
    
    _isConnecting = NO;
    [_regainConnet setEnabled:NO];//关闭重连按钮相应
    [_regainConnet setHidden:YES];
    [_connectStatus setText:@"重连中..."];
    //开始去链接中控
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnectSuccess:) name:TCP_CONNECT_SUCCESS object:nil];
    _reConnectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reConnectFailed:) userInfo:nil repeats:NO];
    
    dispatch_queue_t quenue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(quenue, ^{
        [[D5LedCommunication sharedLedModule] tcpConnect:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
    });
}

- (void)reConnectSuccess:(NSNotification *)notification {
    @autoreleasepool {
        if (_isConnecting) {
            return;
        }
        
        D5Tcp *tcp = (D5Tcp *)notification.object;
        if ([self isCurrentTcp:tcp]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeView];
                [self setTimerNil];
            });
            [self removeNotification];
        }
    }
}

- (D5Tcp *)currentTcp {
    @autoreleasepool {
        D5Tcp *currentTcp = [[D5TcpManager defaultTcpManager] tcpOfServer:[D5CurrentBox currentBoxIP] port:[D5CurrentBox currentBoxTCPPort]];
        return currentTcp;
    }
}

- (BOOL)isCurrentTcp:(D5Tcp *)tcp {
    @autoreleasepool {
        if (!tcp) {
            return NO;
        }
        D5Tcp *currentTcp = [self currentTcp];
        if ([tcp isEqual:currentTcp]) {
            return YES;
        }
        
        return NO;
    }
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reConnectFailed:(NSTimer *)timer {
    @autoreleasepool {
        [_regainConnet setEnabled:YES];
        
        [self removeView];
        [self pushToConnectVC];
        
        [self setTimerNil];
    }
}

- (void)setTimerNil {
    if (_reConnectTimer) {
        [_reConnectTimer invalidate];
        _reConnectTimer = nil;
    }
}

-(NSArray*)getControllers {
    return [UIApplication sharedApplication].keyWindow.rootViewController.navigationController.viewControllers;
}

- (void)pushToConnectVC {
    @autoreleasepool {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:ZKTSOFTWARE_STORYBOARD_ID bundle:nil];
        D5LoadingViewController *connectZKTVC = [sb instantiateViewControllerWithIdentifier:CONNECT_ZKT_VC_ID];
        MyNavigationController*nav = [[MyNavigationController alloc]initWithRootViewController:connectZKTVC];
        [self.view removeFromSuperview];
        if (connectZKTVC) {
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      [self initView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeView];
}

-(void)initView
{
    //重新连接下划线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"重新连接"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_regainConnet setAttributedTitle:str forState:UIControlStateNormal];
    [_regainConnet.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [_regainConnet setEnabled:NO];//禁用连接
    _isConnecting = YES;//设置用户点击手动重连
    [_regainConnet setEnabled:YES];//关闭重连按钮相应
    [_regainConnet setHidden:NO];
    [_connectStatus setText:@"中控已断开连接"];
    //启动定时器
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
