//
//  HDUtils.m
//  HandleiPad
//
//  Created by handlecar on 2017/2/20.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDUtils.h"
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>

static CGFloat sMainScreenbrightness = -1;
static BOOL sIsbrightness = NO;

@implementation HDUtils
+ (void)setConfig:(NSString*)key value:(id)value
{
    NSUserDefaults* userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts setObject:value forKey:key];
}

+ (void)setCustomClassConfig:(NSString*)key value:(id)value
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    [HDUtils setConfig:key value:data];
}

+ (BOOL)saveConfig
{
    NSUserDefaults* userDefaluts = [NSUserDefaults standardUserDefaults];
    return [userDefaluts synchronize];
}

+ (id)readConfig:(NSString*)key
{
    NSUserDefaults* userDefaluts = [NSUserDefaults standardUserDefaults];
    id value = [userDefaluts objectForKey:key];
    return value;
}

+ (id)readCustomClassConfig:(NSString *)key
{
    NSData *data = [HDUtils readConfig:key];
    if (![data isKindOfClass:[NSData class]]) {
        return data;
    }
    id value = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    return value;
}

+ (void)removeConfig:(NSString*)key
{
    NSUserDefaults* userDefaluts = [NSUserDefaults standardUserDefaults];
    [userDefaluts removeObjectForKey:key];
    [userDefaluts synchronize];
}

+ (void)playSound:(NSString *)soundName soundType:(NSString *)type
{
    static SystemSoundID soundIDTest = 0;
    NSString * path = [[NSBundle mainBundle] pathForResource:soundName ofType:type];
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
    }
    
    AudioServicesPlaySystemSound( soundIDTest );
}

+ (void)brightScreen
{
    if (NO == sIsbrightness)
    {
        sMainScreenbrightness = [UIScreen mainScreen].brightness;
        [UIScreen mainScreen].brightness = 1;
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        sIsbrightness = YES;
    }
}

+ (void)regainScreen
{
    if (sIsbrightness)
    {
        if (sMainScreenbrightness >= 0)
        {
            [UIScreen mainScreen].brightness = sMainScreenbrightness;
        }
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        
        sIsbrightness = NO;
    }
}

+(BOOL)compareVersionFromOldVersion : (NSString *)oldVersion
                         newVersion : (NSString *)newVersion
{
    NSArray*oldV = [oldVersion componentsSeparatedByString:@"."];
    NSArray*newV = [newVersion componentsSeparatedByString:@"."];
    
    if (oldV.count == newV.count) {
        for (NSInteger i = 0; i < oldV.count; i++) {
            NSInteger old = [(NSString *)[oldV objectAtIndex:i] integerValue];
            NSInteger new = [(NSString *)[newV objectAtIndex:i] integerValue];
            if (old < new) {
                return YES;
            }
        }
        return NO;
    } else {
        return NO;
    }
}

+(NSDictionary*)getObjectData:(id)obj;
{
    NSMutableDictionary*dic = [NSMutableDictionary dictionary];
    
    unsigned
    int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int
        i = 0;i < propsCount; i++)
        
    {
        
        objc_property_t prop = props[i];
        
        
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id
        value = [obj valueForKey:propName];
        
        if(value == nil)
            
        {
            
            value = [NSNull null];
            
        }
        
        else
            
        {
            
            value = [self getObjectInternal:value];
            
        }
        
        [dic setObject:value forKey:propName];
        
    }
    
    return dic;
}

+ (id)getObjectInternal:(id)obj

{
    
    if([obj isKindOfClass:[NSString class]]
       
       ||
       [obj isKindOfClass:[NSNumber class]]
       
       ||
       [obj isKindOfClass:[NSNull class]])
        
    {
        
        return obj;
        
    }
    if([obj isKindOfClass:[NSArray class]])
        
    {
        
        NSArray *objarr = obj;
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0;i < objarr.count; i++)
            
        {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
            
        }
        
        return arr;
        
    }
    
    
    
    if([obj isKindOfClass:[NSDictionary class]])
        
    {
        
        NSDictionary *objdic = obj;
        
        NSMutableDictionary*dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString*key in objdic.allKeys)
            
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
            
        }
        
        return dic;
        
    }
    
    return [self getObjectData:obj];
}

+ (BOOL)isFirstLaunch {
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次启动
        return YES;
    }else{
        //不是第一次启动了
        return NO;
    }
}

@end
