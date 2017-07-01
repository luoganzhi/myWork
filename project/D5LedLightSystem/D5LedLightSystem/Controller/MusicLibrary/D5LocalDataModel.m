//
//  D5LocalDataModel.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/10/13.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LocalDataModel.h"

@implementation D5LocalDataModel

#pragma  mark --序列化初始
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.musicName = [aDecoder decodeObjectForKey:@"name"];
        self.musicId = [aDecoder decodeIntegerForKey:@"id"];
        self.centreBoxId = [aDecoder decodeObjectForKey:@"box"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.musicName forKey:@"name"];
    [aCoder encodeInteger:self.musicId forKey:@"id"];
    [aCoder encodeObject:self.centreBoxId forKey:@"box"];
    
}

#pragma mark - NSCoping协议
- (id)copyWithZone:(NSZone *)zone {
    
    D5LocalDataModel *copy = [[[self class] allocWithZone:zone] init];
    
    copy.musicName = [self.musicName copyWithZone:zone];
    copy.musicId = self.musicId;
    copy.centreBoxId = [self.centreBoxId copyWithZone:zone];
    return copy;
}
@end
