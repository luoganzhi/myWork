//
//  D5HomeCoder.h
//  pdCoder
//
//  Created by anthonyxoing on 16/1/26.
//  Copyright © 2016年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5HomeCoder : NSObject

/************************************************************
 函数名称 : + (NSString *)base64StringFromText:(NSString *)text
 函数描述 : 将文本转换为base64格式字符串
 输入参数 : (NSString *)text    文本
 输出参数 : N/A
 返回参数 : (NSString *)    base64格式字符串
 备注信息 :
 **********************************************************/
+ (NSString *)encode:(NSString *)text key:(NSString *)key;

/************************************************************
 函数名称 : + (NSString *)textFromBase64String:(NSString *)base64
 函数描述 : 将base64格式字符串转换为文本
 输入参数 : (NSString *)base64  base64格式字符串
 输出参数 : N/A
 返回参数 : (NSString *)    文本
 备注信息 :
 **********************************************************/
+ (NSString *)decode:(NSString *)base64 key:(NSString *)key;
@end