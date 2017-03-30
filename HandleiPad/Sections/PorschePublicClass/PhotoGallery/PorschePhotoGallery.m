//
//  PorschePhotoGallery.m
//  HandleiPad
//
//  Created by Robin on 16/10/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorschePhotoGallery.h"
#import "PorschePhotoGalleryTableViewCell.h"
#import "PorschePhotoGalleryHeaderView.h"
//#import "ZLCamera.h"
#import "PorschePhotoModelController.h"
#import "PorscheVideoPlayer.h"
#import "HZPhotoBrowser.h"

@interface PorschePhotoGallery () <UITableViewDelegate, UITableViewDataSource,PorschePhotoGalleryTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) ZLCamera *videoModel;
@property (nonatomic, strong) NSMutableArray <ZLCamera *> *carPics;
@property (nonatomic, strong) NSMutableArray <PorscheGallerSchemeInfo *> *schemePics;
@property (nonatomic, strong) PorschePhotoModelController *modelController;
@property (nonatomic, strong) PorscheGalleryModel *model;
@end

@implementation PorschePhotoGallery

+ (instancetype)viewWithCarVideo:(ZLCamera *)video model:(PorscheGalleryModel *)model viewType:(PorschePhotoGalleryViewType)viewType;
{
    PorschePhotoGallery *photoGallery = [[[NSBundle mainBundle] loadNibNamed:@"PorschePhotoGallery" owner:nil options:nil] lastObject];
    photoGallery.frame = KEY_WINDOW.bounds;
    photoGallery.viewType = viewType;
    photoGallery.contentView.layer.masksToBounds = YES;
    photoGallery.contentView.layer.borderWidth = 1;
    photoGallery.contentView.layer.cornerRadius = 6;
    photoGallery.contentView.layer.borderColor = Color(200, 200, 200).CGColor;
    photoGallery.model = model;
    [photoGallery setBaseInfoWithCarPics:model.carpics schemePics:model.schemeinfo];

    return photoGallery;
}

- (void)setBaseInfoWithCarPics:(NSArray *)carPics schemePics:(NSArray *)schemePics
{
    self.videoModel = [ZLCamera queryVideoFirstKeframeFromCameras:carPics]; // 获取
    self.carPics = [NSMutableArray arrayWithArray:carPics];
    [self.carPics removeObject:self.videoModel];
    if (_videoModel)
    {
        [self.carPics insertObject:self.videoModel atIndex:0];
    }
    self.schemePics = [NSMutableArray arrayWithArray:schemePics];
    [self.tableView reloadData];
    
    [self findScrollToCurrentScheme];
    
}

- (void)findScrollToCurrentScheme
{
    // 查找当前方案
    if ([self.model.currentSchemeid integerValue])
    {
        for (PorscheGallerSchemeInfo *oneScheme in self.schemePics)
        {
            if ([oneScheme.schemeid integerValue] == [self.model.currentSchemeid integerValue])
            {
                NSInteger index = [self.schemePics indexOfObject:oneScheme];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
                
                // 将当前方案滚动最上方
                
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                return;
            }
        }
    }
}

- (UIImage *)placeHolderImageViewWithIndex:(NSInteger)index {
    
    NSInteger i = index%3;
    NSString *imageName;
    switch (i) {
        case 0:
            imageName = @"billing_car_example2";
            break;
        case 1:
            imageName = @"billing_car_example3";
            break;
        case 2:
            imageName = @"billing_car_example4";
            break;
        default:
            break;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    
    return image;
}

//- (NSMutableArray<ZLCamera *> *)carPics {
//    
//    if (!_carPics) {
//        _carPics = [[NSMutableArray alloc] init];
//        for (NSInteger i = 0; i < 10; i ++) {
//            
//            ZLCamera *camera = [[ZLCamera alloc] init];
//            camera.photoImage = [self placeHolderImageViewWithIndex:i];
//            camera.thumbImage = camera.photoImage;
//            [_carPics addObject:camera];
//        }
//    }
//    return _carPics;
//}

//- (NSMutableArray*)schemePics {
//    
//    if (!_schemePics) {
//        _schemePics = [[NSMutableArray alloc] init];
//    
//        for (NSInteger i = 0; i < 2; i ++) {
//            
//            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            for (NSInteger i = 0; i < 10; i ++) {
//                ZLCamera *camera = [[ZLCamera alloc] init];
//                camera.photoImage = [self placeHolderImageViewWithIndex:i];
//                camera.thumbImage = camera.photoImage;
//                [arr addObject:camera];
//            }
//            [_schemePics addObject:arr];
//        }
//    }
//    return _schemePics;
//}

//- (void)chooseTotakephotoupdataWithView:(UIView *)view images:(NSArray *)images video:(ZLCamera *)carmer
//{
//    [self.modelController chooseTotakephotoupdataWithView:view images:images video:carmer];
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return self.schemePics.count;
    }
    return section == 0? 1 : 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section == 0 ? 105 : 135;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 18;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    PorschePhotoGalleryHeaderView *headerView = [PorschePhotoGalleryHeaderView headerWithTableView:tableView];
    headerView.headerLabel.text = section == 0 ? @"环车拍照":@"方案/项目照片";
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PorschePhotoGalleryTableViewCell *cell = [PorschePhotoGalleryTableViewCell cellWithTableView:tableView delegate:self];
    
    if (indexPath.section == 0) {
        cell.hidenTitleLabel = YES;
        cell.sectionType = PorschePhotoGalleryTableViewCellVideoSection;
        cell.videoModel = self.videoModel;
        cell.dataSource = self.carPics;
        cell.pics = self.carPics;
        ZLCamera *cover = [ZLCamera queryCoversFromCameras:self.carPics];
        if ([[cover.editImageUrl absoluteString] length])
        {
            [cell.firstImageView sd_setImageWithURL:cover.editImageUrl placeholderImage:[UIImage imageNamed:PlaceHolderImageNormalName]];
        }
        else
        {
            cell.firstImageView.image = cover.thumbImage;
        }

        //[ZLCamera setImageView:cell.firstImageView ofVideoModelFirstKeyframe:self.videoModel];
    } else {
        cell.hidenTitleLabel = NO;
        cell.sectionType = PorschePhotoGalleryTableViewCellCameraSection;
        PorscheGallerSchemeInfo *model = self.schemePics[indexPath.row];
        cell.titleLabel.text = model.schemename;
        cell.videoModel = nil;
        cell.dataSource  = [NSMutableArray arrayWithArray:[model schemepics]];
        ZLCamera *cover = [ZLCamera queryCoversFromCameras:model.schemepics];
        if ([[cover.editImageUrl absoluteString] length])
        {
            [cell.firstImageView sd_setImageWithURL:cover.editImageUrl placeholderImage:[UIImage imageNamed:PlaceHolderImageNormalName]];
        }
        else
        {
            cell.firstImageView.image = cover.thumbImage;
        }
    }
    if (self.viewType == PorschePhotoGalleryPreview)
    {
        cell.isNeedShowTakePhoto = NO;
        cell.isScanModel = YES;
    }
    else if (self.viewType == PorschePhotoGalleryPreviewAndShoot)
    {
        cell.isNeedShowTakePhoto = YES;
        if (indexPath.section == 0)
        {
            cell.isScanModel = YES;
        }
        else
        {
            cell.isScanModel = NO;
        }
    }
    return cell;
}
- (IBAction)confirmAction:(id)sender {
    
    [self removeFromSuperview];
}
- (IBAction)cancleAction:(id)sender {
    
    [self removeFromSuperview];
}
- (IBAction)closeAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(porschePhotoGalleryClose)])
    {
        [self.delegate porschePhotoGalleryClose];
    }
    
    [self removeFromSuperview];
}

#pragma mark --- 拍摄点击事件处理 ---
- (void)tapCell:(PorschePhotoGalleryTableViewCell *)cell atShootView:(UIView *)view
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
    NSMutableArray *picArray = nil;
//    ZLCamera *videoModel = nil;
    NSMutableDictionary *shootInfo = [NSMutableDictionary dictionary];
    if (indexPath.section == 0)
    {
        /*
        picArray = [NSMutableArray arrayWithArray:self.carPics];
        [shootInfo hs_setSafeValue:[[HDStoreInfoManager shareManager] carorderid] forKey:@"relativeid"];
        [shootInfo hs_setSafeValue:@(PorschePhotoCarImage) forKey:@"shootType"];
        [shootInfo hs_setSafeValue:@(PorschePhotoGalleryKeyTypeOrder) forKey:@"keyType"];
        [shootInfo hs_setSafeValue:self.videoModel forKey:@"videoModel"];
        [shootInfo hs_setSafeValue:picArray forKey:@"picArray"];
        [shootInfo hs_setSafeValue:@(PorschePhotoGalleryFileTypeImage) forKey:@"fileType"];
        */
        
        // 播放视频
  /*      WeakObject(self);
        if (selfWeak.videoModel &&selfWeak.videoModel.videoUrl) {
            PorscheVideoPlayer *videoVC = [[PorscheVideoPlayer alloc] initWithURL:selfWeak.videoModel.videoUrl videoId:selfWeak.videoModel.cameraID];
            videoVC.isScanModel = YES;
            [HD_FULLViewController presentViewController:videoVC animated:YES completion:nil];
            
        }else {
            [AlertViewHelpers setAlertViewWithMessage:@"暂无可播放视频" viewController:HD_FULLViewController button:view];
        }*/
        // 环车拍照
        picArray = [NSMutableArray arrayWithArray:self.carPics];
        [picArray removeObject:self.videoModel];
        
        [shootInfo hs_setSafeValue:[HDStoreInfoManager shareManager].carorderid forKey:@"relativeid"];
        [shootInfo hs_setSafeValue:@(PorschePhotoCarImage) forKey:@"shootType"];
        [shootInfo hs_setSafeValue:@(PorschePhotoGalleryKeyTypeOrder) forKey:@"keyType"];
        [shootInfo hs_setSafeValue:picArray forKey:@"picArray"];
        [shootInfo hs_setSafeValue:@(PorschePhotoGalleryFileTypeImage) forKey:@"fileType"];
        [shootInfo hs_setSafeValue:self.videoModel forKey:@"videoModel"];

        
        if ([self.delegate respondsToSelector:@selector(tapShootView:shootInfo:)])
        {
            [self.delegate tapShootView:view shootInfo:shootInfo];
        }

    }
    else
    {
        
        PorscheGallerSchemeInfo *sheme = self.schemePics[indexPath.row];
        picArray = [NSMutableArray arrayWithArray:sheme.schemepics];

        [shootInfo hs_setSafeValue:sheme.schemeid forKey:@"relativeid"];
        [shootInfo hs_setSafeValue:@(PorschePhotoScheme) forKey:@"shootType"];
        [shootInfo hs_setSafeValue:@(PorschePhotoGalleryKeyTypeScheme) forKey:@"keyType"];
        [shootInfo hs_setSafeValue:picArray forKey:@"picArray"];
        [shootInfo hs_setSafeValue:@(PorschePhotoGalleryFileTypeImage) forKey:@"fileType"];

        if ([self.delegate respondsToSelector:@selector(tapShootView:shootInfo:)])
        {
            [self.delegate tapShootView:view shootInfo:shootInfo];
        }
    }
    

    
//    [self chooseTotakephotoupdataWithView:view images:picArray video:videoModel];
}

- (void)uploadEditImage:(ZLCamera *)camera browser:(HZPhotoBrowser *)browser
{
    if ([self.delegate respondsToSelector:@selector(uploadEditImage:browser:)])
    {
        [self.delegate uploadEditImage:camera browser:browser];
    }
}

- (void)deleteImage:(ZLCamera *)camera
{
    if ([self.delegate respondsToSelector:@selector(deleteImage:)])
    {
        [self.delegate deleteImage:camera];
    }
}

@end
