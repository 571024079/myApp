//
//  PorscheImageManager.h
//  HandleiPad
//
//  Created by Robin on 16/10/25.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PorscheModel.h"
@interface PorscheImageManager : NSObject

//获取安全级别分类图片
+ (NSString *)getSafetyColorImage:(PorscheSchemeLevelStyle)style selected:(BOOL)selected;//彩色图片
+ (NSString *)getSafetyImage:(PorscheItemModelCategooryStyle)style selected:(BOOL)selected;//灰白

//获取方案库矩形item的背景图片
+ (NSString *)getSchemeRectItemBackImage:(PorscheItemModelCategooryStyle)style selected:(BOOL)selected;

//获取方案小库矩形item的背景图片（左侧方案）
+ (NSString *)getSchemeSmallRectItemBackImage:(PorscheItemModelCategooryStyle)style selected:(BOOL)selected;

//回去业务分类图片
+ (NSString *)getSchemeBusinessImage:(PorscheCarBusinessType)type selected:(BOOL)selected;

//获取业务分类icon
+ (NSString *)getSchemeBusinessSmallIconImage:(PorscheCarBusinessType)type;

//获取工时备件icon
+ (NSString *)getMaterialHoursIconImage:(MaterialTaskTimeDetailsType)type Normal:(BOOL)normal;

//获取蓝色打钩图片
+ (NSString *)getTickImage:(BOOL)selected;

@end
