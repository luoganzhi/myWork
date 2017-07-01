//
//  D5LedInitialInfoData.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D5LedInitialInfoData : NSObject

@property (nonatomic, assign) BOOL isFirstNoBox;
@property (nonatomic, assign) BOOL isFirstNoLights;
@property (nonatomic, copy) NSString *deviceToken;

+ (D5LedInitialInfoData *)sharedLedInitialInfoData;
- (D5LedInitialInfoData *)initWithDict:(NSDictionary *)dict;
+ (D5LedInitialInfoData *)dataWithDict:(NSDictionary *)dict;

- (BOOL)saveInfo;
@end
