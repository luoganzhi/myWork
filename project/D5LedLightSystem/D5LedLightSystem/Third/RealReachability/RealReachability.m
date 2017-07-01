//
//  RealReachability.m
//  RealReachability
//
//  Created by Dustturtle on 16/1/9.
//  Copyright © 2016 Dustturtle. All rights reserved.
//

#import "RealReachability.h"
#import "FSMEngine.h"
#import "LocalConnection.h"
#import "PingHelper.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

typedef void(^PDDelayedBlockHandle) (BOOL cancel);

#if (!defined(DEBUG))
#define NSLog(...)
#endif

#define kDefaultHost @"www.apple.com"
#define kDefaultCheckInterval 2.0f
#define kDefaultPingTimeout 2.0f

#define kMinAutoCheckInterval 5.0f
#define kMaxAutoCheckInterval 60.0f

NSString *const kRealReachabilityChangedNotification = @"kRealReachabilityChangedNotification";

@interface RealReachability()
@property (nonatomic, strong) FSMEngine *engine;
@property (nonatomic, assign) BOOL isNotifying;

@property (nonatomic,strong) NSArray *typeStrings4G;
@property (nonatomic,strong) NSArray *typeStrings3G;
@property (nonatomic,strong) NSArray *typeStrings2G;

@property (nonatomic, assign) ReachabilityStatus previousStatus;

@property (nonatomic, copy) PDDelayedBlockHandle delayedBlockHandle;

@property (nonatomic, assign) NSTimeInterval pingCheckTime;

@end

@implementation RealReachability

#pragma mark - Life Circle

- (id)init
{
    if ((self = [super init]))
    {
        _engine = [[FSMEngine alloc] init];
        [_engine start];
        
        _typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];
        
        _typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];
        
        _typeStrings4G = @[CTRadioAccessTechnologyLTE];
        
        _hostForPing = [D5CurrentBox currentBoxIP];
//        _hostForPing = kDefaultHost;
        _autoCheckInterval = kDefaultCheckInterval;
        _pingTimeout = kDefaultPingTimeout;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.engine = nil;
    
    [GLocalConnection stopNotifier];
}

#pragma mark - Handle system event

- (void)appBecomeActive
{
    if (self.isNotifying)
    {
        [self reachabilityWithBlock:nil];
    }
}

#pragma mark - Singlton Method

+ (instancetype)sharedInstance
{
    static id localConnection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localConnection = [[self alloc] init];
    });
    
    return localConnection;
}

#pragma mark - actions

- (void)startNotifier
{
    if (self.isNotifying)
    {
        // avoid duplicate action
        return;
    }
    
    self.isNotifying = YES;
    self.previousStatus = RealStatusUnknown;
    
    NSDictionary *inputDic = @{kEventKeyID:@(RREventLoad)};
    [self.engine receiveInput:inputDic];
    
    [GLocalConnection startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localConnectionChanged:)
                                                 name:kLocalConnectionChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localConnectionInitialized:)
                                                 name:kLocalConnectionInitializedNotification
                                               object:nil];
    
    GPingHelper.host = _hostForPing;
    GPingHelper.timeout = self.pingTimeout;
    GPingHelper.weakBlock = [_wifiWeakBlock copy];
    GPingHelper.strongBlock = [_wifiStrongBlock copy];
    
    [self autoCheckReachability];
}

- (void)stopNotifier {
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"start_check_time"];
    
    cancel_delayed_block(_delayedBlockHandle);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLocalConnectionChangedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLocalConnectionInitializedNotification
                                                  object:nil];
    
    NSDictionary *inputDic = @{kEventKeyID:@(RREventUnLoad)};
    [self.engine receiveInput:inputDic];
    
    [GLocalConnection stopNotifier];
    
    self.isNotifying = NO;
}

#pragma mark - outside invoke

- (void)reachabilityWithBlock:(void (^)(ReachabilityStatus status))asyncHandler
{
    // logic optimization: no need to ping when Local connection unavailable!
    if ([GLocalConnection currentLocalConnectionStatus] == LC_UnReachable)
    {
        if (asyncHandler != nil)
        {
            asyncHandler(RealStatusNotReachable);
        }
        return;
    }
    
    ReachabilityStatus status = [self currentReachabilityStatus];
    __weak __typeof(self)weakSelf = self;
    [GPingHelper pingWithBlock:^(BOOL isSuccess)
     {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
         NSDictionary *inputDic = @{kEventKeyID:@(RREventPingCallback), kEventKeyParam:@(isSuccess)};
         NSInteger rtn = [strongSelf.engine receiveInput:inputDic];
         if (rtn == 0) // state changed & state available, post notification.
         {
             if ([strongSelf.engine isCurrentStateAvailable])
             {
                 strongSelf.previousStatus = status;
                 // this makes sure the change notification happens on the MAIN THREAD
                 __weak __typeof(strongSelf)deepWeakSelf = strongSelf;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     __strong __typeof(deepWeakSelf)deepStrongSelf = deepWeakSelf;
                     [[NSNotificationCenter defaultCenter] postNotificationName:kRealReachabilityChangedNotification
                                                                         object:deepStrongSelf];
                 });
             }
         }
         
         if (asyncHandler != nil)
         {
             RRStateID currentID = strongSelf.engine.currentStateID;
             switch (currentID)
             {
                 case RRStateUnReachable:
                 {
                     asyncHandler(RealStatusNotReachable);
                     break;
                 }
                 case RRStateWIFI:
                 {
                     asyncHandler(RealStatusViaWiFi);
                     break;
                 }
                 case RRStateWWAN:
                 {
                     asyncHandler(RealStatusViaWWAN);
                     break;
                 }
                     
                 default:
                 {
                     NSLog(@"warning! reachState uncertain! state unmatched, treat as unreachable temporary");
                     asyncHandler(RealStatusNotReachable);
                     break;
                 }
             }
         }
     }];
}

- (ReachabilityStatus)currentReachabilityStatus
{
    RRStateID currentID = self.engine.currentStateID;
    
    switch (currentID)
    {
        case RRStateUnReachable:
        {
            return RealStatusNotReachable;
        }
        case RRStateWIFI:
        {
            return RealStatusViaWiFi;
        }
        case RRStateWWAN:
        {
            return RealStatusViaWWAN;
        }
        case RRStateLoading:
        {
            // status on loading, return local status temporary.
            return (ReachabilityStatus)(GLocalConnection.currentLocalConnectionStatus);
        }
            
        default:
        {
            NSLog(@"No normal status matched, return unreachable temporary");
            return RealStatusNotReachable;
        }
    }
}

- (ReachabilityStatus)previousReachabilityStatus
{
    return self.previousStatus;
}

- (void)setHostForPing:(NSString *)hostForPing
{
    _hostForPing = nil;
    _hostForPing = [hostForPing copy];
    
    GPingHelper.host = _hostForPing;
}

- (void)setPingTimeout:(NSTimeInterval)pingTimeout {
    _pingTimeout = pingTimeout;
    GPingHelper.timeout = pingTimeout;
}

- (WWANAccessType)currentWWANtype
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([accessString length] > 0)
        {
            return [self accessTypeForString:accessString];
        }
        else
        {
            return WWANTypeUnknown;
        }
    }
    else
    {
        return WWANTypeUnknown;
    }
}

#pragma mark  delayed block 
static PDDelayedBlockHandle perform_block_after_delay(CGFloat seconds, dispatch_block_t block) {
    if (block == nil) {
        return nil;
    }
    
    __block dispatch_block_t blockToExecute = [block copy];
    __block PDDelayedBlockHandle delayHandleCopy = nil;
    
    PDDelayedBlockHandle delayHandle = ^(BOOL cancel) {
        if (!cancel && blockToExecute) {
            blockToExecute();
        }
        
        // Once the handle block is executed, canceled or not, we free blockToExecute and the handle.
        // Doing this here means that if the block is canceled, we aren't holding onto retained objects for any longer than necessary.
#if !__has_feature(objc_arc)
        [blockToExecute release];
        [delayHandleCopy release];
#endif
        
        blockToExecute = nil;
        delayHandleCopy = nil;
    };
    // delayHandle also needs to be moved to the heap.
    delayHandleCopy = [delayHandle copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (nil != delayHandleCopy) {
            delayHandleCopy(NO);
        }
    });
    
    return delayHandleCopy;
}

static void cancel_delayed_block(PDDelayedBlockHandle delayedHandle) {
    if (nil == delayedHandle) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        delayedHandle(YES);
    });
}

#pragma mark - inner methods
- (NSString *)paramValueFromStatus:(LocalConnectionStatus)status
{
    switch (status)
    {
        case LC_UnReachable:
        {
            return kParamValueUnReachable;
        }
        case LC_WiFi:
        {
          return kParamValueWIFI;
        }
        case LC_WWAN:
        {
            return kParamValueWWAN;
        }
           
        default:
        {
            NSLog(@"RealReachability error! paramValueFromStatus not matched!");
            return @"";
        }
    }
}

// auto checking after every autoCheckInterval minutes
- (void)autoCheckReachability
{
    if (!self.isNotifying)
    {
        return;
    }
    
    if (self.autoCheckInterval < kMinAutoCheckInterval)
    {
        self.autoCheckInterval = kMinAutoCheckInterval;
    }
    
    if (self.autoCheckInterval > kMaxAutoCheckInterval)
    {
        self.autoCheckInterval = kMaxAutoCheckInterval;
    }
    
    __weak __typeof(self)weakSelf = self;
    _delayedBlockHandle = perform_block_after_delay(self.autoCheckInterval, ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf reachabilityWithBlock:nil];
        [strongSelf autoCheckReachability];
    });
}


- (WWANAccessType)accessTypeForString:(NSString *)accessString
{
    if ([self.typeStrings4G containsObject:accessString])
    {
        return WWANType4G;
    }
    else if ([self.typeStrings3G containsObject:accessString])
    {
        return WWANType3G;
    }
    else if ([self.typeStrings2G containsObject:accessString])
    {
        return WWANType2G;
    }
    else
    {
        return WWANTypeUnknown;
    }
}

#pragma mark - Notification observer
- (void)localConnectionChanged:(NSNotification *)notification
{
    LocalConnection *lc = (LocalConnection *)notification.object;
    LocalConnectionStatus lcStatus = [lc currentLocalConnectionStatus];
    //NSLog(@"currentLocalConnectionStatus:%@",@(lcStatus));
    ReachabilityStatus status = [self currentReachabilityStatus];
    
    NSDictionary *inputDic = @{kEventKeyID:@(RREventLocalConnectionCallback), kEventKeyParam:[self paramValueFromStatus:lcStatus]};
    NSInteger rtn = [self.engine receiveInput:inputDic];
    
    if (rtn == 0) // state changed & state available, post notification.
    {
        if ([self.engine isCurrentStateAvailable])
        {
            self.previousStatus = status;
            // already in main thread.
            [[NSNotificationCenter defaultCenter] postNotificationName:kRealReachabilityChangedNotification
                                                                object:self];
            
            if (lcStatus != LC_UnReachable)
            {
                // To make sure your reachability is "Real".
                [self reachabilityWithBlock:nil];
            }
        }
    }
}

- (void)localConnectionInitialized:(NSNotification *)notification
{
    LocalConnection *lc = (LocalConnection *)notification.object;
    LocalConnectionStatus lcStatus = [lc currentLocalConnectionStatus];
    NSLog(@"localConnectionInitializedStatus:%@",@(lcStatus));
    
    NSDictionary *inputDic = @{kEventKeyID:@(RREventLocalConnectionCallback), kEventKeyParam:[self paramValueFromStatus:lcStatus]};
    NSInteger rtn = [self.engine receiveInput:inputDic];
    
    // Initialized state, ping once to check the reachability(if local status reachable).
    if ((rtn == 0) && [self.engine isCurrentStateAvailable] && (lcStatus != LC_UnReachable))
    {
        // To make sure your reachability is "Real".
        [self reachabilityWithBlock:nil];
    }
}

@end

