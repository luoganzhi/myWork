//
//  D5ChangeNameViewController.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

/**
 加密算法
 
 1. 哈希算法：不可逆（MD5、HMAC、SHA1/256/512)
        用途：(1) 保护用户的密码
             (2) 搜索引擎的拆词搜索（几个词语的md5，按位相加结果如果一样，那么搜索结果就是一样的）
             (3) 版权验证：md5对比文件、音频、视频是否是同一个文件

    注意：iOS 7.0.3之前，用NSUserDefaults存储账号和密码；现在用NSUserDefaults存储账号，用钥匙串访问 SSKeyChain将密码存储在系统中，就算APP被卸载（前提是系统没被卸载），再次安装的app存储的密码仍存在
 
        SSKeyChain保存的密码是：将未加密的密码通过AES加密保存在系统中/Library/Keychains/目录下。
 
        需要在App-->Capability-->打开Keychian Sharing
 
 2. 对称加密算法：可逆
    明文-->加密-->密文-->解密-->明文
        （1）DES：数据加密标准
        （2）3DES：使用3个密钥，对相同的数据进行3次加密
        （3）AES：高级加密算法的标准
 
    两种加密方案：
        （1）ECB：电子代码本，每一块数据进行独立加密进行顺序拼接，
        （2）CBC：密码块链，使用一个密钥&初始化向量对数据执行加密，每一段数据和上一段数据有一个联系。某一块数据被获取，也不能完全拿到所有数据。保证密码的完整性（军事上可用）
 
    注意：CBC需要多传入一个参数：iv即初始化向量（与上段数据多的那个联系）
 
 3. 非对称加密算法：可逆（RSA，因式分解），军事上用的多
    公钥-->加密，私钥-->解密   私钥-->加密，公钥-->解密
 
 */

#import "D5BaseViewController.h"

@protocol D5ChangeNameViewControllerDelegate <NSObject>

- (void)finishChangeName:(NSString *)name;

@end

@interface D5ChangeNameViewController : D5BaseViewController

@property (nonatomic, weak) id<D5ChangeNameViewControllerDelegate> delegate;

/** name */
@property (nonatomic, copy) NSString *name;


@end
