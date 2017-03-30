//
//  ShareUtil.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ShareUtil.h"
#import <MessageUI/MessageUI.h>

@interface ShareUtil ()

@end

@implementation ShareUtil

//+ (MFMailComposeViewController *)shareForMailWithRecipinets:(NSArray<NSString *> *)recipients ccRecipients:(NSArray<NSString *> *)ccRecipients bccRecipients:(NSArray<NSString *> *)bccRecipients subject:(NSString *)subject messageBody:(NSString *)messageBody attachmentSettings :(void (^)(MFMailComposeViewController *))setting delegate:(id<MFMailComposeViewControllerDelegate> __nullable)delegate
//{
//    
//    if (![MFMailComposeViewController canSendMail]) {
//        return nil;
//    }
//    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]init];
//    //收件人列表
//    if (recipients != nil)
//    {
//        [mailVC setToRecipients:recipients];
//    }
//    //抄送
//    if (ccRecipients != nil)
//    {
//        [mailVC setCcRecipients:ccRecipients];
//    }
//    //密送
//    if (bccRecipients != nil)
//    {
//        [mailVC setBccRecipients:bccRecipients];
//    }
//    //主题
//    if (subject != nil)
//    {
//        [mailVC setSubject:subject];
//    }
//     //内容
//    if (messageBody != nil)
//    {
//        [mailVC setMessageBody:messageBody isHTML:NO ];
//    }
//    setting(mailVC);
////    //附件
////    UIImage *img = [UIImage imageNamed:@"rockstar programmer"];
////    NSData *data = UIImagePNGRepresentation(img);
////    [mailVC addAttachmentData:data mimeType:@"image/jpg" fileName:@"rockstar programmer.jpg"];
//    //MFMailComposeViewConreoller的代理
//    mailVC.mailComposeDelegate = delegate;
//    
//    return mailVC;
//
//}

+ (void)shareWechatParamsByText:(NSString *)shareContent images:(NSArray *)images url:(NSURL *)url title:(NSString *)title
{

    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:shareContent
                                     images:images //传入要分享的图片
                                        url:url
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         NSLog(@"");
     }];
}

+ (void)shareMailParamsByText:(NSString *)text title:(NSString *)title images:(id)images attachments:(id)attachments recipients:(NSArray *)recipients ccRecipients:(NSArray *)ccRecipients bccRecipients:(NSArray *)bccRecipients
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupMailParamsByText:text title:title images:images attachments:attachments recipients:recipients ccRecipients:ccRecipients bccRecipients:bccRecipients type:SSDKContentTypeAuto];
    

    [ShareSDK share:SSDKPlatformTypeMail parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
    }];
}

@end
