//
//  NSObject+runtime.m
//  D5NetWork
//
//  Created by anthonyxiong on 2016/11/15.
//  Copyright © 2016年 anthonyxiong. All rights reserved.
//

#import "NSObject+runtime.h"

Class object_getClass(id object);
const char *object_getClassName(id obj);

@implementation NSObject (runtime)

- (Class)objectGetClass:(__weak id)obj{
    return object_getClass(obj);
}

+ (NSString *)objectClassName:(__weak id)obj {
    return [NSString stringWithCString:object_getClassName(obj) encoding:NSUTF8StringEncoding];
}


@end
