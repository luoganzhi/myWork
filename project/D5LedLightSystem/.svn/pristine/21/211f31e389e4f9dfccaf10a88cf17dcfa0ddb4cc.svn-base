//
//  D5UploadingView.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5UploadingView.h"
#import "D5UploadSuccessView.h"
#import "D5UploadFailedView.h"
#import "D5MoubileTanslateSongsController.h"
#import "D5TFOrUsbViewController.h"

#define UPLOAD_ING_TIP_STR(currentIndex, totalCount) [NSString stringWithFormat:@"歌曲上传中 (%d / %d)", currentIndex, totalCount]

static D5UploadingView *instance = nil;

@interface D5UploadingView () {
    Class _oldClass;
}

/** 当前上传的歌曲索引 */
@property (nonatomic, assign) int currentUploadIndex;

/** 要上传的歌曲总数 */
@property (nonatomic, assign) int totalCount;

/** 上传中 */
@property (weak, nonatomic) IBOutlet UIImageView *loadingImgView;
@property (weak, nonatomic) IBOutlet UILabel *uploadMusicCountLable;
@property (weak, nonatomic) IBOutlet UILabel *uploadMusicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadMusicProgressLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelUpload;
- (IBAction)btnCancelUploadClicked:(UIButton *)sender;

@end

@implementation D5UploadingView

#pragma mark - 检查和设置代理
- (void)setDelegate:(id<D5UploadingViewDelegate>)delegate {
    _delegate = delegate;
    _oldClass = [self objectGetClass:_delegate];
}

- (void)layoutSubviews {
    [self addLineToBtn:_btnCancelUpload];
}

- (BOOL)checkDelegate {
    if (!_delegate) {
        return NO;
    }
    
    Class nowClass = [self objectGetClass:_delegate];
    return nowClass && (nowClass == _oldClass);
}

+ (instancetype)sharedUploadingView {
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

- (IBAction)btnCancelUploadClicked:(UIButton *)sender {
    [self hideTipView];
    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(uploadIngCancelUpload:)]) {
        [_delegate uploadIngCancelUpload:self];
    }
}

- (void)active {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startRotateForImg:_loadingImgView];
    });
}

- (void)showUploadIngViewByIndex:(int)index totalCount:(int)totalCount musicName:(NSString *)name progress:(int)progress {
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(active) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self startRotateForImg:_loadingImgView];
        
        _currentUploadIndex = index;
        _totalCount = totalCount;
        
        _uploadMusicCountLable.text = UPLOAD_ING_TIP_STR(index, totalCount);
        _uploadMusicNameLabel.text = name;
        _uploadMusicProgressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
        
        [self showView];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)showView {
    @autoreleasepool {
        NSArray *childVCs = [UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers;
        if (childVCs && childVCs.count > 0) {
            UIViewController *vc = [childVCs lastObject];
            if (vc && ([vc isKindOfClass:[D5MoubileTanslateSongsController class]] || [vc isKindOfClass:[D5TFOrUsbViewController class]])) {
                [super showView];
            }
        }
    }
}

- (void)updateProgress:(int)progress currentIndex:(int)index musicName:(NSString *)name {
    @autoreleasepool {
        DLog(@"index = %d", index);
        _currentUploadIndex = index;
        
        _uploadMusicProgressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
        if (index >= 0) {
            _currentUploadIndex = index;
            _uploadMusicCountLable.text = UPLOAD_ING_TIP_STR(index, _totalCount);
        }
        
        if (progress >= 0) {
            _uploadMusicProgressLabel.text = [NSString stringWithFormat:@"%d%%", progress];
        }
        
        if ([NSString isValidateString:name]) {
            _uploadMusicNameLabel.text = name;
        }
    }
}

- (void)hideTipView {
    [super hideTipView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopRotateForImg:_loadingImgView];
}

@end
