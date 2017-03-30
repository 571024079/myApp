//
//  HZPhotoBrowser.m
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import "HZPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "HZPhotoBrowserView.h"
//  ============在这里方便配置样式相关设置===========

//                      ||
//                      ||
//                      ||
//                     \\//
//                      \/

#import "HZPhotoBrowserConfig.h"
//  =============================================
#define kAnimationDuration 0.35f

@implementation HZPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_markLabel;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIButton *_editButton;
    UIActivityIndicatorView *_indicatorView;
    UIView *_contentView;
    CGRect _showRect;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HZPhotoBrowserBackgrounColor;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBrowserPhoto:) name:RELOAD_PHOTOBROWSER_NOTIFICATION object:nil];
    }
    return self;
}

- (void)reloadBrowserPhoto:(NSNotification *)notification
{
    NSNumber *index = notification.object;
    [self reloadPhotoWithIndex:[index integerValue]];
}

- (void)reloadCurrentPhoto
{
    [self reloadPhotoWithIndex:self.currentImageIndex];

}

//当视图移动完成后调用
- (void)didMoveToSuperview
{
    
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"图片浏览器释放~~~~~~~~");
}

- (void)setupToolbars
{
    //0.标记说明
    UILabel *markLabel = [[UILabel alloc] init];
//    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.textColor = [UIColor whiteColor];
    markLabel.font = [UIFont boldSystemFontOfSize:20];
    markLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    _markLabel = markLabel;
    _markLabel.text = [self markContentForIndex:self.currentImageIndex];
    [self addSubview:markLabel];

    // 1. 序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.layer.cornerRadius = 15;
    indexLabel.clipsToBounds = YES;
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
        _indexLabel = indexLabel;
        [self addSubview:indexLabel];
    }

    // 2.保存按钮
//    UIButton *saveButton = [[UIButton alloc] init];
//    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
//    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    saveButton.layer.borderWidth = 0.1;
//    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
//    saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
//    saveButton.layer.cornerRadius = 2;
//    saveButton.clipsToBounds = YES;
//    [saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
//    _saveButton = saveButton;
//    [self addSubview:saveButton];
    if (!self.isScanModel)
    {
        // 3.编辑按钮
        UIButton *editButton = [[UIButton alloc] init];
        //    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        //    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //    editButton.layer.borderWidth = 0.1;
        //    editButton.layer.borderColor = [UIColor whiteColor].CGColor;
        //    editButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
        [editButton setImage:[UIImage imageNamed:@"Camera_edit"] forState:UIControlStateNormal];
        editButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        editButton.layer.cornerRadius = 2;
        editButton.clipsToBounds = YES;
        [editButton addTarget:self action:@selector(editImage) forControlEvents:UIControlEventTouchUpInside];
        _editButton = editButton;
        [self addSubview:editButton];
    }
}

#pragma mark 保存图像
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    HZPhotoBrowserView *currentView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

#pragma mark - 编辑图片

- (void)editImage {

    if ([self.delegate respondsToSelector:@selector(photoBrowser:EditImageForIndex:)]) {
        [self.delegate photoBrowser:self EditImageForIndex:self.currentImageIndex];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 40);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = HZPhotoBrowserSaveImageFailText;
    }   else {
        label.text = HZPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)setupScrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        HZPhotoBrowserView *view = [[HZPhotoBrowserView alloc] init];
        view.imageview.tag = i;
        
        //处理单击
        __weak __typeof(self)weakSelf = self;
        view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf photoClick:recognizer];
        };

        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    HZPhotoBrowserView *view = _scrollView.subviews[index];
    if (view.beginLoadingImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
//    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.width += HZPhotoBrowserImageViewMargin * 2;
    _scrollView.bounds = rect;
//    _scrollView.center = self.center;
    _scrollView.center = CGPointMake(self.bounds.size.width *0.5, self.bounds.size.height *0.5);
    
    CGFloat y = 0;
    __block CGFloat w = _scrollView.frame.size.width - HZPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;

    [_scrollView.subviews enumerateObjectsUsingBlock:^(HZPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = HZPhotoBrowserImageViewMargin + idx * (HZPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
//    if (!_hasShowedFistView) {
//        [self showFirstImage];
//    }
    
    _markLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 80);
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 55, 30);
    _editButton.frame = CGRectMake(self.bounds.size.width - 85, 10, 60, 60);
//    CGRectMake(self.bounds.size.width - 85, self.bounds.size.height - 70, 55, 30);
    _indexLabel.frame = CGRectMake(0, 0, 80, 30);
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5,self.bounds.size.height - 30);
}

- (void)show {
    
    [self showAboveToWindow:NO];
}

- (void)showOnWindow {
    
    [self showAboveToWindow:YES];
}

- (void)showAboveToWindow:(BOOL)inWindow
{
    
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = HZPhotoBrowserBackgrounColor;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    _contentView.bounds = window.bounds;
    
    self.center = CGPointMake(_contentView.bounds.size.width * 0.5, _contentView.bounds.size.height * 0.5);
    self.bounds = CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height);
    
    [_contentView addSubview:self];
    
    window.windowLevel = UIWindowLevelStatusBar+10.0f;//隐藏状态栏
    
//    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:HZPhotoBrowserShowImageAnimationDuration + 0.2];
    if (inWindow) {
        [window addSubview:_contentView];
    } else {
        [HD_FULLView addSubview:_contentView];
    }
}
- (void)reloadPhotoWithIndex:(NSInteger)index {
    HZPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    [currentView.imageview sd_setImageWithURL:[self highQualityImageURLForIndex:self.currentImageIndex] placeholderImage:currentView.imageview.image];
    _markLabel.text = [NSString stringWithFormat:@"%@",[self markContentForIndex:self.currentImageIndex]];
}
- (void)deletePhotoWithIndex:(NSInteger)index {
    
    self.imageCount = self.imageCount - 1;
    
    for (HZPhotoBrowserView *view in _scrollView.subviews) {
        
        if ([view isKindOfClass:[HZPhotoBrowserView class]]) {
           [view removeFromSuperview];
        }
    }
    if (self.currentImageIndex == self.imageCount) {
        self.currentImageIndex = self.currentImageIndex - 1;
    }
    
    [self didMoveToSuperview];
}

//- (void)onDeviceOrientationChangeWithObserver
//{
//    [self onDeviceOrientationChange];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
//}

-(void)onDeviceOrientationChange
{
    if (!shouldLandscape) {
        return;
    }
    HZPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;

    if (UIDeviceOrientationIsLandscape(orientation)) {
//        NSLog(@"onDeviceOrientationChange");
        [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
            self.bounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:nil];
    }else if (orientation==UIDeviceOrientationPortrait){
        [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            self.bounds = screenBounds;
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:nil];
    }
}

- (void)showFirstImage
{
    UIView *sourceView;
    CGRect rect;
    //如果父视图是collectionView
    if (self.collectionCell) {
        UICollectionView *collectionView = (UICollectionView *)self.sourceImagesContainerView;
        //获取cell在当前collection的位置
        CGRect cellInCollection = [collectionView convertRect:self.collectionCell.frame toView:collectionView];
        //获取cell在当前屏幕的位置
        rect = [collectionView convertRect:cellInCollection toView:self];
        _showRect = rect;
    } else if (self.customRectFromWindow.size.width){
        
        rect = self.customRectFromWindow;
        _showRect = rect;
    } else {
        
        sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
        
        rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    }

    NSLog(@"%@",NSStringFromCGRect(rect));
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.frame = rect;
    tempView.image = [self placeholderImageForIndex:self.currentImageIndex];
    [self addSubview:tempView];
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    CGFloat placeImageSizeW = tempView.image.size.width;
    CGFloat placeImageSizeH = tempView.image.size.height;
    CGRect targetTemp;

    CGFloat placeHolderH = (placeImageSizeH * kAPPWidth)/placeImageSizeW;
    if (placeHolderH <= KAppHeight) {
        targetTemp = CGRectMake(0, (KAppHeight - placeHolderH) * 0.5 , kAPPWidth, placeHolderH);
    } else {//图片高度>屏幕高度
        targetTemp = CGRectMake(0, 0, kAPPWidth, placeHolderH);
    }
    
    //先隐藏scrollview
    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    _editButton.hidden = YES;
    _markLabel.hidden = YES;

    [UIView animateWithDuration:HZPhotoBrowserShowImageAnimationDuration animations:^{
        //将点击的临时imageview动画放大到和目标imageview一样大
        tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        //动画完成后，删除临时imageview，让目标imageview显示
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
        _indexLabel.hidden = NO;
        _saveButton.hidden = NO;
        _editButton.hidden = NO;
        _markLabel.hidden = NO;
    }];
}

- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}
- (NSString *)markContentForIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:markContentForIndex:)]) {
        return [NSString stringWithFormat:@"备注：%@",[self.delegate photoBrowser:self markContentForIndex:index]];
    }
    return @"";
}
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}



#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
//    int imageIndex = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.9) / _scrollView.bounds.size.width;
//    if (imageIndex >= self.imageCount - 1) {
//        imageIndex = (int)self.imageCount - 1;
//    }
//    if (imageIndex <= 0) {
//        imageIndex= 0;
//    }
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
//    NSLog(@"%i",imageIndex);
    long left = index - 1;
    long right = index + 1;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    
    for (long i = left; i < right; i++) {
         [self setupImageOfImageViewForIndex:i];
    }
    
//    [self setupImageOfImageViewForIndex:imageIndex];
}

//scrollview结束滚动调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (HZPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
                view.scrollview.zoomScale = 1.0;
        }
    }
    _markLabel.text = [self markContentForIndex:self.currentImageIndex];
}

#pragma mark - tap
#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    HZPhotoBrowserView *view = (HZPhotoBrowserView *)recognizer.view;
    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
    
    CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;//需要放大的图片的X点
    CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;//需要放大的图片的Y点
    [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES]; //还原
    }
    
}

#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    HZPhotoBrowserView *currentView = _scrollView.subviews[self.currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];//还原
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    _editButton.hidden = YES;
    _markLabel.hidden = YES;
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    CGRect screenBounds = [UIScreen mainScreen].bounds;
//    if (UIDeviceOrientationIsLandscape(orientation)) {
//        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)UIDeviceOrientationPortrait];
//            self.transform = CGAffineTransformIdentity;
//            self.bounds = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
//            [self setNeedsLayout];
//            [self layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            [self hidePhotoBrowser:recognizer];
//        }];
//    } else {
//        [self hidePhotoBrowser:recognizer];
//    }
    [self hidePhotoBrowser:recognizer];
}

- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    HZPhotoBrowserView *view = (HZPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;
    NSUInteger currentIndex = currentImageView.tag;
//#warning 此时获取的subview不一定存在。collection的visiblecells，不一定包含当前cell

    UIView *sourceView;
    CGRect targetTemp;
    if (self.collectionCell) {
        
        targetTemp = _showRect;
    } else if(self.customRectFromWindow.size.width){
        targetTemp = self.customRectFromWindow;
    } else {
        sourceView = self.sourceImagesContainerView.subviews[currentIndex];
        targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    }
    
//    NSLog(@"%@",NSStringFromCGRect(targetTemp));
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    CGFloat tempImageSizeH = tempImageView.image.size.height;
    CGFloat tempImageSizeW = tempImageView.image.size.width;
    CGFloat tempImageViewH = (tempImageSizeH * kAPPWidth)/tempImageSizeW;
    
    if (tempImageViewH < KAppHeight) {//图片高度<屏幕高度
        tempImageView.frame = CGRectMake(0, (KAppHeight - tempImageViewH)*0.5, kAPPWidth, tempImageViewH);
    } else {
        tempImageView.frame = CGRectMake(0, 0, kAPPWidth, tempImageViewH);
    }
    [self addSubview:tempImageView];
    
    _saveButton.hidden = YES;
    _editButton.hidden = YES;
    _indexLabel.hidden = YES;
    _scrollView.hidden = YES;
    _markLabel.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    [UIView animateWithDuration:HZPhotoBrowserHideImageAnimationDuration animations:^{
        tempImageView.frame = targetTemp;
        tempImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
        [tempImageView removeFromSuperview];
    }];
}

- (void)closePhotoBrowser
{
    _saveButton.hidden = YES;
    _editButton.hidden = YES;
    _indexLabel.hidden = YES;
    _scrollView.hidden = YES;
    _markLabel.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelNormal;//显示状态栏
    
    [UIView animateWithDuration:HZPhotoBrowserHideImageAnimationDuration animations:^{
        self.frame = _showRect;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
        [self removeFromSuperview];
    }];

}

@end
