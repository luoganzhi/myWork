//
//  D5BaseViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BaseViewController.h"
#import "UIImage+Color.h"
#import "MyNavigationBar.h"
#import "MyNavigationController.h"

@interface D5BaseViewController()

@property (nonatomic, strong) UIView *addedView;
@property (nonatomic, assign) BOOL hasRemoved;
@property (nonatomic, strong) UITapGestureRecognizer *currentTapGesture;

@end

@implementation D5BaseViewController

- (void)viewDidLoad {
    [self setNavigationBarHidden:NO]; //默认不隐藏navigation
    [self setNavigationTitleColor:WHITE_COLOR]; //默认白色标题
    if (self.translucent == YES) {
        [self setNavigationBarTranslucent];
    }
    [self setNavigationBarWithColor:NAV_BACK_COLOR];
    self.navigationItem.hidesBackButton = YES;
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  - 右上角baritem的标题和enable改变
- (void)changeRightBarItemTitle:(NSString *)title {
    if (self.navigationItem.rightBarButtonItem) {
        UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.text = title;
    }
}

- (void)changeRightBarItemEnabled:(BOOL)enabled {
    if (self.navigationItem.rightBarButtonItem) {
        UIView *view = self.navigationItem.rightBarButtonItem.customView;
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.enabled = enabled;
            
            self.navigationItem.rightBarButtonItem.enabled = enabled;
        }
    }
}

#pragma mark - 设置btn的标题和enable
- (void)setBtnEnable:(UIButton *)btn enable:(BOOL)isEnable {
    btn.enabled = isEnable;
    btn.backgroundColor = isEnable ? BTN_YELLOW_COLOR : BTN_DISABLED_COLOR;
}

/**
 *  设置btn的title
 *
 *  @param title
 *  @param btn
 */
- (void)setBtnTitle:(NSString *)title forBtn:(UIButton *)btn {
    btn.titleLabel.text = title;
    [btn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - 设置navigationbar

/**
 *  设置bar的显示隐藏
 *
 *  @param isHide 是否隐藏
 */
- (void)setNavigationBarHidden:(BOOL)isHide {
    [self.navigationController setNavigationBarHidden:isHide animated:NO];
}

/**
 *  设置navigationbar的color
 *
 *  @param color
 */
//- (void)setNavigationBarColor:(UIColor *)color {
//    [((MyNavigationBar *)[[self navigationController] navigationBar]) setNavigationBarWithColor:color];
//}
- (void)setNavigationBarWithColor:(UIColor *)color {
    UIImage *image = [UIImage imageWithColor:color];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    //投影
    UIImage*shadowImage=[UIImage imageWithColor:[UIColor colorWithHex:0x404040 alpha:1.0]];
    
    [self.navigationController.navigationBar setShadowImage:shadowImage];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self setTranslucent:YES];
}

/**
 *  设置navigationbar的title颜色
 *
 *  @param color
 */
- (void)setNavigationTitleColor:(UIColor *)color {
    //设置titile颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, [UIFont systemFontOfSize:VC_TITLE_FONT_SIZE], NSFontAttributeName, nil]];
}

/**
 *  设置navigationbar的title大小
 *
 *  @param 大小
 */
- (void)setNavigationTitleSize:(CGFloat)size {
    //设置titile颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:size], NSFontAttributeName, nil]];
}

/**
 *  设置navigationbar背景透明
 */
- (void)setNavigationBarTranslucent {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark  - 设置状态栏
/**
 *  设置状态栏的barstyle
 *
 *  @param style
 */
- (void)setStatusBarStyle:(UIBarStyle)style {
    [((MyNavigationBar *)self.navigationController.navigationBar) setBarStyle:style];
}

/**
 *  设置状态栏LightContent
 */
- (void)setLightContentBar {
    [self setNavigationBarHidden:NO];
    [self setStatusBarStyle:UIBarStyleBlack];
}

/**
 *  设置状态栏black
 */
- (void)setBlackBar {
    [self setNavigationBarHidden:NO];
    [self setStatusBarStyle:UIBarStyleDefault];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 返回
- (void)back {
    __weak D5BaseViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       [weakSelf.navigationController popViewControllerAnimated:YES];
    });
    
}

#pragma mark - 动画的开始和结束
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
        
        imgView.hidden = NO;
    }
}

/**
 * 停止旋转动画
 */
- (void)stopRotateForImg:(UIImageView *)imgView {
    imgView.hidden = YES;
    [imgView.layer removeAllAnimations];
}

- (void)addGuideViewWithPoint:(CGPoint)point tipStr:(NSString *)tipStr direction:(GuideBgDirection)direction toView:(UIView *)view {
    @autoreleasepool {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = GUIDE_TIP_TAG;
        
        NSArray *subViews = view.subviews;
        if (subViews && [subViews containsObject:btn]) {
            [btn removeFromSuperview];
        }
        
        NSString *imgName = @"suspension_bg_left";
        switch (direction) {
            case GuideBgDirectionCenter:
                imgName = @"suspension_bg_center";
                break;
            case GuideBgDirectionRight:
                imgName = @"suspension_bg_right";
                break;
            default:
                imgName = @"suspension_bg_left";
                break;
        }
        
        UIImage *img = [UIImage imageNamed:imgName];
        CGSize size = img.size;
        
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize textSize = [tipStr boundingRectWithSize:CGSizeMake(300, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
        CGFloat textWidth = textSize.width + 10;
        CGFloat textHeight = textSize.height + 10;
        
        CGFloat width = size.width;
        CGFloat height = size.height;
        
        if (textWidth > size.width) {
            width = textWidth;
        }
        
        if (textHeight > size.height) {
            height = textHeight;
        }
        
        CGFloat x = point.x;
        if (direction == GuideBgDirectionRight) { // 如果方向向右，这时传的point的x时与屏幕右边距离
            x = CGRectGetWidth([UIScreen mainScreen].bounds) - point.x - width;
        } else if (direction == GuideBgDirectionCenter) {
            x = point.x - width / 2;
        }
        
        btn.frame = CGRectMake(x, point.y, width, height);
        
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor colorWithHex:0x333333 alpha:1] forState:UIControlStateNormal];
        [btn setTitle:tipStr forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        btn.titleLabel.numberOfLines = 0;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        btn.userInteractionEnabled = NO;
        btn.hidden = NO;
        
        _addedView = view;
        
        _currentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignGuideTip)];
        [view addGestureRecognizer:_currentTapGesture];
        DLog(@"guidetip 添加手势");
        
        [view addSubview:btn];
        _hasRemoved = NO;
        DLog(@"guidetip 添加悬浮");
    }
}

- (void)resignGuideTip {
    if (_addedView) {
        if (_currentTapGesture) {
            [_addedView removeGestureRecognizer:_currentTapGesture];
            DLog(@"guidetip 移除手势");
            _currentTapGesture = nil;
        }
        
        [self removeGuideTipFromView:_addedView];
        _addedView = nil;
    }
}

- (void)addGuideViewWithPoint:(CGPoint)point tipStr:(NSString *)tipStr direction:(GuideBgDirection)direction {
    [self addGuideViewWithPoint:point tipStr:tipStr direction:direction toView:[UIApplication sharedApplication].keyWindow];
}

- (void)removeGuideTipFromView:(UIView *)view {
    @autoreleasepool {
        if (_hasRemoved) {
            return;
        }
        
        DLog(@"guidetip 移除悬浮");
        NSArray *subviews = [view subviews];
        if (subviews && subviews.count > 0) {
            __weak D5BaseViewController *weakSelf = self;
            [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *sub = (UIView *)obj;
                if (sub.tag == GUIDE_TIP_TAG) {
                    [sub removeFromSuperview];
                    weakSelf.hasRemoved = YES;
                    *stop = YES;
                }
            }];
        }
    }
}

- (void)removeGuideTip {
    [self removeGuideTipFromView:[UIApplication sharedApplication].keyWindow];
}

@end
