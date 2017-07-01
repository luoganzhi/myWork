//
//  D5String.m
//  D5Home_new
//
//  Created by 黄斌 on 15/12/16.
//  Copyright © 2015年 com.pangdou.d5home. All rights reserved.
//

#import "D5String.h"
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#import <sys/utsname.h>

#define PHONE_NUMBER_REGEX_STRING @"\\+?\\d*\\-?\\d+"

#define STRING_FOR_D5_CONTENT_FIElD_INTERVAL @"~"
#define STRING_FOR_D5_CONTENT_OBJECT_INTERVAL @"#"
#define STRING_FOR_D5_LEVEL_ONE @";"
#define STRING_FOR_D5_LEVEL_TWO @","
#define STRING_FOR_D5_BEGIN @"D5"
#define STRING_FOR_D5_END @"SIGN"

#define SEND_STRING_FOR_D5_CONTENT_FIElD_INTERVAL @"@-_-@"
#define SEND_STRING_FOR_D5_CONTENT_OBJECT_INTERVAL @"@^_^@"
#define SEND_STRING_FOR_D5_LEVEL_ONE @"-@_@-"
#define SEND_STRING_FOR_D5_LEVEL_TWO @"^@_@^"
#define SEND_STRING_FOR_D5_BEGIN @"_@-@_"
#define SEND_STRING_FOR_D5_END @"_@^@_"

#define CANNOT_INPUT_EMOJI  @"不能输入表情 --" //CUSTOMLOCAL_STRING_NORMAL(@"Can't_input_emoji")

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24)

@implementation D5String

+ (void)stringLengthLimitMax:(NSInteger)max sender:(UIView *)sender tip:(NSString *)tip {
    @autoreleasepool {
        if (sender) {
            NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; //键盘输入模式
            
            if ([sender isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)sender;
                NSString *text = textField.text;
                
                int emojiLen = [self stringContainsEmoji:text];
                if (emojiLen > 0) {
                    textField.text = [text substringWithRange:NSMakeRange(0, text.length - emojiLen)];
                    text = textField.text;
                    [MBProgressHUD showMessage:CANNOT_INPUT_EMOJI toView:nil location:MBProgressHUDLocationCenter];
                    return;
                }
                
                if ([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
                    UITextRange *selectedRange = [textField markedTextRange]; //获取高亮部分
                    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0]; // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                    if (!position) {
                        if ([D5String isValidateString:text]) {
                            if (text.length > max) {
                                textField.text = [text substringToIndex:max];
                                [MBProgressHUD showMessage:tip toView:nil location:MBProgressHUDLocationCenter];
                            }
                        }
                    } else {// 有高亮选择的字符串，则暂不对文字进行统计和限制
                        
                    }
                } else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
                    if (text.length > max) {
                        textField.text = [text substringToIndex:max];
                        [MBProgressHUD showMessage:tip toView:nil location:MBProgressHUDLocationCenter];
                    }
                }

            } else if ([sender isKindOfClass:[UITextView class]]) {
                UITextView *textView = (UITextView *)sender;
                NSString *text = textView.text;
                
                int emojiLen = [self stringContainsEmoji:text];
                if (emojiLen > 0) {
                    textView.text = [text substringWithRange:NSMakeRange(0, text.length - emojiLen)];
                    text = textView.text;
                    [MBProgressHUD showMessage:CANNOT_INPUT_EMOJI toView:nil location:MBProgressHUDLocationCenter];
                    return;
                }
                
                if ([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
                    UITextRange *selectedRange = [textView markedTextRange]; //获取高亮部分
                    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0]; // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                    if (!position) {
                        if ([D5String isValidateString:text]) {
                            if (text.length > max) {
                                textView.text = [text substringToIndex:max];
                                [MBProgressHUD showMessage:tip toView:nil location:MBProgressHUDLocationCenter];
                            }
                        }
                    } else {// 有高亮选择的字符串，则暂不对文字进行统计和限制
                        
                    }
                } else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
                    if (text.length > max) {
                        textView.text = [text substringToIndex:max];
                        [MBProgressHUD showMessage:tip toView:nil location:MBProgressHUDLocationCenter];
                    }
                }
            }
        }
    }
}

+ (NSString *)trime:(NSString *)text {
    return text ? [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"";
}

+ (BOOL)isValidateMobile:(NSString *)mobile withZone:(NSString *)zone withAreaArray:(NSArray *)areaArray {
    @autoreleasepool {
        BOOL isValidate = NO;
        int compareResult = 0;
        NSString *nowZone = [zone stringByReplacingOccurrencesOfString:@"+" withString:@""];
        for (int i = 0;i < areaArray.count; i++) {
            @autoreleasepool {
                NSDictionary *dict1 = [areaArray objectAtIndex:i];
                NSString *code1 = [dict1 valueForKey:@"zone"];
                if([code1 isEqualToString:nowZone]){
                    compareResult = 1;
                    NSString *rule1 = [dict1 valueForKey:@"rule"];
                    if ([@"86" isEqualToString:nowZone]) {
                        rule1 = @"^1(3[0-9]|4[57]|5[0-9]|77|8[0-9])\\d{8}$";
                    }
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule1];
                    isValidate = [pred evaluateWithObject:mobile];
                    break;
                }
            }
        }
        if (compareResult == 0) {
            if (mobile.length != 11) {
                isValidate = NO;
            }else{
                isValidate = YES;
            }
        }
        return isValidate;
    }
}

+ (NSArray *)getPhonesFromString:(NSString *)string {
    @autoreleasepool {
        if (string == nil) {
            return nil;
        }
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PHONE_NUMBER_REGEX_STRING options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *array = [regex matchesInString:string options:NSMatchingWithTransparentBounds range:NSMakeRange(0, string.length)];
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        for(NSTextCheckingResult *obj in array){
            if(obj && obj.range.location != NSNotFound){
                [phoneArray addObject:[string substringWithRange:obj.range]];
            }
        }
        return phoneArray;
    }

}
+ (NSString *)getPhoneFromString:(NSString *)string {
    @autoreleasepool {
        if(string == nil){
            return nil;
        }
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PHONE_NUMBER_REGEX_STRING options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result = [regex firstMatchInString:string options:NSMatchingWithTransparentBounds range:NSMakeRange(0, string.length)];
        
        if(result  && result.range.location != NSNotFound && result.range.location == 0){
            if(result.range.length == 0){
                return nil;
            }
            return [string substringWithRange:result.range];
        }else{
            return nil;
        }
    }
}

+ (NSString *)phoneTrimeZoneCode:(NSString *)phone {
    @autoreleasepool {
        NSRange range1 = [phone rangeOfString:@"+"];
        NSRange range2 = [phone rangeOfString:@"-"];
        if(range1.location != NSNotFound && range2.location != NSNotFound){
            NSArray *array = [phone componentsSeparatedByString:@"-"];
            return array.lastObject;
        }else{
            return phone;
        }
    }
}


+ (NSString *)convertStrToSend:(NSString *)sendString {
    @autoreleasepool {
        NSString *send = nil;
        send = [[[[[[sendString stringByReplacingOccurrencesOfString:STRING_FOR_D5_CONTENT_FIElD_INTERVAL withString:SEND_STRING_FOR_D5_CONTENT_FIElD_INTERVAL] stringByReplacingOccurrencesOfString:STRING_FOR_D5_CONTENT_OBJECT_INTERVAL withString:SEND_STRING_FOR_D5_CONTENT_OBJECT_INTERVAL] stringByReplacingOccurrencesOfString:STRING_FOR_D5_LEVEL_ONE withString:SEND_STRING_FOR_D5_LEVEL_ONE] stringByReplacingOccurrencesOfString:STRING_FOR_D5_LEVEL_TWO withString:SEND_STRING_FOR_D5_LEVEL_TWO] stringByReplacingOccurrencesOfString:STRING_FOR_D5_BEGIN withString:SEND_STRING_FOR_D5_BEGIN] stringByReplacingOccurrencesOfString:STRING_FOR_D5_END withString:SEND_STRING_FOR_D5_END];
        return send;
    }
}

+ (NSString *)convertStrFromSend:(NSString *)reciveString {
    @autoreleasepool {
        NSString *string = nil;
        string = [[[[[[reciveString stringByReplacingOccurrencesOfString:SEND_STRING_FOR_D5_CONTENT_FIElD_INTERVAL withString:STRING_FOR_D5_CONTENT_FIElD_INTERVAL] stringByReplacingOccurrencesOfString:SEND_STRING_FOR_D5_CONTENT_OBJECT_INTERVAL withString:STRING_FOR_D5_CONTENT_OBJECT_INTERVAL] stringByReplacingOccurrencesOfString:SEND_STRING_FOR_D5_LEVEL_ONE withString:SEND_STRING_FOR_D5_LEVEL_ONE] stringByReplacingOccurrencesOfString:SEND_STRING_FOR_D5_LEVEL_TWO withString:STRING_FOR_D5_LEVEL_TWO] stringByReplacingOccurrencesOfString:SEND_STRING_FOR_D5_BEGIN withString:STRING_FOR_D5_BEGIN] stringByReplacingOccurrencesOfString:SEND_STRING_FOR_D5_END withString:STRING_FOR_D5_END];
        return string;
    }
}

+ (BOOL)isValidateString:(NSString *)str {
    str = [D5String trime:str];
    return (str != nil) && ![str isEqual:[NSNull null]] && ![str isEqualToString:@""];
}

+ (void)setSQLiteName:(NSString *)name {
    @autoreleasepool {
        NSLog(@"name = %@", name);
//        [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"TrendData"]];
    }
}

+ (BOOL)isIphone4 {
    @autoreleasepool {
        NSString *phonemodel = [self getPhoneModel];
        if ([D5String isValidateString:phonemodel]) {
            NSRange range = [phonemodel rangeOfString:@"iPhone 4"];
            if (range.location != NSNotFound) {
                return YES;
            }
        }
        
        return NO;
    }
}

+ (NSString *)getPhoneModel {
    @autoreleasepool {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
        if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
        if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
        if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
        if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
        if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
        if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
        if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
        if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 plus";
        if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
        if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S plus";
        if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
        if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
        if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
        if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
        if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
        if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
        if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
        if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
        if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
        if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
        return @"iPhone";
    }
    
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

+ (NSString *)aeraCodeNotPlus:(NSString *)orig {
    @autoreleasepool {
        NSString *zone = orig;
        NSRange range = [zone rangeOfString:@"+"];
        if (range.location != NSNotFound) {
            zone = [zone stringByReplacingOccurrencesOfString:@"+" withString:@""];
        }
        
        return zone;
    }
}

+ (NSString *)getIPWithHostName:(const NSString *)hostName {
    @autoreleasepool {
        const char* szname = [hostName UTF8String];
        struct hostent* phot;
        @try {
            phot = gethostbyname(szname);
            if (phot == NULL) {
                return nil;
            }
        } @catch (NSException * e) {
            return nil;
        }
        
        struct in_addr ip_addr;
        memcpy(&ip_addr,phot->h_addr_list[0],4);///h_addr_list[0]里4个字节,每个字节8位，此处为一个数组，一个域名对应多个ip地址或者本地时一个机器有多个网卡
        
        char ip[20] = {0};
        inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
        
        NSString* strIPAddress = [NSString stringWithUTF8String:ip];
        return strIPAddress;
    }
}
@end
