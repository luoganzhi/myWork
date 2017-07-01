//
//  D5LedZKTBoxData.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedZKTBoxData.h"
#import "D5DeviceInfo.h"

@implementation D5LedZKTBoxData

- (D5LedZKTBoxData *)initWithDict:(NSDictionary *)dict {
    @autoreleasepool {
        if (self = [super init]) {
//            NSDictionary *deviceInfoDict = dict[LED_STR_DEVICEINFO];
//            if (deviceInfoDict) {
//                _deviceInfo = [D5DeviceInfo dataWithDict:deviceInfoDict];
//            }
//            
//            NSDictionary *runTimeInfoDict = dict[LED_STR_RUNTIMEINFO];
//            if (runTimeInfoDict) {
//                _runTimeInfo = [D5RunTimeInfo dataWithDict:runTimeInfoDict];
//            }
            
            _boxName = dict[ZKT_BOX_NAME];
            _ledType = [dict[ZKT_BOX_TYPE] intValue];
            _boxId = dict[ZKT_BOX_ID];
            _ip = dict[ZKT_BOX_IP];
            _mac = dict[ZKT_BOX_MAC];
            _tcpPort = [dict[ZKT_BOX_TCP_PORT] intValue];
        }
        return self;
    }
}

+ (D5LedZKTBoxData *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+ (NSDictionary *)dictWithData:(D5LedZKTBoxData *)data {
    @autoreleasepool {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:data.boxName ? data.boxName : @"" forKey:ZKT_BOX_NAME];
        [dict setObject:[NSNumber numberWithInt:data.ledType] forKey:ZKT_BOX_TYPE];
        [dict setObject:data.boxId ? data.boxId : @"" forKey:ZKT_BOX_ID];
        [dict setObject:data.ip ? data.ip : @"" forKey:ZKT_BOX_IP];
        [dict setObject:data.mac ? data.mac : @"" forKey:ZKT_BOX_MAC];
        [dict setObject:@(data.tcpPort) forKey:ZKT_BOX_TCP_PORT];
        
        return dict;
    }
}
@end
