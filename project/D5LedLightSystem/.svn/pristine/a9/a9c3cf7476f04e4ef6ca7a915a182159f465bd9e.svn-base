//
//  D5FileModules.h
//  D5Home_new
//
//  Created by PangDou on 16/1/9.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5Cache.h"
#import "D5File.h"

#define FILETYPE_IMAGE @"image"
#define FILETYPE_VIDEO @"video"
#define FILETYPE_AUDIO @"audio"

#define INITITAL_INFO_FILE_NAME @"initial_info"
#define ZKT_BOX_LIST @"zkt_box_list"

#define SELFCENTER_FILE_NAME @"self_center"
#define MEMBER_CENTER_FILE_NAME @"member_center"
#define TREND_FILE_NAME @"trend_limitsof_%d"
#define ALBUM_IMAGE_FILE_NAME  @"album_image"

#define LOGINCONFIGURE_FILE_NAME @"login_configure"
#define HOMEGROUP_MEMNER_LIST @"home_group_member_list"
#define WORKGROUP_MEMNER_LIST @"work_group_member_list"
#define BEFORE_TODAY_TRACKS_LIST @"before_today_tracks_list"
#define TIME_FOR_LOCATION_LIST  @"%@_%@_location_list"
#define UPLOAD_LOCATION_LIST  @"upload_location_list"
#define OPTION_ADD_DEVICE_LIST  @"option_add_device_list"
#define DEVICE_LIST_FILE_NAME @"device_list"
#define DEVICE_CMD_LIST_FILE_NAME @"device_cmd_list"
#define NEED_ADDED_LIST_FILE_NAME @"need_added_list"
#define MESSAGE_CENTER_LIST_FILE_NAME @"message_center_list"
#define FEED_BACK_LIST_FILE_NAME @"feed_back_list"

#define AUDIO_SUFFIX @"mp3"
#define VIDEO_SUFFIX @"3gp"
#define IMAGE_SUFFIX @"jpg"

@interface D5FileModules : NSObject
+ (NSString *)configurePath:(NSString *)fileName;

+ (NSString *)userFilePath:(NSString *)user;
+ (NSString *)userTempPath:(NSString *)user;

+ (NSString *)filePath;
+ (NSString *)tempPath;

+ (NSString *)tempSubPath:(NSString *)subPath withFileName:(NSString *)name;
+ (NSString *)fileDataPath:(NSString *)name;
+ (NSString *)fileListPath:(NSString *)name;

+ (NSString *)imagePath:(NSString *)name;
+ (NSString *)videoPath:(NSString *)name;
+ (NSString *)audioPath:(NSString *)name;

@end
