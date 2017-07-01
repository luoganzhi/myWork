//
//  D5PhoneMessage.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface D5PhoneMessage : NSObject

+ (NSString *)identifierUUID;
+ (NSString *)deviceToken;          //设备TOKEN

@end
