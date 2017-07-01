//
//  D5SocketBaseTool.m
//  D5Home_new
//
//  Created by PangDou on 16/1/25.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import "D5SocketBaseTool.h"
#import <CommonCrypto/CommonDigest.h>

#import <netinet/in.h>
#import <arpa/inet.h>
#include <stdlib.h>

@implementation D5SocketBaseTool

+ (NSString *)macFormatStrFromStr:(NSString *)str {
    @autoreleasepool {
        if (![NSString isValidateString:str]) {
            return nil;
        }
        
        NSString *tempString = nil;
        if ((str.length % 2) != 0) {
            tempString = [NSString stringWithFormat:@"0%@", str];
        } else {
            tempString = str;
        }
        
        NSRange rang;
        rang.location = 0;
        rang.length = 2;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        while (rang.location < tempString.length) {
            @autoreleasepool {
                NSString * temp = [tempString substringWithRange:rang];
                [array addObject:temp];
                rang.location = rang.location + 2;
            }
        }
        if(array.count < 6){
            int len = 6 - (int)array.count;
            for (int i = 0; i < len; i ++) {
                [array insertObject:@"00" atIndex:0];
            }
        }
        return [array componentsJoinedByString:@":"];
    }
}

+ (NSString *)strFromMacFormatStr:(NSString *)macStr {
    @autoreleasepool {
        if (![NSString isValidateString:macStr]) {
            return nil;
        }
        
        NSArray *arr = [macStr componentsSeparatedByString:@":"];
        NSString *tempStr = nil;
        if (arr && arr.count > 0) {
            tempStr = [arr componentsJoinedByString:@""]; //拼接字符串
        }
        return tempStr;
    }
}

+ (long long)macLongLongFromStr:(NSString *)str {
    @autoreleasepool {
        if (![NSString isValidateString:str]) {
            return 0L;
        }
        
        NSString *tempString = nil;
        if ((str.length % 2) != 0) {
            tempString = [NSString stringWithFormat:@"0%@", str];
        } else {
            tempString = str;
        }
        
        NSRange range;
        range.location = 0;
        range.length = 2;
        long long mac = 0;
        int i = 0;
        while (range.location < tempString.length) {
            @autoreleasepool {
                NSString * temp = [tempString substringWithRange:range];
                
                long long macTemp = strtoll([temp UTF8String], 0, 16);
                mac = (macTemp << (8 * i)) + mac;
                
                range.location = range.location + 2;
                i ++;
            }
        }
        return mac;
    }
}

+ (Byte *)macByteArrFromLong:(long long)mac {
    @autoreleasepool {
        int len = 6;
        NSData *macData = [NSData dataWithBytes:&mac length:len];
        
        Byte *byteData = (Byte *)(malloc(len));
        memset(byteData, 0, len);
        memcpy(byteData, [macData bytes], len);

        return byteData;
    }
}

+ (Byte *)macByteArrFromStr:(NSString *)str {
    @autoreleasepool {
        long long mac = [self macLongLongFromStr:str];
        return [self macByteArrFromLong:mac];
    }
}

+ (long long)macLongLongFromMacFormatStr:(NSString *)macFormatStr {
    @autoreleasepool {
        long long mac = 0L;
        if (![NSString isValidateString:macFormatStr]) {
            return mac;
        }
        
        NSArray *macArray = [macFormatStr componentsSeparatedByString:@":"];
        if (macArray && macArray.count > 0) {
            for (int i = 0; i < macArray.count; i ++) {
                NSString *tempMac = [macArray objectAtIndex:i];
                long long macTemp = strtoll([tempMac UTF8String], 0, 16);
                mac = (macTemp << (8 * i)) + mac;
            }
        }
        return mac;
    }
}

+ (NSString *)macFormatStrFromLongLongMac:(long long)mac {
    @autoreleasepool {
        if (mac == 0L) {
            return nil;
        }
        
        NSMutableArray *macArray = [[NSMutableArray alloc] init];
        char *p = (char *)&mac;
        for (int i = 0; i < 6; i ++) {
            @autoreleasepool {
                char byteMac = *p ++;
                NSString *str = [NSString stringWithFormat:@"%02x",(unsigned char)byteMac];
                
                if (byteMac == 0) {
                    [macArray insertObject:str atIndex:0]; //如果为00，则放在最前面
                } else {
                    [macArray addObject:str];
                }
            }
        }
        return [macArray componentsJoinedByString:@":"];
    }
}

+ (NSString *)macFormatStrFromMacCharArr:(char [6])macArr {
    @autoreleasepool {
        NSMutableArray *macArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i ++) {
            @autoreleasepool {
                Byte temp = macArr[i];
                NSString *str = [NSString stringWithFormat:@"%02x",(unsigned char)temp];
                
                if (temp == 0) {
                    [macArray insertObject:str atIndex:0]; //如果为00，则放在最前面
                } else {
                    [macArray addObject:str];
                }
            }
        }
        return [macArray componentsJoinedByString:@":"];
    }
}

+ (NSString *)macFormatStrFromMacByte:(Byte *)mac {
    @autoreleasepool {
        if (!mac) {
            return nil;
        }
        
        NSMutableArray *macArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i ++) {
            @autoreleasepool {
                Byte temp = mac[i];
                NSString *str = [NSString stringWithFormat:@"%02x",(unsigned char)temp];
                
                if (temp == 0) {
                    [macArray insertObject:str atIndex:0]; //如果为00，则放在最前面
                } else {
                    [macArray addObject:str];
                }
            }
        }
        return [macArray componentsJoinedByString:@":"];
    }
}

+ (NSString *)ipFromInt:(unsigned int)ipNum {
    @autoreleasepool {
        int count = sizeof(int);
        NSMutableArray * ipArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<count; i++) {
            @autoreleasepool {
                //从低位取出ip数值
                unsigned char byteIp = ipNum & 0xFF;
                NSString * str = [NSString stringWithFormat:@"%d",byteIp];
                [ipArray addObject:str];
               //移动位数
                ipNum = ipNum >> 8;
            }
        }
        //数组反过来排列
      NSArray*  reverseIpArray= [[ipArray reverseObjectEnumerator]allObjects];
        return [reverseIpArray componentsJoinedByString:@"."];
    }
}

+ (uint32_t)ipFromString:(NSString *)ipStr {
    @autoreleasepool {
        if ([NSString isValidateString:ipStr]) {
            NSArray *byteStrs = [ipStr componentsSeparatedByString:@"."];
            NSUInteger count = 0;
            if (byteStrs) {
                count = byteStrs.count;
            }
            
            if (count > 0) {
                uint32_t value = 0;
                for (int i = 0; i < count; i ++) {
                    @autoreleasepool {
                        uint8_t byte = [byteStrs[i] intValue] & 0xFF;
                        value = (value | byte);
                        if (i == count - 1) {
                            break;
                        }
                        
                        value = (value << 8);
                    }
                }
                return value;
            }
        }
        return 0;
    }
}

+(long long)getPhoneNumber:(long long)phoneMac{
    char * phoneByte = (char *)&phoneMac;
    long long mac = 0;
    for(int i = 0;i< 8;i++){
        unsigned char key = phoneByte[i];
        unsigned int temp = (key / 16 * 10 + key % 16) ;
        mac = mac + temp * pow(100,i);
    }
    return mac;
    
}

//普通字符串转换为十六进制的
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i= 0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}
@end
