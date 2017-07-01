//
//  D5TransferMusic.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5TransferMusic.h"
#import "NSObject+runtime.h"

static D5TransferMusic *instance = nil;

@interface D5TransferMusic() <D5LedCmdDelegate, D5LedNetWorkErrorDelegate> {
    Class _oldClass;
}

@end

@implementation D5TransferMusic

- (void)setDelegate:(id<D5TransferMusicDelegate>)delegate {
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
+ (D5TransferMusic *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[D5TransferMusic alloc] init];
    });
    return instance;
}

#pragma mark - 打开/关闭传歌服务
- (void)transferServiceOpen:(BOOL)isOpen {
    @autoreleasepool {
        D5LedNormalCmd *openTransfer = [[D5LedNormalCmd alloc] init];
        
        openTransfer.remoteLocalTag = tag_remote;
        openTransfer.remotePort = [D5CurrentBox currentBoxTCPPort];
        openTransfer.strDestMac = [D5CurrentBox currentBoxMac];
        openTransfer.remoteIp = [D5CurrentBox currentBoxIP];
        
        if (isOpen) {
            openTransfer.errorDelegate = self;
            openTransfer.receiveDelegate = self;
        }
        
        [openTransfer ledSendData:Cmd_IO_Operate withSubCmd:isOpen ? SubCmd_File_Trans_Music_On : SubCmd_File_Trans_Music_Off];
    }
}

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    @autoreleasepool {
        if (!dict) {
            return;
        }
        if (header->cmd == Cmd_IO_Operate) {
            switch (header->subCmd) {
                case SubCmd_File_Trans_Music_On: {  // 传歌服务开
                    NSDictionary *data = dict[LED_STR_DATA];
                    if (!data) {
                        return;
                    }
                    
                    int port = [data[LED_STR_PORT] intValue];
                    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(openTransferServiceFinish:ipv4:port:url:)]) {
                        [_delegate openTransferServiceFinish:YES ipv4:data[LED_STR_IPV4] port:port url:data[LED_STR_URL]];
                    }
                }
                    break;
                    
                case SubCmd_File_Trans_Music_Off: { // 传歌服务关
                    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(closeTransferServiceFinish:)]) {
                        [_delegate closeTransferServiceFinish:YES];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    @autoreleasepool {
        if (header->cmd == Cmd_IO_Operate) {
            switch (header->subCmd) {
                case SubCmd_File_Trans_Music_On: {  // 传歌服务开
                    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(openTransferServiceFinish:ipv4:port:url:)]) {
                        [_delegate openTransferServiceFinish:NO ipv4:nil port:0 url:nil];
                    }
                }
                    break;
                    
                case SubCmd_File_Trans_Music_Off: { // 传歌服务关
                    if ([self checkDelegate] && [_delegate respondsToSelector:@selector(closeTransferServiceFinish:)]) {
                        [_delegate closeTransferServiceFinish:NO];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}
@end
