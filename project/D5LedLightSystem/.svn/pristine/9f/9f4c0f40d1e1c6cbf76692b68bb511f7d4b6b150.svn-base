//
//  D5CheckUpdate.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5UpdateModel.h"

typedef enum _check_status {
    CheckUpdateStatusNotCheck,  // 未检查
    CheckUpdateStatusIng,       // 检查中
    CheckUpdateStatusFinish     // 检查完成
}CheckUpdateStatus;

#define CHECK_UPDATE_APP_FINISH_PUSH_NAME @"check_update_app_finish"
#define CHECK_UPDATE_BOX_FINISH_PUSH_NAME @"check_update_box_finish"
#define CHECK_UPDATE_BT_FINISH_PUSH_NAME @"check_update_bt_finish"

#define BT_UPDATE_FINISH_PUSH_NAME      @"bt_update_finish"

#define SHOW_UPDATE_BOX_RED_POINT   @"show_update_box_red_point"
#define SHOW_UPDATE_APP_RED_POINT   @"show_update_app_red_point"

@interface D5CheckUpdate : NSObject

@property (nonatomic, strong) D5UpdateModel *appUpdate;
@property (nonatomic, strong) D5UpdateModel *boxUpdate;
@property (nonatomic, strong) D5UpdateModel *bluetoothUpdate;

@property (nonatomic, assign) CheckUpdateStatus appStatus;
@property (nonatomic, assign) CheckUpdateStatus boxStatus;
@property (nonatomic, assign) CheckUpdateStatus btStatus;

+ (D5CheckUpdate *)sharedInstance;

/**
 获取当前APP版本号--buildID
 
 @return
 */
- (int)appVersionBuildID;

/**
 返回app版本号

 @return
 */
- (NSString *)appVersionText;

/**
 检查单个更新
 用当前版本号version去检测是否有更新
 
 @param type 检查类型
 @param version 当前版本号
 */
- (void)checkUpdate:(CheckUpdateType)type currentVersion:(int)version;

/**
 检查多个更新
 
 @param type 检查类型
 @param appVer 如果要检查app更新，则传当前app版本号, 否则传0
 @param boxVer 如果要检查box更新，则传当前box版本号, 否则传0
 @param blueToothVer 如果要检查blueToothp更新，则传当前blueTooth版本号, 否则传0
 */
- (void)checkUpdate:(CheckUpdateType)type appVersion:(int)appVer boxVersion:(int)boxVer blueToothVerion:(int)blueToothVer;

/**
 从服务器检查app更新，获取更新提示信息

 @param version 当前APP版本
 */
- (void)checkAppUpdateFromServer:(int)version;

/**
 检查中控更新

 @param version 当前版本
 */
- (void)checkBoxUpdate:(int)version;

/**
 检查蓝牙更新
 
 @param version 当前版本
 */
- (void)checkBlueToothUpdate:(int)version;

/**
 从苹果商店检查APP更新，获取更新地址，然后从服务器获取更新提示信息
 */
- (void)checkAppUpdate;
@end
