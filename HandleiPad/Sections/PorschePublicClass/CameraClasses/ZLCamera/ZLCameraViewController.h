//
//  BQCamera.h
//  CameraDemo
//
//  Created by GoodRobin on 16/9/19.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanInfoModel.h"

@class ZLCameraViewController;
typedef NS_ENUM(NSInteger, ZLCameraType) {
    ZLCameraSingle,//单张
    ZLCameraContinuous,//连拍
};

// 功能类型(用于判断)
typedef NS_ENUM(NSInteger, ControllerUsageType) {
    ControllerUsageTypeCamera,   //相机模式
    ControllerUsageTypeScan,   //扫描模式
    ControllerUsageTypeOnlyPhoto, //仅照相
//    ControllerUsageTypeOnlyVideo //仅录像
    ControllerUsageTypeNOMask,  // 无遮罩拍照
};


typedef void(^ZLCameraCallBack)(NSArray *images, ZLCamera *videoModel, UIImage *coverImage);

typedef void(^ScanReturnBack)(ScanInfoModel *model);

@protocol CameraViewControllerDelegete <NSObject>

@optional
/**
 相机关闭回调

 @param images 相片数组
 @param video 视频model
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController confirmBackWithImages:(NSArray *)images Video:(ZLCamera *)video;

/**
 新建了一个视频

 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewVideo:(ZLCamera *)video;

/**
 扫描回调

 @param scaninfo 扫描信息回调
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController scanTypeBackWithScaninfo:(ScanInfoModel *)scaninfo;

/**
 新建了一个原图图片
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewOriginalPhoto:(ZLCamera *)photo;

/**
 新建了一个编辑图片
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewEditPhoto:(ZLCamera *)photo;

/**
 删除了一个图片/视频
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController deleteDidCamera:(ZLCamera *)photo;

@optional
- (void)cameraViewController:(ZLCameraViewController *)cameraController FinishedDidCamera:(ZLCamera *)photo;

@end

@interface ZLCameraViewController : UIViewController


@property (nonatomic, weak) id <CameraViewControllerDelegete> delegete;
//图片数据源
@property (nonatomic, copy) NSMutableArray *images;

@property (nonatomic, strong) UIImageView *videoImageView;

//存视频
@property (nonatomic, strong) ZLCamera *videoModel;
// 拍照的个数限制
@property (assign,nonatomic) NSInteger maxCount;
// 单张还是连拍
@property (nonatomic, assign) ZLCameraType cameraType;

// 完成后回调
@property (copy, nonatomic) ZLCameraCallBack callback;

//扫描回调
@property (copy, nonatomic) ScanReturnBack scanBlock;

- (void)showPickerVc:(UIViewController *)vc;

- (instancetype)initWithUsageType:(ControllerUsageType)type;

/** 1.是否删除视频 2.要删除图片在数据源中的index（需要数据源index统一,如果isVideo=yes，index将无效）*/
- (void)deleteDataSourceVideo:(BOOL)isVideo orImage:(NSInteger)index;

- (void)reloadData;
- (void)addPhoto:(ZLCamera *)camera;
@end
