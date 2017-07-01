//
//  D5ConnectedViewController.h
//  D5LedLightSystem
//
//  Created by ZY on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//  修改记录:
//      ZY 2016-11-03 给方法加注释
//

#import "D5BaseViewController.h"
#import "D5RoundProgressView.h"
#import "D5ConnectZKTCell.h"

#define SEARCH_BOX_TIME_INTERVAL 30.0f

#define NO_SELECT_INDEX -1
#define ZKT_HELP_HTML_NAME @"help"
#define CONNECTED_VC_ID @"CONNECTED_VC"

@protocol D5ConnectedViewControllerDelegate <NSObject>

/**
 密码是否输入完成（8位及以上）

 @param isFinished 是否输入完成
 */
- (void)enterPwdFinish:(BOOL)isFinished;

/**
 从搜索出来的列表中选择了一个中控

 @param selectedIdentify 选中的中控identify
 */
- (void)selectedBoxChanged:(NSString *)selectedIdentify;

@optional

/**
 点击了连接帮助
 */
- (void)helpClick;

/**
 在labelFrame处添加引导提示

 @param labelFrame labelFrame
 */
- (void)addGuideTipWithFrame:(CGRect)labelFrame;

@end

@interface D5ConnectedViewController : D5BaseViewController

@property (nonatomic, weak) id<D5ConnectedViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet D5RoundProgressView *countDownView;

/** WIFI */
//@property (weak, nonatomic) IBOutlet UIButton *wifiLabel;
//@property (weak, nonatomic) IBOutlet UITextField *wifiPwdTF;

/** 搜索成功view */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImgView;

/** 搜出来的中控数组 */
@property (nonatomic, strong) NSMutableArray *zktBoxArr;

/** 选中的中控identify */
@property (nonatomic, copy) NSString *selectedIdentify;

/** 当前vc的高度 */
@property (nonatomic, assign) CGFloat height;

//@property (nonatomic, assign) BOOL canEditPwdTF;

/**
 初始化显示搜索结果的View
 */
- (void)initBottomView;

/**
 初始化中间Scrollview
 */
- (void)initConnectScrollView;

/**
 设置View状态 -- 搜索中
 */
- (void)searchBoxIng;

/**
 设置view状态 -- 搜索失败
 */
- (void)searchBoxFailed;

/**
 设置view状态 -- 搜索到了中控，但还在搜索
 */
- (void)searchBoxSearched;

/**
 设置view状态 -- 搜索到了并结束搜索
 */
- (void)searchBoxSuccess;

//- (void)changeConstraint;

@end
