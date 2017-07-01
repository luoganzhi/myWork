//
//  D5LedCommunication.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/16.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5DeviceBaseCommunication.h"

@protocol D5LedReceiveDataDelegate <NSObject>

@optional
- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip;//ip 局域网ip，远程填nil

@end

@protocol D5LedNetWorkErrorDelegate <NSObject>

@optional
- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header;

@end

@interface D5LedCommunication : D5DeviceBaseCommunication

+ (D5LedCommunication *)sharedLedModule;

@end
