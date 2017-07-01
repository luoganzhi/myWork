//
//  D5WebViewController.h
//  D5LedLightSystem
//
//  Created by PangDou on 2016/9/26.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BaseViewController.h"

#define WEB_VC_ID @"WEB_VC"

@interface D5WebViewController : D5BaseViewController

@property (nonatomic, copy) NSString *htmlFileName;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, copy) NSString *url;

@end
