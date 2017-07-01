//
//  D5PCTanslateSongs.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5PCTanslateSongs.h"
#import "D5TransferMusic.h"

@interface D5PCTanslateSongs() <D5TransferMusicDelegate>

@end

@implementation D5PCTanslateSongs

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"电脑传歌"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.ipAdreess.text = @"";
    [D5BarItem setLeftBarItemWithImage:[UIImage imageNamed:@"back"] target:self action:@selector(back)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [D5TransferMusic sharedInstance].delegate = self;
    [[D5TransferMusic sharedInstance] transferServiceOpen:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[D5TransferMusic sharedInstance] transferServiceOpen:NO];
}

#pragma mark - 传歌服务开关结果
- (void)openTransferServiceFinish:(BOOL)isFinish ipv4:(NSString *)ipv4 port:(int)port url:(NSString *)url {
    @autoreleasepool {
        if (isFinish) {
            [MobClick event:UM_ADD_MUSIC_TYPE attributes:@{LED_STR_TYPE : [NSString stringWithFormat:@"%d", UMAddMusicTypeMac]}];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.ipAdreess.text = [NSString stringWithFormat:@"http://%@:%@", ipv4, [NSString stringWithFormat:@"%d", port]];
                
//                [iToast showButtomTitile:@"开始PC传歌"];
            });
        }
    }
}

- (void)closeTransferServiceFinish:(BOOL)isFinish {
    if (isFinish) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            [iToast showButtomTitile:@"停止PC传歌"];
            self.ipAdreess.text = @"";
        });
    }
}

@end
