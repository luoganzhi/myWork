//
//  NSString+Helper.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/27.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "NSString+Helper.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation NSString (Helper)

- (BOOL)isNULL {
    if (self == nil || self == NULL  || [self isEqual:[NSNull null]]|| [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString*)removeSongSuffix {
    
    if (self.length>4&&[[self substringFromIndex:self.length-4] isEqualToString:@".mp3"]) {
       
        return [self substringToIndex:self.length-4];
    }
    else
    {
        return  self;
    }
   

}

+ (NSString *)trime:(NSString *)text {
    @autoreleasepool {
        NSString *result = @"";
        if (text && [text isKindOfClass:[NSString class]]) {
            result = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        return result;
    }
}

+ (BOOL)isValidateString:(NSString *)str {
    str = [self trime:str];
    return (str != nil) && ![str isEqual:[NSNull null]] && ![str isEqualToString:@""];
}

+ (int)stringContainsEmoji:(NSString *)string {
    @autoreleasepool {
        //        __block BOOL returnValue = NO;
        __block NSInteger strLength = 0;
        [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                                   options:NSStringEnumerationByComposedCharacterSequences
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    const unichar hs = [substring characterAtIndex:0];
                                    if (0xd800 <= hs && hs <= 0xdbff) {
                                        if (substring.length > 1) {
                                            const unichar ls = [substring characterAtIndex:1];
                                            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                            if (0x1d000 <= uc && uc <= 0x1f77f) {
                                                //                                                returnValue = YES;
                                                strLength = substring.length;
                                                *stop = YES;
                                            }
                                        }
                                    } else if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        if (ls == 0x20e3) {
                                            strLength = substring.length;
                                            *stop = YES;
                                        }
                                    } else {
                                        if (0x2100 <= hs && hs <= 0x27ff) {
                                            strLength = substring.length;
                                            *stop = YES;
                                        } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                            strLength = substring.length;
                                            *stop = YES;
                                        } else if (0x2934 <= hs && hs <= 0x2935) {
                                            strLength = substring.length;
                                            *stop = YES;
                                        } else if (0x3297 <= hs && hs <= 0x3299) {
                                            strLength = substring.length;
                                            *stop = YES;
                                        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                            strLength = substring.length;
                                            *stop = YES;
                                        }
                                    }
                                }];
        
        return (int)strLength;
    }
}

+ (NSInteger)integerFromString:(NSString *)string {
    @autoreleasepool {
        if (![NSString isValidateString:string]) {
            return 0;
        }
        
        NSScanner *scanner = [NSScanner scannerWithString:string];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
        
        NSInteger number;
        [scanner scanInteger:&number];
        
        return number;
    }
}

- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
}


+(NSString *)getCentreBoxIP
{
    NSDictionary*centreBoxDic = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_ZKT_KEY];
    
  return [centreBoxDic objectForKey:ZKT_BOX_IP];
    
}
+(NSString *)getCentreBoxMac
{
    NSDictionary*centreBoxDic = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_ZKT_KEY];
    
    return [centreBoxDic objectForKey:ZKT_BOX_MAC];
}

+ (NSString *)base64URLStrFromStr:(NSString *)urlStr {
    @autoreleasepool {
        if (![NSString isValidateString:urlStr]) {
            return @"";
        }
        NSData *basicAuthCredentials = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64AuthCredentials = [basicAuthCredentials base64EncodedStringWithOptions:0];
        
        base64AuthCredentials = [base64AuthCredentials URLEncodedString];
        
        return base64AuthCredentials;
    }
}
@end
