//
//  D5NetRecvieDataArray.h
//  D5Home
//
//  Created by anthonyxoing on 15/9/25.
//  Copyright © 2015年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DATA_FROM_IP @"recive_data_from_ip"
#define DATA_RECIVE @"recive_data"
#define DATA_RECIVE_TYPE @"network_type"

typedef enum __recive_data_type {
    data_from_udp = 10000,
    data_from_tcp
}D5ReciveDataType;

@interface D5NetRecvieDataArray : NSObject

@property (nonatomic,retain) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isCasted;
- (void)addUdpData:(NSData *)data from:(NSString *)IP;
- (void)addTcpData:(NSData *)data;

@end
