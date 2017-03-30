//
//  PorschePhotoModelController.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLCameraViewController.h"
#import "PorscheGalleryModel.h"
#import "PorschePhotoGallery.h"

/*
 	1 环车拍照 2 方案拍照 3 备件图拍照 4 客户确认签名
 */
typedef enum : NSUInteger {
    PorschePhotoCarImage  = 1,  // 环车拍摄
    PorschePhotoScheme,    // 方案拍摄
    PorscheTypeSpare,      // 备件拍摄
    PorscheTypeUserSign,   // 客户签名
} PorscheShootType;


/*
* 文件类型 1.img、2.video、3.doc、4.excel、5.txt等
*/
typedef enum : NSUInteger {
    PorschePhotoGalleryFileTypeImage =1,
    PorschePhotoGalleryFileTypeVideo,
    PorschePhotoGalleryFileTypeDoc,
    PorschePhotoGalleryFileTypeExcel,
    PorschePhotoGalleryFileTypeTxt,
} PorschePhotoGalleryFileType;

/*
*  关联类型 	1：工单，2：方案，3：备件
*/
typedef enum : NSUInteger {
    PorschePhotoGalleryKeyTypeOrder = 1,
    PorschePhotoGalleryKeyTypeScheme,
    PorschePhotoGalleryKeyTypeSpare,
} PorschePhotoGalleryKeyType;


@interface PorschePhotoModelController : NSObject<CameraViewControllerDelegete>

@property (nonatomic, weak) UIViewController *supporterViewController;
@property (nonatomic) PorscheShootType shootType;
@property (nonatomic) PorschePhotoGalleryFileType fileType;
@property (nonatomic) PorschePhotoGalleryKeyType keyType;
@property (nonatomic, strong)NSNumber *relativeid;  // 关联id: 方案id、备件id等

// 图片浏览页面model
@property (nonatomic, strong) PorscheGalleryModel *model;

- (instancetype)initWithShootType:(PorscheShootType)shootType fileType:(PorschePhotoGalleryFileType)fileType;

// 选择上传类型：本地上传，拍摄上传
- (void)chooseTotakephotoupdataWithView:(UIView *)view images:(NSArray *)images video:(ZLCamera *)video;
// 上传媒体
- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewOriginalPhoto:(ZLCamera *)photo;
// 获取图片列表
+ (void)getPhotoListCompletion:(PResponserCallBack)completion;
// 进入拍摄页面
- (void)cycleTakePhoto:(NSArray *)images video:(ZLCamera *)video;
// 进入系统相册
- (void)showSystemPhoto;
// 展示图片浏览页面
- (void)showPhotoGalleryWithModel:(PorscheGalleryModel *)model viewType:(PorschePhotoGalleryViewType)viewType;

@end
