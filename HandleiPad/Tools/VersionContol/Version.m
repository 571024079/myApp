//
//  Version.m
//  HandleSales
//
//  Created by Cheney Lau on 7/21/14.
//  Copyright (c) 2014 Handou. All rights reserved.
//

#import "Version.h"

@implementation Version

+ (instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    Version *version = [[self class]allocWithZone:zone];
    version.versionCode = _versionCode;
    version.updateUrl = _updateUrl;
    version.appName = _appName;
    version.functionsNew = _functionsNew;
    version.updateUrlRightNow = _updateUrlRightNow;
    return version;
}

@end