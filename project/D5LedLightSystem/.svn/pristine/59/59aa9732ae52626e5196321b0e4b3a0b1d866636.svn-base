//
//  D5SheetController.h
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SheetControllerVC @"SheetController"

typedef void(^ACTIONOP)(void);

@interface D5SheetController : D5BaseViewController

@property (weak, nonatomic) IBOutlet UIView *topview;
@property (weak, nonatomic) IBOutlet UIView *buttomView;

@property(nonatomic,copy)ACTIONOP mobileTranslate;//选择手机传歌
@property(nonatomic,copy)ACTIONOP pcTranslate;//选择PC上传
/** usb传歌 */
@property (nonatomic, copy) ACTIONOP usbTfTranslate; 

-(void)setAnimation:(UIViewController*)vc animation:(BOOL)animation;

-(void)hideAnimation:(BOOL)animation;

@end
