//
//  D5BigLittleEndianExchange.h
//  D5Home
//
//  Created by anthonyxoing on 6/11/14.
//  Copyright (c) 2014年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum __CPUModel{
    ENDIAN_BIG = 1,
    ENDIAN_LITTLE
}CPUModel;

@interface D5BigLittleEndianExchange : NSObject
+(CPUModel)deviceCpuModel;
+(int)changeInt:(int)number;  //32
+(long)changeLong:(long)number; //64
+(short)changeShort:(short)number; //16
+ (long long)changeMac:(long long)mac;

@end
