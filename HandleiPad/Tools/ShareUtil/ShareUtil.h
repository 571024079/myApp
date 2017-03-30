//
//  ShareUtil.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@protocol MFMailComposeViewControllerDelegate;
@class MFMailComposeViewController;
@interface ShareUtil : NSObject

//+ (MFMailComposeViewController *)shareForMailWithRecipinets:(NSArray<NSString *> *)recipients ccRecipients:(NSArray<NSString *> *)ccRecipients bccRecipients:(NSArray<NSString *> *)bccRecipients subject:(NSString *)subject messageBody:(NSString *)messageBody attachmentSettings:(void (^)(MFMailComposeViewController *VC))setting  delegate:(id<MFMailComposeViewControllerDelegate> __nullable)delegate;
+ (void)shareWechatParamsByText:(nullable NSString *)shareContent images:(nullable NSArray *)images url:(nullable NSURL *)url title:(nullable NSString *)title;
+ (void)shareMailParamsByText:(nullable NSString *)text title:(nullable NSString *)title images:(nullable id)images attachments:(nullable id)attachments recipients:(nullable NSArray *)recipients ccRecipients:(nullable NSArray *)ccRecipients bccRecipients:(nullable NSArray *)bccRecipients;
@end
