//
//  ZLCamera.m
//  CameraDemo
//
//  Created by GoodRobin on 16/9/19.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import "ZLCamera.h"
#import <AVFoundation/AVFoundation.h>
#import "ACEDrawingTools.h"
#import "UIColor+util.h"

@implementation ZLCamera

- (instancetype)initWithPhoto:(PorscheResponserPictureVideoModel *)photoModel
{
    self = [super init];
    if (self) {


        [self convertPhotoWithPhoto:photoModel];
        /*
         @property (nonatomic, strong) NSURL *photoImageUrl; //原图url
         @property (nonatomic, assign) NSInteger photoImageID; //原图id
         @property (nonatomic, strong) UIImage *editImage;  //编辑后的图片
         @property (nonatomic, strong) NSURL *editImageUrl;//编辑图Url
         @property (nonatomic, copy) NSString *markString;  //图片备注
         @property (strong, nonatomic) NSURL *videoUrl;  //视频地址
         @property (nonatomic, assign) BOOL isCovers; //是否为封页
         @property (nonatomic, copy) NSMutableArray *pathArray; //编辑笔记途径model数组
         */
    }
    return self;
}

- (void)convertPhotoWithPhoto:(PorscheResponserPictureVideoModel *)photoModel
{
    self.photoImageUrl = [NSURL URLWithString:photoModel.fullpath];
    
    if ([photoModel.maiid integerValue] == 0)
    {
        photoModel.mfullpath = photoModel.fullpath;
    }
    
    self.editImageUrl = [NSURL URLWithString:photoModel.mfullpath];
    self.markString = photoModel.maieditdesc;
    
    self.isCovers = [photoModel.iscovers boolValue];
    self.cameraID = photoModel.aiid;
    self.pathArray = [self convertPathArrayToDrawToolArraysFromArray:photoModel.mpatharray];
}

- (instancetype)initWithVideo:(PorscheResponserPictureVideoModel *)videoModel
{
    self = [super init];
    if (self) {
        [self convertVideoWithVideo:videoModel];
    }
    return self;
}

- (void)convertVideoWithVideo:(PorscheResponserPictureVideoModel *)videoModel
{
    self.videoUrl = [NSURL URLWithString:videoModel.fullpath];
    self.cameraID = videoModel.aiid;
}

+ (instancetype)cameraWithPhoto:(PorscheResponserPictureVideoModel *)photoModel {
    
    ZLCamera *camera = [[ZLCamera alloc] initWithPhoto:photoModel];
    return camera;
}

+ (instancetype)cameraWithVideo:(PorscheResponserPictureVideoModel *)videoModel {
    
    ZLCamera *camera = [[ZLCamera alloc] initWithVideo:videoModel];
    return camera;
}

+ (instancetype)queryCoversFromCameras:(NSArray<ZLCamera *> *)cameras
{
    for (ZLCamera *camera in cameras) {
        if (camera.isCovers)
        {
            return camera;
        }
    }
    
    for (ZLCamera *camera in cameras)
    {
        if (![[camera.videoUrl absoluteString] length]) {
            return camera;
        }
    }
    
    return nil;
}

+ (instancetype)queryVideoFirstKeframeFromCameras:(NSArray <ZLCamera *> *)cameras
{
    for (ZLCamera *camera in cameras) {
        if ([[camera.videoUrl absoluteString] length])
        {
            return camera;
        }
    }
    return nil;
}

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
//    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


- (NSString *)convertPathArrayToString
{
    NSMutableArray *pathInfoArray = [NSMutableArray array];
    for (id<ACEDrawingTool>drawTool in self.pathArray)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

        [dict hs_setSafeValue:@(drawTool.lineWidth) forKey:@"lineWidth"];
        [dict hs_setSafeValue:@(drawTool.lineAlpha) forKey:@"lineAlpha"];
        [dict hs_setSafeValue:@(drawTool.toolType) forKey:@"toolType"];
//        NSValue *first = [NSValue valueWithCGPoint:drawTool.firstPoint];
//        NSValue *lastPoint = [NSValue valueWithCGPoint:drawTool.lastPoint];

        [dict hs_setSafeValue:[UIColor getColorInfoWithColor:drawTool.lineColor] forKey:@"lineColor"];
        [dict hs_setSafeValue:NSStringFromCGPoint(drawTool.firstPoint) forKey:@"firstPoint"];
        [dict hs_setSafeValue:NSStringFromCGPoint(drawTool.lastPoint) forKey:@"lastPoint"];
        [pathInfoArray addObject:dict];
    }
    
    
    
    NSString *pathJsonString = [[pathInfoArray yy_modelToJSONString] stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"];
    
    return pathJsonString;
}



- (NSMutableArray *)convertPathArrayToDrawToolArraysFromArray:(NSString *)drawToolJsonString
{
    // 把普通字符串转化为json字符串
    NSString *pathFormateString = [drawToolJsonString stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    NSArray *pathInfoArray = [pathFormateString JSONValue];
    
    NSMutableArray *drawToolArray = [NSMutableArray array];
    
    for (NSDictionary *dict in pathInfoArray) {
        
        CGFloat lineAlpha = [[dict objectForKey:@"lineAlpha"] floatValue];
        CGFloat lineWidth = [[dict objectForKey:@"lineWidth"] floatValue];
        NSInteger toolType = [[dict objectForKey:@"toolType"] integerValue];
        CGPoint firstPoint = CGPointFromString([dict objectForKey:@"firstPoint"]);
        CGPoint lastPoint = CGPointFromString([dict objectForKey:@"lastPoint"]);

        // @{@"red":red,@"green":green,@"blue":blue};
        NSDictionary *colorInfo = [dict objectForKey:@"lineColor"];
        NSNumber *red = [colorInfo objectForKey:@"red"];
        NSNumber *green = [colorInfo objectForKey:@"green"];
        NSNumber *blue = [colorInfo objectForKey:@"blue"];

        UIColor *color = [UIColor colorWithRed:[red floatValue] green:[green floatValue]  blue:[blue floatValue]  alpha:1];
        
        id<ACEDrawingTool>drawTool = nil;
        // 创建对应的 轨迹model
        switch (toolType) {
            case 1:
            {
                drawTool = [ACEDrawingRectangleTool new];
            }
                break;
            case 2:
            {
                drawTool = [ACEDrawingEllipseTool new];
            }
                break;
            case 3:
            {
                drawTool = [ACEDrawingArrowTool new];
            }
                break;
            default:
                break;
        }
        drawTool.lineWidth = lineWidth;
        drawTool.lineAlpha = lineAlpha;
        drawTool.lineColor = color;
        drawTool.firstPoint = firstPoint;
        drawTool.lastPoint = lastPoint;

        if (drawTool)
        {
            [drawToolArray addObject:drawTool];
        }
    }
    return drawToolArray;
}
// 转换照片model
+ (NSMutableArray *)convertToZLCameraFrom:(NSArray *)picArray
{
    NSMutableArray *dataSource = [NSMutableArray array];
    for (PorscheResponserPictureVideoModel *model in picArray) {
        ZLCamera *cameraModel = nil;
        if ([model.aifiletype integerValue] == 1)
        {
            cameraModel = [ZLCamera cameraWithPhoto:model];
        }
        else if([model.aifiletype integerValue] == 2)
        {
            cameraModel = [ZLCamera cameraWithVideo:model];
            
        }
        if (cameraModel)
        {
            [dataSource addObject:cameraModel];
        }
    }
    return dataSource;
}

+ (void)setImageView:(UIImageView *)imageView ofVideoModelFirstKeyframe:(ZLCamera *)video
{
    if ([[video.videoUrl absoluteString] length])
    {
        if (video.videoImage)
        {
            imageView.image = video.videoImage;
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *image = [ZLCamera thumbnailImageForVideo:video.videoUrl atTime:1];
                video.videoImage = image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
            });
        }
    }
    else
    {
        imageView.image = nil;
    }

}

@end
