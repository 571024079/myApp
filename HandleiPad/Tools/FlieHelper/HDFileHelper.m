//
//  HDFileHelper.m
//  HandleiPad
//
//  Created by Ais on 2016/12/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDFileHelper.h"

@implementation HDFileHelper

+ (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSURL *)PDFFileURL
{
    NSString *documentPath = [HDFileHelper documentPath];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentPath, PDF_NAME];
    NSURL *fileURL = [NSURL fileURLWithPath:fullPath];
    return fileURL;
}

@end
