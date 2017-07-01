//
//  D5WifiConnectedController.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2017/2/14.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5BaseViewController.h"

@interface D5WifiConnectedController : D5BaseViewController
/** 切换成功 */
@property (nonatomic, copy) void(^wifiChangeSuccessBlock)();

@end
