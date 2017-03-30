//
//  PHTTPRequestSender.m
//  HandleiPad
//
//  Created by Handlecar on 16/11/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PHTTPRequestSender.h"
#import "HDLeftSingleton.h"
static NSString *RelativePath = @"ifv10/fileupload";
static NSString *ImageScale = @"0.5";

@implementation PHTTPRequestSender

+ (void)sendRequestWithURLStr:(NSString *)URLStr parameters:(id _Nullable)parameters orderid:(NSNumber *)orderid completion:(PResponserCallBack)resopnserCallBack isNeedShowPopView:(BOOL)isNeed
{
    if (!orderid) {
        [PHTTPRequestSender sendRequestWithURLStr:URLStr parameters:parameters completion:resopnserCallBack isNeedShowPopView:NO];
    }
    else
    {
        // 参数格式
        /*
         get请求，全包在data中，需要的传，不需要的可不传
         userid;//用户ID
         storeid;//4S店ID
         reqdata;{}请求额外参数对象
         currpage = 0;  //当前页数
         pagesize=10;//每页显示数量
         carorderid;
         modifytype;
         list;请求数组
         */
        
        NSMutableDictionary *requestInfo = [NSMutableDictionary dictionary];
        if ([parameters isKindOfClass:[NSArray class]])
        {
            [requestInfo setObject:parameters forKey:@"list"];
        }
        else if ([parameters isKindOfClass:[NSDictionary class]])
        {
            [requestInfo setObject:parameters forKey:@"reqdata"];
        }
        
        [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].userid  forKey:@"userid"];
        [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].nickname  forKey:@"username"];
        [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].storeid  forKey:@"storeid"];
        [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].currpage  forKey:@"currpage"];
        [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].pagesize  forKey:@"pagesize"];
        [requestInfo hs_setSafeValue:orderid forKey:@"carorderid"];
        [requestInfo hs_setSafeValue:@"mini"  forKey:@"sourcefrom"];
        [requestInfo hs_setSafeValue:@([HDLeftSingleton shareSingleton].stepStatus) forKey:@"displayflg"];
        
        NSDictionary *requestDataInfo = [NSDictionary dictionary];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestInfo options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (jsonStr.length)
        {
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            //        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            requestDataInfo = @{@"data":jsonStr};
        }
        
        if (!isNeed) {
            [[PRequestManager sharePRequestManager] sendRequestWithURLStr:URLStr parameters:requestDataInfo completion:resopnserCallBack withNeedShowPopView:NO];
        }else {
            [[PRequestManager sharePRequestManager] sendRequestWithURLStr:URLStr parameters:requestDataInfo completion:resopnserCallBack];
        }
        
        if (![URLStr isEqualToString:WORK_ORDER_NOTICE_NOTIFINATION])
        {
            NSString *responseString = [requestDataInfo description];
            responseString = [responseString stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
            responseString = [responseString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
            NSLog(@"URLStr:%@\n  requestDataInfo:%@",[BASE_URL stringByAppendingString:URLStr],responseString);
        }
    }
}
/**
 发送http请求API
 
 @param URLStr            接口编号
 @param parameters        参数信息
 @param resopnserCallBack 回调
 @param isNeed            是否显示提示框
 */
+ (void)sendRequestWithURLStr:(NSString *)URLStr parameters:(id _Nullable)parameters completion:(PResponserCallBack)resopnserCallBack isNeedShowPopView:(BOOL)isNeed {
    // 参数格式
    /*
     get请求，全包在data中，需要的传，不需要的可不传
     userid;//用户ID
     storeid;//4S店ID
     reqdata;{}请求额外参数对象
     currpage = 0;  //当前页数
     pagesize=10;//每页显示数量
     carorderid;
     modifytype;
     list;请求数组
     */
    
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionary];
    if ([parameters isKindOfClass:[NSArray class]])
    {
        [requestInfo setObject:parameters forKey:@"list"];
    }
    else if ([parameters isKindOfClass:[NSDictionary class]])
    {
        [requestInfo setObject:parameters forKey:@"reqdata"];
    }
    
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].userid  forKey:@"userid"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].nickname  forKey:@"username"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].storeid  forKey:@"storeid"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].currpage  forKey:@"currpage"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].pagesize  forKey:@"pagesize"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].carorderid  forKey:@"carorderid"];
    [requestInfo hs_setSafeValue:@"mini"  forKey:@"sourcefrom"];
    [requestInfo hs_setSafeValue:@([HDLeftSingleton shareSingleton].stepStatus) forKey:@"displayflg"];
    
    NSDictionary *requestDataInfo = [NSDictionary dictionary];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (jsonStr.length)
    {
        requestDataInfo = @{@"data":jsonStr};
    }

    if (!isNeed) {
        [[PRequestManager sharePRequestManager] sendRequestWithURLStr:URLStr parameters:requestDataInfo completion:resopnserCallBack withNeedShowPopView:NO];
    }else {
        [[PRequestManager sharePRequestManager] sendRequestWithURLStr:URLStr parameters:requestDataInfo completion:resopnserCallBack];
    }
    
    if (![URLStr hasSuffix:WORK_ORDER_NOTICE_NOTIFINATION])
    {
        NSString *responseString = [requestDataInfo description];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
        NSLog(@"URLStr:%@\n  requestDataInfo:\n<---------参数----------->\n data=\"%@\"\n<------------------->",[BASE_URL stringByAppendingString:URLStr],jsonStr);
    }
}

/**
 发送http请求API

 @param URLStr            接口编号
 @param parameters        参数信息
 @param resopnserCallBack 回调
 */
+ (void)sendRequestWithURLStr:(NSString *)URLStr parameters:(id _Nullable)parameters completion:(PResponserCallBack)resopnserCallBack
{
    [self sendRequestWithURLStr:URLStr parameters:parameters completion:resopnserCallBack isNeedShowPopView:NO];
}

/**
 发送http请求API
 @param image             上传图片
 @param URLStr            接口编号
 @param parameters        参数信息
 @param completion        回调
 */
+ (void)uploadImage:(NSArray <UIImage *>*)images videoUrl:(NSURL *)videoUrl parameters:(id)parameters progress:(void(^)(NSProgress * _Nonnull progress))progress completion:(void (^)(id _Nullable responser, NSError * _Nullable error))completion
{
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionary];
    
    [requestInfo setObject:parameters forKey:@"reqdata"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].userid  forKey:@"userid"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].storeid  forKey:@"storeid"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].carorderid  forKey:@"carorderid"];
    [requestInfo hs_setSafeValue:@"mini"  forKey:@"sourcefrom"];

    NSDictionary *requestDataInfo = [NSDictionary dictionary];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (jsonStr.length)
    {
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        requestDataInfo = @{@"data":jsonStr};
    }
    
    NSMutableArray *imageDatasArray = [[NSMutableArray alloc] init];
    
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
        [imageDatasArray addObject:imageData];
    }];
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
    
    NSLog(@"视频大小 -- %f",[PHTTPRequestSender getFileSize:videoUrl.absoluteString]);
    
    [[PRequestManager sharePRequestManager] uploadPictureDatas:imageDatasArray videoData:videoData parameters:requestDataInfo urlStr:UP_DATA_IMAGE_URL progress:progress completionHandler:completion];
}

+ (CGFloat)getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}

+ (void)sendDownloadRequestWithURLStr:(NSString *)URLStr parameters:(id)parameters orderid:(NSNumber *)orderid completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
{
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionary];
    
    [requestInfo hs_setSafeValue:parameters forKey:@"reqdata"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].userid  forKey:@"userid"];
    [requestInfo hs_setSafeValue:[HDStoreInfoManager shareManager].storeid  forKey:@"storeid"];
    [requestInfo hs_setSafeValue:orderid  forKey:@"carorderid"];
    [requestInfo hs_setSafeValue:@"mini"  forKey:@"sourcefrom"];

    NSDictionary *requestDataInfo = [NSDictionary dictionary];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if (jsonStr.length)
    {
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        requestDataInfo = @{@"data":jsonStr};
    }
    
    [[PRequestManager sharePRequestManager] sendDownloadWithURLStr:URLStr parameters:requestDataInfo completionHandler:completionHandler];
}

+ (void)sendVersionCheckWithCompletion:(void (^)(NSArray * _Nonnull))responser
{
    
    NSDictionary *params = @{@"versionName": HDAppConfig_versionName, @"version":XcodeAppVersion};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HDAppConfig_versionBaseUrl]];
    
    [manager POST:HDAppConfig_versionRelativePath parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responser(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        responser(error);
    }];

}

@end
