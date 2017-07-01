//
//  D5ToastViewController.h
//  D5LedLightSystem
//
//  Created by LGZwr on 2016/12/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D5ToastViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

/** title */
//@property (nonatomic, copy) NSString *titleStr;

+ (instancetype)shareView;

- (void)showView;

- (void)hideView;
/** 设置控件值 */
- (void)setLabelWithTitle:(NSString *)title LeftBtn:(NSString *)left RightBtn:(NSString *)right;

/** 左边按钮点击事件 */
@property (nonatomic, copy) void(^leftBtnClickBlock)();
/** 右边按钮点击事件 */
@property (nonatomic, copy) void(^rightBtnClickBlock)();
@end
