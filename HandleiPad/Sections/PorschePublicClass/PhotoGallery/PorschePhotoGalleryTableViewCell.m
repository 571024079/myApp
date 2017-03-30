//
//  PorschePhotoGalleryTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorschePhotoGalleryTableViewCell.h"
#import "PorschePhotoGalleryImageCollectionViewCell.h"
#import "ZLCameraViewController.h"
#import "HZPhotoBrowser.h"
#import "DrawViewController.h"
#import "PorscheVideoPlayer.h"

@interface PorschePhotoGalleryTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, HZPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopLayout;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *firstPlaceholderImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLeftLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *takPhotoButton;
@property (nonatomic, strong) HZPhotoBrowser *browser;
@end

@implementation PorschePhotoGalleryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nextButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setupShandow:self.firstImageView];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    return [PorschePhotoGalleryTableViewCell cellWithTableView:tableView delegate:nil];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView delegate:(id<PorschePhotoGalleryTableViewCellDelegate>)delegate
{
    static NSString *identifier = @"PorschePhotoGalleryTableViewCell";
    PorschePhotoGalleryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] objectAtIndex:0];
        cell.delegate = delegate;
    }
    //    [cell viewSetup];
    return cell;
}

- (void)setDataSource:(NSMutableArray<ZLCamera *> *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)setupShandow:(UIView *)view {
    
    view.clipsToBounds = NO;
    UIColor *color = [UIColor grayColor];
    view.layer.shadowColor = color.CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,3);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 1.0;//阴影透明度，默认0
    view.layer.shadowRadius = 2;//阴影半径，默认3
}

- (void)setIsNeedShowTakePhoto:(BOOL)isNeedShowTakePhoto
{
    if (!_isNeedShowTakePhoto)
    {
        _isNeedShowTakePhoto = isNeedShowTakePhoto;
    }
    
    // 图片列表是否显示拍照按钮
    if (!_isNeedShowTakePhoto)
    {
        // 调整界面显示
        self.collectionViewLeftLayoutConstraint.constant = - (self.firstImageView.bounds.size.width + 15);
        self.takPhotoButton.hidden = YES;
        self.firstPlaceholderImageView.hidden = YES;
    }
}

- (void)setSectionType:(PorschePhotoGalleryTableViewCellSectionType)sectionType {
    
    _sectionType = sectionType;
    
    [self setupConfig];
}

- (void)setPics:(NSArray *)pics
{
    NSMutableArray *picsDataScoure = [NSMutableArray arrayWithArray:pics];
    
    [picsDataScoure removeObject:self.videoModel];
    _pics = picsDataScoure;
}

- (void)setupConfig {
    
    switch (self.sectionType) {
        case PorschePhotoGalleryTableViewCellVideoSection:
        {
            self.firstPlaceholderImageView.image = [UIImage imageNamed:@"billing_camera_pic.png"];
            //self.firstImageView.image = [UIImage imageNamed:@"billing_car_example"];
        }
            break;
        case PorschePhotoGalleryTableViewCellCameraSection:
        {
            self.firstPlaceholderImageView.image = [UIImage imageNamed:@"billing_camera_pic.png"];
        }
            break;
        default:
            break;
    }
}

- (void)setVideoModel:(ZLCamera *)videoModel {
    
    _videoModel = videoModel;
//    self.firstImageView.image = videoModel.thumbImage;
}

- (void)setHidenTitleLabel:(BOOL)hidenTitleLabel {
    
    _hidenTitleLabel = hidenTitleLabel;
    
    self.titleTopLayout.constant = hidenTitleLabel ? 0 : 10;
    self.titleLabelHeightLayout.constant = hidenTitleLabel ? 0 : 20;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(105, 75);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PorschePhotoGalleryImageCollectionViewCell *cell = [PorschePhotoGalleryImageCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    ZLCamera *model = self.dataSource[indexPath.row];
    
    // 如果是视频
    if ([model.videoUrl absoluteString].length)
    {
        cell.palyImageView.hidden = NO;
        [ZLCamera setImageView:cell.imageView ofVideoModelFirstKeyframe:self.videoModel];
        return cell;
    }
    else
    {
        cell.palyImageView.hidden = YES;
    }

    if ([model.editImageUrl absoluteString].length)
    {
        [cell.imageView sd_setImageWithURL:model.editImageUrl];
    }
    else
    {
        cell.imageView.image = model.thumbImage;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row >=self.dataSource.count) return;

    PorschePhotoGalleryImageCollectionViewCell *cell = (PorschePhotoGalleryImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ZLCamera *model = self.dataSource[indexPath.row];
    // 如果是视频
    if ([model.videoUrl absoluteString].length)
    {
        cell.palyImageView.hidden = NO;
        [ZLCamera setImageView:cell.imageView ofVideoModelFirstKeyframe:self.videoModel];
        
        WeakObject(self);
        if (selfWeak.videoModel &&selfWeak.videoModel.videoUrl) {
            PorscheVideoPlayer *videoVC = [[PorscheVideoPlayer alloc] initWithURL:selfWeak.videoModel.videoUrl videoId:selfWeak.videoModel.cameraID];
            videoVC.isScanModel = YES;
            [HD_FULLViewController presentViewController:videoVC animated:YES completion:nil];
            
        }else {
            [AlertViewHelpers setAlertViewWithMessage:@"暂无可播放视频" viewController:HD_FULLViewController button:cell];
        }
    }
    else
    {
        [self showPhotoBrowerFromCell:cell imageIndex:indexPath.row];
    }
    
    
}

- (void)showPhotoBrowerFromCell:(PorschePhotoGalleryImageCollectionViewCell *)cell imageIndex:(NSInteger)index; {
    
    NSInteger count = self.dataSource.count;
    if ([[self.videoModel.videoUrl absoluteString] length])
    {
        index -= 1;
        count -= 1;
    }
    
    HZPhotoBrowser *photoBrowser = [[HZPhotoBrowser alloc] init];
    self.browser = photoBrowser;
    photoBrowser.delegate = self;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    photoBrowser.collectionCell = cell;
    photoBrowser.imageCount = count;
    photoBrowser.currentImageIndex = (int)index;
    photoBrowser.isScanModel = self.isScanModel;
    [photoBrowser show];
}

#pragma mark - 图片浏览器代理
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
//    ZLCamera *model = self.dataSource[index];
    
//    UIImage *image = model.editImage ? model.editImage : model.photoImage;
    return [UIImage imageNamed:PlaceHolderSmallImageName];
}

- (void)photoBrowser:(HZPhotoBrowser *)browser EditImageForIndex:(NSInteger)index {
    
    [self drawImageControllerIndex:index photoBrowser:browser];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSArray *dataSource = self.dataSource;
    if ([[self.videoModel.videoUrl absoluteString] length])
    {
        dataSource = _pics;
    }
    
    ZLCamera *camera = [dataSource objectAtIndex:index];
    return camera.editImageUrl;
}

- (NSString *)photoBrowser:(HZPhotoBrowser *)browser markContentForIndex:(NSInteger)index
{
    NSArray *dataSource = self.dataSource;
    if ([[self.videoModel.videoUrl absoluteString] length])
    {
        dataSource = _pics;
    }
    
    ZLCamera *camera = [dataSource objectAtIndex:index];
    return camera.markString;
}

- (void)drawImageControllerIndex:(NSInteger)index photoBrowser:(HZPhotoBrowser *)photoBrowser {
    
    WeakObject(self);
    ZLCamera *camera = [self.dataSource objectAtIndex:index];
    DrawViewController *drawVC = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
    drawVC.image = camera.photoImage;
    drawVC.imageUrl = camera.photoImageUrl;
    drawVC.pathArray = camera.pathArray;
    drawVC.markString = camera.markString;
    drawVC.isCovers = camera.isCovers;
    drawVC.doneBlock = ^(UIImage *image, NSString *markString,BOOL isCovers, NSMutableArray *pathArray) {
    camera.editImage = image;


        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        camera.editImage = image;
        camera.markString = markString;
        camera.thumbImage = [UIImage imageWithData:data];
        camera.isCovers = isCovers;
        camera.pathArray = pathArray;
        
        if ([selfWeak.delegate respondsToSelector:@selector(uploadEditImage: browser:)])
        {
            [selfWeak.delegate uploadEditImage:camera browser:self.browser];
        }
        
//        [selfWeak cameraViewController:nil createDidNewEditPhoto:camera];
        
    };
    
    WeakObject(drawVC);
    drawVC.deleteBlock = ^ () {
        
        [selfWeak.dataSource removeObjectAtIndex:index];
        [selfWeak.collectionView reloadData];
        if (selfWeak.dataSource.count ==0) {
            
            [photoBrowser closePhotoBrowser];
            
            [drawVCWeak dismissViewControllerAnimated:YES completion:nil];
            
            //            selfWeak.billingView.cycleCarimgv.image = nil;
        }else {
//            [selfWeak.dataSource removeObjectAtIndex:index];
            [photoBrowser deletePhotoWithIndex:index];
        }
        //        selfWeak.billingView.picArray = selfWeak.picArray;
        if ([selfWeak.delegate respondsToSelector:@selector(deleteImage:)])
        {
            [selfWeak.delegate deleteImage:camera];
        }
        //        [selfWeak.cameraVC deleteDataSourceVideo:NO orImage:index];
        
    };
    

    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:drawVC animated:NO completion:nil];
}


- (IBAction)nextImageAction:(id)sender {

}

- (IBAction)playAction:(id)sender {
    
    switch (self.sectionType) {
        case PorschePhotoGalleryTableViewCellVideoSection:
        {
            
        }
            break;
        case PorschePhotoGalleryTableViewCellCameraSection:
        {
//            ZLCameraViewController *camera = [[ZLCameraViewController alloc] initWithUsageType:ControllerUsageTypeOnlyPhoto];
//            camera.cameraType = ZLCameraContinuous;
//            [KEY_WINDOW.rootViewController.presentedViewController presentViewController:camera animated:YES completion:^{
//                
//            }];
        }
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(tapCell:atShootView:)])
    {
        [self.delegate tapCell:self atShootView:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
