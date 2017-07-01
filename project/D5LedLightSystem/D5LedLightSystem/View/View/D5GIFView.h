//
//  D5GIFView.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/10.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface D5GIFView : UIView {
    CGImageSourceRef gif;
    NSDictionary *gifProperties;
    size_t index;
    size_t count;
    NSTimer *timer;
}

@property (nonatomic, strong) NSData *gifData;

- (void)startPlay;

@end
