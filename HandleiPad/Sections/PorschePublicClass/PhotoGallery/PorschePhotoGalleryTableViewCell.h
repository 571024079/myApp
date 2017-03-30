//
//  PorschePhotoGalleryTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 16/10/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PorschePhotoGalleryTableViewCellSectionType) {
    
    PorschePhotoGalleryTableViewCellVideoSection,
    PorschePhotoGalleryTableViewCellCameraSection
};

@class PorschePhotoGalleryTableViewCell;
@class HZPhotoBrowser;
/**
 处理拍摄点击事件
 */
@protocol PorschePhotoGalleryTableViewCellDelegate <NSObject>

- (void)tapCell:(PorschePhotoGalleryTableViewCell *)cell atShootView:(UIView *)view;
- (void)uploadEditImage:(ZLCamera *)camera browser:(HZPhotoBrowser *)browser;
- (void)deleteImage:(ZLCamera *)camera;
@end

@interface PorschePhotoGalleryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (nonatomic, assign) BOOL hidenTitleLabel;

@property (nonatomic, assign) PorschePhotoGalleryTableViewCellSectionType sectionType;

@property (nonatomic, strong) NSMutableArray <ZLCamera *>*dataSource;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) ZLCamera *videoModel;

@property (nonatomic) BOOL isNeedShowTakePhoto;
@property (nonatomic) BOOL isScanModel;
@property (nonatomic, weak) id<PorschePhotoGalleryTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSArray *pics; // 不包含视频

+ (instancetype)cellWithTableView:(UITableView *)tableView delegate:(id<PorschePhotoGalleryTableViewCellDelegate>)delegate;

@end
