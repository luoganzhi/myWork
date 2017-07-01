//
//  D5LedLinkDevice.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class D5LedLinkDevice;

@protocol D5LedLinkDeviceDelegate <NSObject>

@optional
- (void)ledLinkDeviceListGetFinish:(BOOL)isFinish primaryDevice:(NSDictionary *)primaryDict withSubordinateDevices:(NSArray *)deivces;

- (void)ledLinkDeviceAddFinish:(BOOL)isFinish;

- (void)ledLinkDeviceDeleteFinish:(BOOL)isFinish;

@end

@interface D5LedLinkDevice : NSObject

@property (nonatomic, weak) id<D5LedLinkDeviceDelegate> delegate;

+ (D5LedLinkDevice *)sharedInstance;

- (void)addLinkDevice:(NSString *)ip port:(int)port;

- (void)deleteLinkDevice:(NSInteger)primaryBoxID subordinateBoxID:(NSInteger)boxId;

- (void)getLinkDevice;

@end
