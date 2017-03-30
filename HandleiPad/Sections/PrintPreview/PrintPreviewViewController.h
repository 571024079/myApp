//
//  PrintPreviewViewController.h
//  HandleiPad
//
//  Created by Handlecar on 10/8/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PrintPreviewVCFromStyle_userAffirm,//客户确认界面
    PrintPreviewVCFromStyle_Service,//服务档案右侧长按
}PrintPreviewVCFromStyle;




@interface PrintPreviewViewController : UIViewController
//进入显示方式
@property (nonatomic, assign) PrintPreviewVCFromStyle fromStyle;

@property (nonatomic, strong) NSDictionary *info;  /// key:fromstyle   signimage
@property (nonatomic, strong) NSMutableArray *dataSource;  // 预览页面数据源

@property (nonatomic, assign) BOOL isCanRotate;//是否可以进行屏幕旋转

/**
 传入pdf文件路径

 @param PDFUrl pdf文件URL
 @return 预览界面
 */

- (instancetype)initWithPDFURL:(NSURL *)PDFUrl;

@end
