//
//  D5MusicSpecialData.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/21.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_SPECIAL_DATA_HEIGHT 33

#define SPECIAL_NAME @"name"
#define SPECIAL_DJ @"user"
#define SPECIAL_ID @"serverId"

@interface D5MusicSpecialData : NSObject

@property (nonatomic, copy) NSString *specialName;
@property (nonatomic, copy) NSString *specialDJ;
/** 配置id */
@property (nonatomic, assign) NSInteger specialId;

- (D5MusicSpecialData *)initWithDict:(NSDictionary *)dict;
+ (D5MusicSpecialData *)dataWithDict:(NSDictionary *)dict;

@end
