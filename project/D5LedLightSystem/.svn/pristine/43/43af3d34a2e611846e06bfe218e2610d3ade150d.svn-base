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
+(int)changeInt:(int)number;
+(long)changeLong:(long)number;
+(short)changeShort:(short)number;
+ (long long)changeMac:(long long)mac;
@end
