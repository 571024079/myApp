//
//  HDUtils.h
//  HandleiPad
//
//  Created by handlecar on 2017/2/20.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDUtils : NSObject
+ (void)setConfig:(NSString*)key value:(id)value;
+ (void)setCustomClassConfig:(NSString*)key value:(id)value;
+ (BOOL)saveConfig;
+ (id)readConfig:(NSString*)key;
+ (id)readCustomClassConfig:(NSString*)key;
+ (void)removeConfig:(NSString*)key;

+ (void)playSound:(NSString *)soundName soundType:(NSString *)type;

+ (void)brightScreen;
+ (void)regainScreen;
+ (NSDictionary*)getObjectData:(id)obj;

+ (BOOL)isFirstLaunch;

@end
