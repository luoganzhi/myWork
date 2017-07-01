//
//  D5SpecialConfigModel.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/9/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5SpecialConfigModel : NSObject

/** 特效名称 */
@property (nonatomic, copy) NSString *name;

/** 特效作者 */
@property (nonatomic, copy) NSString *user;

/** 特效severID */
@property (nonatomic, assign) int32_t serverId;

/** id */
@property (nonatomic, assign) int32_t configId;

/** status */
//@property (nonatomic, assign) int32_t status;



@end
