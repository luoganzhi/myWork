//
//  D5ProtocolAction.h
//  D5Home
//
//  Created by anthonyxoing on 2/7/14.
//  Copyright (c) 2014年 anthonyxoing. All rights reserved.
//
#import "D5Protocol.h"
#ifndef D5Home_D5ProtocolAction_h
#define D5Home_D5ProtocolAction_h

//#define D5ACTION_SUCCESS 111

typedef enum _check_update_type {
    CheckUpdateTypeAPP = 1,
    CheckUpdateTypeBox = 2,
    CheckUpdateTypeBlueTooth = 4,
    CheckUpdateTypeAll = 7
}CheckUpdateType;

#ifndef PLATFORM
typedef enum _Platform_type{
    D5PlatFormTypeAndroid = 1,
    D5PlatFormTypeIOS,
    D5PlatFormTypeWeb
}D5PlatFormType;
#define PLATFORM_TYPE(type) [NSNumber numberWithInt:type]

#endif

#ifndef LANGUAGE

typedef enum _Language_type {
    D5LanguageTypeZh = 0,
    D5LanguageTypeEn
}D5LanguageType;
#define APP_LANGUAGE_TYPE(type) [NSNumber numberWithInt:type]

#endif

#define TIMEOUT_INTERVAL 10.0f

typedef enum D5ProtocolAction{
    send_suggestion = 12,
    check_update = 321,
    spot_music = 14
    
} D5NetWorkAction;

#pragma mark - 请求参数名
#ifndef __SEND_PARAMETER_NAME
#define __SEND_PARAMETER_NAME
#define NSS_APP                         @"app"

#define NNS_METHOD                      @"cmd"
#define NNS_APP_ID                      @"app_id"
#define NNS_APP_VER                     @"app_ver"
#define NNS_ZK_VER                     @"zk_ver"
#define NNS_BT_VER                     @"bt_ver"
#define NNS_BT_TYPE                     @"bt_type"

#define BOX_APP_ID                      @"box_app_id"

#define NNS_VERSION                     @"nns_version"
#define NNS_PLATFORM                    @"platform"
#define NNS_LANG                        @"nns_lang"
#define NNS_LOGIN_TYPE                  @"nns_login_type"
#define NNS_USER                        @"nns_user"
#define NNS_PWD                         @"nns_pwd"
#define NNS_SMS_CODE                    @"nns_sms_code"
#define NNS_DEVICE                      @"nns_device"
#define NNS_PHONE_MODEL                 @"nns_phone_model"
#define NNS_AUTO_LOGIN                  @"nns_auto_login"
#define NNS_NAME                     @"nns_name"
#define NNS_USER_ID                    @"nns_user_id"                      //用户ID
#define NNS_AUTHOR_CODE             @"nns_author_code"                  //用户登陆授权Key
#define NNS_GROUP_ID                @"nns_group_id"
#define NNS_PAGE_SIZE               @"nns_page_size"
#define NNS_PAGE_NUM                @"nns_page_num"
#define NNS_TYPE                    @"type"
#define NNS_ADDRESS                 @"nns_address"
#define NNS_GET_USER_ID             @"nns_get_user_id"
#define NNS_FROM                @"nns_from"
#define NNS_VALUE_STRING            @"nns_value_string"
#define NNS_MEMBER_ID               @"nns_member_id"
#define NNS_TRANSFER_ID             @"nns_transfer_id"
#define NNS_SYS_VER             @"nns_sys_ver"
#define NNS_NEWS_ID             @"nns_news_id"

#define NNS_IMAGE                   @"nns_image"
#define NNS_VIDEO                   @"nns_video"
#define NNS_AUDIO                   @"nns_audio"
#define NNS_USER_HEAD               @"nns_user_head"

#define ACTION_STATUS               @"status"
#define ACTION_DATA                 @"data"

#define NNS_SINGER                  @"singer"
#define NNS_ALBUMS                  @"albums"
#define NNS_ALBUM_COVER             @"cover"
#define NNS_MUSIC                   @"music"

#pragma mark - 检查升级
#define ACTION_IS_FORCEUPGRADE @"is_forceUpgrade"
#define ACTION_TAG @"tag"
#define ACTION_TIPS @"tips"
#define ACTION_URL @"url"
#define ACTION_VERCODE @"verCode"
#define ACTION_VERTEXT @"verText"

#define ACTION_APP      @"app"
#define ACTION_ZK       @"zk"
#define ACTION_BT       @"bt"

#define HEAD_IMAGE_SIZE CGSizeMake(300, 300)
#define IMAGE_SIZE      CGSizeMake(1200, 1200)

#define HEAD_IMAGE_MAX_DATA_SIZE 20 * 1024
#define IMAGE_MAX_DATA_SIZE      500 * 1024

#endif

#endif
