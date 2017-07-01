//
//  D5HLocalMusicList.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5HLocalMusicList.h"
#import "D5LocalDataModel.h"
#import "D5MusicLibraryData.h"

@interface D5HLocalMusicList() {
    __block dispatch_semaphore_t semaphore;
}

@end
typedef enum {
    kEDSupportedMediaTypeAAC = 'aac ',
    kEDSupportedMediaTypeMP3 = '.mp3'
} EDSupportedMediaType;

@implementation D5HLocalMusicList

+(D5HLocalMusicList *)shareInstance  {
    static D5HLocalMusicList*obj =  nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        obj = [[D5HLocalMusicList alloc]init];
    });
    return obj;
    
}

- (NSMutableArray *)getlocalMusicList {
    @autoreleasepool {
        NSMutableArray*array = [NSMutableArray array];
        MPMediaQuery *allMp3 = [[MPMediaQuery alloc] init];
        // 读取条件为音乐文件
        MPMediaPropertyPredicate *albumNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic] forProperty: MPMediaItemPropertyMediaType];
        //筛选器筛选
        [allMp3 addFilterPredicate:albumNamePredicate];
        //播放列表数组
        NSArray *playlist = [allMp3 collections];
        
        for (MPMediaPlaylist * list in playlist) {
            //歌曲数组
            NSArray *songs = [list items];
            
            for (MPMediaItem *song in songs) {
                @autoreleasepool {
                    //歌曲名
                    NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
                    //歌手名
                    NSString *artist = [[song valueForProperty:MPMediaItemPropertyArtist] uppercaseString];
                    //歌曲ID
                    NSNumber *songsID = [song valueForProperty:MPMediaItemPropertyPersistentID];
                    //专辑标题
                    NSString *albumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
                    //专辑图片
                    MPMediaItemArtwork *artwork = [song valueForProperty:MPMediaItemPropertyArtwork];
                    UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(40, 40)];
                    if (artworkImage == nil) {
                        artworkImage = [[UIImage alloc]init];
                    }
                    //资源URL
                    NSURL *assentURL = [song valueForProperty: MPMediaItemPropertyAssetURL];
                    //暂时未使用，由于版权原因暂时无法直接读取二进制文件
                    //            NSError*error = nil;
                    //            NSData*data = [NSData dataWithContentsOfURL:assentURL options:NSDataReadingMappedAlways error:&error];
                    
                    artist = (artist == nil) ? @"" : artist;
                    albumTitle = (albumTitle == nil) ? @"" : albumTitle;
                    assentURL = (assentURL == nil) ? [NSURL URLWithString:@""] : assentURL;
                    // 组装数组
                    NSDictionary*dic = @{ MUSIC_LIST_NAME   : title,
                                          MUSIC_LIST_SINGER : artist,
                                          MUSIC_LIST_ID     : songsID,
                                          MUSIC_LIST_ALBUM  : albumTitle,
                                          MUSIC_LIST_URL    : assentURL,
                                          MUSIC_LIST_ALBUM_IMAGE    : artworkImage,
                                          MUSIC_LIST_MEDIAITEM      : song};
                    D5MusicLibraryData *music = [D5MusicLibraryData dataWithDict:dic];
                    
                    if(songsID != nil && ![array containsObject:music]){
                        [array addObject:music];
                    }
                }
            }
        }
        
        DLog(@"本地音乐  原始数量 %d", array.count);
        return array;
    }
}

//获取音乐文件目录
-(NSString*)getfileDir:(NSInteger)songId {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * myDocumentsDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString * fileName = [NSString stringWithFormat:@"%ld.m4a", (long)songId];
    
    NSString *exportFile = [myDocumentsDirectory stringByAppendingPathComponent:fileName];
    
    return exportFile;
}

//MPMediaItem 存入本地文件
- (NSDictionary *)mediaItemToData :(MPMediaItem*)curItem {
    @autoreleasepool {
        NSURL *url = [curItem valueForProperty: MPMediaItemPropertyAssetURL];
        AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        MPMediaItemArtwork *artwork = curItem.artwork;
        UIImage *img = [artwork imageWithSize:artwork.bounds.size];
        NSString *albumTitle = curItem.albumTitle;
        NSString *artist = curItem.artist;
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset
                                                                          presetName:AVAssetExportPresetAppleM4A];
        exporter.outputFileType  =  AVFileTypeAppleM4A;
        
        NSString *exportFile = [self getfileDir:[[curItem valueForProperty:MPMediaItemPropertyPersistentID] integerValue]];
        
        NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
        
        exporter.outputURL = exportURL;
        
        semaphore = dispatch_semaphore_create(0);//创建信号量
        
        [exporter exportAsynchronouslyWithCompletionHandler: ^{
            AVAssetExportSessionStatus exportStatus = exporter.status;
            NSError *exportError = exporter.error;
            dispatch_semaphore_signal(semaphore);
            
            switch ((int)exportStatus) {
                case AVAssetExportSessionStatusFailed: // 失败
                    NSLog(@"AVAssetExportSessionStatusFailed: %@", exportError.description);
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"AVAssetExportSessionStatusExporting");
                    break;
                case AVAssetExportSessionStatusCompleted: // 成功
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    break;
            }
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//阻塞线程
        
        semaphore = nil;
        NSData *data1 = [NSData dataWithContentsOfFile:exportFile];
        
        NSDictionary *dict = @{NNS_SINGER : artist ? : @"",
                               NNS_ALBUMS : albumTitle ? : @"",
                               NNS_ALBUM_COVER : img ? : @"",
                               NNS_MUSIC : data1 ? : @""};
        
        return dict;
    }
    
}

//获取本地已经上传的歌曲记
+ (NSMutableArray*)getLocalUploadTagArray {
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:[self getfileDir]];
}

+ (NSString *)getfileDir {
    @autoreleasepool {
        
        NSString * myDocumentsDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"localMusic.plist"];
        return myDocumentsDirectory;
    }
}

// 将中文str转为拼音
- (NSString *)transformStr:(NSString *)chinese {
    @autoreleasepool {
        NSMutableString *pinyin = [chinese mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
        NSLog(@"%@", pinyin);
        return [pinyin uppercaseString];
    }
}

// 获取arr中index处的dictionary
- (NSMutableDictionary *)getDictFromArr:(NSMutableArray *)arr atIndex:(int)index {
    @autoreleasepool {
        if (!arr || arr.count == 0) {
            DLog(@"数组错误");
            return nil;
        }
        
        if (index >= arr.count) {   // 还不存在，新建一个加入arr
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            [arr addObject:mutableDict];
            
            return mutableDict;
        }
        
        NSMutableDictionary *mutableDict = arr[index];
        if (!mutableDict) {
            mutableDict = [NSMutableDictionary dictionary];
        }
        return mutableDict;
    }
}

// 将arr中index处的对象(arr)中加入obj
- (void)addObjFromArr:(NSMutableArray *)arr atIndex:(int)index obj:(id)obj {
    @autoreleasepool {
        if (!arr || arr.count == 0) {
            DLog(@"传入的数组错误");
            return;
        }
        
        if (index < arr.count) {
            // 获取arr中index为value处的arr
            NSMutableArray *mutableArr = [arr objectAtIndex:index];
            
            // 如果数组为空，则新建一个数组，将该拼音字符串加入数组中
            if (!mutableArr) {
                mutableArr = [NSMutableArray array];
            }
            
            [mutableArr addObject:obj];
        }
    }
}

/**
 获取str的首字符
 
 @param str str
 @return 首字符
 */
- (char)firstCharWithStr:(NSString *)str {
    @autoreleasepool {
        // 将musicName转为大写拼音
        NSString *upper = [self transformStr:str];
        
        upper = [NSString trime:upper];
        
        // 将小写拼音转成char字符
        const char *charStr = [upper UTF8String];
        
        char first = 0;
        
        // 首字符
        if (charStr) {
            first = charStr[0];
        }
        
        return first;
    }
}

- (NSString *)firstStrFromArr:(NSArray *)arr atIndex:(NSInteger)index {
    @autoreleasepool {
        NSString *firstStr = @"#";
        if (arr && arr.count > 0) {
            char first = index + 'A';
            if (index != arr.count - 1) {
                firstStr = [NSString stringWithFormat:@"%c", first];
                if ([NSString isValidateString:firstStr] && firstStr.length > 0) {
                    firstStr = [firstStr substringToIndex:1];
                }
            }
        }
        return firstStr;
    }
}

+ (NSString *)titleFromArr:(NSArray *)arr atSection:(NSInteger)section {
    @autoreleasepool {
        if (arr && arr.count > 0) {
            if (section < arr.count) {
                NSDictionary *dict = arr[section];
                NSArray *keys = [dict allKeys];
                if (keys && keys.count > 0) {
                    return keys[0];
                }
            }
        }
        
        return nil;
    }
}

+ (NSInteger)totalMusicCountFromArr:(NSArray *)arr {
    @autoreleasepool {
        if (arr && arr.count > 0) {
            NSInteger totalCount = 0;
            for (NSDictionary *dict in arr) {
                @autoreleasepool {
                    NSArray *values = [dict allValues];
                    if (values && values.count > 0) {
                        NSArray *datas = values[0];
                        if (datas) {
                            totalCount += datas.count;
                        }
                    }
                }
            }
            
            return totalCount;
        }
        
        return 0;
    }
}

/**
 获取arr中section处的row处的data数据(tf卡）
 
 @param arr arr
 @param section section
 @param row row
 @return data
 */
+ (D5TFMusicModel *)tfModelFromArr:(NSArray *)arr atSection:(NSInteger)section atRow:(NSInteger)row {
    @autoreleasepool {
        if (arr && arr.count > 0) {
            if (section < arr.count) {
                NSDictionary *dict = arr[section];
                if (dict) {
                    NSArray *values = [dict allValues];
                    if (values && values.count > 0) {
                        NSArray *datas = values[0];
                        if (row < datas.count) {
                            D5TFMusicModel *data = datas[row];
                            return data;
                        }
                    }
                }
            }
        }
        
        return nil;
    }
}


/**
 获取arr中section处的row处的data数据(本地音乐）
 
 @param arr arr
 @param section section
 @param row row
 @return data
 */
+ (D5MusicLibraryData *)dataFromArr:(NSArray *)arr atSection:(NSInteger)section atRow:(NSInteger)row {
    @autoreleasepool {
        if (arr && arr.count > 0) {
            if (section < arr.count) {
                NSDictionary *dict = arr[section];
                if (dict) {
                    NSArray *values = [dict allValues];
                    if (values && values.count > 0) {
                        NSArray *datas = values[0];
                        if (row < datas.count) {
                            D5MusicLibraryData *data = datas[row];
                            return data;
                        }
                    }
                }
            }
        }
        
        return nil;
    }
}

+ (NSInteger)rowCountFromArr:(NSArray *)arr atSection:(NSInteger)section {
    @autoreleasepool {
        if (arr && arr.count > 0) {
            if (section < arr.count) {
                NSMutableDictionary *dict = arr[section];
                if (dict) {
                    NSArray *values = [dict allValues];
                    if (values && values.count > 0) {
                        NSArray *datas = values[0];
                        return datas ? datas.count : 0;
                    }
                }
            }
        }
        
        return 0;
    }
}

/**
 根据title获取该对象在arr中的index
 
 @param title 首字符串
 @param arr arr
 @return index
 */
+ (NSInteger)indexForTitle:(NSString *)firstStr fromArr:(NSArray *)arr {
    @autoreleasepool {
        NSInteger index = -1;
        if (arr && arr.count > 0 && [NSString isValidateString:firstStr]) {
            for (int i = 0; i < arr.count; i ++) {
                @autoreleasepool {
                    NSDictionary *dict = arr[i];
                    if (dict) {
                        NSArray *keys = [dict allKeys];
                        if (keys && keys.count > 0) {
                            NSString *key = keys[0];
                            if ([firstStr isEqualToString:key]) {
                                index = i;
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        return index;
    }
}

- (void)sortedTFMusicArr:(NSArray *)tfMusicArr {
    @autoreleasepool {
        if (!tfMusicArr || tfMusicArr.count <= 0) {
            if (_tfMusicBlock) {
                _tfMusicBlock(nil);
            }
            return ;
        }
        
        int count = 27; //(a-z#)
        __block NSMutableArray *bigArr = [self arrWithCount:count];
        
        for (D5TFMusicModel *musicModel in tfMusicArr) {
            @autoreleasepool {
                // 歌曲名
                NSString *musicName = musicModel.name;
                
                // 首字符
                char first = [self firstCharWithStr:musicName];
                
                if (first < 'A' || first > 'Z') {   // 如果首字符不在a-z之间（属于#）
                    [self addObjFromArr:bigArr atIndex:((int)bigArr.count - 1) obj:musicModel];
                } else {         // 如果首字符在a-z之间
                    // 得出在最外层arr中的的位置索引（a-z之间，一定大于等于0且小于等于25）
                    int index = first - 'A';
                    
                    [self addObjFromArr:bigArr atIndex:index obj:musicModel];
                }
            }
        }
        
        __block NSMutableArray *resultArr = [NSMutableArray array];
        
        _tfTotalCount = 0;
        [bigArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                NSArray *sub = obj;
                if (sub && sub.count > 0) {   // 不为空，则排序再加入resultArr
                    NSArray *sortedArr = nil;
                    if (idx != bigArr.count - 1) {
                        sortedArr = [self arrSortedByArr:obj];
                    } else  {
                        sortedArr = [self arrSortedTFSpecialArr:obj];
                    }
                    
                    if (sortedArr) {
                        [bigArr replaceObjectAtIndex:idx withObject:sortedArr];
                    }
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    NSString *key = [self firstStrFromArr:bigArr atIndex:idx];
                    
                    NSArray *subArr = bigArr[idx];
                    if ([NSString isValidateString:key] && subArr) {
                        dict[key] = subArr;
                        _tfTotalCount += subArr.count;
                    }
                    
                    [resultArr addObject:dict];
                }
            }
        }];
        
        DLog(@"歌曲数量 %d", _tfTotalCount);
        if (_tfMusicBlock) {
            _tfMusicBlock(resultArr);
        }
    }
}


- (void)localMusicSortedArr {
    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSMutableArray *localMusicArr = [self getlocalMusicList];
                if (!localMusicArr || localMusicArr.count <= 0) {
                    if (_arrBlock) {
                        _arrBlock(nil);
                    }
                    return ;
                }
                
                NSArray *array = [D5HLocalMusicList getLocalUploadTagArray];
                
                //移除掉已经本地上传过的音乐显示
                NSArray *sortedArr = [NSArray arrayWithArray:localMusicArr];
                for (D5MusicLibraryData *data in sortedArr) {
                    for (D5LocalDataModel *model in array) {
                        @autoreleasepool {
                            if ([model.centreBoxId isEqualToString:[D5CurrentBox currentBoxId]] && model.musicId == data.musicId) {
                                [localMusicArr removeObject:data];
                            }
                        }
                    }
                }
                
                int count = 27; //(a-z#)
                __block NSMutableArray *bigArr = [self arrWithCount:count];
                
                for (D5MusicLibraryData *musicData in localMusicArr) {
                    @autoreleasepool {
                        // 歌曲名
                        NSString *musicName = musicData.musicName;
                        
                        // 首字符
                        char first = [self firstCharWithStr:musicName];
                        
                        if (first < 'A' || first > 'Z') {   // 如果首字符不在a-z之间（属于#）
                            [self addObjFromArr:bigArr atIndex:((int)bigArr.count - 1) obj:musicData];
                        } else {         // 如果首字符在a-z之间
                            // 得出在最外层arr中的的位置索引（a-z之间，一定大于等于0且小于等于25）
                            int index = first - 'A';
                            
                            [self addObjFromArr:bigArr atIndex:index obj:musicData];
                        }
                    }
                }
                
                __block NSMutableArray *resultArr = [NSMutableArray array];
                
                _totalCount = 0;
                
                __weak D5HLocalMusicList *weakSelf = self;
                [bigArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    @autoreleasepool {
                        NSArray *sub = obj;
                        if (sub && sub.count > 0) {   // 不为空，则排序再加入resultArr
                            NSArray *sortedArr = nil;
                            if (idx != bigArr.count - 1) {
                                sortedArr = [weakSelf arrSortedByArr:obj];
                            } else  {
                                sortedArr = [weakSelf arrSortedSpecialArr:obj];
                            }
                            
                            if (sortedArr) {
                                [bigArr replaceObjectAtIndex:idx withObject:sortedArr];
                            }
                            
                            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                            NSString *key = [weakSelf firstStrFromArr:bigArr atIndex:idx];
                            
                            NSArray *subArr = bigArr[idx];
                            if ([NSString isValidateString:key] && subArr) {
                                dict[key] = subArr;
                                weakSelf.totalCount += subArr.count;
                            }
                            
                            [resultArr addObject:dict];
                        }
                    }
                }];
                
                DLog(@"歌曲数量 %d", _totalCount);
                if (_arrBlock) {
                    _arrBlock(resultArr);
                }
            }
        });
    }
}

/**
 新建一个count长度的数组，每个对象里面装的是NSMutableArray类型的子数组
 
 @param count count
 @return 数组
 */
- (NSMutableArray *)arrWithCount:(int)count {
    @autoreleasepool {
        if (count <= 0) {
            return nil;
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:count]; // 存放的array
        for (int i = 0; i < count; i ++) {
            NSMutableArray *subArr = [NSMutableArray array];
            [arr addObject:subArr];
        }
        
        return arr;
    }
}

- (NSArray *)arrSortedByArr:(NSArray *)arr {
    @autoreleasepool {
        if (!arr || arr.count == 0) {
            DLog(@"排序普通数组时传入数组为空");
            return nil;
        }
        
        NSComparator finderSort = ^(id obj1,id obj2){
            NSComparisonResult result = NSOrderedSame;
            if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
                NSString *pingyinstr1 = [self transformStr:obj1];
                NSString *pingyinstr2 = [self transformStr:obj2];
                
                result = [pingyinstr1 compare:pingyinstr2];
            }
            
            return result;
        };
        
        NSArray *resultArray = [arr sortedArrayUsingComparator:finderSort];
        return resultArray;
        
    }
}

- (NSArray *)arrSortedSpecialArr:(NSArray *)arr {
    @autoreleasepool {
        if (!arr || arr.count == 0) {
            DLog(@"特殊字符排序时传入数组为空");
            return nil;
        }
        
        NSMutableArray *numberArr = [NSMutableArray array];
        NSMutableArray *specialArr = [NSMutableArray array];
        for (D5MusicLibraryData *libraryData in arr) {
            @autoreleasepool {
                NSString *musicName = libraryData.musicName;
                
                // 首字符
                char first = [self firstCharWithStr:musicName];
                
                if (first < '0' || first > '9') {   // 如果首字符不在0-9之间（属于specialArr）
                    [specialArr addObject:libraryData];
                } else {         // 如果首字符在0-9之间
                    // 得出在最外层arr中的的位置索引
                    [numberArr addObject:libraryData];
                }
            }
        }
        
        NSArray *numberSortedArr = [self arrSortedByArr:numberArr];
        NSArray *specialSortedArr = [self arrSortedByArr:specialArr];
        
        NSArray *resultArr = [numberSortedArr arrayByAddingObjectsFromArray:specialSortedArr];
        return resultArr;
    }
}

- (NSArray *)arrSortedTFSpecialArr:(NSArray *)arr {
    @autoreleasepool {
        if (!arr || arr.count == 0) {
            DLog(@"特殊字符排序时传入数组为空");
            return nil;
        }
        
        NSMutableArray *numberArr = [NSMutableArray array];
        NSMutableArray *specialArr = [NSMutableArray array];
        for (D5TFMusicModel *musicModel in arr) {
            @autoreleasepool {
                NSString *musicName = musicModel.name;
                
                // 首字符
                char first = [self firstCharWithStr:musicName];
                
                if (first < '0' || first > '9') {   // 如果首字符不在0-9之间（属于specialArr）
                    [specialArr addObject:musicModel];
                } else {         // 如果首字符在0-9之间
                    // 得出在最外层arr中的的位置索引
                    [numberArr addObject:musicModel];
                }
            }
        }
        
        NSArray *numberSortedArr = [self arrSortedByArr:numberArr];
        NSArray *specialSortedArr = [self arrSortedByArr:specialArr];
        
        NSArray *resultArr = [numberSortedArr arrayByAddingObjectsFromArray:specialSortedArr];
        return resultArr;
    }
}
@end
