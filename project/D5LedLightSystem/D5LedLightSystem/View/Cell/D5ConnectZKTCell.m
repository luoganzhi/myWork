//
//  D5ConnectZKTCell.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ConnectZKTCell.h"

@interface D5ConnectZKTCell()

@property (weak, nonatomic) IBOutlet UIImageView *_boxImgView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@end

@implementation D5ConnectZKTCell

- (void)setData:(D5LedZKTBoxData *)data selectedIdentifier:(NSString *)selectedIdentifier {
    @autoreleasepool {
        _boxMacLabel.text = data.boxName;
        
        if ([NSString isValidateString:selectedIdentifier] && [selectedIdentifier isEqualToString:data.boxId]) { //被选择的
            _btnSelect.selected = YES;
        } else {
            _btnSelect.selected = NO;
        }
    }
}

@end
