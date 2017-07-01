
//
//  D5ManualMode.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ManualMode.h"
#import "NSObject+runtime.h"

static D5ManualMode *instance = nil;

@interface D5ManualMode () <D5LedCmdDelegate, D5LedNetWorkErrorDelegate> {
    Class _oldClass;
}

@property (nonatomic, assign) ManualSetting type;

@end

@implementation D5ManualMode

- (void)setDelegate:(id<D5ManualModeDelegate>)delegate {
    _delegate = delegate;
    _oldClass = [self objectGetClass:_delegate];
}

- (BOOL)checkDelegate {
    if (!_delegate) {
        return NO;
    }
    Class nowClass = [self objectGetClass:_delegate];
    return nowClass && (nowClass == _oldClass);
}

+ (D5ManualMode *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[D5ManualMode alloc] init];
    });
    return instance;
}

- (void)setManualMode:(BOOL)isEnter {
    @autoreleasepool {
        ManualSetting type = isEnter ? ManualOpen : ManualClose;
        
        _type = type;
        
        D5LedNormalCmd *manualSetting = [[D5LedNormalCmd alloc] init];
        manualSetting.remotePort = [D5CurrentBox currentBoxTCPPort];
        manualSetting.strDestMac =  [D5CurrentBox currentBoxMac];
        manualSetting.remoteLocalTag = tag_remote;
        manualSetting.remoteIp = [D5CurrentBox currentBoxIP];
        manualSetting.receiveDelegate = self;
        manualSetting.errorDelegate = self;
        
        NSDictionary *dict = @{LED_STR_TYPE : @(type)};
        
        [manualSetting ledSendData:Cmd_Media_Operate withSubCmd:SubCmd_Manual_Setting withData:dict];
    }
}

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    if (header->cmd == Cmd_Media_Operate && header->subCmd == SubCmd_Manual_Setting) {
        switch (_type) {
            case ManualOpen:  {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(openManualMode:isFinish:)]) {
                    [_delegate openManualMode:self isFinish:YES];
                }
            }
                
                break;
                
            case ManualClose: {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(closeManualMode:isFinish:)]) {
                    [_delegate closeManualMode:self isFinish:YES];
                }
            }
                
                break;
                
            default:
                break;
        }
    }
}

- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    if (header->cmd == Cmd_Media_Operate && header->subCmd == SubCmd_Manual_Setting) {
        switch (_type) {
            case ManualOpen:  {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(openManualMode:isFinish:)]) {
                    [_delegate openManualMode:self isFinish:NO];
                }
            }
                
                break;
                
            case ManualClose: {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(closeManualMode:isFinish:)]) {
                    [_delegate closeManualMode:self isFinish:NO];
                }
            }
                
                break;
                
            default:
                break;
        }
    }
}

@end
