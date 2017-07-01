//
//  NSString+URL.m
//  D5Home
//
//  Created by anthonyxoing on 2/7/14.
//  Copyright (c) 2014年 anthonyxoing. All rights reserved.
//

#import "NSString+URL.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NSString (URL)

- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                (CFStringRef)self,
                                                NULL,
                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                kCFStringEncodingUTF8));
    return encodedString;
}

@end
