//
//  D5LedNormalCmd.m
//  D5LedLightSystem
//
//  Created by zhangyu on 2016/11/16.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5LedNormalCmd.h"

@interface D5LedNormalCmd()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation D5LedNormalCmd

#pragma mark - 实现父类方法
- (void)setHeaderSn {
    @autoreleasepool {
        //sn从0开始，每次+1，存在全局
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger serialNum =  [userDefaults integerForKey:CMD_SERIALNUMBER];
        self.sn = serialNum % 256 + 1;
        
        [userDefaults setInteger:(serialNum + 1) forKey:CMD_SERIALNUMBER];
        [userDefaults synchronize];
    }
}

/**
 需要关闭udp
 */
- (void)endCmd {
    [super endCmd];
    
    [self closeUdp];
}

- (NSMutableData *)ledSendData:(LedCmd)cmd withSubCmd:(uint8_t)subCmd withData:(NSDictionary *)dict {
    @autoreleasepool {
        NSMutableData *data = [super ledSendData:cmd withSubCmd:subCmd withData:dict];
        DLog(@"%@------发送 %d-%d ---先加入列表%d--- %@", [self class], self.headerCmd, self.headerSubCmd, self.isNeedAddToList, data);
        
        [self sendData:data needAddToTempList:self.isNeedAddToList];
        return data;
    }
}

- (void)getResult:(LedHeader *)header body:(NSDictionary *)body from:(NSString *)ip {
    [super getResult:header body:body from:ip];
    // 推送的
    if ((header->cmd == Cmd_Box_Operate && (header->subCmd == SubCmd_Box_Scan ||
                                            header->subCmd == SubCmd_Box_Heart)) ||
        (header->cmd == Cmd_Led_Operate && (header->subCmd == SubCmd_Led_List ||
                                            header->subCmd == SubCmd_Led_Heart)) ||
        (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Runtime_Info) ||
        (header->cmd == Cmd_IO_Operate && header -> subCmd == SubCmd_File_ExtDeviceType) ||
        (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Trans_Progress) ||
        (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Update_Progress) ||
        (header->cmd == Cmd_IO_Operate && header->subCmd == SubCmd_File_Bt_Update_Progress)) {
            return;
    }
    
    [self endCmd];
}

- (void)cmdError:(int)errorCode withMsg:(NSString *)msg withHeader:(LedHeader *)header withData:(NSDictionary *)data from:(NSString *)ip {
    [super cmdError:errorCode withMsg:msg withHeader:header withData:data from:ip];
    
    [self endCmd];
}

///**
// *  超时处理
// */
//- (void)cmdTimeOut {
//    @autoreleasepool {
//        DLog(@"超时结束接收数据 ----  %d-%d", self.headerCmd, self.headerSubCmd);
//        [self endCmd];
//        
//        if ([self checkErrorDelegate] && [self.errorDelegate respondsToSelector:@selector(d5NetWorkError:errorMessage:data:forHeader:)]) {
//            NSString *error = [NSString stringWithFormat:@"%u", D5SocketErrorCodeTypeTimeOut];
//            LedHeader header = self.header;
//            [self.errorDelegate d5NetWorkError:D5SocketErrorCodeTypeTimeOut errorMessage:CustomLocalizedStringFromTable(error, @"D5SocketMessage", nil) data:nil forHeader:&header];
//        }
//    }
//}

@end
