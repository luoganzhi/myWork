//
//  D5LedWelcomeViewController.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/19.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5BaseViewController.h"

#define LED_WELCCOME_VC_ID @"LED_WELCCOME_VC"

@protocol D5LedWelcomeDelegate <NSObject>

- (void)welcome;

@end

@interface D5LedWelcomeViewController : D5BaseViewController

@property (nonatomic, weak) id<D5LedWelcomeDelegate> delegate;

@end
