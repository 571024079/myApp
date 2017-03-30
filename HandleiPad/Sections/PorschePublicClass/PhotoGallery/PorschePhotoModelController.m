//
//  PorschePhotoModelController.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorschePhotoModelController.h"
#import "HDPoperDeleteView.h"
#import "ZLCameraViewController.h"
#import "HZPhotoBrowser.h"

@interface PorschePhotoModelController()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,PorschePhotoGalleryDelegate>
@property (nonatomic, strong) PorschePhotoGallery *porschePhotoGallery;
@property (nonatomic, weak) HZPhotoBrowser *photoBroser;
@end

@implementation PorschePhotoModelController


- (instancetype)initWithShootType:(PorscheShootType)shootType fileType:(PorschePhotoGalleryFileType)fileType
{
    self = [super init];
    if (self) {
        _shootType = shootType;
        _fileType = fileType;
    }
    return self;
}

- (void)chooseTotakephotoupdataWithView:(UIView *)view images:(NSArray *)images video:(ZLCamera *)video {
    WeakObject(self);
    [HDPoperDeleteView showUpDatePhotoViewAroundView:view direction:UIPopoverArrowDirectionRight Camera:^{
        [selfWeak cycleTakePhoto:images video:video];
    } location:^{
        [selfWeak showSystemPhoto];
    }];
}

- (void)cycleTakePhoto:(NSArray *)images video:(ZLCamera *)video {
    WeakObject(self);
    
    ZLCameraViewController *cameraVC =  [[ZLCameraViewController alloc] initWithUsageType:ControllerUsageTypeCamera];
    
    // 拍照最多个数
    cameraVC.maxCount = 10;
    // 多张拍摄
    cameraVC.cameraType = ZLCameraContinuous;
    
    cameraVC.images = [NSMutableArray arrayWithArray:images];
    
    cameraVC.videoModel = video;
    cameraVC.delegete = self;
    
    //模态推出相机页面（可自行用Push方法代替）
    [cameraVC showPickerVc:selfWeak.supporterViewController];
}


- (void)showPhotoGalleryWithModel:(PorscheGalleryModel *)model viewType:(PorschePhotoGalleryViewType)viewType
{
    
    [model convertPorscheResponserPictureVideoModelToZLCamera];
    self.porschePhotoGallery = [PorschePhotoGallery viewWithCarVideo:nil model:model viewType:viewType];
    self.porschePhotoGallery.delegate = self;
    [HD_FULLView addSubview:self.porschePhotoGallery];
}

#pragma mark 进入图片库
- (void)showSystemPhoto {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        
        ipc.delegate = self;
        [self intoPhotoLibrarySetting];
        [self.supporterViewController presentViewController:ipc animated:YES completion:NULL];
    }
}

#pragma mark -- 获取图片浏览库信息并刷新图片库
- (void)getPhotoListAndRefresh
{
    WeakObject(self);
    [PorschePhotoModelController getPhotoListCompletion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            PorscheGalleryModel *model = [PorscheGalleryModel yy_modelWithDictionary:responser.object];
            [model convertPorscheResponserPictureVideoModelToZLCamera];
            [selfWeak.porschePhotoGallery setBaseInfoWithCarPics:model.carpics schemePics:model.schemeinfo];
        }
    }];
}

// 进入图片库
- (void)intoPhotoLibrarySetting
{
    [[NSNotificationCenter defaultCenter] postNotificationName:INTO_PHOTOLIBRARY_NOTIFICATION object:nil];
}

// 退出图片库
- (void)exitPhotoLibrarySetting
{
    [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_PHOTOLIBRARY_NOTIFICATION object:nil];
}

#pragma mark  访问相册选择照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self exitPhotoLibrarySetting];
    UIImage *selectImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    ZLCamera *camera = [[ZLCamera alloc] init];
    camera.photoImage = selectImage;
    [self cameraViewController:nil createDidNewOriginalPhoto:camera];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self exitPhotoLibrarySetting];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/**
 新建了一个原图图片
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewOriginalPhoto:(ZLCamera *)photo;
{
    WeakObject(self);
    PorscheRequestUploadPictureVideoModel *request = [[PorscheRequestUploadPictureVideoModel alloc] init];
    request.aieditdesc = photo.markString;
    request.aifiletype = @(_fileType);
    request.aipictype = @(_shootType);
    request.keytype = @(_keyType); // 工单 方案 备件 签名也是属于工单
    if (_keyType == PorschePhotoGalleryKeyTypeOrder)
    {
        request.relativeid = [[HDStoreInfoManager shareManager] carorderid];
    }
    else
    {
        request.relativeid = self.relativeid;
    }
    
    request.edittype = @1;
//    request.aiid = nil;  // 新建时为空，编辑时才有
    request.parentid = nil;
    request.patharray = nil;
    request.iscovers = photo.isCovers ? @1 : @0;
    // 新建工单图片
    [PorscheRequestManager uploadCameraImages:@[photo] editImage:NO video:nil parameModel:request completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *responserObjectInfo = [responser objectForKey:@"object"];
            PorscheResponserPictureVideoModel *picModel = [PorscheResponserPictureVideoModel yy_modelWithDictionary:responserObjectInfo];
            //            photo.cameraID = picModel.aiid;
            [photo convertPhotoWithPhoto:picModel];
            if (selfWeak.porschePhotoGallery)
            {
                // 刷新列表
                [selfWeak getPhotoListAndRefresh];
            }
            [cameraController addPhoto:photo];
        }
    }];
    
}
/**
 新建了一个编辑图片
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewEditPhoto:(ZLCamera *)photo;
{
    WeakObject(self);
    PorscheRequestUploadPictureVideoModel *request = [[PorscheRequestUploadPictureVideoModel alloc] init];
    request.aieditdesc = photo.markString;
    request.aifiletype = @(_fileType);
    request.aipictype = @(_shootType);
    request.keytype = @(_keyType); // 工单 方案 备件 签名也是属于工单
    
    if (_keyType == PorschePhotoGalleryKeyTypeOrder)
    {
        request.relativeid = [[HDStoreInfoManager shareManager] carorderid];
    }
    else
    {
        request.relativeid = self.relativeid;
    }
    
    request.edittype = @2;
    request.aiid = photo.cameraID;  // 新建时为空，编辑时才有
    request.iscovers = photo.isCovers ? @1 : @0;
    request.parentid = photo.cameraID;
    request.patharray = [photo convertPathArrayToString];//[[photo.pathArray yy_modelToJSONString] stringByReplacingOccurrencesOfString:@"\"" withString:@"\'"];
    [PorscheRequestManager uploadCameraImages:@[photo] editImage:YES video:nil parameModel:request completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *responserObjectInfo = [responser objectForKey:@"object"];
            PorscheResponserPictureVideoModel *picModel = [PorscheResponserPictureVideoModel yy_modelWithDictionary:responserObjectInfo];
            [photo convertPhotoWithPhoto:picModel];
            if (selfWeak.porschePhotoGallery)
            {
                // 刷新列表
                [selfWeak getPhotoListAndRefresh];
            }
            [selfWeak.photoBroser reloadCurrentPhoto];
            [cameraController reloadData];
        }
    }];
}


- (void)cameraViewController:(ZLCameraViewController *)cameraController createDidNewVideo:(ZLCamera *)video
{
    WeakObject(self);

    PorscheRequestUploadPictureVideoModel *request = [[PorscheRequestUploadPictureVideoModel alloc] init];
    request.aieditdesc = @"视频上传";
    request.aifiletype = @(2);
    request.aipictype = @(1);
    request.keytype = @(1);
    request.relativeid = [HDStoreInfoManager shareManager].carorderid;
    request.edittype = @1;
//    request.aiid = nil;  // 新建时为空，编辑时才有
    request.parentid = nil;
    request.patharray = nil;
    request.iscovers = video.isCovers ? @1 : @0;
    [PorscheRequestManager uploadCameraImages:@[] editImage:NO video:video.videoUrl parameModel:request completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (!error)
        {
            NSDictionary *responserObjectInfo = [responser objectForKey:@"object"];
            PorscheResponserPictureVideoModel *picModel = [PorscheResponserPictureVideoModel yy_modelWithDictionary:responserObjectInfo];
            video.cameraID = picModel.aiid;
            [video convertVideoWithVideo:picModel];
            if (selfWeak.porschePhotoGallery)
            {
                // 刷新列表
                [selfWeak getPhotoListAndRefresh];
            }
            [cameraController reloadData];
        }
    }];
}

/**
 删除了一个图片
 */
- (void)cameraViewController:(ZLCameraViewController *)cameraController deleteDidCamera:(ZLCamera *)photo{
    if ([photo.cameraID integerValue] == 0)
    {
        return;
    }
    WeakObject(self);

    [PorscheRequestManager deleteCameraImage:photo.cameraID.integerValue complete:^(BOOL delete, NSString * _Nonnull errorMsg) {
        if (delete)
        {
            NSLog(@"删除成功");
            if (selfWeak.porschePhotoGallery)
            {
                // 刷新列表
                [selfWeak getPhotoListAndRefresh];
            }
        }
    }];
}


/**
*  拍摄完成
*/

- (void)cameraViewController:(ZLCameraViewController *)cameraController FinishedDidCamera:(ZLCamera *)photo
{
    [PorschePhotoModelController getPhotoListCompletion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
//            if (selfWeak.porschePhotoGallery)
//            {
//                // 刷新列表
//                [selfWeak getPhotoListAndRefresh];
//            }
        }
    }];
}

+ (void)getPhotoListCompletion:(PResponserCallBack)completion
{
    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_PHOTOLIST parameters:nil completion:completion];
}

#pragma mark -- 图片浏览库 ---
- (void)tapShootView:(UIView *)view shootInfo:(NSDictionary *)dict
{
    NSArray *images = [dict objectForKey:@"picArray"];
    ZLCamera *video = [dict objectForKey:@"videoModel"];
    self.relativeid = [dict objectForKey:@"relativeid"];
    self.shootType =  [[dict objectForKey:@"shootType"] integerValue];
    self.keyType =    [[dict objectForKey:@"keyType"]  integerValue];
    self.fileType = [[dict objectForKey:@"fileType"] integerValue];;
    
    WeakObject(self);
    [HDPoperDeleteView showUpDatePhotoViewAroundView:view direction:UIPopoverArrowDirectionRight Camera:^{
        [selfWeak cycleTakePhoto:images video:video];
    } location:^{
        [selfWeak showSystemPhoto];
    }];
}

- (void)uploadEditImage:(ZLCamera *)camera browser:(HZPhotoBrowser *)browser;
{
    self.photoBroser = browser;
    [self cameraViewController:nil createDidNewEditPhoto:camera];
}

- (void)deleteImage:(ZLCamera *)camera
{
    [self cameraViewController:nil deleteDidCamera:camera];
}

- (void)porschePhotoGalleryClose
{
    self.porschePhotoGallery = nil;
}



@end
