//
//  D5RoundProgressView.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2017/1/6.
//  Copyright © 2017年 PangDou. All rights reserved.
//

#import "D5RoundProgressView.h"

@interface D5RoundProgressView() {
    id _target;
    SEL _action;
    BOOL isAnimating;
    NSTimer *_waveTimer;
}

/** 进度圈 */
@property (nonatomic, strong) CAShapeLayer *realCircleLayer;

/** 底圈 */
@property (nonatomic, strong) CAShapeLayer *maskCircleLayer;

/** 竖线 */
@property (nonatomic, strong) CAShapeLayer *verticalLineLayer;

@property (nonatomic, strong) UILabel *progressLabel;

@end


@implementation D5RoundProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    
    self.progressWidth = 2;
    
    _progress = 0.0f;
    isAnimating = NO;
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    
    self.maskCircleLayer.lineWidth = progressWidth;
    self.realCircleLayer.lineWidth = progressWidth + 0.5;
}

/**
 设置进度之前，要设置totalInterval

 @param progress 进度，在这里是时间
 */
- (void)setProgress:(CGFloat)progress {
    @autoreleasepool {
        if (self.isHidden) {
            return;
        }
        if (_totalInterval == 0) {
            return;
        }
        
        CGFloat realProgress = progress /_totalInterval;
        
        _progress = MAX(MIN(realProgress, 1.0), 0.0); // keep it between 0 and 1
        
        //进度
        self.realCircleLayer.path = [self getCirclePathWithProgress:_progress].CGPath;
        
        self.progressLabel.text = [NSString stringWithFormat:@"%ds", (int)_totalInterval - (int)progress];
    }
}

- (void)setTotalInterval:(NSTimeInterval)totalInterval {
    _totalInterval = totalInterval;
    
    self.progressLabel.text = [NSString stringWithFormat:@"%ds", (int)_totalInterval];
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        
        _progressLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        _progressLabel.textColor = self.labelColor;
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.adjustsFontSizeToFitWidth = YES;
        _progressLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}

- (UIColor *)maskCircleColor {
    if (!_maskCircleColor) {
        _maskCircleColor = [UIColor colorWithHex:0xffd400 alpha:1];
    }
    return _maskCircleColor;
}

- (UIColor *)realCircleColor {
    if (!_realCircleColor) {
        _realCircleColor = [UIColor colorWithHex:0x333333 alpha:1];
    }
    return _realCircleColor;
}

- (UIColor *)labelColor {
    if (!_labelColor) {
        _labelColor = [UIColor colorWithHex:0xffd400 alpha:1];
        
    }
    return _labelColor;
}

/**
 底圈

 @return 底圈
 */
- (CAShapeLayer *)maskCircleLayer {
    if (!_maskCircleLayer) {
        _maskCircleLayer = [self getOriginLayer];
        _maskCircleLayer.strokeColor = self.maskCircleColor.CGColor;
       
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:[self bounds]];
        _maskCircleLayer.path = path.CGPath;
        [self.layer addSublayer:self.maskCircleLayer];
    }
    return _maskCircleLayer;
}

- (CAShapeLayer *)realCircleLayer {
    if (!_realCircleLayer) {
        _realCircleLayer = [self getOriginLayer];
        _realCircleLayer.strokeColor = self.realCircleColor.CGColor;
      
        [self.layer addSublayer:self.realCircleLayer];
    }
    return _realCircleLayer;
}

- (CAShapeLayer *)getOriginLayer {
    @autoreleasepool {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = [self bounds];
        layer.lineWidth = self.progressWidth;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineCap = kCALineCapRound;
        return layer;
    }
}


/**
 *  获取圆圈进度
 *
 *  @param progress 当前进度值
 *
 *  @return path
 */
- (UIBezierPath *)getCirclePathWithProgress:(CGFloat)progress {
    @autoreleasepool {
        CGFloat squareW = CGRectGetWidth(self.frame) / 2;
        CGFloat squareH = CGRectGetHeight(self.frame) / 2;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(squareW, squareH)
                                                            radius:squareW
                                                        startAngle: - M_PI_2
                                                          endAngle: (M_PI * 2) * progress - M_PI_2
                                                         clockwise:YES];
        return path;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
