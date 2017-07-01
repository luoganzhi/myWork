//
//  D5PlayMusicViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5PlayMusicViewController.h"
#import "D5WheelView.h"

#import "D5MusicStateModel.h"
#import "D5MusicStateMusicModel.h"
#import "D5MusicStateConfigModel.h"
#import "MJExtension.h"

#import "D5Protocol.h"
#import "UIImageView+WebCache.h"

#import "D5RuntimeShareInstance.h"
#import "D5RuntimeMusic.h"
#import "D5RuntimeEffects.h"

#define PLAY_CYCLE_IMG [UIImage imageNamed:@"icon_music_order"]
#define PLAY_RANDOM_IMG [UIImage imageNamed:@"music_icon_shuffle"]
#define USER_SPOT_CONFIG @"userSpotConfig"

@interface D5PlayMusicViewController () <D5WheelViewDelegate, D5LedListDelegate>
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *volumeBtn;
@property (weak, nonatomic) IBOutlet D5WheelView *whellView;
@property (weak, nonatomic) IBOutlet UIButton *btnCycleModel;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialLabel;
@property (weak, nonatomic) IBOutlet UILabel *djNameLabel;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UIView *guideView;
@property (weak, nonatomic) IBOutlet UIButton *spotBtn;
@property (weak, nonatomic) IBOutlet UIImageView *musicCoverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backCoverImageView;

/** 指针 */
@property (nonatomic, strong) UIImageView *pointImageView;

/** 播放顺序数组 */
@property (nonatomic, strong) NSArray *playCycleModel;
/** 播放模式数 */
@property (nonatomic, assign) NSInteger currentPlayModelIndex;


/** 歌曲状态模型对象 */
@property (nonatomic, strong) D5MusicStateModel *model;

/** 获取歌曲信息的定时器 */
@property (nonatomic, strong) CADisplayLink *getStateTimer;


/** 颜色数组 */
@property (nonatomic, strong) NSArray *colorArray;

/** 遮罩 */
@property (nonatomic, strong) UIView *v;

/** 当前音量 */
@property (nonatomic, assign) NSUInteger volume;

/** 记录当前slider取值 */
@property (nonatomic, assign) NSUInteger currentVolume;

/** 存在本地的配置集合 */
@property (nonatomic, strong) NSMutableArray *configArray;

/** runLedCmd */
@property (nonatomic, strong) D5LedSpecialCmd *runLedCmd;

/** musicUrl */
@property (nonatomic, strong) NSString *musicCoverUrl;

/** once */
@property (nonatomic, assign) BOOL onceAnimation;

/** twice */
@property (nonatomic, assign) BOOL twiceAnimation;

/** currentPos */
@property (nonatomic, assign) int currentPos;




@end

@implementation D5PlayMusicViewController

#pragma mark -  懒加载

- (NSMutableArray *)configArray
{
    if (!_configArray) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_SPOT_CONFIG];
        _configArray = [dict objectForKey:[D5RuntimeShareInstance sharedInstance].music.name];

        if (!_configArray) {
            _configArray = [NSMutableArray array];
        }
    }
    return _configArray;
}

- (UIView *)v
{
    if (!_v) {
        _v = [[UIView alloc] init];
        _v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
        _v.frame = self.whellView.frame;
        _v.userInteractionEnabled = NO;
        _v.layer.cornerRadius = self.whellView.bounds.size.width / 2;
        _v.layer.masksToBounds = YES;
    }
    
    return _v;
}

- (NSArray *)colorArray
{
    if (!_colorArray) {
        
        _colorArray = @[[self wheelColorWithR:253 G:198 B:11], [self wheelColorWithR:241 G:142 B:28], [self wheelColorWithR:234 G:98 B:31], [self wheelColorWithR:277 G:35 B:34], [self wheelColorWithR:196 G:3 B:125], [self wheelColorWithR:109 G:57 B:139], [self wheelColorWithR:68 G:78 B:153], [self wheelColorWithR:42 G:113 B:176], [self wheelColorWithR:6 G:150 B:187], [self wheelColorWithR:0 G:142 B:91], [self wheelColorWithR:140 G:187 B:38], [self wheelColorWithR:244 G:229 B:0]];
        
    }
    return _colorArray;
}

- (NSValue *)wheelColorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B
{
    LedRGBAll wheelColor;
    wheelColor.R = R;
    wheelColor.G = G;
    wheelColor.B = B;
    
    NSValue *value = [NSValue valueWithBytes:&wheelColor objCType:@encode(LedRGBAll)];
    
    return value;
}



- (CADisplayLink *)getStateTimer
{
    if (!_getStateTimer) {
        _getStateTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(getStatus)];
        
        //开始循环
        _getStateTimer.frameInterval = 60;
        [_getStateTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _getStateTimer;
}

// 获取状态
- (void)getStatus
{
    D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];

    self.currentPos = self.currentPos + 1000;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentTimeLabel.text = [self labeltimeWithNSTime:(instance.music.duration - self.currentPos)];
        
        if (self.currentPos >= instance.music.duration) {
            self.currentPos = 0;
        }

    });

}

// 返回特定格式的时间
- (NSString *)labeltimeWithNSTime:(NSInteger)duration
{
    
    CGFloat time = duration / 1000.0;
    
    NSInteger min = time / 60;
    NSInteger sec = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"-%02zd:%02zd",min,sec];
    
}

- (void)sendSetModelWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        D5LedNormalCmd *musicSetModel = [[D5LedNormalCmd alloc] init];
        
        musicSetModel.remotePort = [D5CurrentBox currentBoxTCPPort];
        musicSetModel.strDestMac =  [D5CurrentBox currentBoxMac];
        musicSetModel.remoteLocalTag = tag_remote;
        musicSetModel.remoteIp = [D5CurrentBox currentBoxIP];
        musicSetModel.errorDelegate = self;
        musicSetModel.receiveDelegate = self;
        [musicSetModel ledSendData:Cmd_Media_Operate withSubCmd:SubCmd_Music_Setting withData:dict];
    }
}


- (NSArray *)playCycleModel
{
    if (!_playCycleModel) {
        _playCycleModel = @[PLAY_CYCLE_IMG, PLAY_RANDOM_IMG];
    }
    return _playCycleModel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (D5LedSpecialCmd *)runLedCmd {
    if (!_runLedCmd) {
        _runLedCmd = [[D5LedSpecialCmd alloc] init];
        _runLedCmd.remoteLocalTag = tag_remote;
        _runLedCmd.errorDelegate = self;
        _runLedCmd.receiveDelegate = self;
        
        _runLedCmd.cmdType = SpecialCmdTypePush;
    }
    
    _runLedCmd.remotePort = [D5CurrentBox currentBoxTCPPort];
    _runLedCmd.strDestMac =  [D5CurrentBox currentBoxMac];
    _runLedCmd.remoteIp = [D5CurrentBox currentBoxIP];
    return _runLedCmd;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"1-5PlayMusic--viewDidLoad");
    
    // 初始化view
    [self initView];
    // 获取运行时状态
    [self.runLedCmd ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Runtime_Info];
    
    [self runtimeInfoChange];
    [self addNotificaiton];
}

- (void)dealloc {
    self.runLedCmd.receiveDelegate = nil;
    self.runLedCmd.errorDelegate = nil;
    [self.playOrPauseBtn removeObserver:self forKeyPath:@"selected"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"1-5PlayMusic --  removeObserver");
}



- (void)addNotificaiton {
    DLog(@"1-5PlayMusic --  addObserver runtimeInfoChange");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runtimeInfoChange) name:Runtime_Info_Update object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(runtimeInfoChange)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}



// 更新界面
- (void)runtimeInfoChange
{
    DLog(@"1-5PlayMusic --  runtimeInfoChange");
    D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (instance.playMode == 1) {
            [self.btnCycleModel setImage:self.playCycleModel[0] forState:UIControlStateNormal];
        } else {
            [self.btnCycleModel setImage:self.playCycleModel[1] forState:UIControlStateNormal];
        }
       

        // 根据是否播放界面展示问题
        if (instance.music.playStatus == Play) { // 在播放
            self.currentPos = instance.music.currentPos;
            

            [self getStateTimer];
            self.musicNameLabel.hidden = NO;
            self.singerNameLabel.hidden = NO;
            self.currentTimeLabel.hidden = NO;
            self.controlView.hidden = NO;
            self.barView.hidden = NO;
            self.guideView.hidden = YES;
            
            self.playOrPauseBtn.selected = NO;
            
        } else if (instance.music.playStatus == Pause) { // 有歌曲，暂停中

            [self.getStateTimer invalidate];
            self.getStateTimer = nil;
            
            
            self.musicNameLabel.hidden = NO;
            self.singerNameLabel.hidden = NO;
            self.currentTimeLabel.hidden = NO;
            self.controlView.hidden = NO;
            self.barView.hidden = NO;
            self.guideView.hidden = YES;
            
            self.playOrPauseBtn.selected = YES;

            
        } else {  // 没歌停止播放
            [self.getStateTimer invalidate];
            self.getStateTimer = nil;

            self.playOrPauseBtn.selected = YES;
            self.musicNameLabel.hidden = YES;
            self.singerNameLabel.hidden = YES;
            self.currentTimeLabel.hidden = YES;
            self.controlView.hidden = YES;
            self.barView.hidden = YES;
            self.guideView.hidden = NO;
        }


        self.musicNameLabel.text = instance.music.name;
//        self.currentTimeLabel.text = [self labeltimeWithNSTime:(instance.music.duration - instance.music.currentPos)];
        
        if (([instance.music.singerName isEqualToString:@""] || !instance.music.singerName) && ([instance.music.albumName isEqualToString:@""] || !instance.music.albumName)) {
            self.singerNameLabel.text = @"未知";
        } else if (([instance.music.singerName isEqualToString:@""] || !instance.music.singerName) && ![instance.music.albumName isEqualToString:@""]) {
            self.singerNameLabel.text = instance.music.albumName;
        } else if (![instance.music.singerName isEqualToString:@""] &&([instance.music.albumName isEqualToString:@""] || !instance.music.albumName)) {
            self.singerNameLabel.text = instance.music.singerName;
        } else if (![instance.music.singerName isEqualToString:@""] && ![instance.music.albumName isEqualToString:@""]){
            self.singerNameLabel.text =  [NSString stringWithFormat:@"%@ - %@", instance.music.singerName, instance.music.albumName];
        }
        
        if (instance.colorMode == Color_Scene) {
            switch (instance.sceneType) {
                case LedSceneTypeNormal:
                    self.djNameLabel.text = @"照明场景";
                    break;
                case LedSceneTypeWarm:
                    self.djNameLabel.text = @"温馨场景";
                    break;
                case LedSceneTypeParty:
                    self.djNameLabel.text = @"浪漫场景";
                    break;
                case LedSceneTypeCinema:
                    self.djNameLabel.text = @"冷漠场景";
                    break;
                default:
                    break;
            }
            
        } else if (instance.colorMode == Color_Manual) {
            self.djNameLabel.text = @"手动模式";
            
        } else {
            if (!instance.effects.name) { //如果没有通用特效
                self.djNameLabel.text = @"音乐与灯光更配哦";
            } else {
                if (instance.effects.effectType == Effects_Common) { //通用特效
                    self.djNameLabel.text = [NSString stringWithFormat:@"%@-%@", instance.music.name, instance.effects.name] ;
                } else if (instance.effects.effectType == Effects_Short) { //简短特效
                    self.djNameLabel.text = [NSString stringWithFormat:@"%@", instance.effects.name];
                }else { // 其他特效
                    self.djNameLabel.text = [NSString stringWithFormat:@"%@-%@",instance.effects.name, instance.effects.author];
                }
            }
        }

        
        self.volumeSlider.value = instance.volume / 100.0;
        
        if (self.volumeSlider.value == 0) {
            self.volumeBtn.selected = YES;
        } else {
            self.volumeBtn.selected = NO;
        }
        

        
        self.spotBtn.selected = NO;
        
        // 专辑封面显示
        if ([instance.music.albumImgUrl isEqualToString:@""] || !instance.music.albumImgUrl) {
            self.musicCoverImageView.image = [UIImage imageNamed:@"music_cover_default"];
            self.musicCoverUrl = @"";
            
        } else {
            if (![instance.music.albumImgUrl isEqualToString:self.musicCoverUrl]) {
            
                
                [self.musicCoverImageView sd_setImageWithURL:[NSURL D5UrlWithString:instance.music.albumImgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        self.musicCoverImageView.image = [image circleImage];
                    } else {
                         self.musicCoverImageView.image = [UIImage imageNamed:@"music_cover_default"];
                    }
                    
                }];
                self.musicCoverUrl = instance.music.albumImgUrl;
            }
        }
        
        // 点赞与否
        for (NSNumber *config in self.configArray) {
            if([config integerValue] == instance.effects.effectId) {
                self.spotBtn.selected = YES;
                break;
            }
        }
        
        self.configArray = nil;
        
    });
    
       DLog(@"runtimeInfoChange-------start");

}


- (void)initView
{
    // 设置声音滑块按钮
    self.volumeSlider.transform = CGAffineTransformMakeRotation(-1.57079633);
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"music_volume_slide"] forState:UIControlStateNormal];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 设置指针按钮
    [self.view layoutIfNeeded];
    self.pointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music_pointer"]];
    self.pointImageView.layer.anchorPoint = CGPointMake(0, 0);
    self.pointImageView.center = self.circleImageView.center;
    [self.view insertSubview:self.pointImageView belowSubview:self.circleImageView];
    
    
    self.whellView.delegate = self;
    
    // 监听属性， 按钮变化，指针跟着变化
    [self.playOrPauseBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    self.musicNameLabel.hidden = YES;
    self.singerNameLabel.hidden = YES;
    self.currentTimeLabel.hidden = YES;
    self.controlView.hidden = YES;
    self.barView.hidden = YES;
    self.guideView.hidden = NO;
    self.playOrPauseBtn.selected = YES;
    
    self.onceAnimation = NO;
    self.twiceAnimation = NO;
    
    self.backCoverImageView.layer.cornerRadius = self.backCoverImageView.frame.size.width / 2;
    self.backCoverImageView.layer.masksToBounds = YES;
//       [self startRotateForImg:self.musicCoverImageView];


}

- (void)doAnimation
{
    [self.musicCoverImageView.layer removeAllAnimations];
    
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; //让其在z轴旋转
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];//旋转角度
    rotationAnimation.duration = 20; //旋转周期
    rotationAnimation.cumulative = YES;//旋转累加角度
    rotationAnimation.repeatCount = MAXFLOAT;//旋转次数
    //    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.musicCoverImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"]; //让其在z轴旋转
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];//旋转角度
    rotationAnimation.duration = 20; //旋转周期
    rotationAnimation.cumulative = YES;//旋转累加角度
    rotationAnimation.repeatCount = MAXFLOAT;//旋转次数
//    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.musicCoverImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [D5LedList sharedInstance].delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.getStateTimer invalidate];
    self.getStateTimer = nil;
    [D5LedList sharedInstance].delegate = nil;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UIButton *button = (UIButton *)object;
    if (self.playOrPauseBtn == button && [@"selected" isEqualToString:keyPath]) {
//        NSLog(@"self.button的enabled属性改变了%@===== %@",[change objectForKey:@"new"],change);
        
        if (self.playOrPauseBtn.selected) { // 没有播放
            [UIView animateWithDuration:0.15 animations:^{
                self.pointImageView.transform = CGAffineTransformMakeRotation(-45 / 180.0 * M_PI);
            }];
            self.whellView.userInteractionEnabled = NO;

            if (!self.onceAnimation) {
            
                [self.musicCoverImageView.layer pauseAnimate];
                self.onceAnimation = YES;
                self.twiceAnimation = NO;
            }

        
        } else {
            [UIView animateWithDuration:0.15 animations:^{ // 在播放
                self.pointImageView.transform = CGAffineTransformMakeRotation(0 / 180.0 * M_PI);
            }];
            self.whellView.userInteractionEnabled = YES;
            if (!self.twiceAnimation) {
                [self.musicCoverImageView.layer resumeAnimate];
                self.twiceAnimation = YES;
                self.onceAnimation = NO;
            }
    

        }
        
    }
}




#pragma mark - 界面上按钮的点击事件
- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  播放/暂停
 */
- (IBAction)playOrPauseBtnClick:(UIButton *)sender {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    
    if (sender.isSelected) { //去暂停
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@(LedMusicControlTypePause),@"type", nil];
        [self sendOperateWithDict:dict];
        [self.getStateTimer invalidate];
        self.getStateTimer = nil;

        
        
    } else { //去播放
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@(LedMusicControlTypePlay),@"type", nil];
        [self sendOperateWithDict:dict];
        [self getStateTimer];
        
    }

}
/**
 *  上一首
 */
- (IBAction)btnPreviousClicked:(UIButton *)sender {
//    [self.musicControl ledMusicControl:LedMusicControlTypePrevious];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@(LedMusicControlTypePrevious),@"type", nil];
    [self sendOperateWithDict:dict];
}

- (void)sendOperateWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        D5LedNormalCmd *musicControl = [[D5LedNormalCmd alloc] init];
        musicControl.remotePort = [D5CurrentBox currentBoxTCPPort];
        musicControl.strDestMac =  [D5CurrentBox currentBoxMac];
        musicControl.remoteLocalTag = tag_remote;
        musicControl.remoteIp = [D5CurrentBox currentBoxIP];
        musicControl.errorDelegate = self;
        musicControl.receiveDelegate = self;
        
        [musicControl ledSendData:Cmd_Media_Operate withSubCmd:SubCmd_Music_Control withData:dict];
    }
}

/**
 *  下一首
 */
- (IBAction)btnNextClicked:(UIButton *)sender {
//    [self.musicControl ledMusicControl:LedMusicControlTypeNext];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@(LedMusicControlTypeNext),@"type", nil];
    [self sendOperateWithDict:dict];
    
}


/**
 *  循环模式的点击事件
 */
- (IBAction)btnCycleModelClicked:(UIButton *)sender {
    // 每次点击做+1 在做算法
    self.currentPlayModelIndex = self.currentPlayModelIndex + 1;
    self.currentPlayModelIndex = self.currentPlayModelIndex % self.playCycleModel.count;
    
    [self.btnCycleModel setImage:self.playCycleModel[self.currentPlayModelIndex] forState:UIControlStateNormal];
    
    // 将值保存到偏好设置中
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentPlayModelIndex forKey:@"currentPlayModelIndex"];
    
    // 判断播放模式
    switch (self.currentPlayModelIndex) {
        case 0: {//循环播放
            NSDictionary *dict1 = [[NSDictionary alloc] initWithObjectsAndKeys:@(ModeSwitch),LED_STR_TYPE, @(LedMusicSetModelTypeOrder), LED_STR_PLAYMODE, nil];
            [self sendSetModelWithDict:dict1];
            [MBProgressHUD showMessage:@"循环播放"];
        
            break;
        }
        case 1: {// 随机播放
            NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@(ModeSwitch),LED_STR_TYPE, @(LedMusicSetModelTypeRandom), LED_STR_PLAYMODE, nil];
            [self sendSetModelWithDict:dict2];

            [MBProgressHUD showMessage:@"随机播放"];
        
            break;
        }
        default:
            break;
    }
}




// 音量按钮点击事件
- (IBAction)volumeBtnClick:(id)sender {
    self.volumeSlider.hidden = !self.volumeSlider.hidden;
    if (self.volumeSlider.hidden == NO) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.volumeSlider.hidden = YES;
        });
    }
}
- (IBAction)volumeSilderBtnClickTouch:(UISlider *)sender {
    if (self.volumeSlider.value == 0) {
        self.volumeBtn.selected = YES;
        DLog(@"yes");
    } else {
        self.volumeBtn.selected = NO;
        DLog(@"no");
    }
    
    
    NSUInteger index = (NSUInteger)(sender.value * 100);
    
    // 如果为当前音量就返回不发送数据
    if (self.currentVolume != 0 && self.currentVolume == index) return;
    

    self.currentVolume = index;

    
    NSDictionary *dict2 = [[NSDictionary alloc] initWithObjectsAndKeys:@(VOL),@"type",@(4), LED_STR_VOLTYPE, @(index), LED_STR_VOLVALUE, nil];
    
    D5LedNormalCmd *musicSetVolume = [[D5LedNormalCmd alloc] init];
    musicSetVolume.remotePort = [D5CurrentBox currentBoxTCPPort];
    musicSetVolume.strDestMac =  [D5CurrentBox currentBoxMac];
    musicSetVolume.remoteLocalTag = tag_remote;
    musicSetVolume.remoteIp = [D5CurrentBox currentBoxIP];
    musicSetVolume.errorDelegate = self;
    musicSetVolume.receiveDelegate = self;
    
    [musicSetVolume ledSendData:Cmd_Media_Operate withSubCmd:SubCmd_Music_Setting withData:dict2];
}


// 点赞
- (IBAction)spotBtnClick:(UIButton *)sender {
    D5Protocol *d5 = [[D5Protocol alloc] init];
    [d5 setFinishBlock:^(NSDictionary *response){
    }];
    
    [d5 setFaildBlock:^(NSString *errorStr) {
        //DLog(@"errorStr = %@", errorStr);
    }];
    
    D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
    NSString *colorModeStr = [NSString stringWithFormat:@"%d", instance.colorMode];
    
    [MobClick event:UM_FAVOR_EFFECT attributes:@{LED_STR_TYPE : colorModeStr}];
    
    self.spotBtn.selected = !self.spotBtn.selected;
    
    if (instance.effects.effectId) {
        [d5 spotCMD:14 MusicId:instance.music.serverId Cid:instance.effects.effectId];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
   
    for (NSNumber *config in self.configArray) {
        if ([config integerValue] == instance.effects.effectId) {
            if (!self.spotBtn.selected) {
                NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:self.configArray];
                [ary removeObject:@(instance.effects.effectId)];
                
                [dict setObject:ary forKey:instance.music.name];
                if (instance.effects.effectId) {
                    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USER_SPOT_CONFIG];
                }
                
                self.configArray = nil;

            }

            
            return;
        }
    }
    
    if (self.spotBtn.selected == YES) {
        NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:self.configArray];
        [ary addObject:@(instance.effects.effectId)];
        [dict setObject:ary forKey:instance.music.name];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:USER_SPOT_CONFIG];
        
        self.configArray = nil;

    }
    
}


#pragma mark - <whellDelegate>
// 色盘调色
- (void)wheelView:(D5WheelView *)wheelView didSelectedItemAtIndex:(NSInteger)index
{
    [MobClick event:UM_WHEEL_COLOR];
    [[D5ManualMode sharedInstance] setManualMode:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSValue *value = [self.colorArray objectAtIndex:index];
        LedRGBAll rgb;
        [value getValue:&rgb];
        
        NSDictionary *dict = @{LED_STR_RED: @(rgb.R),
                               LED_STR_GREEN: @(rgb.G),
                               LED_STR_BLUE: @(rgb.B)
                               };
        
        [[D5LedList sharedInstance] operateAllAddedLight:LedOperateTypeColor parameterDict:dict];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[D5ManualMode sharedInstance] setManualMode:NO];
    });
    
}

- (NSInteger)numberOfItemsInWheelView:(D5WheelView *)wheelView
{
    return self.colorArray.count;
}

#pragma mark - <MyDelegate>
- (void)ledListErrorOperateAllLed:(D5LedList *)list operateType:(LedOperateType)operateTyp errorType:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage {
    if (errorType == D5SocketErrorCodeTypeTimeOut) {
        //DLog(@"超时:%d->%d",header->cmd,header->subCmd);
    } else if (errorType == D5SocketErrorCodeTypeTCPSendDataFailed) {
        [self.getStateTimer invalidate];
        self.getStateTimer = nil;
    }
}

@end
