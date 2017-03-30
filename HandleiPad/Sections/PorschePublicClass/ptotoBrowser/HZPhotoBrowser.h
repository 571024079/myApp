//
//  HZPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HZButton, HZPhotoBrowser;

@protocol HZPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSString *)photoBrowser:(HZPhotoBrowser *)browser markContentForIndex:(NSInteger)index;

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

- (void)photoBrowser:(HZPhotoBrowser *)browser EditImageForIndex:(NSInteger)index;

@end


@interface HZPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) int currentImageIndex;
@property (nonatomic, weak) UICollectionViewCell *collectionCell; //当父视图为collectionview传入一个起始cell
@property (nonatomic, weak) UIView *customStartView; //自定义的view启动
@property (nonatomic, assign) CGRect customRectFromWindow;
@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, strong) NSArray *imageModels;
@property (nonatomic) BOOL isScanModel;  // 是否是浏览模式：只看不编辑
@property (nonatomic, weak) id<HZPhotoBrowserDelegate> delegate;

- (void)showOnWindow;
- (void)show;
- (void)reloadPhotoWithIndex:(NSInteger)index;
- (void)deletePhotoWithIndex:(NSInteger)index;
- (void)closePhotoBrowser;
- (void)reloadCurrentPhoto;
@end
