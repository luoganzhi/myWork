//
//  D5HUploadLocalMusic.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/8/23.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5HUploadLocalMusic.h"
#import "AFNetworking.h"
#import "NSJSONSerialization+Helper.h"

@interface D5HUploadLocalMusic()


@end


@implementation D5HUploadLocalMusic

/** manager */
static AFHTTPRequestOperationManager *manager = nil;
static  AFHTTPSessionManager *seesionManger = nil;
static NSString *deleteUrl = nil;
static NSURLSessionDataTask *task = nil;
#pragma mark - Private

+ (void)successResponse:(id)responseData callback:(D5HResponseSuccess)success {
    if (success) {
        if (responseData==nil) {
            
            //DLog(@"Http返回数据为空");
            return;
        }
       NSDictionary*data= [NSJSONSerialization dictFromJsonData:responseData];
        success(data);
    }
}

- (BOOL)validateUrl:(NSString *)candidate {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}
+(void)afNewNetworkingServer:(NSString *)urlStrting cmd:(NSInteger)cmd success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail {
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
     manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.requestSerializer.timeoutInterval = 20.0f;
    
    NSMutableSet *set = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    [set addObject:@"text/plain"];
    [set addObject:@"application/json"];
    
    manager.responseSerializer.acceptableContentTypes = set;
    
    NSString *url = [NSString stringWithFormat:@"%@?cmd=%ld&g=%@",D5NEW_LEDBASEURL,(long)cmd,urlStrting];

    [manager setSecurityPolicy:securityPolicy];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.operationQueue.maxConcurrentOperationCount = 3;
    url=  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary*dic = responseObject;
            NSInteger code=0;
            //错误码
            code=[[dic valueForKey:@"code"]integerValue];
            NSString*string=[dic valueForKey:@"msg"];
            if (code != 100) {
                if (string == nil || [string isEqual:[NSNull null]]) {
                    
                    [iToast showButtomTitile:@"获取数据失败"];
                    
                }else {
                    
                    [iToast showButtomTitile:string];
                }
                
                
                return ;
            }
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        fail(error);
        
    }];


}

//+(void)afNetworkingServer:(NSString *)urlStrting success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail
//{
//    
//    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//    [securityPolicy setAllowInvalidCertificates:YES];
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 20.0f;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil];
// manager.responseSerializer = [AFJSONResponseSerializer serializer];
//  
//    NSString *url = [NSString stringWithFormat:@"%@%@",D5LEDBASEURL,urlStrting];
//    [manager setSecurityPolicy:securityPolicy];
//    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
//    manager.operationQueue.maxConcurrentOperationCount = 3;
//   url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        success(responseObject);
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        
//        fail(error);
//        
//    }];
//}

+(void)afNetworkingAddParametersServer:(NSString *)urlStrting parameters:(NSDictionary*)paraments success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail
{
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 20.0f;
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@?g=%@",D5NEW_LEDBASEURL,@"{""cmd"":7,""pageNum"":10,""nowPage"":0}"];
    [manager setSecurityPolicy:securityPolicy];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    manager.operationQueue.maxConcurrentOperationCount = 3;
    //    manager.baseURL=[NSURL URLWithString:D5LEDBASEURL];
    
//   url= @"http://ledcrm2.d5home.com/index.php/api/default?g={"cmd":7,"pageNum":20,"nowPage":0}";
    http://ledcrm.d5home.com/api/default?g={"cmd":7,"pageNum":20,"nowPage":0}
    url=  [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        fail(error);
        
    }];
    
    
    
    
    
}


+(D5HUploadLocalMusic*)shareInstance
{
    static D5HUploadLocalMusic* obj = nil;
    static dispatch_once_t once ;

    dispatch_once(&once, ^{
        
        obj = [[D5HUploadLocalMusic alloc]init];
    });
    return obj;
}

+(void)cancelUploadMusic
{
////    getAllTasksWithCompletionHandler
//    [[AFHTTPSessionManager manager].session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
//        
//        //取消所有的上传任务
//        for (NSURLSessionUploadTask *task  in uploadTasks) {
//             [task cancel];
//        }
//       
//    }];
////    [AFHTTPSessionManager manager].session.tas.currentRequest;
//    
//    for (NSURLSessionUploadTask* task in [AFHTTPSessionManager manager].uploadTasks) {
//        
//        [task cancel];
//    }
    
//     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        NSURLSessionDataTask* task =  [manager.session dataTaskWithRequest:self.requst];
    // [self.requst cancel];
        //取消操作队列
//    [manager.operationQueue cancelAllOperations];

}
#pragma mark -- public 方法
+(void)uploadNewMusicFile:(NSDictionary *)dataDict name:(NSString *)names url:(NSString *)urlString progress:(D5HUploadProgress)progress success:(D5HResponseSuccess)success fail:(D5HResponseFail)fail {
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    seesionManger = [AFHTTPSessionManager manager];

    seesionManger.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置默认的相应配置
    seesionManger.responseSerializer = [AFJSONResponseSerializer serializer];

    //超时时间
    seesionManger.requestSerializer.timeoutInterval = 60.0f;
    //设置安全策略
    [seesionManger setSecurityPolicy:securityPolicy];

    seesionManger.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];

    seesionManger.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    NSString *parameterUrl = [NSString stringWithFormat:@"?%@=%@&%@=%@&%@=%@", NNS_TYPE, @(1), NNS_SINGER, [NSString base64URLStrFromStr:dataDict[NNS_SINGER]], NNS_ALBUMS, [NSString base64URLStrFromStr:dataDict[NNS_ALBUMS]]];
    
    deleteUrl = [urlString stringByAppendingString:parameterUrl];
    
    task = [seesionManger POST:deleteUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *musicData = dataDict[NNS_MUSIC];
        if (musicData) {
            [formData appendPartWithFileData:musicData name:[NSString stringWithFormat:@"%@.mp3",names] fileName:[NSString stringWithFormat:@"%@.mp3",names] mimeType:@"Content-Type:audio/mpeg"];
        }
        
        UIImage *image = dataDict[NNS_ALBUM_COVER];
        if (image && ![image isEqual:@""]) {
            NSData *imgData;
            if (UIImagePNGRepresentation(image) == nil) {
                imgData = UIImageJPEGRepresentation(image, 1);
            } else {
                imgData = UIImagePNGRepresentation(image);
            }
            
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"%@.jpg", names] fileName:@"image.jpg" mimeType:@"Content-Type:image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        DLog(@"uploadProgress:%@", uploadProgress);
        progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        DLog(@"成功-------%@",responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        DLog(@"失败-------%@",error);
    }];
    
    //self.requst = task;
   // manager.curentDataTask = task;

    //manager.uploadTasks.
    //manager.session.
    //[task cancel];
// dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//阻塞线程
    

}

+ (void)cancelPost{
    [task cancel];

    [manager.operationQueue cancelAllOperations];
    [seesionManger.operationQueue cancelAllOperations];
}

+(void)uploadMusic:(NSMutableArray*)data name:(NSMutableArray*)names url:(NSString*)urlString sucess:(D5HResponseSuccess )sucess failure:(D5HResponseFail)failure
{
    @autoreleasepool {
      
        //安全策略
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        
        manager=[AFHTTPRequestOperationManager manager];
        //设置可接受内容
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        //超时时间
        manager.requestSerializer.timeoutInterval = 10.0f;
        //设置安全策略
        [manager setSecurityPolicy:securityPolicy];
        //设置默认的相应配置
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [MBProgressHUD showLoading:@"正在上传..."];
        /*
       [manager POST:[NSString stringWithFormat:@"%@",urlString] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
           
           int i=0;
           
           for (NSString*name in names ) {
               //提交表单
               [formData appendPartWithFileData:data[i] name:[NSString stringWithFormat:@"%@.mp3",name] fileName:[NSString stringWithFormat:@"%@.mp3",name] mimeType:@"Content-Type:audio/mp4"];
               i++;
           }
       } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
           
// #error  解析数据
            //DLog(@"%@",responseObject);
           [MBProgressHUD hideHUD];
           [iToast showButtomTitile:@"上传成功"];
           [self successResponse:(responseObject) callback:sucess];
           
       } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
           //DLog(@"上传失败:%@",error);
           [MBProgressHUD hideHUD];
           [iToast showButtomTitile:@"上传失败"];
           failure(error);
           
       }];
         */
        
    };

}
@end
