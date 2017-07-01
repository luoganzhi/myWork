//
//  D5CurrentBox.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5DeviceInfo.h"

@class D5RunTimeInfo;

@interface D5CurrentBox : NSObject

/**
 * 当前中控
 */
+ (NSDictionary *)currentBox;

/**
 * 当前中控IP
 */
+ (NSString *)currentBoxIP;

/**
 * 当前中控MAC
 */
+ (NSString *)currentBoxMac;

/**
 * 当前中控IDENTIFY
 */
+ (NSString *)currentBoxId;

/**
 * 当前中控名称
 */
+ (NSString *)currentBoxName;

/**
 * 实例置空
 */
+ (void)setInstanceNil;

/**
 当前中控的的deviceInfo

 @return deviceInfo
 */
+ (D5DeviceInfo *)currentBoxDeviceInfo;

/**
 修改当前中控的的deviceInfo
 
 @return deviceInfo
 */
+ (void)setCurrentBoxDeviceInfo:(NSDictionary *)deviceInfo;

+ (void)setRunTimeInfo;

+ (int)currentBoxTCPPort;

@end
