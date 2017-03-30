//
//  PRequestManager.m
//  HandleiPad
//
//  Created by Handlecar on 16/11/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PRequestManager.h"
#import "HDLeftSingleton.h"
static PRequestManager *manager = nil;

@implementation PRequestManager

+ (instancetype)sharePRequestManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PRequestManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer.timeoutInterval = 60;
    });
    return manager;
}
- (void)sendRequestWithURLStr:(NSString *)urlStr parameters:(NSDictionary *)params completion:(PResponserCallBack)resopnserCallBack withNeedShowPopView:(BOOL)isNeed {
    
    NSString *baseURL = [HDUtils readCustomClassConfig:@"servivAddress"];
    urlStr = [NSString stringWithFormat:@"%@%@", baseURL.length?baseURL:@"", urlStr];
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    if (![[URL path] length]) {
        NSError *error = [NSError errorWithDomain:@"" code:-1002 userInfo:nil];
        resopnserCallBack(nil, error);
        return;
    }

    
    [self POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        PResponseModel *responseModel = [[PResponseModel alloc] init];
        
        NSError *jsonError = nil;
        if (responseObject != nil)
        {
            NSMutableDictionary *responseInfo = [NSMutableDictionary dictionaryWithDictionary:responseObject];
            [responseInfo removeObjectForKey:@"userauths"];
                NSString *responserStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseInfo options:NSJSONWritingPrettyPrinted error:&jsonError] encoding:NSUTF8StringEncoding];
            if (![urlStr hasSuffix:WORK_ORDER_NOTICE_NOTIFINATION])
            {
                NSLog(@"url：%@， responser %@", [BASE_URL stringByAppendingString:urlStr],responserStr);
            }
        }
        
        [responseModel setValuesForKeysWithDictionary:responseObject];
        if ([[responseObject objectForKey:@"status"] integerValue] == 100) {
            NSArray *permissionArray = [NSArray arrayWithArray:[responseObject objectForKey:@"userauths"]];
            [[HDPermissionManager sharePermission] setDataSourceForPermission:permissionArray];
        }
        //看权限 右侧顶部五个流程按钮 设置字体
//        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_HEADER_BUTTON_TEXT_COLOR object:nil];
        [[HDLeftSingleton shareSingleton] changeHeaderTextColor];
        
        if (isNeed) {
            NSURL *url = [NSURL URLWithString:BASE_URL];
            if (![url.port isEqualToNumber:@8689]) { //开发使用服务器
                // 统一的系统信息弹出
                if (responseModel.msg.length && responseModel.status != 100) {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responseModel.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
                }
            }else { //测试用服务器
                
            }
        }
        
        resopnserCallBack(responseModel, nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        resopnserCallBack(nil, error);
        NSLog(@"error: %@",error);
    }];
    
//    [self GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        PResponseModel *responseModel = [[PResponseModel alloc] init];
//        
//        NSError *jsonError = nil;
//        if (responseObject != nil)
//        {
//            NSString *responserStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&jsonError] encoding:NSUTF8StringEncoding];
//            NSLog(@"url：%@， responser %@",urlStr,responserStr);
//        }
//        
//        [responseModel setValuesForKeysWithDictionary:responseObject];
//        if ([[responseObject objectForKey:@"status"] integerValue] == 100) {
//            NSArray *permissionArray = [NSArray arrayWithArray:[responseObject objectForKey:@"userauths"]];
//            [[HDPermissionManager sharePermission] setDataSourceForPermission:[permissionArray mutableCopy]];            
//        }
//        //看权限 右侧顶部五个流程按钮 设置字体
//        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_HEADER_BUTTON_TEXT_COLOR object:nil];
//        
//        
//        if (isNeed) {
//            NSURL *url = [NSURL URLWithString:BASE_URL];
//            if (![url.port isEqualToNumber:@8689]) { //开发使用服务器
//                // 统一的系统信息弹出
//                if (responseModel.msg.length && responseModel.status != 100) {
//                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responseModel.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
//                }
//            }else { //测试用服务器
//                
//            }
//        }
//        
//        resopnserCallBack(responseModel, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        resopnserCallBack(nil, error);
//        NSLog(@"error: %@",error);
//    }];
}

- (void)sendRequestWithURLStr:(NSString *)urlStr parameters:(NSDictionary *)params completion:(PResponserCallBack)resopnserCallBack
{
    [self sendRequestWithURLStr:urlStr parameters:params completion:resopnserCallBack withNeedShowPopView:YES];
}

/**
 上传文件

 @param data 二进制文件
 @param params params
 @param urlStr 地址
 @param mimeType @"video/quicktime" @"image/png"
 @param uploadProgressBlock
 @param completionHandler
 */
- (void)uploadPictureDatas:(NSArray *)picdatas videoData:(NSData *_Nullable)videoData parameters:(NSDictionary *)params urlStr:(NSString *)urlStr progress:(void (^)(NSProgress * _Nullable))uploadProgressBlock completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {

    NSLog(@"上传附件完整请求 -- %@",params);
    
    NSString *baseURL = [HDUtils readCustomClassConfig:@"servivAddress"];
    urlStr = [NSString stringWithFormat:@"%@%@", baseURL.length?baseURL:@"", urlStr];
    
    [self POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [picdatas enumerateObjectsUsingBlock:^(NSData * _Nonnull data, NSUInteger idx, BOOL * _Nonnull stop) {
           
            // 上传文件
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString * fileName =[NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        }];
    
        if (videoData) {
            // 上传视频文件
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];;
            [formData appendPartWithFileData:videoData name:@"file" fileName:fileName mimeType:@"video/quicktime"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        uploadProgressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(responseObject, nil);
        NSLog(@"上传成功：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(nil, error);
        NSLog(@"上传失败");
    }];
}

- (void)sendDownloadWithURLStr:(NSString *)urlStr parameters:(NSDictionary *)params completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
//    [self GET:urlStr parameters:params progress:downloadProgress success:success failure:failure];
//    [self GET:urlStr parameters:params progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, PDF_NAME];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSString *baseURL = [HDUtils readCustomClassConfig:@"servivAddress"];
    urlStr = [NSString stringWithFormat:@"%@%@", baseURL.length?baseURL:@"", urlStr];
    // 先删除文件
    [self deleteFileWithURL:[NSURL URLWithString:fullPath]];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:params error:&serializationError];
//    [request addValue:@"86631" forHTTPHeaderField:@"Content-Length"];
    NSLog(@"-------->%@",[[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);

//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://106.14.38.215:8689/increaseitem/printpdforder?data={\"userid\":1,\"storeid\":1,\"carorderid\":1,\"reqdata\":{\"type\":1}}"]];
//    [manager.requestSerializer setValue:@"188631" forHTTPHeaderField:@"Content-Length"];
//    NSString *url = [[request.URL absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *URL = [NSURL URLWithString:url];
//    [
//    [request setURL:URL];
    NSURLSessionDownloadTask *task =
    [manager downloadTaskWithRequest:request
                            progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                return [NSURL fileURLWithPath:fullPath];
                            }
                   completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//                       NSURL *url = [NSURL fileURLWithPath:[filePath absolutionString]];
                       NSData *data = [NSData dataWithContentsOfURL:filePath];
                       NSError *jsonerror ;
                       if (data.length)
                       {
                           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonerror];
                           if ([NSJSONSerialization isValidJSONObject:dict] )
                           {
                               NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"获取pdf失败 错误信息: %@ ",jsonStr);
                               NSString *msg = [dict objectForKey:@"msg"];

                               jsonerror = [NSError errorWithDomain:msg code:[[dict objectForKey:@"status"] integerValue] userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]];
                               completionHandler(response, filePath, jsonerror);
                               return;
                           }
                       }
        
                       completionHandler(response, filePath, error);
                       
                   }];
    [task resume];
    
}

- (void)deleteFileWithURL:(NSURL *)fileUrl
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:PDF_NAME];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    
    NSString *MapLayerDataPath2 = [documentsDirectory stringByAppendingPathComponent:@"__MACOSX"];
    BOOL bRet2 = [fileMgr fileExistsAtPath:MapLayerDataPath2];
    if (bRet2) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath2 error:&err];
    }
    
}

@end
