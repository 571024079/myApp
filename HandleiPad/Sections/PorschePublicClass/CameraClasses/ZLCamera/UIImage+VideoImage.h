//
//  UIImage+VideoImage.h
//  HandleiPad
//
//  Created by Robin on 16/9/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (VideoImage)

//获取视频图片
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

//合并图层
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;

@end
