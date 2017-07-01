//
//  D5SocketBaseTool.h
//  D5Home_new
//
//  Created by PangDou on 16/1/25.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5SocketBaseTool : NSObject


/**
 将str转成mac地址格式的字符串 如：15812345678 --> 01:58:12:34:56:78

 @param str 普通字符串
 @return mac格式的字符串(带冒号的）
 */
+ (NSString *)macFormatStrFromStr:(NSString *)str;


/**
 将mac地址格式的字符串转成不带冒号的字符串 如：01:58:12:34:56:78 --> 15812345678

 @param macStr
 @return 不带冒号的字符串
 */
+ (NSString *)strFromMacFormatStr:(NSString *)macStr;


/**
 将str转成0xstr的mac 如：15812345678 --> 0x785634125801

 @param str mac字符串
 @return long long型的mac
 */
+ (long long)macLongLongFromStr:(NSString *)str;

/**
 将char数组,长度为6的mac转成带冒号的mac字符串 如：char[0x01, 0x58, 0x28, 0x05, 0x92, 0x76] --> 01:58:12:34:56:78
 
 @param mac char数组,长度为6的mac
 @return 带冒号的mac字符串
 */
+ (NSString *)macFormatStrFromMacCharArr:(char[6])macArr;

/**
 将Byte数组,长度为6的mac转成带冒号的mac字符串 如：Byte[0x01, 0x58, 0x28, 0x05, 0x92, 0x76] --> 01:58:12:34:56:78

 @param mac Byte数组,长度为6的mac
 @return 带冒号的mac字符串
 */
+ (NSString *)macFormatStrFromMacByte:(Byte *)mac;

/**
 将long long型的mac转为byte数组格式的mac 如:0x785634125801 --> Byte[0x01, 0x58, 0x28, 0x05, 0x92, 0x76]

 @param mac
 @return Byte数组,长度为6
 */
+ (Byte *)macByteArrFromLong:(long long)mac;

/**
 将str转成byte数组格式的mac 如：15812345678 --> Byte[0x01, 0x58, 0x28, 0x05, 0x92, 0x76]

 @param str mac的str个数
 @return Byte数组,长度为6
 */
+ (Byte *)macByteArrFromStr:(NSString *)str;

/**
 将带冒号的mac格式str转为longlong型mac 如：01:58:12:34:56:78 --> 0x785634125801

 @param macFormatStr
 @return long long型的mac
 */
+ (long long)macLongLongFromMacFormatStr:(NSString *)macFormatStr;

/**
  将为longlong型mac格式转成带冒号的mac字符串 如：0x785634125801 --> 01:58:12:34:56:78

 @param mac longlong型mac
 @return 带冒号的mac字符串
 */
+ (NSString *)macFormatStrFromLongLongMac:(long long)mac;

+ (NSString *)ipFromInt:(unsigned int)ipNum;

+(long long)getPhoneNumber:(long long)phoneMac;


/**
 将ip字符串转为十六进制  如：192(c0).168(a8).1(01).231(e7) --> 0xc0a801e7

 @param ipStr
 @return 十六进制
 */
+ (uint32_t)ipFromString:(NSString *)ipStr;

//普通字符串转换为十六进制的
+ (NSString *)hexStringFromString:(NSString *)string;
@end
