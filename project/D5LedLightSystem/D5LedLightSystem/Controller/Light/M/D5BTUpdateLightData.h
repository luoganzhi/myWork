//
//  D5BTUpdateLightData.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/12/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJKeyValue.h"

typedef enum _bt_update_status {
    BtUpdateStatusCompleted = 1,    // 升级完成
    BtUpdateStatusNotUpdate,        // 未升级
    BtUpdateStatusUpdating,         // 升级中
    BtUpdateStatusUpdateError,      // 升级失败
    BtUpdateStatusLightOffline      // 灯离线
}BtUpdateStatus;

@interface D5BTUpdateLightData : NSObject

@property (nonatomic, assign) int lightID;
@property (nonatomic, assign) int progress;
@property (nonatomic, assign) BtUpdateStatus updateStatus;

@end
