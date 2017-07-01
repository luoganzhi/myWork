//
//  D5NetRecvieDataArray.m
//  D5Home
//
//  Created by anthonyxoing on 15/9/25.
//  Copyright © 2015年 anthonyxoing. All rights reserved.
//

#import "D5NetRecvieDataArray.h"

@implementation D5NetRecvieDataArray
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)addUdpData:(NSData *)data from:(NSString *)IP {
    @autoreleasepool {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:data_from_udp] forKey:DATA_RECIVE_TYPE];
        [dic setObject:IP forKey:DATA_FROM_IP];
        [dic setObject:data forKey:DATA_RECIVE];
        [self.dataArray addObject:dic];
    }
}

- (void)addTcpData:(NSData *)data{
    @autoreleasepool {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:data_from_tcp] forKey:DATA_RECIVE_TYPE];
        [dic setObject:data forKey:DATA_RECIVE];
        [self.dataArray addObject:dic];
    }
}
@end
