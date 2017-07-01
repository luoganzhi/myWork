//
//  D5MusicLibraryData.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define DEFAULT_LIBRARY_DATA_HEIGHT 45

#define MUSIC_LIST_NAME   @"name"
#define MUSIC_LIST_SINGER  @"singer"
#define MUSIC_LIST_CONFIG_DJ @"ccc"
#define MUSIC_LIST_SPECIAL  @"configs"
#define MUSIC_LIST_ALBUM @"album"
#define MUSIC_LIST_LOCALDATA @"localdata"
#define  MUSIC_LIST_URL  @"url"
#define  MUSIC_LIST_ALBUM_IMAGE @"albumImage"
#define MUSIC_LIST_MEDIAITEM @"mediaitem"
#define MUSIC_LIST_ALBUM_URL @"albumurl"

#define MUSIC_LIST_ID  @"id"

@interface D5MusicLibraryData : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, copy) NSString *musicName;
@property (nonatomic, copy) NSString *musicSinger;

@property (nonatomic, copy) NSString *musicConfigDJ;
/** id */
@property (nonatomic, assign) NSInteger musicId;

@property (nonatomic, strong) NSArray *musicSpecialDatas; //dict//特效
@property(nonatomic,copy)NSString*album;//专辑
@property(nonatomic,strong)NSData*Localdata;//音乐数据
@property(nonatomic,strong)NSURL*musicURL;//音乐URL
@property(nonatomic,strong)UIImage*albumImage;
@property(nonatomic,copy)NSString*albumURL;//网络上获取到的专辑图片的地址
@property(nonatomic,strong)MPMediaItem*curItem;

@property (nonatomic, assign) CGFloat height;
@property(nonatomic,assign)BOOL isUploaded;//是否已经上传到中控
@property (nonatomic, assign) BOOL isSelected;//是否已经选择
@property(nonatomic,assign)BOOL isNOPermitDownload;//是否不允许下载



@property (nonatomic, assign) BOOL isShow;

- (D5MusicLibraryData *)initWithDict:(NSDictionary *)dict;
+ (D5MusicLibraryData *)dataWithDict:(NSDictionary *)dict;

- (void)setData:(D5MusicLibraryData *)data;

@end

@interface MusicModel : NSObject

@property(nonatomic,copy)NSString*musicName;
@property(nonatomic,assign)NSInteger musicID;

@end


@interface ClassifyModel : NSObject
@property(nonatomic,copy)NSString*classifyName;
@property(nonatomic,assign)NSInteger classifyID;
@end


