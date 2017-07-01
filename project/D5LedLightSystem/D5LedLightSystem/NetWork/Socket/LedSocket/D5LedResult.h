//
//  D5LedResult.h
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/26.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "D5Socket.h"

@interface D5LedResult : NSObject

@property (nonatomic, strong) NSArray *cmds;

- (void)receivedData:(NSData *)data from:(NSString *)ip networkType:(D5SocketType)socketType;

@end
