//
//  D5LedData.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WARM_COLOR_STR @"light_warm"

#define WHITE_COLOR_STR @"light_white"
#define RED_COLOR_STR @"light_red"
#define ORANGE_COLOR_STR @"light_orange"
#define YELLOW_COLOR_STR @"light_yellow"
#define GREEN_COLOR_STR @"light_green"
#define CYAN_COLOR_STR @"light_cyan"
#define BLUE_COLOR_STR @"light_blue"
#define PURPLE_COLOR_STR @"light_purple"
#define GRAY_COLOR_STR @"light_gray"

#define OFF_OFFLINE_COLOR_STR   @"light_off_offline"
#define NOT_ADD_COLOR_STR   @"light_not_add"

@interface D5LedData : NSObject

@property (nonatomic, assign)   NSInteger       lightId;
@property (nonatomic, assign)   BOOL            isMaster;

/** LED 灯Mesh网络通信的唯一地址 */
@property (nonatomic, assign)   NSInteger       meshAddress;

@property (nonatomic, copy)     NSString        *macAddress;
@property (nonatomic, assign)   LedOnOffStatus  onoffStatus;

@property (nonatomic, assign) BOOL isSelectedDelete; // 是否被选中删除
@property (nonatomic, strong) UIColor *currentColor;// 手动里面当前颜色

- (D5LedData *)initWithDict:(NSDictionary *)dict;
+ (D5LedData *)dataWithDict:(NSDictionary *)dict;

@end
