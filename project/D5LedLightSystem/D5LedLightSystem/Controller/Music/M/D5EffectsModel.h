//
//  D5EffectsModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/10/14.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5EffectsModel : NSObject

/** 特效名 */
@property (nonatomic, copy) NSString *name;

/** 特效作者 */
@property (nonatomic, copy) NSString *author;

/** id */
@property (nonatomic, assign) int32_t effectID;

/** serverId */
@property (nonatomic, assign) int32_t serverId;

/** 配置类型 */
@property (nonatomic, assign) LedEffectType type;

@end
