//
//  UIView+VideoImage.h
//  HandleiPad
//
//  Created by Robin on 16/9/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VideoImage)

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

@end
