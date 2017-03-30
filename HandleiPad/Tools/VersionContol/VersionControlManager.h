//
//  VersionControlManager.h
//  HandleiPad
//
//  Created by Handlecar on 2017/2/20.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionControlManager : NSObject

+ (instancetype)sharedInstance;

- (void)checkVersion;
//检查更新
- (void)checkVersion:(BOOL)isNeedAlert checkResult:(void(^)(BOOL isHaveNewVersion))result;

@end
