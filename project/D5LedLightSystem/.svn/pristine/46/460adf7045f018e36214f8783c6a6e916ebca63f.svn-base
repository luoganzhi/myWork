//
//  D5DeviceInfo.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//  登录中控后，返回的中控deviceInfo信息
//

#import <Foundation/Foundation.h>

typedef enum _net_connect_type {
    NetConnectTypeWIFI = 1,     // wifi
    NetConnectTypeWired         // 有线
}NetConnectType;

@interface D5DeviceInfo : NSObject

/** deviceInfo */
@property (nonatomic, copy)     NSString        *boxId;
@property (nonatomic, copy)     NSString        *boxName;
@property (nonatomic, copy)     NSString        *versionText;
@property (nonatomic, assign)   int             versionCode;
@property (nonatomic, assign)   NetConnectType  connectType;
@property (nonatomic, assign)   int boxAppId;

@property (nonatomic, assign) int btType;

@property (nonatomic, copy)     NSString        *btVerText;
@property (nonatomic, assign)   int             btVerCode;

@property (nonatomic, copy)     NSString        *modelName;

- (D5DeviceInfo *)initWithDict:(NSDictionary *)dict;
+ (D5DeviceInfo *)dataWithDict:(NSDictionary *)dict;

@end
