项目相关

1、项目结构
resource：存放图片目录
Vender：存放一些三方库
Expand:
	Category:存放一些公用类目、类别
	Config:存放自定义宏，包括接口IP、接口名等
	Net:包含网络请求类、网络判断等
	Utils：公用工具类，包括文件管理、时间转换、账号管理等
Main:功能模块，每个模块包含controller、view、model三个目录
	Controller：模块的controller
	View：存放该模块的View，包括tableview的cell、其他view
	Model：该模块的网络请求类，也可存放数据模型model
备注：以下项目除配网以外，项目结构都同上所述

2、主要项目
	天府蜀珍：其中原声开发包含4个一级页面和设置页面，其余均有HTML5开发，交互协议见《app与JS交互》文档。主要的交互协议在Main目录下base中的FTBaseWebViewControlle，其中有加载html的过度动画、以及一些webview加载失败等处理

	检察院：原生开发，主要难点在律师预约、在线举报两个功能模块提交数据方面，其他功能点不多

	配网：主要功能模块面对面快传、项目踏勘、数据缓存。面对面快传利用socket热点方式进行传输，数据缓存见《配网数据缓存步骤》

	心询心用户版：主要功能即时通讯，包括聊天、视频通话、语音通话，都是集成于网易云信，聊天有专门的viewcontroller---》NTESSessionViewController,需要进行图文聊天时，只需传入NIMSession，即对方的聊天ID即可进行图文聊天，语音聊天---》NTESAudioChatViewController,只需传入对方的聊天id就能进行语音聊天，视频聊天同语音---》NTESVideoChatViewController。直播模块，用户端只需观看直播---》NELivePlayerViewController,只需要传入拉流地址即可观看。其中还包含分享、支付等，分享公用类---》FTShareManager   支付公用类---》PaymentManager

	心询心专家版：主要功能即时聊天，原理同心询心用户版，在直播模块有所不同，创建直播--->MediaCaptureViewController,推流地址请求拿到过后传入MediaCaptureViewController，就开始直播，在之前需要设置直播类型以及直播的清晰度

	西咪兔：主要功能模块互动直播、聊天，集成于网易云信，目前已经集成到项目当中，直播可以观看，由于创建直播需要和后台挂钩，暂时没完成，其中还包括视频采集功能，技术demo已经完成，详情见桌面videoHandle项目和ViewFilerClipDemo，第一个有播放器，本地以及拍照过后进行视频采集，然后保存本地和上传，第二个主要是滤镜处理，主要框架GPUImage,本地选取和拍照添加滤镜，西咪兔UI开发已完成部分，后期可能会有所调整


西米兔
1、项目结构
resource：存放图片目录
Vender：存放一些三方库
Expand:
	Category:存放一些公用类目、类别
	Config:存放自定义宏，包括接口IP、接口名等
	Net:包含网络请求类、网络判断等
	Utils：公用工具类，包括文件管理、时间转换、账号管理等
Main:功能模块，每个模块包含controller、view、model三个目录
	Controller：模块的controller
	View：存放该模块的View，包括tableview的cell、其他view
	Model：该模块的网络请求类，也可存放数据模型model

NetRequest 
网络请求接口
YEL
外援代码，部分已经废弃
Main
主要代码入口
Community
社区代码tabcontroller
Health
活动部分tabcontroller
video
视频tabcontroller
IM
网易云信im服务
Base
基础类
PersonCenter
我的tabcontroller
西咪兔：主要功能模块互动直播、聊天，集成于网易云信，目前已经集成到项目当中，直播可以观看，由于创建直播需要和后台挂钩，暂时没完成，其中还包括视频采集功能，技术demo已经完成，详情见桌面videoHandle项目和ViewFilerClipDemo，第一个有播放器，本地以及拍照过后进行视频采集，然后保存本地和上传，第二个主要是滤镜处理，主要框架GPUImage,本地选取和拍照添加滤镜，西咪兔UI开发已完成部分，后期可能会有所调整



git： 开发分支development-master       
// master 由于忽略了所有静态库，checkout下来会报错，所以用development-master分支
libNELivePlayer.a  静态库由于大于100M 所以没有上传到git，如果checkout下来的时候报错，手动添加到项目中。



ximitwo@ximitwo.com 密码Yccm258852
