//
//  D5FileModules.m
//  D5Home_new
//
//  Created by PangDou on 16/1/9.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import "D5FileModules.h"
#import "D5PhoneMessage.h"

@implementation D5FileModules

+ (NSString *)userTempPath:(NSString *)user {
    @autoreleasepool {
        NSString *tempDir = NSTemporaryDirectory();
        NSString *path = [tempDir stringByAppendingPathComponent:user];
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL isExist = [fm fileExistsAtPath:path isDirectory:&isDir];
        if (!isExist) {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return path;
    }
}

+ (NSString *)configurePath:(NSString *)fileName {
    @autoreleasepool {
        NSString *path = [D5FileModules userFilePath:@""];
        return [path stringByAppendingPathComponent:fileName];
    }
}

+ (NSString *)userFilePath:(NSString *)user {
    @autoreleasepool {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *userPath = [path stringByAppendingPathComponent:user];
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL isExist = [fm fileExistsAtPath:userPath isDirectory:&isDir];
        if (!isExist) {
            [fm createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return userPath;
    }
}

+ (NSString *)tempPath {
    @autoreleasepool  {
        NSString *path = [D5FileModules userTempPath:[D5PhoneMessage identifierUUID]];
        return path;
    }
    
}

+ (NSString *)filePath {
    @autoreleasepool  {
        NSString *path = [D5FileModules userFilePath:[D5PhoneMessage identifierUUID]];
        return path;
    }
}

+ (NSString *)fileSubPath:(NSString *)subPath withFileName:(NSString *)name {
    @autoreleasepool {
        NSString *path = [D5FileModules filePath];
        NSString *desPath = [path stringByAppendingPathComponent:subPath];
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:desPath]) {
            [fm createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return [desPath stringByAppendingPathComponent:name];
    }
}

+ (NSString *)tempSubPath:(NSString *)subPath withFileName:(NSString *)name {
    @autoreleasepool {
        NSString *path = [D5FileModules tempPath];
        NSString *desPath = [path stringByAppendingPathComponent:subPath];
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:desPath] ) {
            [fm createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return [desPath stringByAppendingPathComponent:name];
    }
}

+ (NSString *)fileDataPath:(NSString *)name {
    @autoreleasepool {
        return [D5FileModules fileSubPath:@"data" withFileName:name];
    }
}

+ (NSString *)fileListPath:(NSString *)name {
    @autoreleasepool {
        return [D5FileModules fileSubPath:@"list" withFileName:name];
    }
}

+ (NSString *)imagePath:(NSString *)name {
    return [D5FileModules tempSubPath:FILETYPE_IMAGE withFileName:name];
}

+ (NSString *)videoPath:(NSString *)name {
    return [D5FileModules tempSubPath:FILETYPE_VIDEO withFileName:name];
}

+ (NSString *)audioPath:(NSString *)name {
    return [D5FileModules tempSubPath:FILETYPE_AUDIO withFileName:name];
}

@end
