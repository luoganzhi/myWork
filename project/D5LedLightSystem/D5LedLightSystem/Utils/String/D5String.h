//
//  D5String.h
//  D5Home_new
//
//  Created by 黄斌 on 15/12/16.
//  Copyright © 2015年 com.pangdou.d5home. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define CANNOT_INPUT_EMOJI CUSTOMLOCAL_STRING_NORMAL(@"Can't_input_emoji")

@interface D5String : NSObject

/**
 *  如果sender中的text长度超过max,则提示tip
 *
 *  @param max    最大长度
 *  @param sender
 *  @param tip    提示信息
 */
+ (void)stringLengthLimitMax:(NSInteger)max sender:(UIView *)sender tip:(NSString *)tip;

/**
 *  判断是否为有效手机号
 *
 *  @param mobile    手机号
 *  @param zone      所在区
 *  @param areaArray 区号数组
 *
 *  @return 是否有效
 */
+ (BOOL)isValidateMobile:(NSString *)mobile withZone:(NSString *)zone withAreaArray:(NSArray *)areaArray;

/**
 *  获取string中所有的手机号
 *
 *  @param string
 *
 *  @return 所有手机号
 */
+ (NSArray *)getPhonesFromString:(NSString *)string;

/**
 *  获取string中的手机号
 *
 *  @param string
 *
 *  @return 手机号
 */
+ (NSString *)getPhoneFromString:(NSString *)string;

/**
 *  获取没有区号的电话号码
 *
 *  @param phone
 *
 *  @return
 */
+ (NSString *)phoneTrimeZoneCode:(NSString *)phone;

/**
 *  设置数据库名
 *
 *  @param name
 */
+ (void)setSQLiteName:(NSString *)name;

/**
 *  判断手机是否为IPhone4
 *
 *  @return 是否为IPhone4
 */
+ (BOOL)isIphone4;

/**
 *  获取手机型号
 *
 *  @return 手机型号
 */
+ (NSString *)getPhoneModel;

/**
 *  将+8615888888888转为8615888888888
 *
 *  @param orig
 *
 *  @return 不带+的区号电话号码
 */
+ (NSString *)aeraCodeNotPlus:(NSString *)orig;

/**
 *  根据域名获取ip地址
 *
 *  @param hostName 域名
 *
 *  @return Ip地址
 */
+ (NSString*)getIPWithHostName:(const NSString *)hostName;

/**
 *  拼接发送的字符串
 *
 *  @param sendString 要拼接的字符串
 *
 *  @return 拼接后的字符串
 */
+ (NSString *)convertStrToSend:(NSString *)sendString;

/**
 *  拼接接收的字符串
 *
 *  @param sendString 要拼接的字符串
 *
 *  @return 拼接后的字符串
 */
+ (NSString *)convertStrFromSend:(NSString *)receiveString;

/**
 *  给string添加下划线，设置颜色
 *
 *  @param string
 *  @param color
 *
 *  @return 带下划线的attriString
 */
+ (NSMutableAttributedString *)attrStringWithString:(NSString *)string fontColor:(UIColor *)color;


//当前系统版本是否IOS10
+ (BOOL)systemVersionAtLeast10;
@end
