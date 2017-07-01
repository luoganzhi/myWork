//
//  D5SocketTool.h
//  D5Home_new
//
//  Created by PangDou on 16/1/25.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5SocketTool : NSObject

//将mac地址字符串转换成数字
//eg:00:08:61:51:14:08:32:28 to 0x28320814516108
+ (long long)macStringToNumber:(NSString *)number;
//将数字转换成Mac地址字符串
//eg:0x28320814516108 to 00:08:61:51:14:08:32:28
+ (NSString *)macNumberToString:(long long)mac;

//eg:00:00:ac:cf:de:09:08:07  ->  ac:cf:de:09:08:07
+ (NSString *)macStringToDeleteZeroStr:(NSString *)mac;

//eg: ac:cf:de:09:08:07  ->  00:00:ac:cf:de:09:08:07
+ (NSString *)macStringToPlusZeroStr:(NSString *)mac;

@end
