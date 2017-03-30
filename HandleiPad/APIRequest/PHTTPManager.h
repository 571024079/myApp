//
//  PHTTPManager.h
//  HandleiPad
//
//  Created by Handlecar on 9/23/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "AFHTTPSessionManager.h"
typedef void (^UploadDrvingResponse)(NSURLResponse *response, id responser, NSError *error);
typedef void (^PHTTPResponse)(id  responser, NSError *error);
@interface PHTTPManager : AFHTTPSessionManager

// 行驶证识别
+ (void)recognizeDrivingLicenseWithImage:(UIImage *)image uploadToBaseUrl:(NSString *)url response:(UploadDrvingResponse) uploadServiceResponse;

// vin码识别  品牌id = 582 保时捷 spdcars 车系
+ (void)vinRecoginzeWithVin:(NSString *)vinStr response:(PHTTPResponse) uploadServiceResponse;

// 车系  level = 2 pid = 582 year = @"" carsflg = 1 cars = @"" 取车系
// 车型 level = 2 pid = 582 year = @"" carsflg = 0 cars = @"车系汉字";
// 年款 level = 3 pid = 车型id year = @"" carslfg = 0 cars = @"车系汉字"；
// 排量 level = 4 pid = 车型id year = @"选择的汉字年款" carsflg = 0 cars = @"车系汉字";
// if002/010  http://120.26.67.161:8080/erpdata/if002/010

+ (void)cartypeInfoWithParams:(NSDictionary *)param response:(PHTTPResponse)uploadServiceResponse;

// 获取车系
+ (void)getCarSeriesResponse:(PHTTPResponse)response;
// 获取车型
+ (void)getCarTypeWithCarseries:(NSString *)carSeries response:(PHTTPResponse)response;
// 获取年款
+ (void)getCarYearWithCartypeId:(NSNumber *)carTypeid carSeris:(NSString *)carSeries response:(PHTTPResponse)response;
// 获取排量
+ (void)getCarOutputWithCartypeId:(NSNumber *)carTypeid carSeris:(NSString *)carSeries carYears:(NSString *)carYears response:(PHTTPResponse)response;

@end
