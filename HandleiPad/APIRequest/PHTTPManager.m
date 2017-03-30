//
//  PHTTPManager.m
//  HandleiPad
//
//  Created by Handlecar on 9/23/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "PHTTPManager.h"
#import "PorscheVinCarModel.h"


@implementation PHTTPManager

+ (void)recognizeDrivingLicenseWithImage:(UIImage *)image uploadToBaseUrl:(NSString *)url response:(UploadDrvingResponse) uploadServiceResponse
{
    PHTTPManager *httpManager = [[PHTTPManager alloc] initWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //@"http://115.29.10.68:8080/zscarinfo/car/drivinglicense?shopCode=%@&deviceId=B%@&appUser=%@&type=1"
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://115.29.10.68:8080/zscarinfo/car/drivinglicense" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    } error:nil];

    NSData* imageData = UIImageJPEGRepresentation(image, 1);
    NSInputStream *datastream = [[NSInputStream alloc] initWithData:imageData];
    request.HTTPBodyStream = datastream;
    request.timeoutInterval = 20;
    NSURLSessionUploadTask *uploadTask = [httpManager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            uploadServiceResponse(response,nil,error);
        }else
        {
            uploadServiceResponse(response,responseObject,nil);
        }
    }];
    [uploadTask resume];
}

+ (void)vinRecoginzeWithVin:(NSString *)vinStr response:(PHTTPResponse)uploadServiceResponse
{
    PHTTPManager *httpManager = [[PHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.26.67.161:8080/erpdata/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    [httpManager GET:@"if002/012" parameters:@{@"vinno":vinStr} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        uploadServiceResponse(responseObject, nil);
        
        
        __block NSMutableArray *vinCarModels = [[NSMutableArray alloc] init];
        [(NSArray *)responseObject enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *carTypes = [obj objectForKey:@"cartypelist"];
            //车型总model数组
            __block PorscheVinCarModel *carModel = [[PorscheVinCarModel alloc] init];
            carModel.cars = [obj objectForKey:@"cars"];
        
            __block NSMutableArray <PorscheVinCarTypeModel *>*carTypeModels = [[NSMutableArray alloc] init];
            //获取车型元素
            [carTypes enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull typeObj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *cartype = [typeObj objectForKey:@"cartype"];
                if ([cartype isEqualToString:@""]) {
                    
                    NSDictionary *carYearDic = [carTypes[idx] objectForKey:@"caryear"];
                    NSDictionary *carDisplacementDic = [carYearDic objectForKey:@"displacement"];
                    PorscheVinCarTypeModel *carTypeModel = [[PorscheVinCarTypeModel alloc] init];
                    carTypeModel.cartype = @"";
                    carTypeModel.year = [carYearDic objectForKey:@"year"];
                    carTypeModel.displacement = [carDisplacementDic objectForKey:@"displacement"];
                    [carTypeModels addObject:carTypeModel];
                } else {
                    
                    NSDictionary *carYearDic = [carTypes[idx] objectForKey:@"caryear"];
                    NSDictionary *carDisplacementDic = [carYearDic objectForKey:@"displacement"];
                    NSArray *cartypeConfigure = [carYearDic objectForKey:@"configure"];
                    //获取configure
                    [cartypeConfigure enumerateObjectsUsingBlock:^(NSString * _Nonnull configure, NSUInteger idx, BOOL * _Nonnull stop) {
                        //建立车型model
                        PorscheVinCarTypeModel *carTypeModel = [[PorscheVinCarTypeModel alloc] init];
                        carTypeModel.cartype = [NSString stringWithFormat:@"%@ %@",cartype,configure];
                        carTypeModel.year = [carYearDic objectForKey:@"year"];
                        carTypeModel.displacement = [carDisplacementDic objectForKey:@"displacement"];
                        [carTypeModels addObject:carTypeModel];
                    }];
                }
            }];
            carModel.cartTypes = carTypeModels;
            [vinCarModels addObject:carModel];
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        uploadServiceResponse(nil, error);
    }];
}

+ (void)cartypeInfoWithParams:(NSDictionary *)param response:(PHTTPResponse)uploadServiceResponse
{
    PHTTPManager *httpManager = [[PHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.26.67.161:8080/erpdata/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [httpManager GET:@"if002/010" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        uploadServiceResponse(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        uploadServiceResponse(nil, error);
    }];
}

+ (void)getCarSeriesResponse:(PHTTPResponse)response
{
    // // 车系  level = 2 pid = 582 year = @"" carsflg = 1 cars = @"" 取车系
    PHTTPManager *httpManager = [[PHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.26.67.161:8080/erpdata/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [httpManager GET:@"if002/010" parameters:@{@"level":@2, @"pid": @582, @"year":@"", @"carsflg":@1, @"cars":@""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        response(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        response(nil, error);
    }];
}

+ (void)getCarTypeWithCarseries:(NSString *)carSeries response:(PHTTPResponse)response
{
    if (!carSeries)
    {
        carSeries = @"";
    }
    // // 车系  level = 2 pid = 582 year = @"" carsflg = 1 cars = @"" 取车系
    PHTTPManager *httpManager = [[PHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.26.67.161:8080/erpdata/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [httpManager GET:@"if002/010" parameters:@{@"level":@2, @"pid": @582, @"year":@"", @"carsflg":@0, @"cars":carSeries} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        response(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        response(nil, error);
    }];
}

+ (void)getCarYearWithCartypeId:(NSNumber *)carTypeid carSeris:(NSString *)carSeries response:(PHTTPResponse)response
{
    if (!carSeries)
    {
        carSeries = @"";
    }
    if (!carSeries)
    {
        carSeries = @"";
    }
    if (!carTypeid) {
        carTypeid = @0;
    }
//    if (!carYears)
//    {
//        carYears = @"";
//    }
    // // 车系  level = 2 pid = 582 year = @"" carsflg = 1 cars = @"" 取车系
    PHTTPManager *httpManager = [[PHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.26.67.161:8080/erpdata/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [httpManager GET:@"if002/010" parameters:@{@"level":@3, @"pid": carTypeid, @"year":@"", @"carsflg":@0, @"cars":carSeries} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        response(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        response(nil, error);
    }];
}

+ (void)getCarOutputWithCartypeId:(NSNumber *)carTypeid carSeris:(NSString *)carSeries carYears:(NSString *)carYears response:(PHTTPResponse)response
{
    if (!carSeries)
    {
        carSeries = @"";
    }
    if (!carTypeid) {
        carTypeid = @0;
    }
    if (!carYears)
    {
        carYears = @"";
    }
    // // 车系  level = 2 pid = 582 year = @"" carsflg = 1 cars = @"" 取车系
    PHTTPManager *httpManager = [[PHTTPManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://120.26.67.161:8080/erpdata/"] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    httpManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [httpManager GET:@"if002/010" parameters:@{@"level":@4, @"pid": carTypeid, @"year":carYears, @"carsflg":@0, @"cars":carSeries} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        response(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        response(nil, error);
    }];
}

@end
