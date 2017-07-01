//
//  D5Popovercontroller.m
//  MyPopOver
//
//  Created by 熊少云 on 15/6/18.
//  Copyright (c) 2015年 D5. All rights reserved.
//

#import "D5Popovercontroller.h"
#import <objc/message.h>

static D5Popovercontroller * defaultPopOverController = nil;
#define ARROW_DEFAULT_SIZE CGSizeMake(50, 50)
#define ARROW_UP_IMAGE [UIImage imageNamed:@"d5popoverarrowup.png"]
#define ARROW_DOWN_IMAGE [UIImage imageNamed:@"d5popoverarrowdown.png"]
#define ARROW_LEFT_IMAGE [UIImage imageNamed:@"d5popoverarrowleft.png"]
#define ARROW_RIGHT_IMAGE [UIImage imageNamed:@"d5popoverarrowright.png"]
#define SCREEN_SIZE_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_SIZE_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEFAULT_CONTAINER_WIDTH SCREEN_SIZE_WIDTH - 40
#define DEFAULT_CONTAINER_HEIGHT ([UIScreen mainScreen].bounds.size.height/2)

@interface D5Popovercontroller()
@property (retain,nonatomic) UIView * containerView;//放置目标sUIViewController，和箭头的容器
@property (retain,nonatomic) UIImageView * arrowView;//箭头
@property (retain,nonatomic) UIView * arrowFromView;//为方便布局多出来的一个空view，用来确定显示的内容的位置
@property (retain,nonatomic) UIViewController * contentController;//需要显示的UIViewController

@property (assign,nonatomic) D5PopoverArrowDirection arrowDirection;//箭头方向
@property (assign,nonatomic) CGRect arrowFromRect;//为布局而提前预定的空view的位置
@property (assign,nonatomic) CGSize arrowViewSize;// 箭头的尺寸
@property (assign,nonatomic) CGSize containerViewSize;//容器尺寸
@property (assign,nonatomic) CGSize contentViewControllerSize;
@property (retain,nonatomic) UIWindow *window;
@property (assign,nonatomic) BOOL arrowhidden;

@property (retain,nonatomic) NSMutableArray * windowConstraintsArray;
@property (retain,nonatomic) NSMutableArray * arrowFromViewConstraintsArray;
@property (retain,nonatomic) NSMutableArray * containerViewConstraintsArray;
@property (retain,nonatomic) NSMutableArray * arrowViewConstraintsArray;
@property (retain,nonatomic) NSMutableArray * contentViewControllerConstraintsArray;
@property (assign,nonatomic) D5PopovercontrollerContentAlignment contentAlignment;
@property (assign,nonatomic) CGFloat radius;
@end

@implementation D5Popovercontroller
#pragma mark - present popovercontroller
- (instancetype)initWithRootViewController:(UIViewController *)vc {
    self = [super init];
    if (self) {
        [self initSubViews];
        self.rootViewController = vc;
        _bgColor = [UIColor clearColor];
        _isClickDismiss = NO;
        defaultPopOverController = self;
        _contentAlignment = D5PopovercontrollerAlignmentToSourceViewNone;
        _borderColor = [UIColor colorWithRed:(234.0/255.0) green:(234.0/255.0) blue:(234.0/255.0) alpha:0.9];
    }
    return self;
}

#pragma mark - public method
- (void)presentController:(UIViewController *)contentController
               sourceView:(UIView *)fromView
          arrowDirecttion:(D5PopoverArrowDirection)direction
         contentAlignment:(D5PopovercontrollerContentAlignment)alignment{
    _contentController = contentController;
    _arrowDirection = direction;
    _contentAlignment = alignment;
    [_contentController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (fromView == nil) {//确定显示模式，居中显示
        //        _arrowDirection = D5PopoverArrowDirectionNone;
        _arrowhidden = YES;
    }
    
    [_contentController view];
    
    
    //初始化各个控件的位置或者尺寸
    
    if (fromView) {
        _arrowFromRect = [fromView convertRect:fromView.bounds toView:self];
    }
    if (_contentViewControllerSize.height == 0 && _contentViewControllerSize.width == 0) {
        if ([_contentController respondsToSelector:@selector(preferredContentSize)]) {
            _contentViewControllerSize = [_contentController preferredContentSize];
            if (_contentViewControllerSize.width == 0 && _contentViewControllerSize.height == 0) {
                _contentViewControllerSize = [_contentController.view bounds].size;
            }
        } else {
            _contentViewControllerSize = [_contentController.view bounds].size;
        }
    }
    @autoreleasepool {
        UIImage *image = nil;
        if (_arrowDirection == D5PopoverArrowDirectionup) {
            image = ARROW_UP_IMAGE;
        } else if (_arrowDirection == D5PopoverArrowDirectionDown) {
            image  = ARROW_DOWN_IMAGE;
        }
        _arrowViewSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
        [_arrowView setImage:image];
    }
    
    [self show];
}
- (void)hideArrow {
    _arrowhidden = YES;
}
- (void)setContentSize:(CGSize)size {
    _contentViewControllerSize = size;
}
#pragma mark - dismiss
- (void)dismiss{
    [UIView animateWithDuration:0.1f  delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        if (![D5String isIphone4]) {
            _containerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        }
    } completion:^(BOOL finished){
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        if (_popOverdelegate && [_popOverdelegate respondsToSelector:@selector(d5popoverControllerWillDismiss:)]) {
            [_popOverdelegate d5popoverControllerWillDismiss:self];
        }
        [self removeKeyboardObserver];
        _radius = 0;
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.rootViewController = nil;
        [self resignKeyWindow];
        
        defaultPopOverController = nil;
        
        [[[[UIApplication sharedApplication] windows] firstObject] makeKeyAndVisible];
    }];
    
}

#pragma mark - tap gesture method
- (void)addTapGesture{
    @autoreleasepool {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
}

#pragma mark - add keyboard method
- (void)addKeyboardObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [self removeKeyboardObserver];
}

- (void) keyBoardWillShow:(NSNotification *)notification{
    NSDictionary * dic = [notification userInfo];
    CGRect keyboardRect = [[dic valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGFloat keyboardTopY = SCREEN_SIZE_HEIGHT - keyboardHeight;
    
    CGFloat containerViewBottomY = _containerView.frame.origin.y + _containerView.frame.size.height;
    
    CGFloat distance = containerViewBottomY - keyboardTopY;
    if(distance > 0){
        CGRect rect = self.frame;
        rect.origin.y -= distance;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        self.frame = rect;
        [UIView commitAnimations];
    }
    
}
- (void) keyBoardWillHidden:(NSNotification *)notification{
    CGRect rect = self.frame;
    rect.origin.y = 0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    self.frame = rect;
    [UIView commitAnimations];
}
#pragma mark - init method
- (void) initSubViews{
    [self initWindow];
    
    [self confirmSize];
    [self initArrowFromView];
    [self initArrowView];
    [self initContainerView];
    [self initConstaintArray];
    
    self.windowLevel = UIWindowLevelAlert;
}

- (void)initContainerView {
    if(_containerView == nil){
        _containerView = [[UIView alloc] init];
        [_containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_containerView setBackgroundColor:[UIColor clearColor]];
    }
}
- (void)initWindow {
    if (self == nil) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)initArrowFromView {
    if( _arrowFromView == nil){
        _arrowFromView = [[UIView alloc] init];
        _arrowFromView.backgroundColor = [UIColor clearColor];
        [_arrowFromView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}
- (void)initArrowView{
    if(_arrowView == nil){
        _arrowView = [[UIImageView alloc] init];
        [_arrowView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}
- (void)initConstaintArray{
    _windowConstraintsArray = [[NSMutableArray alloc] init];
    _arrowViewConstraintsArray = [[NSMutableArray alloc] init];
    _arrowFromViewConstraintsArray = [[NSMutableArray alloc] init];
    _containerViewConstraintsArray = [[NSMutableArray alloc] init];
    _contentViewControllerConstraintsArray = [[NSMutableArray alloc] init];
}

#pragma mark - size confirm method
- (void)confirmSize{
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.origin = CGPointMake(0, 0);
    self.frame = rect;
}

- (void)comfirmContainerSize{
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    if(_arrowhidden){
        width = _contentViewControllerSize.width;
        height = _contentViewControllerSize.height;
    }else if(_arrowDirection == D5PopoverArrowDirectionup || _arrowDirection == D5PopoverArrowDirectionDown){
        width = _contentViewControllerSize.width;
        height = _contentViewControllerSize.height + _arrowViewSize.height;
    }
    
    if(width > DEFAULT_CONTAINER_WIDTH){
        width = DEFAULT_CONTAINER_WIDTH;
    }
    if(height > DEFAULT_CONTAINER_HEIGHT){
        height = DEFAULT_CONTAINER_HEIGHT;
    }
    _containerViewSize = CGSizeMake(width, height);
}

#pragma mark - add subviews
- (void) subViewAdd{
    [self addSubview:_arrowFromView];
    [self addSubview:_containerView];
    [_containerView addSubview:_arrowView];
    [_containerView addSubview:_contentController.view];
    
    [_containerView becomeFirstResponder];
}
#pragma mark - show window
- (void)show{
    self.backgroundColor = _bgColor;
    
    if (_isClickDismiss) {
        [self addTapGesture];
    }
    //    if(_window == nil){
    [self initSubViews];
    //    }
    [self comfirmContainerSize];
    [self subViewAdd];
    [self layoutArrowFromView];
    [self layoutContainerView];
    [self layoutContentViewController];
    [self layoutArrowView];
    
    [self constraintAdd];
    [_contentController viewWillAppear:YES];
    [self updateConstraints];
    
    [self layoutIfNeeded];
    [_contentController.view layoutIfNeeded];
    [self makeKeyAndVisible];
    [self setRadiusForContent];
    [self addKeyboardObserver];
    
    _containerView.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _containerView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
-(void)setRadius:(CGFloat)radius{
    _radius = radius;
}
- (void)setRadiusForContent {
    if(_radius == 0){
        return;
    }
    CALayer * layer = _contentController.view.layer;
    layer.cornerRadius = _radius;
    layer.borderColor = _contentController.view.backgroundColor.CGColor;
    layer.masksToBounds = YES;
    layer.borderColor = _borderColor.CGColor;
    layer.borderWidth = 1;
    
    //    CALayer * layer2 =  _containerView.layer;
    //    layer2.cornerRadius = _radius;
    //    layer2.borderColor = _containerView.backgroundColor.CGColor;
    //    layer2.borderWidth = 2;
}

- (void) constraintAdd{
    if(_arrowFromViewConstraintsArray.count > 0){
        NSArray * array = [_arrowFromView constraints];
        [_arrowFromView removeConstraints:array];
        [_arrowFromView addConstraints:_arrowFromViewConstraintsArray];
    }
    if(_containerViewConstraintsArray.count > 0){
        NSArray * array = [_containerView constraints];
        [_containerView removeConstraints:array];
        [_containerView addConstraints:_containerViewConstraintsArray];
    }
    if(_arrowViewConstraintsArray.count > 0){
        NSArray * array = [_arrowView constraints];
        [_arrowView removeConstraints:array];
        [_arrowView addConstraints:_arrowViewConstraintsArray];
    }
    if(_contentViewControllerConstraintsArray.count > 0){
        NSArray * array = [_contentController.view constraints];
        [_contentController.view removeConstraints:array];
        [_contentController.view addConstraints:_contentViewControllerConstraintsArray];
    }
    if(_windowConstraintsArray.count > 0){
        NSArray * array = [self constraints];
        [self removeConstraints:array];
        [self addConstraints:_windowConstraintsArray];
    }
}
#pragma mark - layout set method

- (void) layoutArrowFromView{
    _arrowView.hidden = _arrowhidden;
    NSLayoutConstraint * with = [NSLayoutConstraint constraintWithItem:_arrowFromView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_arrowFromRect.size.width];
    
    
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:_arrowFromView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_arrowFromRect.size.height];
    
    [_arrowFromViewConstraintsArray addObject:with];
    [_arrowFromViewConstraintsArray addObject:height];
    
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:_arrowFromView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:_arrowFromRect.origin.x];
    
    
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:_arrowFromView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:_arrowFromRect.origin.y];
    
    [_windowConstraintsArray addObject:left];
    [_windowConstraintsArray addObject:right];
    
}
- (void) layoutArrowView{
    if((_arrowDirection == D5PopoverArrowDirectionDown || _arrowDirection == D5PopoverArrowDirectionup) && !_arrowhidden){
        [self layoutArrowViewSize];
        [self layoutArrowViewupOrDown];
    }
    
}
-(void) layoutContainerView{
    [self layoutContainerViewSize];
    if((_arrowhidden) && _contentAlignment == D5PopovercontrollerAlignmentToSourceViewNone){
        [self layoutContainerViewCenter];
    }else if(_arrowDirection == D5PopoverArrowDirectionDown || _arrowDirection == D5PopoverArrowDirectionup || _contentAlignment != D5PopovercontrollerAlignmentToSourceViewNone){
        [self layoutContainerViewUpOrDown];
    }
}
- (void) layoutContentViewController{
    if(_arrowDirection == D5PopoverArrowDirectionDown || _arrowDirection == D5PopoverArrowDirectionup){
        [self layoutContentViewControllerUpOrDown];
    }
}
#pragma mark - layout arrow method
- (void) layoutArrowViewSize{
    NSLayoutConstraint * with = [NSLayoutConstraint constraintWithItem:_arrowView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_arrowViewSize.width];
    
    
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:_arrowView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_arrowViewSize.height];
    
    [_arrowViewConstraintsArray addObject:with];
    [_arrowViewConstraintsArray addObject:height];
}
- (void) layoutArrowViewupOrDown{
    NSLayoutConstraint * centerx = [NSLayoutConstraint constraintWithItem:_arrowView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    [_windowConstraintsArray addObject:centerx];
    
    NSLayoutConstraint * topOrBottom = nil;
    if(_arrowDirection == D5PopoverArrowDirectionup){
        topOrBottom = [NSLayoutConstraint constraintWithItem:_arrowView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    }else if(_arrowDirection == D5PopoverArrowDirectionDown){
        topOrBottom = [NSLayoutConstraint constraintWithItem:_arrowView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    }
    if(topOrBottom){
        [_containerViewConstraintsArray addObject:topOrBottom];
    }
}
#pragma mark - layout contentviewcontroller method
- (void)layoutContentViewControllerUpOrDown{
    NSLayoutConstraint * top = nil;
    NSLayoutConstraint * bottom = nil;
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:_contentController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:_contentController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
    
    if(_arrowhidden){
        top = [NSLayoutConstraint constraintWithItem:_contentController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        bottom = [NSLayoutConstraint constraintWithItem:_contentController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    }else if (_arrowDirection == D5PopoverArrowDirectionup){
        top = [NSLayoutConstraint constraintWithItem:_contentController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_arrowView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        bottom = [NSLayoutConstraint constraintWithItem:_contentController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    }else if (_arrowDirection == D5PopoverArrowDirectionDown){
        top = [NSLayoutConstraint constraintWithItem:_contentController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_containerView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        bottom = [NSLayoutConstraint constraintWithItem:_contentController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_arrowView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    }
    
    [_containerViewConstraintsArray addObject:left];
    [_containerViewConstraintsArray addObject:right];
    if(top){
        [_containerViewConstraintsArray addObject:top];
    }
    if(bottom){
        [_containerViewConstraintsArray addObject:bottom];
    }
}
#pragma mark - layout container method
- (void) layoutContainerViewCenter{
    NSLayoutConstraint * centerx = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint * centery = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    
    [_windowConstraintsArray addObject:centerx];
    [_windowConstraintsArray addObject:centery];
}
- (void) layoutContainerViewUpOrDown{
    CGFloat leftDistanceToWindow = 0;
    CGFloat rightDistantceToWindow = 0;
    CGFloat centerXOfArrowFromView = _arrowFromRect.origin.x + _arrowFromRect.size.width / 2;
    
    leftDistanceToWindow = centerXOfArrowFromView - _containerViewSize.width / 2;
    rightDistantceToWindow = SCREEN_SIZE_WIDTH - (centerXOfArrowFromView + _containerViewSize.width / 2);
    if(leftDistanceToWindow > 0 && rightDistantceToWindow > 0){
        if(_contentAlignment == D5PopovercontrollerAlignmentToSourceViewNone){
            _contentAlignment = D5PopovercontrollerAlignmentToSourceViewCenter;
        }
    }else if (leftDistanceToWindow > 0 && rightDistantceToWindow < 0){
        CGFloat arrowFromRectRight = _arrowFromRect.origin.x + _arrowFromRect.size.width;
        CGFloat containerLeft = arrowFromRectRight - _containerViewSize.width;
        if(containerLeft <= 0){//右对齐，左边超出手机屏幕
            _contentAlignment = D5PopovercontrollerAlignmentToSourceViewNone;
            CGFloat distance = (leftDistanceToWindow + rightDistantceToWindow) / 2;
            [self layoutContainerViewToWindowRight:distance];
            return;
        }else{
            _contentAlignment = D5PopovercontrollerAlignmentToSourceViewRight;
        }
    }else if (leftDistanceToWindow < 0 && rightDistantceToWindow > 0){
        CGFloat arrowFromRectLeft = _arrowFromRect.origin.x;
        CGFloat containerRight = arrowFromRectLeft + _containerViewSize.width;
        if(SCREEN_SIZE_WIDTH - containerRight < 0 ){//左对齐，右边超出手机屏幕
            _contentAlignment = D5PopovercontrollerAlignmentToSourceViewNone;
            CGFloat distance = (leftDistanceToWindow + rightDistantceToWindow) / 2;
            [self layoutContainerViewToWindowLeft:distance];
            return;
        }else{
            _contentAlignment = D5PopovercontrollerAlignmentToSourceViewLeft;
        }
    }
    [self layoutContainerViewToWindowByAligment];
}
- (void)layoutContainerViewSize{
    NSLayoutConstraint * with = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_containerViewSize.width];
    
    
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_containerViewSize.height];
    
    [_containerViewConstraintsArray addObject:with];
    [_containerViewConstraintsArray addObject:height];
}
- (void) layoutContainerViewToWindowRight:(CGFloat)rightDistance{
    //右对齐，左边超出手机屏幕
    @autoreleasepool {
        NSLayoutConstraint * upOrDown = nil;
        if(_arrowDirection == D5PopoverArrowDirectionup){
            upOrDown = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        }else if(_arrowDirection == D5PopoverArrowDirectionDown){
            upOrDown = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        }
        NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-rightDistance];
        
        [_windowConstraintsArray addObject:upOrDown];
        [_windowConstraintsArray addObject:right];
    }
}
- (void) layoutContainerViewToWindowLeft:(CGFloat)leftDistance{
    //左对齐，右边超出手机屏幕
    @autoreleasepool {
        NSLayoutConstraint * upOrDown = nil;
        if(_arrowDirection == D5PopoverArrowDirectionup){
            upOrDown = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        }else if(_arrowDirection == D5PopoverArrowDirectionDown){
            upOrDown = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        }
        NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_window attribute:NSLayoutAttributeLeading multiplier:1.0f constant:leftDistance];
        
        [_windowConstraintsArray addObject:upOrDown];
        [_windowConstraintsArray addObject:left];
    }
}
- (void) layoutContainerViewToWindowByAligment{
    if(_contentAlignment == D5PopovercontrollerAlignmentToSourceViewNone){
        return;
    }else{
        NSLayoutConstraint * upOrDown = nil;
        if(_arrowDirection == D5PopoverArrowDirectionup){
            upOrDown = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        }else if(_arrowDirection == D5PopoverArrowDirectionDown){
            upOrDown = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        }
        NSLayoutConstraint * leftOrRight = nil;
        NSLayoutConstraint * centerX = nil;
        if(_contentAlignment == D5PopovercontrollerAlignmentToSourceViewLeft){
            leftOrRight = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
        }else if(_contentAlignment == D5PopovercontrollerAlignmentToSourceViewRight){
            leftOrRight = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
        }else if(_contentAlignment == D5PopovercontrollerAlignmentToSourceViewCenter){
            centerX = [NSLayoutConstraint constraintWithItem:_containerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_arrowFromView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
        }
        if(upOrDown){
            [_windowConstraintsArray addObject:upOrDown];
        }
        if(leftOrRight){
            [_windowConstraintsArray addObject:leftOrRight];
        }else{
            [_windowConstraintsArray addObject:centerX];
        }
    }
}

@end
