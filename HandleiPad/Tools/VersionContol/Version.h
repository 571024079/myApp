//
//  Version.h
//  HandleSales
//
//  Created by Cheney Lau on 7/21/14.
//  Copyright (c) 2014 Handou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Version : NSObject<NSCopying>

@property (nonatomic,assign) NSInteger versionCode;
@property (nonatomic,strong) NSString *updateUrl;
@property (nonatomic,strong) NSString *updateUrlRightNow;
@property (nonatomic,strong) NSString *appName;
@property (nonatomic,strong) NSString *functionsNew;
@property (nonatomic,strong) NSNumber *isForceUpdate;//是否强制更新
@property (nonatomic,strong) NSNumber *updateflg;//是否可以更新

+ (instancetype)sharedInstance; 

@end
