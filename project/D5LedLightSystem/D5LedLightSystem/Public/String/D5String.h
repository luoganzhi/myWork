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

+ (void)stringLengthLimitMax:(NSInteger)max sender:(UIView *)sender tip:(NSString *)tip;

+ (NSString *)convertStrToSend:(NSString *)sendString;      //拼接发送的字符串
+ (NSString *)convertStrFromSend:(NSString *)reciveString;  //拼接接收的字符串

+ (NSString *)trime:(NSString *)text;                       //得到去掉空格的字符串
+ (BOOL)isValidateMobile:(NSString *)mobile withZone:(NSString *)zone withAreaArray:(NSArray *)areaArray;                                   //判断是否为有效手机号
+ (NSArray *)getPhonesFromString:(NSString *)string;        //获取string中所有的手机号
+ (NSString *)getPhoneFromString:(NSString *)string;        //获取string中的手机号
+ (NSString *)phoneTrimeZoneCode:(NSString *)phone;         //获取区空格的地区code
+ (BOOL)isValidateString:(NSString *)str;
+ (void)setSQLiteName:(NSString *)name;
+ (BOOL)isIphone4;
+ (NSString *)getPhoneModel;
+ (int)stringContainsEmoji:(NSString *)string;

+ (NSString *)aeraCodeNotPlus:(NSString *)orig;
+ (NSString*)getIPWithHostName:(const NSString *)hostName;      //根据域名获取ip地址
@end
