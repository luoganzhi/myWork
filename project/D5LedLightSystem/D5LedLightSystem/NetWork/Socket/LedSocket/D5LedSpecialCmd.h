//
//  D5LedSpecialCmd.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/16.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedSendReceiveCmd.h"

typedef enum _special_cmd_type {
    SpecialCmdTypeBroadCast = 1,    // 广播
    SpecialCmdTypeHeart,            // 心跳
    SpecialCmdTypePush              // 推送
}SpecialCmdType;

@interface D5LedSpecialCmd : D5LedSendReceiveCmd

@property (nonatomic, assign) SpecialCmdType cmdType;

/**
 关闭广播(不再接收广播)
 */
- (void)closeBroadCast;

/**
 结束接收数据
 */
- (void)finishReceive;
@end
