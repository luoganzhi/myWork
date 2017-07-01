//
//  D5LightGroupNumberViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LightGroupNumberViewController.h"
#import "D5ManualColorButton.h"
#define LIGHT_BTN_START_TAG 6660

@interface D5LightGroupNumberViewController ()

@property (weak, nonatomic) IBOutlet D5ManualColorButton *btnLight1;
@property (weak, nonatomic) IBOutlet D5ManualColorButton *btnLight2;
@property (weak, nonatomic) IBOutlet D5ManualColorButton *btnLight3;
@property (weak, nonatomic) IBOutlet D5ManualColorButton *btnLight4;
@property (weak, nonatomic) IBOutlet D5ManualColorButton *btnLight5;
@property (weak, nonatomic) IBOutlet D5ManualColorButton *btnLight6;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

- (IBAction)btnLightClicked:(D5ManualColorButton *)sender;
- (IBAction)btnCancelClicked:(UIButton *)sender;

- (IBAction)btnSureClicked:(UIButton *)sender;

@end

@implementation D5LightGroupNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)judgeSetNoGuide {
    NSString *key = @"has_setno_light_guide";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasSetNoLightGuide = [userDefaults boolForKey:key];
    if (!hasSetNoLightGuide) {
        CGRect convertFrame = [self.view convertRect:_btnLight1.frame fromView:_btnLight1.superview];
        CGFloat x = CGRectGetMidX(convertFrame);
        CGFloat y = CGRectGetMaxY(convertFrame);
        [self addGuideViewWithPoint:CGPointMake(x, y) tipStr:@"编号后再次点击\n可取消该编号" direction:GuideBgDirectionCenter];
        
        [userDefaults setBool:YES forKey:key];
        [userDefaults synchronize];
    }
}

- (void)initView {
    @autoreleasepool {
        _selectedIndex = -1;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEmpty)];
        [_emptyView addGestureRecognizer:tap];
        
        NSArray *setNoArr = [[D5LedList sharedInstance] arrWithSetNoLedList];
        if ((!setNoArr || setNoArr.count == 0) && self.noAddSetNoIDArr.count == 0) {
            return;
        }
        
        NSMutableArray *hasSetNoArr = [NSMutableArray new];
        if (self.noAddSetNoIDArr.count > 0) {
            [hasSetNoArr addObjectsFromArray:self.noAddSetNoIDArr];
        }
        
        if (setNoArr && setNoArr.count > 0) {
            for (NSDictionary *dict in setNoArr) {
                @autoreleasepool {
                    int index = [dict[LED_STR_ID] intValue];
                    [hasSetNoArr addObject:@(index)];
                }
            }
        }
        
        DLog(@"---- 已经编号的灯 -- %@", hasSetNoArr);
        for (NSNumber *index in hasSetNoArr) {
            @autoreleasepool {
                UIButton *btn = [self.view viewWithTag:LIGHT_BTN_START_TAG + [index intValue]];
                
                if (_isNewScanLight) {
                    if (_pushLed) {
                        NSInteger lightID = _pushLed.lightId;
                        if (lightID == [index integerValue]) {
                            btn.selected = YES;
                            
                            NSInteger index = btn.tag - LIGHT_BTN_START_TAG;
                            _selectedIndex = index;
                        } else {
                            btn.enabled = NO;
                        }
                    }
                } else {
                    btn.enabled = NO;
                }
            }
        }
    }
}

#pragma mark - 点击事件
- (void)setOtherBtnDisSelect:(D5ManualColorButton *)sender {
    @autoreleasepool {
        for (int i = 1; i <= 6; i ++) {
            @autoreleasepool {
                NSInteger tag = LIGHT_BTN_START_TAG + i;
                if (_isNewScanLight) {
                    if (sender.tag != tag) {
                        UIButton *btn = [self.view viewWithTag:tag];
                        btn.selected = NO;
                    }
                } else {
                    UIButton *btn = [self.view viewWithTag:tag];
                    btn.selected = NO;
                }
            }
        }
    }
}

- (void)clickEmpty {
    [self resignGuideTip];
    if (_delegate && [_delegate respondsToSelector:@selector(lightNumbered:meshAddr:selectedIndex:)]) {
        [_delegate lightNumbered:NumberButtonTypeCancel meshAddr:-1 selectedIndex:-1];
    }
}

- (IBAction)btnLightClicked:(D5ManualColorButton *)sender {
    [self setOtherBtnDisSelect:sender];
    sender.selected = !sender.isSelected;
    
    NSInteger index = sender.tag - LIGHT_BTN_START_TAG;
    _selectedIndex = sender.isSelected ? index : -1;
    
    [self resignGuideTip];
}

- (IBAction)btnCancelClicked:(UIButton *)sender {
    [self clickEmpty];
}

- (IBAction)btnSureClicked:(UIButton *)sender {
//    if (_selectedIndex == -1) {
//        //DLog(@"请选择编号");
//        
//        [self clickEmpty];
//        return;
//    }
    
    [self resignGuideTip];
    if (_delegate && [_delegate respondsToSelector:@selector(lightNumbered:meshAddr:selectedIndex:)]) {
        [_delegate lightNumbered:NumberButtonTypeSure meshAddr:(_pushLed ? _pushLed.meshAddress : -1) selectedIndex:_selectedIndex];
    }
}
@end
