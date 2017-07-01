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

+ (NSString *)macNumberToString:(long long)mac {
    @autoreleasepool {
        NSMutableArray *macArray = [[NSMutableArray alloc] init];
        int count = sizeof(long long);
        char *p = (char *)&mac;
        for (int i = 0; i < count; i ++) {
            @autoreleasepool {
                char byteMac = *p++;
                NSString *str = [NSString stringWithFormat:@"%02x",(unsigned char)byteMac];
                [macArray addObject:str];
            }
        }
        return [macArray componentsJoinedByString:@":"];
    }
}

+ (NSString *)macStringToDeleteZeroStr:(NSString *)mac {
    @autoreleasepool {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray: [mac componentsSeparatedByString:@":"]];
        if ([array.firstObject isEqualToString:@"00"]) {
            [array removeObjectAtIndex:0];
        }
        if ([array.firstObject isEqualToString:@"00"]) {
            [array removeObjectAtIndex:0];
        }
        return [array componentsJoinedByString:@":"];
    }
}


+ (NSString *)macStringToPlusZeroStr:(NSString *)mac {
    @autoreleasepool {
        NSArray *arr = [mac componentsSeparatedByString:@":"];
        NSString *newMac = @"";
        if (arr.count < 8) {
            int value = 8 - (int)arr.count;
            for (int i = 1;  i <= value; i ++) {
                newMac = [newMac stringByAppendingString:@"00:"];
            }
            
            newMac = [NSString stringWithFormat:@"%@%@", newMac, mac];
        }
        return newMac;
    }
}

+ (long long)macStringToNumber:(NSString *)number {
    @autoreleasepool {
        NSArray *macArray = [number componentsSeparatedByString:@":"];
        long long mac = 0;
        for (int i = 0; i < macArray.count; i ++) {
            NSString *tempMac = [macArray objectAtIndex:i];
            long long macTemp = strtoll([tempMac UTF8String], 0, 16);
            mac = (macTemp << (8 * i)) + mac;
        }
        return mac;
    }
}

+ (NSData *)md5With32Byte:(NSString *)string {
    @autoreleasepool {
        if(string == nil){
            return nil;
        }
        const char *cStr = [string UTF8String];
        unsigned char result[16];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
        NSMutableData * md5 = [[NSMutableData alloc] init];
        unsigned char blank[16];
        memset(blank, 0, 16);
        [md5 appendBytes:blank length:16];
        [md5 appendBytes:result length:16];
        return md5;
    }
}

+ (NSString *)ipFromInt:(unsigned int)ipNum {
    @autoreleasepool {
        int count = sizeof(int);
        NSMutableArray * ipArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<count; i++) {
            @autoreleasepool {
                unsigned char byteIp = ipNum & 0xFF;
                NSString * str = [NSString stringWithFormat:@"%d",byteIp];
                [ipArray addObject:str];
                ipNum = ipNum >> 8;
            }
        }
        return [ipArray componentsJoinedByString:@"."];
    }
}
+ (NSString *)weekMessageFromByte:(Byte)week{
    NSMutableString * message = [[NSMutableString alloc] init];
    Byte mask = 1;
//    if(week == 128 || week == 0){
//        [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Single")];
//    }else if(week == 127){
//        [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Everyday")];
//    }else{
//        if((week & mask) != 0){
//            [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Mon")];
//            [message appendString:@" "];
//        }
//        
//        mask = mask << 1;
//        if((week & mask) != 0){
//            [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Tue")];
//            [message appendString:@" "];
//        }
//        
//        mask = mask << 1;
//        if((week & mask) != 0){
//            [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Wed")];
//            [message appendString:@" "];
//        }
//        
//        mask = mask << 1;
//        if((week & mask) != 0){
//            [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Thu")];
//            [message appendString:@" "];
//        }
//        
//        mask = mask << 1;
//        if((week & mask) != 0){
//            [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Fri")];
//            [message appendString:@" "];
//        }
//        
//        mask = mask << 1;
//        if((week & mask) != 0){
//            [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Sat")];
//            [message appendString:@" "];
//        }
//        
//        mask = mask << 1;
//        if((week & mask) != 0){
//            [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Sun")];
//            [message appendString:@" "];
//        }
//    }
    return message;
}
+ (NSString *)weekStringFromByte:(Byte)week{
    NSMutableString * message = [[NSMutableString alloc] init];
    Byte mask = 1;
    if(week == 128 || week == 0){
//        [message appendString:CUSTOMLOCAL_STRING_NORMAL(@"Single")];
    }else if(week == 127){
        [message appendString:@"1 2 3 4 5 6 7"];
    }else{
        if((week & mask) != 0){
            [message appendString:@"1"];
            [message appendString:@" "];
        }
        
        mask = mask << 1;
        if((week & mask) != 0){
            [message appendString:@"2"];
            [message appendString:@" "];
        }
        
        mask = mask << 1;
        if((week & mask) != 0){
            [message appendString:@"3"];
            [message appendString:@" "];
        }
        
        mask = mask << 1;
        if((week & mask) != 0){
            [message appendString:@"4"];
            [message appendString:@" "];
        }
        
        mask = mask << 1;
        if((week & mask) != 0){
            [message appendString:@"5"];
            [message appendString:@" "];
        }
        
        mask = mask << 1;
        if((week & mask) != 0){
            [message appendString:@"6"];
            [message appendString:@" "];
        }
        
        mask = mask << 1;
        if((week & mask) != 0){
            [message appendString:@"7"];
        }
    }
    return message;
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
@end
