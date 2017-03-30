//
//  PorschePhotoGallery.h
//  HandleiPad
//
//  Created by Robin on 16/10/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PorscheGalleryModel.h"
typedef enum : NSUInteger {
    PorschePhotoGalleryPreviewAndShoot,
    PorschePhotoGalleryPreview,
} PorschePhotoGalleryViewType;

@class HZPhotoBrowser;

@protocol PorschePhotoGalleryDelegate <NSObject>

- (void)tapShootView:(UIView *)view shootInfo:(NSDictionary *)dict;
- (void)porschePhotoGalleryClose;
- (void)uploadEditImage:(ZLCamera *)camera browser:(HZPhotoBrowser *)browser;
- (void)deleteImage:(ZLCamera *)camera;
@end

@interface PorschePhotoGallery : UIView
@property (nonatomic) PorschePhotoGalleryViewType viewType;
@property (nonatomic,weak) id<PorschePhotoGalleryDelegate>delegate;

+ (instancetype)viewWithCarVideo:(ZLCamera *)video model:(PorscheGalleryModel *)model viewType:(PorschePhotoGalleryViewType)viewType;

- (void)setBaseInfoWithCarPics:(NSArray *)carPics schemePics:(NSArray *)schemePics;
@end
