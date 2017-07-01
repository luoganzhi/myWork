//
//  D5LedLinkDevice.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedLinkDevice.h"
#import "NSObject+runtime.h"

static D5LedLinkDevice *instance = nil;

@interface D5LedLinkDevice() <D5LedCmdDelegate, D5LedNetWorkErrorDelegate> {
    Class _oldClass;
}

@end

@implementation D5LedLinkDevice

- (void)setDelegate:(id<D5LedLinkDeviceDelegate>)delegate {
    _delegate = delegate;
    _oldClass = [self objectGetClass:_delegate];
}

#pragma mark - 检测代理是否存在
- (BOOL)checkDelegate {
    if (!_delegate) {
        return NO;
    }
    Class nowClass = [self objectGetClass:_delegate];
    return nowClass && (nowClass == _oldClass);
}

#pragma mark - 实例化
+ (D5LedLinkDevice *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[D5LedLinkDevice alloc] init];
    });
    return instance;
}

#pragma mark - 获取联动设备
- (void)getLinkDevice {
    @autoreleasepool {
        D5LedNormalCmd *getLinkDevice = [[D5LedNormalCmd alloc] init];
        
        getLinkDevice.strDestMac = [D5CurrentBox currentBoxMac];
        getLinkDevice.remoteLocalTag = tag_remote;
        getLinkDevice.remotePort = [D5CurrentBox currentBoxTCPPort];
        getLinkDevice.remoteIp = [D5CurrentBox currentBoxIP];
        getLinkDevice.errorDelegate = self;
        getLinkDevice.receiveDelegate = self;

        [getLinkDevice ledSendData:Cmd_Link_Operate withSubCmd:SubCmd_Link_Get];
    }
}

- (void)addLinkDevice:(NSString *)ip port:(int)port {
    @autoreleasepool {
        D5LedNormalCmd *addLink = [[D5LedNormalCmd alloc] init];
        
        addLink.strDestMac = [D5CurrentBox currentBoxMac];
        addLink.remoteLocalTag = tag_remote;
        addLink.remotePort = [D5CurrentBox currentBoxTCPPort];
        addLink.remoteIp = [D5CurrentBox currentBoxIP];
        addLink.errorDelegate = self;
        addLink.receiveDelegate = self;
        
        NSDictionary *sendDict = @{LED_STR_IPSTR : ip,
                                   LED_STR_PORT : @(port)};
        [addLink ledSendData:Cmd_Link_Operate withSubCmd:SubCmd_Link_Add withData:@{LED_STR_DEVICEINFOS : @[sendDict]}];
    }
}

- (void)deleteLinkDevice:(NSInteger)primaryBoxID subordinateBoxID:(NSInteger)boxId {
    @autoreleasepool {
        D5LedNormalCmd *deleteLink = [[D5LedNormalCmd alloc] init];
        
        deleteLink.strDestMac = [D5CurrentBox currentBoxMac];
        deleteLink.remoteLocalTag = tag_remote;
        deleteLink.remotePort = [D5CurrentBox currentBoxTCPPort];
        deleteLink.remoteIp = [D5CurrentBox currentBoxIP];
        deleteLink.errorDelegate = self;
        deleteLink.receiveDelegate = self;
        
        NSDictionary *sendDict = @{LED_STR_PRIID : @(primaryBoxID),
                                   LED_STR_SUBIDS : @[@(boxId)]};
        [deleteLink ledSendData:Cmd_Link_Operate withSubCmd:SubCmd_Link_Delete withData:sendDict];
    }
}

#pragma mark - 收到数据的处理
- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    if (!dict) {
        return;
    }
    
    if (header->cmd == Cmd_Link_Operate) {
        switch (header->subCmd) {
            case SubCmd_Link_Get: {
                NSDictionary *data = dict[LED_STR_DATA];
                if (!data) {
                    return;
                }
                
                NSDictionary *primary = data[LED_STR_PRIMARY];
                NSArray *suborinate = data[LED_STR_SUBORDINATE];
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(ledLinkDeviceListGetFinish:primaryDevice:withSubordinateDevices:)]) {
                    [_delegate ledLinkDeviceListGetFinish:YES primaryDevice:primary withSubordinateDevices:suborinate];
                }
            }
                break;
                
            case SubCmd_Link_Delete: {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(ledLinkDeviceDeleteFinish:)]) {
                    [_delegate ledLinkDeviceDeleteFinish:YES];
                }
            }
                break;
                
            case SubCmd_Link_Add: {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(ledLinkDeviceAddFinish:)]) {
                    [_delegate ledLinkDeviceAddFinish:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    if (header->cmd == Cmd_Link_Operate) {
        switch (header->subCmd) {
            case SubCmd_Link_Get: {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(ledLinkDeviceListGetFinish:primaryDevice:withSubordinateDevices:)]) {
                    [_delegate ledLinkDeviceListGetFinish:NO primaryDevice:nil withSubordinateDevices:nil];
                }
            }
                break;
                
            case SubCmd_Link_Delete: {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(ledLinkDeviceDeleteFinish:)]) {
                    [_delegate ledLinkDeviceDeleteFinish:NO];
                }
            }
                break;
                
            case SubCmd_Link_Add: {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(ledLinkDeviceAddFinish:)]) {
                    [_delegate ledLinkDeviceAddFinish:NO];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

@end
