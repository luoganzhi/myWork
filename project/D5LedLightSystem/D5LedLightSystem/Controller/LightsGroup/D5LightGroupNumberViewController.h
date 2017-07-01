//
//  D5LightGroupNumberViewController.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BaseViewController.h"
#import "D5LedData.h"

typedef enum _btn_type {
    NumberButtonTypeCancel = 1001,
    NumberButtonTypeSure
}NumberButtonType;

#define LIGHT_GROUP_NUMBER_VC_ID @"LIGHT_GROUP_NUMBER_VC"

@protocol D5LightGroupNumberViewControllerDelegate <NSObject>

@optional
- (void)lightNumbered:(NumberButtonType)type meshAddr:(NSInteger)meshAddr selectedIndex:(NSInteger)index;

@end

@interface D5LightGroupNumberViewController : D5BaseViewController

@property (nonatomic, assign) BOOL isNewScanLight;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<D5LightGroupNumberViewControllerDelegate> delegate;
@property (nonatomic, strong) D5LedData *pushLed;

/** 在未添加的灯列表中，已编号的灯的lightId数组 */
@property (nonatomic, strong) NSMutableArray *noAddSetNoIDArr;

- (void)judgeSetNoGuide;

@end
