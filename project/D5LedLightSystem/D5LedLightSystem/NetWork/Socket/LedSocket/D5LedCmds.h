//
//  D5LedCmds.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/22.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#ifndef D5LedCmds_h
#define D5LedCmds_h

#import "D5LedCmdKeys.h"
#import "D5Socket.h"

#define HEADER_CODE 0xADD5
#define HEADER_PROTOCAOL_VERSION 1  // 协议版本
#define HEADER_TYPE_APP 0xff        // app端type
#define HEADER_SUBTYPE_IOS 0x01     // app端subType(ios = 1 android = 2)

#pragma mark - 返回码的枚举
typedef enum _led_code {
    LedCodeSuccess = 1,         // 操作成功
    LedCodeFailed = -1,         // 操作失败
    LedCodeNotLogin = -100      // 没登录
}LedCode;

#pragma mark - cmd type
typedef enum _cmd_type {
    LedCmdTypeServer = 1,  // 代表的是设备与服务器的通信指令
    LedCmdTypeApp,         // 代表设备与app的通信指令
    LedCmdTypeDevice       // 代表设备与设备之间的通信指令
}LedCmdType;

#pragma mark - 错误码枚举
typedef enum _led_error_code {
    LedErrorCodeMac = -10001,
    LedErrorCodeCheckCode,
    LedErrorCodeLength,
    LedErrorCodePermission,
    LedErrorCodeDeviceOffline,
    LedErrorCodeStartUpdate,
    LedErrorCodeRestartUpdate,
    LedErrorCodeServerConn,
    LedErrorCodeFirmwareUpload
}LedErrorCode;

#pragma mark - tag枚举
typedef enum _device_tag {
    tag_remote = 1,
    tag_local
}DeviceTag;

#pragma mark - cmd枚举
typedef enum _led_cmd {
    Cmd_Box_Operate = 1,    // 盒子操作类
    Cmd_Led_Operate,        // Led灯操作类
    Cmd_Media_Operate,      // 音乐播放操作
    Cmd_IO_Operate,          // 文件操作
    Cmd_Link_Operate        // 联动
}LedCmd;

#pragma mark - 中控盒子操作的subcmd
typedef enum _led_subcmd_box_operate {
    SubCmd_Box_Scan = 1,        // 扫描中控盒子
    SubCmd_Box_App_Login,       // 登陆中控盒子 App端进行TCP通信时确认能连接上Tcp
    SubCmd_Box_Heart,           // APP&中控心跳
    SubCmd_Box_Get_Info,        // 获取中控基础信息
    SubCmd_Box_Runtime_Info = 5,// 获取中控运行时信息
    SubCmd_Box_Update,          // 中控升级(APP&蓝牙固件)
    SubCmd_Box_Set_TimeTask,    // 设置定时任务
    SubCmd_Box_Get_TimeTask,    // 读取定时任务
    SubCmd_Box_Change_Connect,  // 切换中控联网方式
    SubCmd_Box_Set_Info         // 中控基础信息
}LedSubCmdBoxOperate;

#pragma mark - 灯的操作的suncmd
typedef enum _led_subcmd_led_operate {
    SubCmd_Led_List = 1,        // 获取Led灯列表
    SubCmd_Led_Heart,           // 扫描灯/可用于心跳维持
    SubCmd_Led_Operate_New,     // 给新灯操作（标号或开关）
    SubCmd_Led_Add_Ok,          // 添灯时最后确认
    SubCmd_Led_Operate_All,     // 灯控（所有灯，包括开关，颜色，亮度，模式）
    SubCmd_Led_Operate_Single,  // 灯控（单个灯，包括开关，颜色，亮度，模式,已添加灯的编号）
    SubCmd_Led_Scene            // 场景设置
}LedSubCmdLedOperate;

#pragma mark - 音乐操作的subcmd
typedef enum _led_subcmd_music_operate {
    SubCmd_Music_List = 1,      // 获取音乐列表
    SubCmd_Effects_List = 2,    // 拉取特效文件
    SubCmd_Music_Play,          // 播放指定歌曲
    SubCmd_Effects_Play,        // 播放指定特效
    SubCmd_Music_Control,       // 播放控制 （下一首 、 上一首 、 开始 、 暂停 、 停止）
    SubCmd_Music_Setting,       // 播放器设置
    SubCmd_Manual_Setting,      // 手动调色模式
}LedSubCmdMusicOperate;

#pragma mark - 文件操作的subcmd
typedef enum _led_subcmd_file_operate {
    SubCmd_File_Download_Music  = 1, //  下载音乐文件
    SubCmd_File_Delete_Music = 2, //删除音乐
    SubCmd_File_Trans_Music_On, // 移动端上传音乐文件开启服务
    SubCmd_File_Trans_Music_Off, // 移动端上传音乐文件关闭服务
    SubCmd_File_Get_Music_TF,
    SubCmd_File_Trans_TFMusic, // 将tf卡音乐上传
    SubCmd_File_Trans_Progress,
    SubCmd_File_Update_Progress, // 下载进度统一返回
    SubCmd_File_Bt_Update_Progress,  //蓝牙固件升级进度
    SubCmd_File_ExtDeviceType,
    SubCmd_File_CancelDownload_Music,
     SubCmd_File_Downloading_MusicList,
}LedSubCmdFileOperate;

#pragma mark - 联动的subcmd
typedef enum _led_subcmd_link_operate {
    SubCmd_Link_Get = 1,    // 拉取联动设备信息
    SubCmd_Link_Delete,     // 删除联动设备信息
    SubCmd_Link_Add         // 添加联动设备信息
}LedSubCmdLinkOperate;

#pragma mark - 更新下载状态
typedef enum _update_download_status {
    UpdateDownloadStatusReady = 0,      // 准备下载
    UpdateDownloadStatusIng,            // 下载中
    UpdateDownloadStatusFailed,         // 下载失败
    UpdateDownloadStatusSuccess = 4     // 下载成功
}UpdateDownloadStatus;

#pragma mark - 更新下载文件类型
typedef enum _update_file_type {
    UpdateFileTypeBox = 1,              // 中控更新apk
    UpdateFileTypeMusic,                // 音乐下载
    UpdateFileTypeConfig                // 配置下载
}UpdateFileType;

#pragma mark - 删除
typedef enum {
    /**
     * 清空
     */
    Del_All = 1,
    
    /**
     * 自定义删除
     */
    Del_Custom = 2

    
}MusicDelType;

#pragma mark - 播放特效
typedef enum {
    /**
     * 播放
     */
    EffectPlay = 1,
    
    /**
     * 停止
     */
    EffectStop = 2
}EffectPlayType;

typedef enum _play_status {
    Play = 1,  // 播放
    Pause,   // 暂停
    Stop       // 停止
}PlayStatusType;

typedef enum {
    /**
     * 配置模式
     */
    Color_Config = 1,
    
    /**
     * 场景模式
     */
    Color_Scene = 10,
    
    /**
     * 特效模式
     */
    Color_Effects = 20,
    
    /**
     * 手动模式
     */
    Color_Manual = 30
}LedColorModel;


#pragma mark - TF卡上传
typedef enum {
    /**
     * 复制列表
     */
    TF_Copy_Files = 1,
    
    /**
     * 剪切列表
     */
    TF_Cut_Files = 2,
    
    /**
     * 暂停文件操作
     */
    TF_Pause = 3,
    
    /**
     * 继续文件操作
     */
    TF_Continue = 4,
    
    /**
     * 取消文件操作
     */
    TF_Cancle = 5
}TFTranstMusic;

typedef enum {
    /* Usb 外设
    */
    Usb_Only = 1,
    /**
     * Sdcard外设
     */
    Sdcard_Only = 2,
    /**
     * Usb 外设与Sdcard外设同时存在
     */
    Usb_Sdcard = 3

}ExtDeviceType;

#pragma mark - 其它操作的subcmd
typedef enum _led_subcmd_other_operate {
    SubCmd_Other_AllStatus = 1 // 状态返回
}LedSubCmdOtherOperate;

#pragma mark - 操作从属中控的subcmd
typedef enum _led_subcmd_link_device {
    SubCmd_Device_List_From_App = 1, // App拉取设备列表
    SubCmd_Device_Delete_From_App = 2, // App删除指定设备
    SubCmd_Device_Add_From_App = 3 // App指示主中控添加指定设备
}LedSubCmdLinkDevice;

#pragma mark - 中控升级类型
typedef enum _led_box_update_type {
    LedBoxUpdateTypeDevice = 1,         // 中控升级
    LedBoxUpdateTypeBlueTooth,          // 蓝牙固件升级
    LedBoxUpdateTypeRetry               // 蓝牙重新升级
}LedBoxUpdateType;

#pragma mark - 中控盒子添加的灯类型
typedef enum _led_box_led_type {
    LedBoxLedTypeDefault = 0, //Mini 或吸顶  未添加灯时为Default
    LedBoxLedTypeMini, //Mini
    LedBoxLedTypeCeiling //吸顶
}LedBoxLedType;

#pragma mark - 中控操作定时任务的类型
typedef enum _led_operate_timetask_type {
    LedOperateTaskTypeCreate = 1,   //新建
    LedOperateTaskTypeOpen = 5,     //启用
    LedOperateTaskTypeClose = 10,   //暂停
    LedOperateTaskTypeUpdate = 15,  //修改
    LedOperateTaskTypeDelete = 20   //删除
}LedOperateTaskType;

#pragma mark - 中控定时任务的循环方式
typedef enum _led_timetask_cycle_type {
    LedTimeTaskCycleTypeCustomWeek = 1  // 自定义按星期执行
}LedTimeTaskCycleType;

#pragma mark - 定时任务操作灯的类型
typedef enum _led_timetask_led_operate {
    LedTimeTaskLedOperateOn = 1,    // led灯开
    LedTimeTaskLedOperateOff        // led灯关
}LedTimeTaskLedOperate;

#pragma mark - 没添加的灯的操作类型
typedef enum _led_operate_new_type {
    LedOperateNewTypeCancel = -1,    // LED灯的取消编号
    LedOperateNewTypeSetNo = 1,      // LED灯的编号
    LedOperateNewTypeSwitch          // LED灯的开关
}LedOperateNewType;

#pragma mark - 进入手动模式

typedef enum {
    /**
     * 开启手动模式
     */
    ManualOpen = 1,
    
    /**
     * 关闭手动模式
     */
    ManualClose = 2

}ManualSetting;

#pragma mark - 灯的控制类型
typedef enum _led_operate_type {
    LedOperateTypeSwitch = 1,       // LED灯的开关
    LedOperateTypeColor,            // LED灯的颜色设置
    LedOperateTypeBrightness,       // LED灯的亮度调节
    LedOperateTypeMode,             // LED灯的模式（RGB/冷暖）
    LedOperateTypeDelete,           // LED灯的删除
    LedOperateTypeSetNo             // LED灯的编号（已添加的灯）
}LedOperateType;

#pragma mark - 中控设置的类型
typedef enum _led_box_setting_type {
    LedBoxSettingTypeSetName = 1        // 设置名称
}LedBoxSettingType;

#pragma mark - 灯的开关控制
typedef enum _led_onoff_all_type {
    LedOnOffAllTypeOn = 1,
    LedOnOffAllTypeOff,
    LedOnOffAllTypeReserve,
    LedOnOffAllTypeHold
}LedOnOffAllType;

#pragma mark - 灯的开关状态
typedef enum _led_onoff_status {
    LedOnOffStatusOn = 1,
    LedOnOffStatusOff = 5,
    LedOnOffStatusOffline = 10,
    LedOnOffStatusNotAdd = 15
}LedOnOffStatus;

#pragma mark - 返回灯的类型

typedef enum {
    /**
     * 默认
     */
    Default = 0,
    
    /**
     * Mini灯
     */
    Mini = 1,
    
    /**
     * 吸顶灯
     */
    Ceiling = 2
    
}LedDeviceType;


#pragma mark - 灯的模式切换
typedef enum _led_model_type {
    LedModelTypeRGB = 1, //RGB
    LedModelTypeCold, //冷光
    LedModelTypeWarm //暖光
}LedModelType;

typedef enum {
    /**
     * LED开关灯
     */
    LED_ON_OFF = 1,
    
    /**
     * 设置颜色
     */
    LED_Color = 2,
    
    /**
     * 亮度调节
     */
    LED_Brightness = 3,
    
    /**
     * 模式(RGB/冷暖)
     */
    LED_Mode = 4,
    
    /**
     * 删除灯
     */
    LED_Delete = 5

}LedControlType;

#pragma mark - 灯的场景设置
typedef enum _led_scene_type {
    LedSceneTypeNo = 0,     // 无模式
    LedSceneTypeNormal = 1, // 照明
    LedSceneTypeWarm,       // 温暖
    LedSceneTypeParty,      // 聚会
    LedSceneTypeCinema      // 影院
}LedSceneType;

#pragma mark - 灯的颜色模式
typedef enum _led_color_type {
    LedColorTypeScene = 1,  // 场景模式
    LedColorTypeEffects,    // 特效模式
    LedColorTypeConfig,     // 配置模式
    LedColorTypeManual      // 手动模式
}LedColorType;

#pragma mark - 灯的删除（剔除或者重置）
typedef enum _led_delete_type {
    LedDeleteTypeReset = 1, //重置
    LedDeleteTypeDelete //剔除
}LedDeleteType;

#pragma mark - 获取Led灯的列表
typedef enum _led_list_type {
    LedListTypeNotAdd = 1,  //1 -- 未被添加
    LedListTypeHasAdded     //2 -- 已经添加
}LedListType;

#pragma mark - 播放状态
typedef enum _led_play_status {
    LedPlayStatusPlay = 1, // 播放
    LedPlayStatusPause,    // 暂停
    LedPlayStatusStop      // 停止
}LedPlayStatus;

#pragma mark - 音乐设置类型
typedef enum {
    VOL = 1, // 音量
    ModeSwitch = 2     // 播放模式
}MediaSettingType;


#pragma mark - 播放控制
typedef enum _led_music_control_type {
    LedMusicControlTypePrevious = 1, //上一首
    LedMusicControlTypeNext = 2, //下一首
    LedMusicControlTypePlay = 3, //播放
    LedMusicControlTypePause = 4, //停止
    LedMusicControlTypeStop = 5//停止
}LedMusicControlType;

#pragma mark -  播放器设置（声道设置）
typedef enum _led_music_settrack_type {
    LedMusicSetTrackTypeLeft = 1, // 左声道
    LedMusicSetTrackTypeRight, // 右声道
    LedMusicSetTrackTypeMix // 混音
}LedMusicSetTrackType;

#pragma mark - 播放器设置（播放模式设置）
typedef enum _led_music_setmodel_type {
    LedMusicSetModelTypeOrder = 1,  //顺序播放
    LedMusicSetModelTypeRandom      //随机播放
}LedMusicSetModelType;

#pragma mark - 配置文件相关控制 模式切换
typedef enum _led_config_control_type {
    LedConfigControlTypeStartManual = 1, // 开启手动模式（停配置不停音乐）
    LedConfigControlTypeStopManual     // 停止手动模式（播放配置文件）
}LedConfigControlType;

#pragma mark - 特效类型
typedef enum _led_effect_type {
    LedEffectTypeShort = 1,         // 简短特效
    LedEffectTypeCommon,            // 通用特效
    LedEffectTypeSelf               // 独有特效
}LedEffectType;

#pragma mark - 播放/停止播放特效
typedef enum _led_config_effect_control_type {
    LedConfigEffectControlTypePlay = 1, // 播放特效
    LedConfigEffectControlTypeStop, // 停止播放特效
    LedConfigEffectControlTypePreview // 预览特效
}LedConfigEffectControlType;

#pragma mark - PC端上传音乐文件--ipv4/ipv6
typedef enum _led_file_trans_music_pc_ipv {
    LedFileTransMusicPCIPV4 = 1, // ipv4
    LedFileTransMusicPCIPV6     // ipv6
}LedFileTransMusicPCIPV;

#pragma mark - 中控功能开关状态
typedef enum _led_box_status {
    LedBoxStatusOn = 1, // 开
    LedBoxStatusOff     // 关
}LedBoxStatus;

#pragma mark - 所有状态
#pragma pack(1)
typedef struct _led_other_allstatus {
    uint8_t boxOnOff; //盒子开关 2--关  1--开
    uint8_t ledOnOff; //灯开关 1--开  2--关
    uint8_t boxStauts;
    uint8_t brightness; // 灯亮度
    uint8_t scene; //场景 1-常规照明 2-温暖 3-放松  4-影院
    uint32_t versionCode; //版本号
}LedOtherAllStatus;

#pragma mark - 从属中控的地址和端口
#pragma pack(1)
typedef struct _led_link_device_add {
    uint32_t ip; //(ipv4服务器地址)
    uint32_t port; //(服务器端口
}LedLinkDeviceAdd;

#pragma mark - flag
#pragma pack(1)
typedef struct _led_flag {
    Byte needResponse:1;
    Byte error:1;
    Byte hasExtentData:1;
    Byte bound:1;
    Byte serverdisconnected:1;
    Byte isBindApp:1;
}LedFlag;

#pragma mark - header
#pragma pack(1)
typedef struct _led_header{
    uint16_t len;
    uint8_t sn;
    uint8_t protocolVersion;
    uint16_t appVersion;
    uint8_t type;
    uint8_t subType;
    uint8_t cmd;
    uint8_t subCmd;
    uint8_t flag;
    char srcMac[6];
    char destMac[6];
    uint16_t code;
}LedHeader;

#pragma mark - 给灯编号--灯的编号信息
#pragma pack(1)
typedef struct _led_set_no {
    uint8_t index; // 灯的编号 范围 0 ~ 254 ；(Led 灯的MeshAddress)
    uint8_t lightId; // 灯的Id 范围 （1 ~ 6 ）
}LedSetNo;

#pragma mark - 不定量灯的开关控制--灯的开关信息
#pragma pack(1)
typedef struct _led_on_off {
    uint8_t index; //灯的编号 范围 0 ~ 254 ；(Led 灯的MeshAddress)
    uint8_t onoff; //( 1--on (开) 2--off（关）  3--reserve （反转） 4-- hold（不变）)
}LedOnOff;

#pragma mark - 所有灯的颜色调节
#pragma pack(1)
typedef struct _led_rgb_all {
    int R; //（0 -- 255）
    int G; //（0 -- 255）
    int B; //（0 -- 255）
}LedRGBAll;

#pragma mark - 所有灯的颜色调节
#pragma pack(1)
typedef struct _led_scene_all {
    uint8_t type; //场景
    uint8_t R; //（0 -- 255）
    uint8_t G; //（0 -- 255）
    uint8_t B; //（0 -- 255）
}LedAllScene;

#pragma pack(1)
typedef struct _led_scene_new {
    uint8_t ID;
    uint8_t mode; //场景
    uint8_t R; //（0 -- 255）
    uint8_t G; //（0 -- 255）
    uint8_t B; //（0 -- 255）
}LedAllSceneNew;

#pragma mark - 不定量灯的颜色调节--灯的Rgb信息
#pragma pack(1)
typedef struct _led_rgb_single {
    uint8_t index; //灯的编号 范围 0 ~ 254 ；(Led 灯的MeshAddress)
    LedRGBAll rgb;
    int32_t mac;
}LedRGBSingle;

#pragma mark - 不定量灯的亮度调节--灯的Brightness信息
#pragma pack(1)
typedef struct _led_brightness_single {
    uint8_t index; //灯的编号 范围 0 ~ 254 ； （Led灯的MeshAddress）
    uint8_t brightness; //灯的亮度 范围 0 ~ 100
}LedBrightnessSingle;

#pragma mark - 不定量灯的模式切换--灯的Model信息
#pragma pack(1)
typedef struct _led_model_single {
    uint8_t index; // 灯的编号 范围 0 ~ 254 ； （Led灯的MeshAddress）
    uint8_t model; // (1 RGB  2 冷  3 暖)
}LedModelSingle;

#pragma mark - 不定量灯的场景设置--灯的Scene信息
#pragma pack(1)
typedef struct _led_scene_single {
    uint8_t index; // 灯的编号 范围 0 ~ 254 ； （Led灯的MeshAddress）
    uint8_t scene; //  (1 常规照明  2 温暖  3 放松  4 影院)
}LedSceneSingle;

#pragma mark - 删除灯--灯的删除信息（剔除或者重置）
#pragma pack(1)
typedef struct _led_delete {
    uint8_t index; // 灯的编号 范围 0 ~ 254 ； （Led灯的MeshAddress）
    uint8_t type; //  (1-- 重置   2 -- 剔除)
    uint32_t macInt;
}LedDelete;

#pragma mark - 添灯时最后确认--灯的信息
#pragma pack(1)
typedef struct _led_add_ok {
    uint8_t index; // 灯的编号 范围 0 ~ 254 ； （Led灯的MeshAddress）
    uint8_t lightId; //（如果有设置Id ，未设置时传0）
}LedAddOk;

#pragma mark - 播放某一首音乐
#pragma pack(1)
typedef struct _led_music_play {
    int32_t Musicid; //音乐Id ；
    int32_t Configid; //配置Id ；
}LedMusicPlay;

#pragma mark - 播放特效文件
#pragma pack(1)
typedef struct _led_config_play_effect {
    uint8_t type;
    int32_t effectId;
}LedConfigPlayEffect;

#pragma mark - 读取定时任务
#pragma pack(1)
typedef struct _led_read_time_task {
    uint64_t key;   // 定时任务唯一标识（从中控读取，初始从零开始 ）
    uint32_t time;  // 将二十四制转成的分钟数
    uint8_t status;  //（Led开关与重复的天数） Bit 0  Led 开关状态 1 开 0 关
    uint8_t switchForAlarm; // 实时任务的开关 1 开 0 关
}LedReadTimeTask;

#pragma mark - 操作定时任务
#pragma pack(1)
typedef struct _led_operate_time_task {
    LedReadTimeTask timeTask;
    uint8_t operate; //  操作（1添加 0 删除 2 删除）LedOperateTimeTaskType
}LedOperateTimeTask;


#pragma mark - 播放器设置（音量设置）
typedef struct _led_music_setvolume_type {
    uint8_t LedMusicSetVolumeTypeMute; //静音
    uint8_t LedMusicControlTypeUp; //增加音量
    uint8_t LedMusicControlTypeDown; //减小音量
    uint8_t LedMusicControlTypeNumber; //设置音量
}LedMusicSetVolumeType;

#pragma mark -  播放特效文件
#pragma pack(1)
typedef struct _led_music_set_volume {
    uint8_t type;
    uint8_t value;
}ledMusicSetVolume;

//// 播放特效文件
//#pragma pack(1)
//typedef struct _led_config_play_effect {
//    uint8_t type;
//    int32_t effectId;
//}LedConfigPlayEffect;

#pragma mark - PC端、移动端上传音乐文件:（开启服务）
#pragma pack(1)
typedef struct _led_file_trans_music_on {
    //    LedFileTransMusicPCIPV type; //(1 -- ipv4  2--ipv6)
    int8_t type;
    uint32_t ipv4IP; // (ipv4服务器地址) -- 和ipv6IP二选一
    //    uint64_t ipv6IP; //(ipv6服务器地址) -- 和ipv4IP二选一
    uint32_t port; // (服务器端口)
}LedFileTransMusicOn;

#endif /* D5LedCmds_h */
