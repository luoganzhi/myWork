//
//  D5LedModule.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5DeviceModule.h"

@protocol D5LedReceiveDataDelegate <NSObject>

@optional
- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip;//ip 局域网ip，远程填nil

@end

@protocol D5LedNetWorkErrorDelegate <NSObject>

@optional
- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header;

@end

@interface D5LedModule : D5DeviceModule

@property (nonatomic, strong) D5CmdMuticast *resultMuticast;

+ (D5LedModule *)sharedLedModule;

@end
