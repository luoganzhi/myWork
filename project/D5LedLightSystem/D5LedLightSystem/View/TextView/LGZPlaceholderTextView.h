//
//  LGZPlaceholderTextView.h
//  百思不得姐
//
//  Created by LGZwr on 16/5/17.
//  Copyright © 2016年 LGZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGZPlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;

/** 文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
