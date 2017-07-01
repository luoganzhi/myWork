//
//  D5SpecialCell.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/3.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SpecialCell.h"

@interface D5SpecialCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *djLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnLook;


- (IBAction)btnLookClicked:(UIButton *)sender;

@end

@implementation D5SpecialCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(D5MusicSpecialData *)data {
    @autoreleasepool {
        _nameLabel.text = data.specialName;
        _djLabel.text = data.specialDJ;
    }
}

- (IBAction)btnLookClicked:(UIButton *)sender {
    
    if (self.lookBlock) {
        self.lookBlock();
    }
    
}

//#pragma mark - <MyDelegate>
//- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header
//{
//    @autoreleasepool {
//        if (errorType == D5SocketErrorCodeTypeTimeOut) {
//            //DLog(@"获取特效库超时:%d->%d",header->cmd,header->subCmd);
//        } else if (errorType == D5SocketErrorCodeTypeTCPSendDataFailed) {
//            
//        }
//        
//    }
//}


@end
