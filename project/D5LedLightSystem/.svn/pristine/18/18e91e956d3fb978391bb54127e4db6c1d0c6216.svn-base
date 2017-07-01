//
//  NSData+Helper.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/10/20.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "NSData+Helper.h"

@implementation NSData (Helper)
- (NSString *)hexStringFromData {
    
    if (!self || [self length] == 0) {
        return @"";
    }
    Byte *bytes = (Byte *)[self bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for (int i = 0 ;i < [self length];i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",(bytes[i])&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    //    //DLog(@"%@",hexStr);
    
    return hexStr;
}


@end
