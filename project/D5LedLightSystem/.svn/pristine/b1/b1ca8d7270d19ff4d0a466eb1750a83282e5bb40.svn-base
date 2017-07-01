//
//  D5ManualMode.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class D5ManualMode;

@protocol D5ManualModeDelegate <NSObject>

@optional
- (void)openManualMode:(D5ManualMode *)manualMode isFinish:(BOOL)isFinish;
- (void)closeManualMode:(D5ManualMode *)manualMode isFinish:(BOOL)isFinish;

@end

@interface D5ManualMode : NSObject

@property (nonatomic, weak) id<D5ManualModeDelegate> delegate;

+ (D5ManualMode *)sharedInstance;

/**
 进入/退出手动模式

 @param isEnter
 */
- (void)setManualMode:(BOOL)isEnter;

@end
