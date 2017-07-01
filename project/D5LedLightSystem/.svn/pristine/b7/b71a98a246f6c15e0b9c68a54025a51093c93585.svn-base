//
//  D5TipView.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5TipView.h"
#import "NSObject+runtime.h"
#import "D5ConnectZKTViewController.h"

#define UPLOAD_ING_TIP_STR(currentIndex, totalCount) [NSString stringWithFormat:@"歌曲上传中 (%d / %d)", currentIndex, totalCount]

typedef enum _show_status {
    ShowStatusIng = 1,      // 上传中
    ShowStatusFailed,       // 上传失败
    ShowStatusSuccess,      // 上传成功
    ShowStatusDisConnect    // 连接断开
}ShowStatus;

@interface D5TipView() {
    Class _oldClass;
}

@property (nonatomic, assign) ShowStatus showStatus;

/** 当前上传的歌曲索引 */
@property (nonatomic, assign) int currentUploadIndex;

/** 要上传的歌曲总数 */
@property (nonatomic, assign) int totalCount;

/** 重连定时器 */
@property (nonatomic, strong) NSTimer *reConnectTimer;

/** 是否显示了断开连接的界面 */
@property (nonatomic, assign) BOOL isShowDisConnect;

/** 上传中 */
@property (weak, nonatomic) IBOutlet UIView *uploadIngView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImgView;
@property (weak, nonatomic) IBOutlet UILabel *uploadMusicCountLable;
@property (weak, nonatomic) IBOutlet UILabel *uploadMusicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadMusicProgressLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelUpload;
- (IBAction)btnCancelUploadClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/** 上传失败 */
@property (weak, nonatomic) IBOutlet UIView *uploadFailedView;
@property (weak, nonatomic) IBOutlet UIButton *btnReUpload;
- (IBAction)btnReUploadClicked:(UIButton *)sender;

/** 上传成功 */
@property (weak, nonatomic) IBOutlet UIView *uploadSuccessView;

/** 连接断开 */
@property (weak, nonatomic) IBOutlet UIView *connectFailedView;
@property (weak, nonatomic) IBOutlet UILabel *connectTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnReConnect;
- (IBAction)btnReConnectClicked:(UIButton *)sender;

@end

static D5TipView *instance = nil;

@implementation D5TipView

#pragma mark - 检查和设置代理
- (void)setDelegate:(id<D5TipViewDelegate>)delegate {
    _delegate = delegate;
    _oldClass = [self objectGetClass:_delegate];
}

- (BOOL)checkDelegate {
    if (!_delegate) {
        return NO;
    }
    
    Class nowClass = [self objectGetClass:_delegate];
    return nowClass && (nowClass == _oldClass);
}

#pragma mark - 实例化
+ (instancetype)sharedTipView {
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

- (void)active {
    if (_showStatus == ShowStatusIng) {
        [self startRotateForImg:_loadingImgView];
    }
}

- (void)layoutSubviews {
    [self addLineToBtn:_btnReUpload];
    [self addLineToBtn:_btnCancelUpload];
    [self addLineToBtn:_btnReConnect];
}

- (void)addLineToBtn:(UIButton *)btn {
    @autoreleasepool {
        NSString *title = btn.currentTitle;
        [btn setAttributedTitle:[D5String attrStringWithString:title fontColor:btn.currentTitleColor] forState:UIControlStateNormal];
    }
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

- (void)showViewByStatus:(ShowStatus)status {
    @autoreleasepool {
        _isShowDisConnect = NO;
        _showStatus = status;
        
        if (status != ShowStatusIng) {
            [self stopRotateForImg:_loadingImgView];
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(active) name:UIApplicationDidBecomeActiveNotification object:nil];
        }
        
        if (status == ShowStatusDisConnect) {
            [self removeViewFromWindow];
            
            _connectTipLabel.text = @"";
            [self showConnectViewByStatus:ConnectStatusDisConnect];
        }
        _uploadIngView.hidden = (status != ShowStatusIng);
        _uploadFailedView.hidden = (status != ShowStatusFailed);
        _uploadSuccessView.hidden = (status != ShowStatusSuccess);
        _connectFailedView.hidden = (status != ShowStatusDisConnect);
        
        [self addViewToWindow];
    }
}

- (void)showUploadFailedView {
    [self showViewByStatus:ShowStatusFailed];
}

- (void)showUploadSuccessView {
    [self showViewByStatus:ShowStatusSuccess];
}

- (void)showDisConnectView {
    if (_isShowDisConnect) {
        return;
    }
    [self showViewByStatus:ShowStatusDisConnect];
}

- (void)showUploadIngViewByIndex:(int)index totalCount:(int)totalCount musicName:(NSString *)name progress:(int)progress {
    @autoreleasepool {
        _uploadMusicCountLable.text = @"";
        _uploadMusicNameLabel.text = @"";
        _uploadMusicProgressLabel.text = @"";
        
        [self startRotateForImg:_loadingImgView];
        _currentUploadIndex = index;
        _totalCount = totalCount;
        
        _uploadMusicCountLable.text = UPLOAD_ING_TIP_STR(index, totalCount);
        _uploadMusicNameLabel.text = name;
        _uploadMusicProgressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
        
        [self showViewByStatus:ShowStatusIng];
    }
}

- (void)updateProgress:(int)progress currentIndex:(int)index musicName:(NSString *)name {
    @autoreleasepool {
        DLog(@"index = %d", index);
        _uploadMusicCountLable.text = @"";
        _uploadMusicNameLabel.text = @"";

        _musicLabel.text = @"歌曲：";
        _titleLabel.text = @"进度：";
        
        _uploadMusicProgressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
        if (index > 0) {
            _currentUploadIndex = index;
            _uploadMusicCountLable.text = UPLOAD_ING_TIP_STR(index, _totalCount);
        }
        
        if (progress > 0) {
            _uploadMusicProgressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
        }
        
        if ([NSString isValidateString:name]) {
            _uploadMusicNameLabel.text = name;
        }
    }
}

#pragma mark - 重连

/**
 根据重连状态显示view

 @param status 重连状态
 */
- (void)showConnectViewByStatus:(ConnectStatus)status {
    _connectStatus = status;
    
    _btnReConnect.hidden = (status != ConnectStatusDisConnect);
    _connectTipLabel.text = (status == ConnectStatusDisConnect) ? @"中控已断开连接" : @"重连中...";
}


/**
 重连成功

 @param notification 成功的通知
 */
- (void)reConnectSuccess:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        _connectStatus = ConnectStatusConnectSuccess;
        
        [self reConnectResultHandle];
    });
}

/**
 重连失败

 @param notification 失败的通知
 */
- (void)reConnectFailed:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        _connectStatus = ConnectStatusConnectFailed;
        
        [self reConnectResultHandle];
        [self pushToConnectVC];
        
    });
}

- (void)reConnectResultHandle {
    [self stopConnectTimer];
    
    [self hideTipView];
    
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

#pragma mark - 动画
/**
 * 开始旋转
 */
- (void)startRotateForImg:(UIImageView *)imgView {
    @autoreleasepool {
        CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; //让其在z轴旋转
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];//旋转角度
        rotationAnimation.duration = 2; //旋转周期
        rotationAnimation.cumulative = YES;//旋转累加角度
        rotationAnimation.repeatCount = 100000;//旋转次数
        [imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

/**
 * 停止旋转动画
 */
- (void)stopRotateForImg:(UIImageView *)imgView {
    [imgView.layer removeAllAnimations];
}

#pragma mark - 隐藏view
- (void)hideTipView {
    if (_showStatus == ShowStatusDisConnect) {
        _isShowDisConnect = NO;
    }
    [self removeViewFromWindow];
}

#pragma mark - 添加和移除view
- (void)addViewToWindow {
    @autoreleasepool {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        NSArray *childVcs = [window.rootViewController childViewControllers];
        
        if (childVcs && childVcs.count > 0) {
            UIViewController *vc = [childVcs lastObject];
            if ([vc isKindOfClass:[D5ConnectZKTViewController class]]) {
                return;
            }
        }
        
        NSArray *subViews = window.subviews;
        if (subViews && ![subViews containsObject:self]) {
            if (_showStatus == ShowStatusDisConnect) {
                _isShowDisConnect = YES;
            }
            [window addSubview:self];
        }
    }
}

- (void)removeViewFromWindow {
    @autoreleasepool {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        NSArray *subViews = window.subviews;
        if (subViews && [subViews containsObject:self]) {
            [self removeFromSuperview];
        }
    }
}

#pragma mark - 点击事件
- (IBAction)btnCancelUploadClicked:(UIButton *)sender {
    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(tipViewCancelUpload:)]) {
        [_delegate tipViewCancelUpload:self];
    }
}

- (IBAction)btnReUploadClicked:(UIButton *)sender {
    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(tipViewReUpload:currentIndex:)]) {
        [_delegate tipViewReUpload:self currentIndex:_currentUploadIndex];
    }
}

- (IBAction)btnReConnectClicked:(UIButton *)sender {
    if (_connectStatus == ConnectStatusConnectIng) {    // 重连中，则等待重连结果即可
        return;
    }
    
    _connectTipLabel.text = @"";
    [self showConnectViewByStatus:ConnectStatusConnectIng];
    
    [self addConnecResultNotification];
    
    // 连接超时定时器
    _reConnectTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reConnectTimeOut) userInfo:nil repeats:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 连接TCP
        [[D5LedCommunication sharedLedModule] tcpConnect:[D5CurrentBox currentBoxIP] port:LED_TCP_LONG_CONN_PORT];
    });
}

@end
