//
//  NSString+Helper.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)
/**
 *  str是否为空
 *
 *  @param str
 *
 *  @return 
 */
- (BOOL)isNULL;

/**
 *  string中是否包含表情
 *
 *  @param string
 *
 *  @return 字符串中表情前的字符长度
 */
+ (int)stringContainsEmoji:(NSString *)string;

/**
 *  判断str是否是有效字符串
 *
 *  @param str
 *
 *  @return 是否有效
 */
+ (BOOL)isValidateString:(NSString *)str;

/**
 *  得到去掉空格的字符串
 *
 *  @param text
 *
 *  @return 去掉空格的字符串
 */
+ (NSString *)trime:(NSString *)text;

/**
 *  从字符串string中提取数字
 *
 *  @param string
 *
 *  @return 数字
 */
+ (NSInteger)integerFromString:(NSString *)string;

- (NSString *)URLEncodedString;

//移除歌曲的后缀名
-(NSString*)removeSongSuffix;

//获取当前中控的IP和Mac 地址
+(NSString*)getCentreBoxIP;
+(NSString*)getCentreBoxMac;

/**
 将str的urlbase64加密

 @param urlStr <#urlStr description#>
 @return <#return value description#>
 */
+ (NSString *)base64URLStrFromStr:(NSString *)urlStr;
@end
