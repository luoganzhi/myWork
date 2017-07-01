//
//  D5Socket.h
//  D5Home_new
//
//  Created by PangDou on 16/1/16.
//  Copyright © 2016年 com.pangdou.d5home. All rights reserved.
//

#ifndef D5Socket_h
#define D5Socket_h

typedef enum _SOCK_ERROR{
    D5SocketErrorCodeTypeTimeOut = 1110,
    D5SocketErrorCodeTypeUdpDisconnect,
    D5SocketErrorCodeTypeTcpDisconnect,
    D5SocketErrorCodeTypeUDPSendDataFailed,
    D5SocketErrorCodeTypeTCPSendDataFailed,
    D5SocketErrorCodeTypeExtDevicesNotMounted = -101, // 外设未挂载
    D5SocketErrorCodeTypeMediaFileNotExsit = -102,  // 歌曲被删除
    D5SocketErrorCodeTypeLedNotAdd = -103,
    D5SocketErrorCodeTypeLedDisconnect = -104,
    D5SocketErrorCodeTypeLedInUploading = -105,     // 处于蓝牙灯升级状态
    D5SocketErrorCodeTypeLedInFollowModel = -106,   // 处于随动模式
    D5SocketErrorCodeTypeExtUsbDeviceUnmount = -107,   //
    D5SocketErrorCodeTypeStorageWarn = -111,   // 内存警告
    D5SocketErrorCodeTypeBluetooth_Error = -113,
    D5SocketErrorCodeTypeFileCopyCutComplete = 2
}D5SocketErrorCodeType;

typedef enum _socket_network_type{
    D5SocketTypeUdp = 1,
    D5SocketTypeTcp = 1<<1
}D5SocketType;

typedef enum _SOCK_ERROR_CODE {

    D5SocketErrorCodeMACERROR                  =      -10001,//表示mac地址错误，设备或APP收到的destMac与自身Mac不匹配时使用
    D5SocketErrorCodeCHECKSUMMISMATCH          =      -10002,//校验码数据，checkSum值与计算出的值不匹配时使用
    D5SocketErrorCodeDATALENTHERROR            =      -10003,//包长度错误，len与实现包长度不匹配时使用
    D5SocketErrorCodePERSSIONERROR             =      -10004,//权限错误， 已被其他手机绑定
    D5SocketErrorCodeDEVICEOFFLINE             =      -10005,//设备不在线（远程服务器返回）
     D5SocketErrorCodeSTARTUPDATEFAILURE       =      -10006,//启动更新失败
     D5SocketErrorCodeREPEATEDSTARTUPDATEE     =      -10007,//已经启动更新了，不能重复启用
     D5SocketErrorCodeSERVERCONNECTIONFAILED   =      -10008,//服务器连接失败
     D5SocketErrorCodeFIRMWAREDOWNLOADFAILED   =      -10009,//固件下载失败
     D5SocketErrorCodeBODYERROR                =      -10010,//Body错误
     D5SocketErrorCodeBODYNULL                 =      -10011,//Body为空
     D5SocketErrorCodeUNKNOWNERROR             =      -10012,//默认错误（未知错误）
     D5SocketErrorCode1003                     =      -10013,
     D5SocketErrorCodeADDINGLIGHTS             =      -10014,//正在添加新灯时不能进行灯的控制
     D5SocketErrorCodeTOOMANYLIGHTS            =      -10015,//已经添加过255 盏灯了不能再添加了
     D5SocketErrorCode1006                     =      -10016,
     D5SocketErrorCodeOPERATIONFAILURE         =      -10017,//操作失败
     D5SocketErrorCode1008                     =      -10018,
     D5SocketErrorCodeBOXCLOSE                 =      -10019,//盒子已经关闭不能执行当前操作
     D5SocketErrorCodeBOXWIFINOTCONFIGURED     =      -10020,//盒子WIFI未配置
}D5HSocketErrorCode;



#endif /* D5Socket_h */
