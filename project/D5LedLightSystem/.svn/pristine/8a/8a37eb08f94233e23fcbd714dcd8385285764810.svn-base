//
//  D5BigLittleEndianExchange.m
//  D5Home
//
//  Created by anthonyxoing on 6/11/14.
//  Copyright (c) 2014年 anthonyxoing. All rights reserved.
//

#import "D5BigLittleEndianExchange.h"

@implementation D5BigLittleEndianExchange
+(CPUModel)deviceCpuModel{
    union{
        short int a;
        char b;
    }temp;
    temp.a = 0x1234;
    
    if(0x12 == temp.b){
        return ENDIAN_BIG;
    }else{
        return ENDIAN_LITTLE;
    }
}
+(int)changeInt:(int)number{
    int changedNumber;
    char * p = (char *)&changedNumber;
    char * p2 = (char *)&number;
    int count = sizeof(int);
    for(int index = count - 1;index >= 0;index--){
        *p = *(p2 + index);
        p++;
    }
    return changedNumber;
}
+(long)changeLong:(long)number{
    int changedNumber;
    char * p = (char *)&changedNumber;
    char * p2 = (char *)&number;
    int count = sizeof(long);
    for(int index = count - 1;index >= 0;index--){
        *p = *(p2 + index);
        p++;
    }
    return changedNumber;
}

+(short)changeShort:(short)number{
    int changedNumber;
    char * p = (char *)&changedNumber;
    char * p2 = (char *)&number;
    int count = sizeof(short);
    for(int index = count - 1;index >= 0;index--){
        *p = *(p2 + index);
        p++;
    }
    return changedNumber;
}

+ (long long)changeMac:(long long)mac {
    long long changedMac;
    char *p = (char *)&changedMac;
    
    int len = 8;
    char phone[len];
    memset(phone, 0, len);
    
    NSMutableString *phoneStr = [NSMutableString stringWithFormat:@"%llu", mac];
    if ([phoneStr length] / 2 > 8) {
        return 0;
    }
    for (int i = 0; i < len; i ++) {
        char temp = mac % 100;
        phone[i] = temp / 10 * 16 + temp % 10;
        mac /= 100;
    }
    
    char *p2 = (char *)phone;
    int count = sizeof(long long);
    for(int index = count - 1;index >= 0;index--){
        *p = *(p2 + index);
        p++;
    }
    return changedMac;
}
@end
