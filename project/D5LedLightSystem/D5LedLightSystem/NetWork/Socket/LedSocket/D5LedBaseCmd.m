//
//  D5LedBaseCmd.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedBaseCmd.h"
#import "D5SocketBaseTool.h"
#import "D5LedCommunication.h"
#import "D5UdpPingManager.h"

@interface D5LedBaseCmd ()

@property (nonatomic, assign) uint16_t appVersion;

@end

@implementation D5LedBaseCmd

- (instancetype)init {
    if (self = [super init]) {
        _remoteModel = ENDIAN_LITTLE;
        _sn = 0;
    }
    return self;
}

#pragma mark - setter and getter
- (NSMutableData *)receiveData {
    if (!_receiveData) {
        _receiveData = [NSMutableData data];
    }
    return _receiveData;
}

- (uint16_t)appVersion {
    @autoreleasepool {
        int build = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] intValue];
        return (uint16_t)build;
    }
}

/**
 设置strSrcMac,并且设置mac的srcMac

 @param strSrcMac
 */
- (void)setStrSrcMac:(NSString *)strSrcMac {
    _strSrcMac = strSrcMac;
    Byte *srcMacByte = [D5SocketBaseTool macByteArrFromStr:strSrcMac];
    memcpy(_mac.srcMac, srcMacByte, 6);
    
    free(srcMacByte);
    srcMacByte = NULL;
}


/**
 设置strDestMac,并且设置mac的destMac

 @param strDestMac
 */
- (void)setStrDestMac:(NSString *)strDestMac {
    @autoreleasepool {
        _strDestMac = strDestMac;
        NSString *str = [D5SocketBaseTool strFromMacFormatStr:strDestMac];
        Byte *destMacByte  = [D5SocketBaseTool macByteArrFromStr:str];
        memcpy(_mac.destMac, destMacByte, 6);
        
        free(destMacByte);
        destMacByte = NULL;
    }
}

#pragma mark - header的设置
- (void)setHeaderSn {}

- (LedHeader *)headerForCmd:(int8_t)cmd withSubCmd:(uint8_t)subCmd {
    @autoreleasepool {
        [self setHeaderSn];
        
        _header.sn = self.sn;
        _header.protocolVersion = HEADER_PROTOCAOL_VERSION;
        _header.appVersion = self.appVersion;
        _header.type = HEADER_TYPE_APP;
        _header.subType = HEADER_SUBTYPE_IOS;
        
        _header.cmd = cmd;
        _headerCmd = cmd;
        
        _header.subCmd = subCmd;
        _headerSubCmd = subCmd;
        
        _strSrcMac = SRC_MAC_STR;  // 默认手机号码
        
        memcpy(_header.srcMac, _mac.srcMac, 6);
        memcpy(_header.destMac, _mac.destMac, 6);
        
        _header.flag = 1;   // 需回复
        _header.code = HEADER_CODE;
        
        return &_header;
    }
}

+ (void)changeHeader:(LedHeader *)header remoteCpuModel:(CPUModel)remoteModel{
    CPUModel model = [D5BigLittleEndianExchange deviceCpuModel];
    if (model != remoteModel) {
        header->len = [D5BigLittleEndianExchange changeShort:header->len];
        header->code = [D5BigLittleEndianExchange changeShort:header->code];
    }
}

#pragma mark - 转换IP
- (NSString *)convertIp {
    @autoreleasepool {
        NSString *phoneIP = [D5NetWork getDeviceIp];
        __block NSString *resultIP = nil;
        if ([NSString isValidateString:phoneIP]) {
            NSArray *arr = [phoneIP componentsSeparatedByString:@"."];
            if (arr && arr.count > 0) {
                NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:arr];
                [mutableArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    @autoreleasepool {
                        if (idx == mutableArr.count - 1) {
                            [mutableArr insertObject:@"255" atIndex:mutableArr.count - 1];
                            [mutableArr removeLastObject];
                            
                            resultIP = [mutableArr componentsJoinedByString:@"."];
                        }
                    }
                }];
            }
        }
        
        return resultIP;
    }
}

#pragma mark - 添加移除cmd
- (void)startCmd {
    [[D5LedCommunication sharedLedModule].cmds addCmd:self];
}

- (void)endCmd {
    [[D5LedCommunication sharedLedModule].cmds removeCmd:self];
}

#pragma mark - 获取校验码
- (int8_t)getCheckSum:(NSData *)data {
    @autoreleasepool {
        Byte *byte = (Byte *)[data bytes];
        NSUInteger sum = 0;
        for (NSUInteger i = 0; i < [data length]; i ++) {
            sum = (Byte)byte[i] + sum;
        }
        return sum % 256;
    }
}

@end
