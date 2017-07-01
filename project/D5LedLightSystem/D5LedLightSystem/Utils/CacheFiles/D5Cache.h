//
//  D5Cache.h
//  D5Home
//
//  Created by anthonyxoing on 17/7/14.
//  Copyright (c) 2014年 anthonyxoing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5FileModules.h"

@interface D5Cache : NSObject

#pragma mark - image cache
+ (UIImage *)imageWithName:(NSString *)name;
+ (void)cacheImage:(NSString *)name withImage:(UIImage *)image;

#pragma mark - audio and video cache
+ (NSData *)tempData:(NSString *)type withName:(NSString *)name;
+ (void)cacheTemp:(NSString *)type withData:(NSData *)data withName:(NSString *) name;

#pragma mark - list cache
+ (NSArray *)listData:(NSString *)name;
+ (void)cacheList:(NSArray *)list withName:(NSString *)name;

#pragma mark - info cache
+ (NSDictionary *)infoData:(NSString *)name;
+ (void)cacheInfo:(NSDictionary *)info withName:(NSString *)name;
@end