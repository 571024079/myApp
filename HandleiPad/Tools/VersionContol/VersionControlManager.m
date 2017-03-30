//
//  VersionControlManager.m
//  HandleiPad
//
//  Created by Handlecar on 2017/2/20.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VersionControlManager.h"
#import "Version.h"


#define SHOWALERT(m) \
{\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:m delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];\
[alert show]; \
}\

@interface VersionControlManager ()<UIAlertViewDelegate>

@end

@implementation VersionControlManager

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


- (void)checkVersion {
    [self checkVersion:NO checkResult:nil];
}

//检查更新
- (void)checkVersion:(BOOL)isNeedAlert checkResult:(void(^)(BOOL isHaveNewVersion))result {
    
    if ([HDUtils isFirstLaunch]) {
        [HDUtils setCustomClassConfig:@"isForceUpdate" value:@0];
        [HDUtils saveConfig];
    }
    
    if (![self checkForceUpdate]) {
        [PHTTPRequestSender sendVersionCheckWithCompletion:^(NSArray * _Nonnull responser) {
            if ([responser isKindOfClass:[NSArray class]] && responser.count > 0) {
                Version *version = [Version sharedInstance];
                
                version.appName = [NSString stringWithFormat:@"%@",[[responser objectAtIndex:0] objectForKey:@"app_name"]];
                version.functionsNew = [NSString stringWithFormat:@"%@",[[responser objectAtIndex:0] objectForKey:@"new_functions"]];
                version.updateUrl = [NSString stringWithFormat:@"%@",[[responser objectAtIndex:0] objectForKey:@"update_url"]];
                version.updateUrlRightNow = [NSString stringWithFormat:@"%@",[[responser objectAtIndex:0] objectForKey:@"updateurl"]];
                version.versionCode = [[[responser objectAtIndex:0] objectForKey:@"version_code"] integerValue];
                version.isForceUpdate = [[responser objectAtIndex:0] objectForKey:@"force_update"];
                version.updateflg = [[responser objectAtIndex:0] objectForKey:@"updateflg"];
                
                [HDUtils setCustomClassConfig:@"updateurl" value:version.updateUrlRightNow];
                [HDUtils setCustomClassConfig:@"new_functions" value:version.functionsNew];
                
                if ([version.updateflg integerValue] == 1) {
                    if ([[HDUtils readCustomClassConfig:@"isForceUpdate"]intValue]<=0) {
                        [HDUtils setCustomClassConfig:@"isForceUpdate" value:version.isForceUpdate];
                    }
                    
                    NSNumber *forceUpdateNumber = [HDUtils readCustomClassConfig:@"isForceUpdate"];
                    if ([forceUpdateNumber intValue]>0) {
                        NSString *msg = [NSString stringWithFormat:@"%@",version.functionsNew];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"更新提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
                        alertView.delegate = self;
                        [alertView show];
                    }
                    else
                    {
                        NSString *msg = [NSString stringWithFormat:@"%@",version.functionsNew];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"更新提示" message:msg delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"更新", nil];
                        alertView.delegate = self;
                        [alertView show];
                    }
                }
                else{
                    
                    if (isNeedAlert) {
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"更新提示" message:@"已是最新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        alertView.delegate = self;
                        [alertView show];
                    }
                }
                
                if (result) {
                    result([version.updateflg boolValue]);
                }
                [HDUtils saveConfig];
                
            }
            else {
                if (result) {
                    result(YES);
                }
            }
            
        }];
        
    }
    else
    {
        if (result) {
            result(YES);
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"willDismissWithButtonIndex");
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex ) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:[HDUtils readCustomClassConfig:@"updateurl"]]];
        [self removeDefault];
        [self performSelector:@selector(exitApp) withObject:nil afterDelay:0.1];
    }
    [self checkForceUpdate];
}


- (BOOL)checkForceUpdate {
    NSNumber *forceUpdateNumber = [HDUtils readCustomClassConfig:@"isForceUpdate"];
    if (![forceUpdateNumber isKindOfClass:[NSNull class]] && [forceUpdateNumber intValue] > 0) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"更新提示"
                              message:[HDUtils readCustomClassConfig:@"new_functions"]
                              delegate:self
                              cancelButtonTitle:nil
                              otherButtonTitles:@"更新",nil];
        [alert show];
        return YES;
    }else return NO;
}

- (void)removeDefault
{
    [HDUtils removeConfig:@"updateurl"];
    [HDUtils removeConfig:@"isForceUpdate"];
    [HDUtils removeConfig:@"new_functions"];
    [HDUtils saveConfig];
}

- (void)exitApp
{
    exit(0);
}

@end
