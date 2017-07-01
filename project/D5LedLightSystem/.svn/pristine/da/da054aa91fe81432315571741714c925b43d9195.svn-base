//
//  D5Protocol.m
//  D5Home
//
//  Created by anthonyxoing on 2/7/14.
//  Copyright (c) 2014年 anthonyxoing. All rights reserved.
//

#import "D5Protocol.h"
#import "D5LedInitialInfoData.h"
#import "D5DeviceInfo.h"

#define LED_APP_ID 20

@interface D5Protocol()

@property (nonatomic, retain) NSNumber *version;
@property (nonatomic, retain) NSNumber *platformType;
@property (nonatomic, retain) NSNumber *appId;
@property (nonatomic, retain) NSString *sysVersion;
@property (nonatomic, strong) D5LedInitialInfoData *data;

@end

@implementation D5Protocol

- (NSNumber *)appId {
    return [NSNumber numberWithInt:LED_APP_ID];
}

- (NSNumber *)platformType {
    return [NSNumber numberWithInt:D5PlatFormTypeIOS];
}

- (NSString *)sysVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (NSNumber *)version {
    @autoreleasepool {
        NSInteger build = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
        return [NSNumber numberWithInteger:build];
    }
}

- (D5LedInitialInfoData *)data {
    if (!_data) {
        _data = [D5LedInitialInfoData sharedLedInitialInfoData];
    }
    return _data;
}

#pragma mark - 检查更新
- (void)checkUpdate:(int8_t)checkType appVersion:(NSInteger)appVersion boxVersion:(NSInteger)boxVersion blueToothVersion:(NSInteger)blueToothVersion {
    @autoreleasepool {
        DLog(@"1-6 检查更新：%d, %d,%d,%d", checkType, appVersion, boxVersion, blueToothVersion);
        NSMutableDictionary *sendDict = [[NSMutableDictionary alloc] init];
        
        [sendDict setObject:[NSNumber numberWithInt:check_update] forKey:NNS_METHOD];
        [sendDict setObject:self.appId forKey:NNS_APP_ID];
        [sendDict setObject:self.platformType forKey:NNS_PLATFORM];
        
        D5DeviceInfo *info = [D5CurrentBox currentBoxDeviceInfo];
        [sendDict setObject:info ? @(info.boxAppId) : @(0) forKey:BOX_APP_ID];
        
        [sendDict setObject:[NSNumber numberWithInteger:appVersion] forKey:NNS_APP_VER];
        [sendDict setObject:[NSNumber numberWithInteger:boxVersion] forKey:NNS_ZK_VER];
        [sendDict setObject:[NSNumber numberWithInteger:blueToothVersion] forKey:NNS_BT_VER];
        
        int btType = [D5CurrentBox currentBoxDeviceInfo].btType;
        [sendDict setObject:[NSNumber numberWithInt:btType] forKey:NNS_BT_TYPE];
        
        [sendDict setObject:[NSNumber numberWithChar:checkType] forKey:NNS_TYPE];
        
        NSString *data = [self JSONString:sendDict];
        [self newSendData:data withMethod:check_update isDevice:NO];
    }
}

- (void)sendSuggestion:(NSString *)message version:(NSString *)version phoneModel:(NSString *)phoneModel{
    @autoreleasepool {
        NSMutableDictionary *sendDict = [[NSMutableDictionary alloc] init];
        [sendDict setObject:@(12) forKey:@"cmd"];
        [sendDict setObject:@(2) forKey:@"platform"];
        [sendDict setObject:version forKey:@"version"];
        [sendDict setObject:phoneModel forKey:@"phone_model"];
        [sendDict setObject:message forKey:@"content"];
        
        NSString *data = [self JSONString:sendDict];
        [self newSendData:data withMethod:send_suggestion isDevice:NO];
    }
}

- (void)spotCMD:(NSInteger)cmd MusicId:(NSInteger)musicId Cid:(NSInteger)cid
{
    NSMutableDictionary *sendDict = [[NSMutableDictionary alloc] init];
    [sendDict setObject:@(cmd) forKey:@"cmd"];
    [sendDict setObject:@(musicId) forKey:@"mid"];
    [sendDict setObject:@(cid) forKey:@"cid"];
    
    NSString *data = [self JSONString:sendDict];
    //DLog(@"%@" , data);
    [self newSendData:data withMethod:spot_music isDevice:NO];
   
}

@end
