//
//  D5PrepareConnectViewController.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BaseViewController.h"

#define PREPARE_CONNECT_VC_ID @"PREPARE_CONNECT_VC"

@interface D5PrepareConnectViewController : D5BaseViewController

@property (assign, nonatomic) BOOL isConnectWIFI;
//@property (assign, nonatomic) BOOL isOpenBlueTooth;

- (void)setWIFIView;

@end
