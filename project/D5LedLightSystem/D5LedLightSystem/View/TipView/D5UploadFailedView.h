//
//  D5UploadFailedView.h
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D5BaseTipView.h"

@class D5UploadFailedView;

@protocol D5UploadFailedViewDelegate <NSObject>

- (void)uploadViewReUpload:(D5UploadFailedView *)tipView;

@end

@interface D5UploadFailedView : D5BaseTipView

@property (nonatomic, weak) id<D5UploadFailedViewDelegate> delegate;

+ (instancetype)sharedUploadFailedView;

@end
