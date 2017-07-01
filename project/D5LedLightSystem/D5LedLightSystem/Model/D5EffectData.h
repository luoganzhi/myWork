//
//  D5EffectData.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5EffectData : NSObject

@property (nonatomic, assign)   LedEffectType   effectType;
@property (nonatomic, assign)   int             effectId;
@property (nonatomic, assign)   int             serverId;
@property (nonatomic, copy)     NSString        *effectName;
@property (nonatomic, copy)     NSString        *author;
@property (nonatomic, assign)   LedPlayStatus   playStatus;

- (D5EffectData *)initWithDict:(NSDictionary *)dict;
+ (D5EffectData *)dataWithDict:(NSDictionary *)dict;

@end
