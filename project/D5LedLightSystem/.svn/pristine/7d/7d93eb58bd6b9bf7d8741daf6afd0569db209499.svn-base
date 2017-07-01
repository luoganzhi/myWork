//
//  D5DisconnectTipView.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5BaseTipView.h"

typedef enum _connect_status {
    ConnectStatusNotReConnect = 1,
    ConnectStatusReConnectIng,
    ConnectStatusReConnectSuccess,
    ConnectStatusReConnectFailed
}ConnectStatus;

@interface D5DisconnectTipView : D5BaseTipView

+ (instancetype)sharedDisconnectTipView;

@property (nonatomic, assign) ConnectStatus status;
@property (nonatomic, assign) BOOL isShow;

- (void)reConnectTCP;

@end
