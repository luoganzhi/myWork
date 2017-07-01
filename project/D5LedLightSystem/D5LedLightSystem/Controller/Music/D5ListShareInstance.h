//
//  D5ListShareInstance.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5ListShareInstance : NSObject


/** 音乐列表 */
@property (nonatomic, strong) NSMutableArray *musicList;

/** 配置列表 */
@property (nonatomic, strong) NSMutableArray *effectsList;

+ (instancetype)sharedInstance;

@end
