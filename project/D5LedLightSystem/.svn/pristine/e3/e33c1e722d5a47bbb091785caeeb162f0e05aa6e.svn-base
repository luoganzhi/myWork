//
//  NSURL+D5Extension.m
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/11/18.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "NSURL+D5Extension.h"

@implementation NSURL (D5Extension)
+ (instancetype)D5UrlWithString:(NSString *)string{
    if ([NSString isValidateString:string]) {
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
   return [NSURL URLWithString:string];
}
@end
