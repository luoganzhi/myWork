//
//  D5BaseProtocol.m
//  D5Home_new
//
//  Created by 黄斌 on 15/12/16.
//  Copyright © 2015年 com.pangdou.d5home. All rights reserved.
//

#import "D5BaseProtocol.h"
#define DEFAULT_REPLACE_IP @"120.25.253.20"

@implementation D5BaseProtocol

- (NSString *)JSONString:(NSDictionary *)dic {
    @autoreleasepool {
        NSError *parseError = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&parseError];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } 
}

- (NSString *)getReplacedUrlByUrl:(NSString *)target {
    @autoreleasepool {
        if (![NSString isValidateString:target]) {
            return nil;
        }
        NSString *hostName = [NSURL URLWithString:target].host;
        NSString *key = [NSString stringWithFormat:IP_ADDRESS_FROM_HOSTNAME, hostName];
        NSString *ip = [[NSUserDefaults standardUserDefaults] stringForKey:key];
        //如果本地取出的IP为空
        if (![NSString isValidateString:ip]) {
            ip = [D5String getIPWithHostName:hostName];
            
            if (![NSString isValidateString:ip]) {
                ip = DEFAULT_REPLACE_IP;
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:ip ? ip : @"" forKey:key];
            }
        }
        if ([NSString isValidateString:hostName] && [NSString isValidateString:ip]){
            NSString *addr = [target stringByReplacingOccurrencesOfString:hostName withString:ip];
            return addr;
        }
        
        return @"";
    }
}

- (NSString *)newParament:(NSString *)sendData withMethod:(int)method {
    @autoreleasepool {
        if (sendData == nil) {
            return nil;
        }
        NSString *url = [NSString stringWithFormat:@"%@?cmd=%d&g=%@", /*[self getReplacedUrlByUrl:*/D5NEW_LEDBASEURL, method, [sendData URLEncodedString]];
        return url;
    }
}


-  (NSDictionary *)urlParament:(NSString *)sendData withMethod:(int)method {
    @autoreleasepool {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithInt:method] forKey:@"method"];
        [dic setObject:sendData forKey:@"data"];
        return dic;
    } 
}

- (void)sendData:(NSString *)data withMethod:(int)method isDevice:(BOOL)isDevice {
    @autoreleasepool {
        if (![D5NetWork isConnectionAvailable]) {
//            [self showErrorMessage:@"网络异常"];
//            //DLog(@"网络异常");
            return;
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = TIMEOUT_INTERVAL;
        
        NSMutableSet *set = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"text/plain"];
        [set addObject:@"application/json"];
        manager.responseSerializer.acceptableContentTypes = set;
//        NSString *url = [self parament:data withMethod:method];
        NSString *url = [self newParament:data withMethod:method];
//        //DLog(@"url ==  %@", url);
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseobject) {
            @autoreleasepool  {
                NSDictionary *dic = (NSDictionary *)responseobject;
//                int status = [[dic objectForKey:ACTION_STATUS] intValue];
//                //DLog(@"debug = %@ method = %d", [responseobject objectForKey:@"debugMsg"], method);
                
                if (!dic) {
                    [self showErrorMessage:nil];
                    return ;
                }
                
                if (_finishBlock) {
                    [self finishBlock](responseobject);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorMessage:[error localizedDescription]];
        }];
    } 
}

- (void)newSendData:(NSString *)data withMethod:(int)method isDevice:(BOOL)isDevice {
    @autoreleasepool {
        if (![D5NetWork isConnectionAvailable]) {
//            [self showErrorMessage:@"网络异常"];
//            //DLog(@"网络异常");
            return;
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = TIMEOUT_INTERVAL;
        
        NSMutableSet *set = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"text/plain"];
        [set addObject:@"application/json"];
        manager.responseSerializer.acceptableContentTypes = set;
        NSString *url = [self newParament:data withMethod:method];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation,id responseobject) {
            @autoreleasepool  {
                NSDictionary *dic = (NSDictionary *)responseobject;
                if (!dic) {
                    [self showErrorMessage:nil];
                    return ;
                }
                
                if (_finishBlock) {
                    [self finishBlock](responseobject);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showErrorMessage:[error localizedDescription]];
        }];
    }
}


/*
//
 post请求网络数据
 
*/
//- (void)postSendData:(NSDictionary *)datas withMethod:(int)method {
//    @autoreleasepool {
//        if (![D5NetWork isConnectionAvailable]) {
////            //DLog(@"网络异常");
//            return;
//        }
//        
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        NSMutableSet *set = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
//        [set addObject:@"text/html"];
//        [set addObject:@"text/plain"];
//        [set addObject:@"application/json"];
//        
//        manager.responseSerializer.acceptableContentTypes = set;
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.requestSerializer.timeoutInterval = TIMEOUT_INTERVAL;
//        NSString *url = [NSString stringWithFormat:@"%@?method=%d", [self getReplacedUrlByUrl:POST_FILE_BASE_URL], method];
//        
//        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            for (NSString *key in datas) {
//                @autoreleasepool {
//                    if ([NNS_VIDEO isEqualToString:key]) {
//                        [formData appendPartWithFileData:datas[key] name:key fileName:@"video.3gp" mimeType:@"Content-Type:video/3gpp"];
//                    } else if ([NNS_AUDIO isEqualToString:key]) {
//                        [formData appendPartWithFileData:datas[key] name:key fileName:@"audio.mp3" mimeType:@"Content-Type:audio/x-mpeg"];
//                    } else if ([NNS_IMAGE isEqualToString:key] || [NNS_USER_HEAD isEqualToString:key]) {
//                        [formData appendPartWithFileData:datas[key] name:key fileName:@"image.jpg" mimeType:@"Content-Type:image/jpeg"];
//                    } else {
//                        [formData appendPartWithFormData:[datas[key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
//                    }
//                }
//            }
//        } success:^(AFHTTPRequestOperation *operation ,id response) {
//            NSDictionary *dic = (NSDictionary *)response;
//            if (!dic) {
//                [self showErrorMessage:nil];
//                return ;
//            }
//            
//            if (_finishBlock) {
//                [self finishBlock](response);
//            }
//        } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
//            NSString *msg = error.localizedDescription;
//            [self showErrorMessage:msg];
//        }];
//    }
//}

- (void)showErrorMessage:(NSString *)message {
    if (![NSString isValidateString:message]) {
        message = @"请求出错啦，请稍后再试！";
    }
    
    if (_faildBlock) {
        [self faildBlock](message);
        return;
    } else {
        [MBProgressHUD showMessage:message];
    }
}
@end
