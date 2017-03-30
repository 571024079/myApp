//
//  ZLCamera.h
//  CameraDemo
//
//  Created by GoodRobin on 16/9/19.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PorscheModel.h"

@interface ZLCamera : NSObject

//@property (copy,nonatomic) NSString *imagePath;
@property (strong,nonatomic) UIImage *thumbImage;  //缩略图
@property (strong,nonatomic) UIImage *photoImage;  //原图
@property (nonatomic, strong) NSURL *photoImageUrl; //原图url
@property (nonatomic, strong) NSNumber *cameraID; //原图id/视频id
@property (nonatomic, strong) UIImage *editImage;  //编辑后的图片
@property (nonatomic, strong) NSURL *editImageUrl;//编辑图Url
@property (nonatomic, copy) NSString *markString;  //图片备注
@property (strong, nonatomic) NSURL *videoUrl;  //视频地址
@property (nonatomic, assign) BOOL isCovers; //是否为封页
@property (nonatomic, strong) UIImage *videoImage;// 视频第一帧
@property (nonatomic, copy) NSMutableArray *pathArray; //编辑笔记途径model数组

// 轨迹model处理
- (NSString *)convertPathArrayToString;
/**
 带图初始化
 */
- (instancetype)initWithPhoto:(PorscheResponserPictureVideoModel *)photoModel;
+ (instancetype)cameraWithPhoto:(PorscheResponserPictureVideoModel *)photoModel;
- (void)convertPhotoWithPhoto:(PorscheResponserPictureVideoModel *)photoModel;
/**
 带视频初始化
 */
- (instancetype)initWithVideo:(PorscheResponserPictureVideoModel *)videoModel;
+ (instancetype)cameraWithVideo:(PorscheResponserPictureVideoModel *)videoModel;
- (void)convertVideoWithVideo:(PorscheResponserPictureVideoModel *)videoModel;

/**
 从数组中查找封面图片信息
 */
+ (instancetype)queryCoversFromCameras:(NSArray <ZLCamera *> *)cameras;
+ (instancetype)queryVideoFirstKeframeFromCameras:(NSArray <ZLCamera *> *)cameras;
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

// 将PorscheResponserPictureVideoModel转化成ZLCamera
+ (NSMutableArray *)convertToZLCameraFrom:(NSArray *)picArray;

+ (void)setImageView:(UIImageView *)imageView ofVideoModelFirstKeyframe:(ZLCamera *)video;
@end
