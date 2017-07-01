//
//  D5DeviceProtocol.h
//  D5Home
//
//  Created by anthonyxoing on 4/2/15.
//  Copyright (c) 2015年 anthonyxoing. All rights reserved.
//

#ifndef D5Home_D5DeviceProtocol_h
#define D5Home_D5DeviceProtocol_h

#define CMD_DATA @"data"
#define CMD_IP   @"ip"
#define CMD_TAG  @"tag"
#define CMD_VIEWCONTROLLER @"viewController"
#define CMD_SEQUENCE @"sequence"

#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "D5BigLittleEndianExchange.h"
#import "D5SocketBaseTool.h"
#import "D5DeviceNetWork.h"
#import "D5DeviceMutiCast.h"

typedef enum _SOCKET_ERROR{
    socket_time_out = 1,
    socket_network_error,
    socket_value_error
}D5SocketErrorCode;

#endif
