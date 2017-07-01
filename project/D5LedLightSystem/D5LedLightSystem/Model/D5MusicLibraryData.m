//
//  D5MusicLibraryData.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicLibraryData.h"
#import "D5MusicSpecialData.h"

@implementation D5MusicLibraryData

#pragma mark - 创建D5MusicLibraryData
- (D5MusicLibraryData *)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.musicName = [dict objectForKey:MUSIC_LIST_NAME];
        self.musicSinger = [dict objectForKey:MUSIC_LIST_SINGER];
        self.musicConfigDJ = [dict objectForKey:MUSIC_LIST_CONFIG_DJ];
        self.musicId = [[dict objectForKey:MUSIC_LIST_ID] integerValue];
        self.album=[dict objectForKey:MUSIC_LIST_ALBUM];
        self.albumImage= [dict objectForKey:MUSIC_LIST_ALBUM_IMAGE];
        self.Localdata=[dict objectForKey:MUSIC_LIST_LOCALDATA];
        self.musicURL=[dict objectForKey:MUSIC_LIST_URL];
        self.curItem=[dict objectForKey:MUSIC_LIST_MEDIAITEM];
        self.albumURL=[dict objectForKey:MUSIC_LIST_ALBUM_URL];
        NSArray *arr = [dict objectForKey:MUSIC_LIST_SPECIAL];
        
        NSMutableArray *mutiArr = [NSMutableArray array];
        if (arr && arr.count > 0) {
            for (NSDictionary *dict in arr) {
                @autoreleasepool {
                    D5MusicSpecialData *data = [D5MusicSpecialData dataWithDict:dict];
                    [mutiArr addObject:data];
                }
            }
        }
        
        self.musicSpecialDatas = [NSArray arrayWithArray:mutiArr];
        self.height = [self calculateHeight:self.isShow withCount:self.musicSpecialDatas.count];
    }
    return self;
}

+ (D5MusicLibraryData *)dataWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

#pragma mark - setData
/**
 *  设置data
 *
 *  @param data
 */
- (void)setData:(D5MusicLibraryData *)data {
    @autoreleasepool {
        self.musicName = data.musicName;
        self.musicConfigDJ = data.musicConfigDJ;
        self.musicSinger = data.musicSinger;
        self.musicSpecialDatas = data.musicSpecialDatas;
        self.musicId = data.musicId;
        self.album=data.album;
        self.albumImage=data.albumImage;
        self.Localdata=data.Localdata;
        self.musicURL=data.musicURL;
        self.curItem=data.curItem;
        self.albumURL=data.albumURL;
        
        self.isShow = data.isShow;
        
        self.height = [self calculateHeight:self.isShow withCount:self.musicSpecialDatas.count];
    }
}

/**
 *  根据是否显示、以及特效数量来计算高度
 *
 *  @param isShow
 *  @param count  特效的个数
 *
 *  @return 高度
 */
- (CGFloat)calculateHeight:(BOOL)isShow withCount:(NSInteger)count {
    @autoreleasepool {
        CGFloat height = DEFAULT_LIBRARY_DATA_HEIGHT;
        if (isShow) {
            height += count * DEFAULT_SPECIAL_DATA_HEIGHT;
        }
        
        return height;
    }
}




- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.musicName = [aDecoder decodeObjectForKey:MUSIC_LIST_NAME];
        self.musicSinger = [aDecoder decodeObjectForKey:MUSIC_LIST_SINGER];
        self.musicConfigDJ = [aDecoder decodeObjectForKey:MUSIC_LIST_CONFIG_DJ];
        self.musicId = [aDecoder decodeIntegerForKey:MUSIC_LIST_ID];
        self.album =  [aDecoder decodeObjectForKey:MUSIC_LIST_ALBUM];
        self.albumImage = [aDecoder decodeObjectForKey:MUSIC_LIST_ALBUM_IMAGE];
        self.Localdata = [aDecoder decodeObjectForKey:MUSIC_LIST_LOCALDATA];
        self.musicURL=[aDecoder decodeObjectForKey:MUSIC_LIST_URL];
        self.curItem=[aDecoder decodeObjectForKey:MUSIC_LIST_MEDIAITEM];
        self.albumURL=[aDecoder decodeObjectForKey:MUSIC_LIST_ALBUM_URL];
        self.height=[aDecoder decodeFloatForKey:@"height"];
        self.isUploaded=[aDecoder decodeBoolForKey:@"Upload"];
        self.isShow=[aDecoder decodeBoolForKey:@"isShow"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:self.musicName forKey:MUSIC_LIST_NAME];
    [aCoder encodeObject:self.musicSinger forKey:MUSIC_LIST_SINGER];
    [aCoder encodeObject:self.musicConfigDJ forKey:MUSIC_LIST_CONFIG_DJ];
    [aCoder encodeInteger:self.musicId forKey:MUSIC_LIST_ID];
    [aCoder encodeObject:self.album forKey:MUSIC_LIST_ALBUM];
    [aCoder encodeObject:self.albumImage forKey:MUSIC_LIST_ALBUM_IMAGE];
    [aCoder encodeObject:self.Localdata forKey:MUSIC_LIST_LOCALDATA];
    [aCoder encodeObject:self.musicURL forKey:MUSIC_LIST_URL];
    [aCoder encodeObject:self.curItem forKey:MUSIC_LIST_MEDIAITEM];
    [aCoder encodeObject: self.albumURL forKey:MUSIC_LIST_ALBUM_URL];
    [aCoder encodeFloat: self.height forKey:@"height"];
    [aCoder encodeBool: self.isUploaded forKey:@"Upload"];
    [aCoder encodeBool: self.isShow forKey:@"isShow"];

    
  
    
}

/*
****
*******       copying协议实现

@property (nonatomic, copy) NSString *musicName;
@property (nonatomic, copy) NSString *musicSinger;

@property (nonatomic, copy) NSString *musicConfigDJ;

@property (nonatomic, assign) NSInteger musicId;

@property (nonatomic, strong) NSArray *musicSpecialDatas; //dict//特效
@property(nonatomic,copy)NSString*album;//专辑
@property(nonatomic,strong)NSData*Localdata;//音乐数据
@property(nonatomic,strong)NSURL*musicURL;//音乐URL
@property(nonatomic,strong)MPMediaItem*curItem;

@property (nonatomic, assign) CGFloat height;
@property(nonatomic,assign)BOOL isUploaded;//是否已经上传到中控



@property (nonatomic, assign) BOOL isShow;
*/
//- (id)copyWithZone:(NSZone *)zone
//{
//    //实现自定义浅拷贝
//    D5MusicLibraryData *data=[[self class] allocWithZone:zone];
//    data.musicName=[_musicName copy];
//    data.musicSinger=[_musicSinger copy];
//    data.musicConfigDJ=[_musicConfigDJ copy];
//    data.musicId=[]
//    
//    return data;
//}


@end


@implementation MusicModel



@end

@implementation ClassifyModel



@end

