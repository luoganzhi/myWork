//
//  D5DownloadList.m
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/10.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5DownloadList.h"

@implementation D5DownloadList

static D5DownloadList* obj = nil;

+(D5DownloadList*)shareInstance{
  
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        obj = [[D5DownloadList alloc]init];
    });
    
    
    return obj;
}

-(NSMutableArray*)list{

    if (_list == nil) {
        
        _list = [NSMutableArray array];
    }
    
    return _list;
}
@end
