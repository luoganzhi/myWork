//
//  D5Protocol.h
//  D5Home
//
//  Created by anthonyxoing on 2/7/14.
//  Copyright (c) 2014年 anthonyxoing. All rights reserved.
//

#import "D5BaseProtocol.h"

@interface D5Protocol : D5BaseProtocol

- (void)checkUpdate:(int8_t)checkType appVersion:(NSInteger)appVersion boxVersion:(NSInteger)boxVersion blueToothVersion:(NSInteger)blueToothVersion;

- (void)sendSuggestion:(NSString *)message version:(NSString *)version phoneModel:(NSString *)phoneModel;

- (void)spotCMD:(NSInteger)cmd MusicId:(NSInteger)musicId Cid:(NSInteger)cid;

@end
