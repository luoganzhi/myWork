//
//  D5Cache.m
//  D5Home
//
//  Created by anthonyxoing on 17/7/14.
//  Copyright (c) 2014年 anthonyxoing. All rights reserved.
//

#import "D5Cache.h"

@implementation D5Cache

#pragma mark - video audio
+ (NSData *)tempData:(NSString *)type withName:(NSString *)name {
    if ([type isEqualToString:FILETYPE_AUDIO]) {
        return [NSData dataWithContentsOfFile:[D5FileModules audioPath:name]];
    }
    return [NSData dataWithContentsOfFile:[D5FileModules videoPath:name]];
}

+ (void)cacheTemp:(NSString *)type withData:(NSData *)data withName:(NSString *)name {
    if ([type isEqualToString:FILETYPE_VIDEO]) {
         [data writeToFile:[D5FileModules videoPath:name] atomically:YES];
    } else {
         [data writeToFile:[D5FileModules audioPath:name] atomically:YES];
    }
}

#pragma mark - image cache
+ (UIImage *)imageWithName:(NSString *)name {
    @autoreleasepool  {
        NSString *imagePath = [D5FileModules imagePath:name];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        return image;
    }
}

+ (void)cacheImage:(NSString *)name withImage:(UIImage *)image {
    @autoreleasepool  {
        NSString *imagePath = [D5FileModules imagePath:name];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        [imageData writeToFile:imagePath atomically:YES];
    }
}

#pragma mark - cache list
+ (NSArray *)listData:(NSString *)name {
    @autoreleasepool {
        NSArray *list = [NSArray arrayWithContentsOfFile:[D5FileModules fileListPath:name]];
        return list;
    }
}

+ (void)cacheList:(NSArray *)list withName:(NSString *)name {
    BOOL isSave = [list writeToFile:[D5FileModules fileListPath:name] atomically:YES];
    //DLog(@"isSave = %d", isSave);
}

#pragma mark - cache info
+ (NSDictionary *)infoData:(NSString *)name  {
    return [NSDictionary dictionaryWithContentsOfFile:[D5FileModules fileDataPath:name]];
}

+ (void)cacheInfo:(NSDictionary *)info withName:(NSString *)name {
    [info writeToFile:[D5FileModules fileDataPath:name] atomically:YES];
}
@end
