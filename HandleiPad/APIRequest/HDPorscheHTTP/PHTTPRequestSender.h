//
//  PHTTPRequestSender.h
//  HandleiPad
//
//  Created by Handlecar on 16/11/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PRequestManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface PHTTPRequestSender : NSObject

+ (void)sendRequestWithURLStr:(NSString *)URLStr parameters:(id _Nullable)parameters completion:(PResponserCallBack)resopnserCallBack isNeedShowPopView:(BOOL)isNeed;

+ (void)sendRequestWithURLStr:(NSString *)URLStr parameters:(id _Nullable)parameters completion:(PResponserCallBack)resopnserCallBack;

+ (void)uploadImage:(NSArray <UIImage *>* _Nonnull)images videoUrl:(NSURL *)videoUrl parameters:(id)parameters progress:(void(^)(NSProgress * _Nonnull progress))progress completion:(void (^)(id  _Nonnull responser, NSError * _Nonnull error))completion;

//+ (void)sendDownloadRequestWithURLStr:(NSString *)URLStr parameters:(id _Nullable)parameters completion:(PResponserCallBack)resopnserCallBack;
+ (void)sendDownloadRequestWithURLStr:(NSString *)URLStr parameters:(id)parameters orderid:(NSNumber *)orderid completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;


// 单独传orderid
+ (void)sendRequestWithURLStr:(NSString *)URLStr parameters:(id _Nullable)parameters orderid:(NSNumber *)orderid completion:(PResponserCallBack)resopnserCallBack isNeedShowPopView:(BOOL)isNeed;

// 版本更新接口
+ (void)sendVersionCheckWithCompletion:(void (^)(NSArray * _Nonnull))responser;
@end
NS_ASSUME_NONNULL_END
