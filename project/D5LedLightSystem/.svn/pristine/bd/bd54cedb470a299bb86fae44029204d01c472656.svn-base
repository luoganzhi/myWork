//
//  D5MultiLightFollowBoxData.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/10/25.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _led_box_onoff_status {
    LedBoxOnOffStatusOn = 1,
    LedBoxOnOffStatusOff,
    LedBoxOnOffStatusOffline
}LedBoxOnOffStatus;

typedef enum _led_box_tag {
    LedBoxTagPrimary = 1, //主中控
    LedBoxTagSubordinate //从中控
}LedBoxTag;

@interface D5MultiLightFollowBoxData : NSObject

@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, assign) NSInteger boxID;
@property (nonatomic, assign) LedBoxOnOffStatus onoffStatus;
@property (nonatomic, assign) LedBoxTag boxTag;

- (D5MultiLightFollowBoxData *)initWithDict:(NSDictionary *)dict;
+ (D5MultiLightFollowBoxData *)dataWithDict:(NSDictionary *)dict;

@end
