//
//  D5HJMusicDownloadManageModel.m
//  D5LedLightSystem
//
//  Created by 黄金 on 17/1/7.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5HJMusicDownloadManageModel.h"


@interface D5HJMusicDownloadManageModel()<NSCopying,NSCoding>

@end
@implementation D5HJMusicDownloadManageModel
#pragma  mark --序列化初始
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.musicID = [aDecoder decodeObjectForKey:@"music_id"];
        self.musicName = [aDecoder decodeObjectForKey:@"music_name"];
        self.centreBoxID = [aDecoder decodeObjectForKey:@"box_id"];
        self.singer = [aDecoder decodeObjectForKey:@"music_singer"];
        self.albumTitle = [aDecoder decodeObjectForKey:@"music_albumtitle"];
        self.albumURL = [aDecoder decodeObjectForKey:@"music_albumURL"];
        self.editSelcteType = [aDecoder decodeIntegerForKey:@"music_edit"];
        self.downloadStatus = [aDecoder decodeIntForKey:@"music_status"];
        self.musicURL = [aDecoder decodeObjectForKey:@"music_url"];
        self.progress = [aDecoder decodeIntegerForKey:@"progress"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.musicID forKey:@"music_id"];
    [aCoder encodeObject:self.musicName forKey:@"music_name"];
    [aCoder encodeObject:self.centreBoxID forKey:@"box_id"];
    [aCoder encodeObject:self.singer forKey:@"music_singer"];
    [aCoder encodeObject:self.albumTitle forKey:@"music_albumtitle"];
    [aCoder encodeObject:self.albumURL forKey:@"music_albumURL"];
    [aCoder encodeInteger:self.editSelcteType forKey:@"music_edit"];
    [aCoder encodeInteger:self.downloadStatus forKey:@"music_status"];
    [aCoder encodeObject:self.musicURL forKey:@"music_url"];
    [aCoder encodeInteger:self.progress forKey:@"progress"];
    
}

#pragma mark - NSCoping协议
- (id)copyWithZone:(NSZone *)zone {
    
    
    D5HJMusicDownloadManageModel *copy = [[[self class] allocWithZone:zone] init];
    
    copy.musicID = [self.musicID copyWithZone:zone];
    copy.musicName =  [self.musicName copyWithZone:zone];
    copy.centreBoxID = [self.centreBoxID copyWithZone:zone];
    copy.singer = [self.singer copyWithZone:zone];
    copy.albumTitle = [self.albumTitle copyWithZone:zone];
    copy.albumURL = [self.albumURL copyWithZone:zone];
    copy.musicURL = [self.musicURL copyWithZone:zone];
    copy.editSelcteType = self.editSelcteType ;
    copy.downloadStatus = self.downloadStatus ;
    copy.progress = self.progress;
    return copy;
}


@end
