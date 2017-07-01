//
//  D5LightController.h
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/9.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BaseViewController.h"
#import "YHArcSlider.h"
@interface D5LightController : D5BaseViewController
@property (weak, nonatomic) IBOutlet YHArcSlider *mySlider;//我的滑动条
@property (weak, nonatomic) IBOutlet UILabel *brightessProgress;//亮度显示
@property (weak, nonatomic) IBOutlet UILabel *switchStatus;//开关状态

@end
