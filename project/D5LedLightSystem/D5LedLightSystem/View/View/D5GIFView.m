//
//  D5GIFView.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/8/10.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5GIFView.h"
#import <QuartzCore/QuartzCore.h>

@implementation D5GIFView

- (void)initGIF {
    @autoreleasepool {
        gifProperties = [NSDictionary dictionaryWithObject:
                         [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    @autoreleasepool {
        NSLog(@"initWithFrame");
        if (self = [super initWithFrame:frame]) {
//            [self initGIF];
        }
        
        return self;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    @autoreleasepool {
        NSLog(@"initWithCoder");
        if (self = [super initWithCoder:aDecoder]) {
            [self initGIF];
        }
        
        return self;
    }
}

- (void)setGifData:(NSData *)gifData {
    _gifData = gifData;
    
    gif = CGImageSourceCreateWithData((CFDataRef)_gifData, (CFDictionaryRef)gifProperties);
    count = CGImageSourceGetCount(gif);
}

- (void)startPlay {
    @autoreleasepool {
        if (!timer) {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(play) userInfo:nil repeats:YES];
        }
        [timer fire];
    }
}

- (void)play {
    if (self.isHidden) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        return;
    }
    
    index ++;
    index = index % count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
    self.layer.contents = (id)ref;
    CFRelease(ref);
}

- (void)dealloc {
    NSLog(@"dealloc");
    CFRelease(gif);
    [gifProperties release];
    [super dealloc];
}
@end
