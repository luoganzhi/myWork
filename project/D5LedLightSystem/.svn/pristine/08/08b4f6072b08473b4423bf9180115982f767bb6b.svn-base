//
//  D5TransferMusic.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol D5TransferMusicDelegate <NSObject>

- (void)openTransferServiceFinish:(BOOL)isFinish ipv4:(NSString *)ipv4 port:(int)port url:(NSString *)url;

@optional
- (void)closeTransferServiceFinish:(BOOL)isFinish;

@end

@interface D5TransferMusic : NSObject

@property (nonatomic, weak) id<D5TransferMusicDelegate> delegate;

+ (D5TransferMusic *)sharedInstance;

/**
 打开/ 关闭传歌服务
 */
- (void)transferServiceOpen:(BOOL)isOpen;
@end
