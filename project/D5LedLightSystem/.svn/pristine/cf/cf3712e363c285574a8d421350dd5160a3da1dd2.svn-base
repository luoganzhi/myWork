//
//  D5ModelViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ModelViewController.h"
#import "MyButton.h"
#import "D5LedList.h"
#import "D5RuntimeShareInstance.h"

@interface D5ModelViewController() <D5LedListDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewTopMargin;
@property (weak, nonatomic) IBOutlet UIButton *btnIndoor; // 照明
@property (weak, nonatomic) IBOutlet UIButton *btnSweet; // 温馨
@property (weak, nonatomic) IBOutlet UIButton *btnRelax; // 放松
@property (weak, nonatomic) IBOutlet UIButton *btnCinema; // 影院
@property (weak, nonatomic) IBOutlet UIView *animationView;

@property (weak, nonatomic) IBOutlet UILabel *hudLabel;


@end

@implementation D5ModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[D5LedList sharedInstance] getLedListByType:LedListTypeHasAdded];
    
    [self statusHasChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusHasChanged) name:Runtime_Info_Update object:nil];
    
    self.btnIndoor.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)checkLedOff {
    @autoreleasepool {
        LedOnOffStatus status = [D5RuntimeShareInstance sharedInstance].lampStatus;
        
        if (![D5LedList sharedInstance].addedLedList || [D5LedList sharedInstance].addedLedList.count <= 0) {
            [MBProgressHUD showMessage:@"请在 “设置-灯组管理”中添加新灯" toView:self.view];
            return YES;
        }
        
        if (status != LedOnOffStatusOn) { // 如果灯关闭
            [MBProgressHUD showMessage:@"请开灯或检查灯是否正确安装" toView:self.view];
            return YES;
        }
        return NO;
    }
}

/**
 runtimeInfo信息改变
 */
- (void)statusHasChanged {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{

            D5RuntimeShareInstance *instance = [D5RuntimeShareInstance sharedInstance];
            // 选中模式
            self.btnIndoor.selected = (instance.sceneType == LedSceneTypeNormal);
            self.btnSweet.selected = (instance.sceneType == LedSceneTypeWarm);
            self.btnRelax.selected = (instance.sceneType == LedSceneTypeParty);
            self.btnCinema.selected = (instance.sceneType == LedSceneTypeCinema);
            
//            [self checkLedOff];
        });
    }
}

- (NSDictionary *)dictWithMode:(LedModelType)type ledId:(int)ledId r:(int)r g:(int)g b:(int)b {
    @autoreleasepool {
        NSDictionary *dict = @{LED_STR_MODE : @(type),
                               LED_STR_LEDID : @(ledId),
                               LED_STR_RED : @(r),
                               LED_STR_GREEN : @(g),
                               LED_STR_BLUE : @(b)};
        return dict;
    }
}

#pragma mark - 按钮点击事件
// 照明
- (IBAction)inDoorBtnClick:(UIButton *)sender {
    [MobClick event:UM_SCENE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", LedSceneTypeNormal]}];
    if ([self checkLedOff]) {
        return;
    }
    
    if (sender.selected == YES) {
        NSDictionary *data = [self dictWithMode:LedModelTypeRGB ledId:0xff r:255 g:255 b:255];
        [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeNo bSame:YES colorArr:@[data]];
        sender.selected = NO;

        return;
    }
    
    [self setOtherBtnSelected];
    sender.selected = YES;
    
    if ([D5RuntimeShareInstance sharedInstance].deviceType == Mini) { // mini 灯
        NSDictionary *data = [self dictWithMode:LedModelTypeRGB ledId:0xff r:255 g:255 b:255];
        [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeNormal bSame:YES colorArr:@[data]];

    } else if ([D5RuntimeShareInstance sharedInstance].deviceType == Ceiling) {
        NSDictionary *data = [self dictWithMode:LedModelTypeCold ledId:0xff r:255 g:255 b:255];
        [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeNormal bSame:YES colorArr:@[data]];

    }
    
}
// 温馨
- (IBAction)sweetBtnClick:(UIButton *)sender {
    [MobClick event:UM_SCENE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", LedSceneTypeWarm]}];
    if ([self checkLedOff]) {
        return;
    }
    
    if (sender.selected == YES) {
        NSDictionary *data = [self dictWithMode:LedModelTypeRGB ledId:0xff r:254 g:133 b:0];
        [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeNo bSame:YES colorArr:@[data]];
        sender.selected = NO;
        return;
    }

    
    [self setOtherBtnSelected];
    sender.selected = YES;
    
    if ([D5RuntimeShareInstance sharedInstance].deviceType == Mini) { // mini 灯
        NSDictionary *data = [self dictWithMode:LedModelTypeRGB ledId:0xff r:254 g:133 b:0];
        [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeWarm bSame:YES colorArr:@[data]];

        
    } else if ([D5RuntimeShareInstance sharedInstance].deviceType == Ceiling) {
        NSDictionary *data = [self dictWithMode:LedModelTypeWarm ledId:0xff r:254 g:133 b:0];
        [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeWarm bSame:YES colorArr:@[data]];
    }

    
   }
// 聚会
- (IBAction)relaxBtnClick:(UIButton *)sender {
    [MobClick event:UM_SCENE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", LedSceneTypeParty]}];
    if ([self checkLedOff]) {
        return;
    }
    
    NSDictionary *data = [self dictWithMode:LedModelTypeRGB ledId:0xff r:255 g:1 b:0];
    if (sender.selected == YES) {
        [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeNo bSame:YES colorArr:@[data]];
        sender.selected = NO;
        return;
    }
    
    [self setOtherBtnSelected];
    sender.selected = YES;
    
    [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeParty bSame:YES colorArr:@[data]];
    


    
//    NSArray *arr = [D5LedList sharedInstance].addedLedList;
//    if (!arr || arr.count == 0) {
//        return;
//    }
//    
//    NSArray *rArr = @[@255, @255, @254, @254, @0, @0];
//    NSArray *gArr = @[@1, @1, @133, @133, @185, @185];
//    NSArray *bArr = @[@0, @0, @0, @0, @237, @237];
//    
//    NSMutableArray *datas = [NSMutableArray new];
//    for (int i = 0; i < 6; i ++) {
//        @autoreleasepool {
//            NSDictionary *data = [self dictWithMode:LedModelTypeRGB ledId:i + 1 r:[rArr[i] intValue] g:[gArr[i] intValue] b:[bArr[i] intValue]];
//            [datas addObject:data];
//        }
//    }
//    [self setModeByType:LedSceneTypeParty Model:LedModelTypeRGB bSame:NO arr:datas];
}

// 影院
- (IBAction)cinemaBtnClick:(UIButton *)sender {
    [MobClick event:UM_SCENE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", LedSceneTypeCinema]}];
    if ([self checkLedOff]) {
        return;
    }
    NSDictionary *data = [self dictWithMode:LedModelTypeRGB ledId:0xff r:0 g:185 b:237];

    if (sender.selected == YES) {
        [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeNo bSame:YES colorArr:@[data]];
        sender.selected = NO;

        return;
    }

    
    [self setOtherBtnSelected];
    sender.selected = YES;
  
    [[D5LedList sharedInstance] operateModeSetting:LedSceneTypeCinema bSame:YES colorArr:@[data]];
}

- (void)setOtherBtnSelected {
    self.btnIndoor.selected = NO;
    self.btnSweet.selected = NO;
    self.btnRelax.selected = NO;
    self.btnCinema.selected = NO;
}

#pragma mark - <MyDelegate>
- (void)ledListErrorOperateMode:(D5LedList *)list sceneType:(LedSceneType)sceneType errorType:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        typeof(weakSelf) strongSelf = weakSelf;
        // 提示框的显示与隐藏
        [UIView animateWithDuration:0.5 animations:^{
            strongSelf.hudLabel.hidden = NO;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                strongSelf.hudLabel.hidden = YES;
            });
            
        }];
    });
}

@end
