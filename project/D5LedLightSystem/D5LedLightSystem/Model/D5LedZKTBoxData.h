//
//  D5LedZKTBoxData.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5LedCmds.h"

@class D5DeviceInfo;
@class D5RunTimeInfo;

#define ZKT_BOX_NAME        @"DeviceName"
#define ZKT_BOX_TYPE        @"DeviceType"
#define ZKT_BOX_ID          @"DeviceIdentify"
#define ZKT_BOX_IP          @"DeviceIp"
#define ZKT_BOX_MAC         @"DeviceMac"
#define ZKT_BOX_TCP_PORT    @"DeviceTcpPort"

@interface D5LedZKTBoxData : NSObject

@property (nonatomic, copy)     NSString        *ip;
@property (nonatomic, copy)     NSString        *mac;
@property (nonatomic, copy)     NSString        *boxName;
@property (nonatomic, assign)   LedBoxLedType   ledType;
@property (nonatomic, copy)     NSString        *boxId;
@property (nonatomic, assign)   int             tcpPort;

//@property (nonatomic, strong)   D5DeviceInfo    *deviceInfo;
//@property (nonatomic, strong)   D5RunTimeInfo   *runTimeInfo;

- (D5LedZKTBoxData *)initWithDict:(NSDictionary *)dict;
+ (D5LedZKTBoxData *)dataWithDict:(NSDictionary *)dict;

+ (NSDictionary *)dictWithData:(D5LedZKTBoxData *)data;

@end
