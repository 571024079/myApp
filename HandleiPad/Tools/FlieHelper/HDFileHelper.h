//
//  HDFileHelper.h
//  HandleiPad
//
//  Created by Ais on 2016/12/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

/*
    文件操作相关类
 */
#import <Foundation/Foundation.h>

@interface HDFileHelper : NSObject

+ (NSString *)documentPath;

+ (NSURL *)PDFFileURL;

@end
