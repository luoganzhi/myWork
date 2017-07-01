//
//  D5NetRecvieDataArray.h
//  D5Home
//
//  Created by anthonyxoing on 15/9/25.
//  Copyright © 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DATA_FROM_IP @"receive_data_from_ip"
#define DATA_RECEIVE @"receive_data"
#define DATA_RECEIVE_TYPE @"network_type"

typedef enum __receive_data_type {
    data_from_udp = 10000,
    data_from_tcp
}D5ReceiveDataType;

@interface D5NetRecvieDataArray : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isCasted;
- (void)addUdpData:(NSData *)data from:(NSString *)IP;
- (void)addTcpData:(NSData *)data;

@end
