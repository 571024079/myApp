//
//  PRequestManager.h
//  HandleiPad
//
//  Created by Handlecar on 16/11/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "PResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PResponserCallBack)(PResponseModel * _Nullable responser,  NSError * _Nullable error);

@interface PRequestManager : AFHTTPSessionManager

//- (void)isNeedShowPopView:(BOOL)isNeed;

+ (instancetype)sharePRequestManager;

- (void)sendRequestWithURLStr:(NSString *)urlStr parameters:(NSDictionary *)params completion:(PResponserCallBack)resopnserCallBack;

- (void)sendRequestWithURLStr:(NSString *)urlStr parameters:(NSDictionary *)params completion:(PResponserCallBack)resopnserCallBack withNeedShowPopView:(BOOL)isNeed;

// 上传照片 视频
- (void)uploadPictureDatas:(NSArray *)picdatas videoData:(NSData * _Nullable)videoData parameters:(NSDictionary *)params urlStr:(NSString *)urlStr progress:(void (^)(NSProgress * _Nullable))uploadProgressBlock completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler;
- (void)sendDownloadWithURLStr:(NSString *)urlStr parameters:(NSDictionary *)params completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

NS_ASSUME_NONNULL_END

@end
