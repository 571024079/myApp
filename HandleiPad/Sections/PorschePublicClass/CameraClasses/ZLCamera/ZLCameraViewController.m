//
//  BQCamera.m
//  CameraDemo
//
//  Created by GoodRobin on 16/9/19.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <objc/message.h>
#import "ZLCameraViewController.h"
#import "ZLCameraImageView.h"
#import "ZLCameraView.h"
#import "UIView+Layout.h"
//#import "LGCameraImageView.h"
#import "DrawViewController.h"
#import "ScanInfoView.h"
#import "ScanInfoTableView.h"
#import "PHTTPManager.h"

#import "ScanView.h"

#import "HZPhotoBrowser.h"

#import "UIImage+VideoImage.h"

#import "HDdeleteView.h"

#import <MediaPlayer/MediaPlayer.h>

#import <AVKit/AVKit.h>

#import "PorscheVideoPlayer.h"

#import "UIImageView+WebCache.h"

#define CellImageViewTag  100
typedef void(^codeBlock)();

// 相机类型
typedef NS_ENUM(NSInteger, CameraType) {
    photoCamera,   //拍照
    videoRecord,   //录制
};


CGFloat const CameraColletionViewWidth = 120;

CGFloat const ZLCameraColletionViewPadding = 20;
CGFloat const ControlViewAlpha = 0.5;
//static CGFloat BOTTOM_HEIGHT = 60;

#define TIMER_INTERVAL 0.1
#define BOTTOM_WIDTH   217.f/[UIScreen mainScreen].scale
#define VIDEO_FOLDER @"videoFolder"
#define PHOTO_INDENTIFIER @"cameraPhotocell"
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ZLCameraViewController ()
<UIActionSheetDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
AVCaptureMetadataOutputObjectsDelegate,
AVCaptureFileOutputRecordingDelegate,
ZLCameraImageViewDelegate,ZLCameraViewDelegate,
HZPhotoBrowserDelegate>

@property (weak,nonatomic) ZLCameraView *caramView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIViewController *currentViewController;

@property (strong, nonatomic) UIButton *cameraBtn;

@property (weak, nonatomic) NSTimer *countTimer; //计时器

// Datas
@property (strong, nonatomic) NSMutableDictionary *dictM;


// AVFoundation
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureStillImageOutput *captureImageOutput;
@property (strong, nonatomic) AVCaptureDevice *capturedevice;
@property (strong, nonatomic) AVCaptureDevice *audioCaptureDevice;
@property (strong, nonatomic) AVCaptureDeviceInput *audioCaptureDeviceInput;
@property (strong, nonatomic) AVCaptureDeviceInput *capturedeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;//视频输出流
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, assign) NSInteger flashCameraState;

@property (nonatomic, strong) UIButton *photoButton; //照片切换
@property (nonatomic, strong) UIButton *videoButton;  //录像切换

@property (nonatomic, assign) CameraType takeType;  //相机类型 照相-录像

@property (nonatomic, assign) ControllerUsageType usageType;  //相机用途类型

@property (nonatomic, strong) ScanView *scanView; //行驶证扫描view

@property (nonatomic, strong) UIView *controlView; // 侧面控制条View

@property (nonatomic, strong) ScanInfoView *scanInfoView;

@property (nonatomic, strong) UIVisualEffectView *effectView;

@end

@implementation ZLCameraViewController {
    
    float _currentTime; //当前视频长度
    
    float _totalTime; //录像总时间

    UILabel *_timeLabel; //录像时间label
    
    UIImage *_coverImage; // 封页
    
    //照相视频切换
    UIButton *_photoButton; //照相按钮
    UIButton *_videoButton;  //视频按钮
}

- (instancetype)initWithUsageType:(ControllerUsageType)type
{
    self = [super init];
    if (self) {
        _usageType = type;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _usageType = ControllerUsageTypeCamera;
    }
    return self;
}

#pragma mark - Getter & Setter

- (void)setImages:(NSMutableArray *)images {
    
    _images = [images mutableCopy];
}

- (NSMutableDictionary *)dictM{
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

#pragma mark - 磨玻璃View
- (UIVisualEffectView *)effectView {
    
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = self.view.bounds;
    }
    
    return _effectView;
}

#pragma mark - Preview 截图
- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.caramView.bounds.size, NO, 0);
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    });
    
    return image;
}

#pragma mark 懒加载相片CollectionView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(CameraColletionViewWidth, ScreenHeight/ScreenWidth *CameraColletionViewWidth);
        layout.minimumLineSpacing = ZLCameraColletionViewPadding;
        
        CGFloat collectionViewW = CameraColletionViewWidth;
        CGFloat collectionViewHGap = self.usageType == ControllerUsageTypeCamera ? CGRectGetHeight(self.videoImageView.frame) : 0;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.width - BOTTOM_WIDTH - collectionViewW - 10, 10, collectionViewW, self.view.height - collectionViewHGap - 30) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PHOTO_INDENTIFIER];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.view insertSubview:collectionView aboveSubview:self.controlView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

#pragma mark - 添加通知 & 移除通知
- (void)addNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}
- (void)removeNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

-(void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation =[[UIDevice currentDevice] orientation];
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGAffineTransform rotationTransform;
    
    BOOL hintHidden = YES;
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeRight: {
            hintHidden = YES;
            if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                
                rotationTransform = CGAffineTransformMakeRotation(0.0); // 180 degress
            } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                
                rotationTransform = CGAffineTransformMakeRotation(M_PI);
            }
            [self transButton:rotationTransform];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            hintHidden = YES;
            if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                
                rotationTransform = CGAffineTransformMakeRotation(0.0); // 0 degrees
            } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                
                rotationTransform = CGAffineTransformMakeRotation(M_PI);
            }
            
            [self transButton:rotationTransform];
        }
            break;
            
        case UIDeviceOrientationFaceUp:
            hintHidden = YES;
            
            break;
        default:
            hintHidden = NO;
            rotationTransform = CGAffineTransformMakeRotation(0.0);
            [self transButton:rotationTransform];
            break;
    }
    if (self.scanView.superview && self.scanView.hintLabel.hidden != hintHidden) {
        self.scanView.hintLabel.hidden = hintHidden;
    }
    self.preview.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
}

- (void)transButton:(CGAffineTransform)rotationTransform {
    
    for (UIView *thisView in self.controlView.subviews) {
        
        if ([thisView isKindOfClass:[UIButton class]]) {
            [UIView animateWithDuration:0.75
                                  delay:0.1
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:2.0
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 thisView.transform = rotationTransform;
                             }
                             completion:^(BOOL finished){
                             }];
        }
    }
}

#pragma mark - 初始化相机配置
- (void) initialize
{
    //判断摄像头是否授权
//    BOOL isCameraAuthor = NO;
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authorStatus == AVAuthorizationStatusRestricted || authorStatus == AVAuthorizationStatusDenied){
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray * allLanguages = [userDefaults objectForKey:@"AppleLanguages"];
        NSString * preferredLang = [allLanguages objectAtIndex:0];
        if (![preferredLang isEqualToString:@"zh-Hans"]) {
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"Please allow to access your device’s camera in “Settings”-“Privacy”-“Camera”" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alt show];
        }else{
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在 '设置-隐私-相机' 中打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alt show];
        }
//        isCameraAuthor = YES;
        return;
    }
    
    self.takeType = photoCamera;
    //1.创建会话层
    self.capturedevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.capturedeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.capturedevice error:nil];
    
    // Output
    self.captureImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureImageOutput setOutputSettings:outputSettings];
    
    // Session
    self.session = [[AVCaptureSession alloc]init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    if ([self.session canAddInput:self.capturedeviceInput])
    {
        [self.session addInput:self.capturedeviceInput];
    }
    
    if ([self.session canAddOutput:self.captureImageOutput])
    {
        [self.session addOutput:self.captureImageOutput];
    }
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = viewWidth / 480 * 640;;
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = self.view.bounds;
    self.preview.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    
    ZLCameraView *caramView = [[ZLCameraView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight)];
    caramView.backgroundColor = [UIColor clearColor];
    caramView.delegate = self;
    [self.view addSubview:caramView];
    [self.view.layer insertSublayer:self.preview atIndex:0];
    self.caramView = caramView;
    
    
    if (self.usageType == ControllerUsageTypeCamera) {
        //添加照相、录像切换手势
        UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeVideoOrPhoto:)];
        [swipeUpGesture setDirection:UISwipeGestureRecognizerDirectionUp];
        [self.caramView addGestureRecognizer:swipeUpGesture];
        
        UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeVideoOrPhoto:)];
        [swipeDownGesture setDirection:UISwipeGestureRecognizerDirectionDown];
        [self.caramView addGestureRecognizer:swipeDownGesture];
        
    }
}

#pragma mark - 切换录制和拍照
- (void)changeVideoOrPhoto:(UISwipeGestureRecognizer *)swipe {
    
    //    NSLog(@"%lu",(unsigned long)swipe.direction);

    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionUp:
        {
            if (self.takeType == videoRecord) {
                return;
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionDown:
            if (self.takeType == photoCamera) {
                return;
            }
            
            break;
        default:
            break;
    }
    
    self.takeType = self.takeType == photoCamera ? videoRecord : photoCamera;
    
    [self.photoButton setSelected:self.takeType == photoCamera];
    [self.videoButton setSelected:self.takeType == videoRecord];
    
    [self reSetupPhotoOrVideo];
}

#pragma mark - 改变相机录像按钮选择
- (void)changeVideoOrPhotoButton:(UIButton *)btn {
    
    if (btn == self.videoButton) {
        self.takeType = videoRecord;
    } else if (btn == self.photoButton) {
        
        self.takeType = photoCamera;
    }
    
    [self.photoButton setSelected:self.takeType == photoCamera];
    [self.videoButton setSelected:self.takeType == videoRecord];

    [self reSetupPhotoOrVideo];
    
}

#pragma mark - 相机切换配置需要重新配置相机
- (void)reSetupPhotoOrVideo {
    
    self.effectView.alpha = 0;
    [self.view insertSubview:self.effectView belowSubview:self.controlView];
    [UIView animateWithDuration:0.5 animations:^{
        self.effectView.alpha = 1.0;
    }];
    
    dispatch_group_t group =  dispatch_group_create();
    //使用组队列异步函数,分别有组队列,和队列的参数.
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // 执行1个耗时的异步操作
        switch (self.takeType) {
            case videoRecord:
                [self setupVideoSession];
                break;
            case photoCamera:
                [self setupPhotoSession];
                break;
            default:
                break;
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
        [UIView animateWithDuration:0.35 animations:^{
            self.effectView.alpha = 0;
        } completion:^(BOOL finished) {

            [self.effectView removeFromSuperview];
        }];
    });
    
}

#pragma mark - 懒加载相机配置
- (AVCaptureDevice *)audioCaptureDevice {
    
    if (!_audioCaptureDevice) {
        _audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    }
    return _audioCaptureDevice;
}

- (AVCaptureDeviceInput *)audioCaptureDeviceInput {
    if (!_audioCaptureDeviceInput) {
        _audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:self.audioCaptureDevice error:nil];
    }
    return _audioCaptureDeviceInput;
}

- (AVCaptureMovieFileOutput *)captureMovieFileOutput {
    
    if (!_captureMovieFileOutput) {
        _captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc]init];
    }
    
    return _captureMovieFileOutput;
}

#pragma mark - 初始化相机Session
- (void)setupVideoSession {
    
    [self.session stopRunning];
    [[self.preview connection] setEnabled:NO];
    NSLog(@"配置录像");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cameraBtn setImage:[UIImage imageNamed:@"Camera_video_normal"] forState:UIControlStateNormal];
        _timeLabel.hidden = NO;
    });
    
    if (_countTimer) {
        [_countTimer invalidate];
        _countTimer = nil;
    }
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        self.session.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    
    //添加一个音频输入设备
    //    if (!_audioCaptureDevice) {
    //        _audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    //    }
    //    _audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:self.audioCaptureDevice error:nil];
    if ([self.session canAddInput:self.audioCaptureDeviceInput]) {
        [self.session addInput:self.audioCaptureDeviceInput];
    }
    
    //初始化设备输出对象，用于获得输出数据
    //    self.captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init]; //已经懒加载
    
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([captureConnection isVideoStabilizationSupported ]) {
        captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
    }
    //将设备输出添加到会话中
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        
        [self.session addOutput:self.captureMovieFileOutput];
    }
    //移除照片输出
    if (self.captureImageOutput) {
        [self.session removeOutput:self.captureImageOutput];
    }
    
    //提交会话配置
    [self.session commitConfiguration];
     [[self.preview connection] setEnabled:YES];
    
    [self.session startRunning];
}

- (void)setupPhotoSession {
    NSLog(@"配置照相机");
    [self.session stopRunning];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cameraBtn setImage:[UIImage imageNamed:@"Cramera_photoAction"] forState:UIControlStateNormal];
        _timeLabel.hidden = YES;
    });
    
    if (_countTimer) {
        [_countTimer invalidate];
        _countTimer = nil;
    }
    
    // Output
    if (!self.captureImageOutput) {
        
        self.captureImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        [self.captureImageOutput setOutputSettings:outputSettings];
    }
    
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    
    if ([self.session canAddOutput:self.captureImageOutput])
    {
        [self.session addOutput:self.captureImageOutput];
    }
    
    if (self.captureMovieFileOutput) {
        [self.session removeOutput:self.captureMovieFileOutput];
    }
    //提交会话配置
    [self.session commitConfiguration];
    
    [self.session startRunning];
}


- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
        default:
            break;
    }
    return 0;
}

- (void)cameraDidSelected:(ZLCameraView *)camera{
    [self.capturedevice lockForConfiguration:nil];
    [self.capturedevice setFocusMode:AVCaptureFocusModeAutoFocus];
    [self.capturedevice setFocusPointOfInterest:camera.point];
    //操作完成后，记得进行unlock。
    [self.capturedevice unlockForConfiguration];
}

//对焦回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if( [keyPath isEqualToString:@"adjustingFocus"] ){
        NSLog(@"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (!self.images) {
        self.images = [[NSMutableArray alloc] init];
    }

    [self canUserCamear];
    [self initialize];
    [self setup];
    
    [self createVideoFolderIfNotExist];
    
    [self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPhotos:) name:RELOAD_PHOTOBROWSER_NOTIFICATION object:nil];
    
}

- (void)reloadPhotos:(NSNotification *)noti
{
    self.images = [noti.userInfo objectForKey:@"images"];
    self.videoModel= [noti.userInfo objectForKey:@"videoModel"];
    
    self.videoImageView.hidden = !self.videoModel.videoUrl;
    self.videoImageView.image = [ZLCamera thumbnailImageForVideo:self.videoModel.videoUrl atTime:1];
    //    [self.videoImageView sd_setImageWithURL:self.videoModel.videoUrl];//self.videoModel.thumbImage;
    self.videoImageView.userInteractionEnabled = YES;

    [_collectionView reloadData];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.session startRunning];
    
    [self addNotificationCenter];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_scanInfoView.lineTimer) {
        [_scanInfoView.lineTimer invalidate];
        _scanInfoView.lineTimer = nil;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.session stopRunning];
    
    [self removeNotificationCenter];
}

#pragma mark -初始化界面
- (void) setup {
    
    switch (self.usageType) {
        case ControllerUsageTypeScan:
        case ControllerUsageTypeNOMask:
             [self setupScan];
            break;
        case ControllerUsageTypeCamera:
        case ControllerUsageTypeOnlyPhoto:
            [self setupCamare];
            break;

        default:
            break;
    }
}

- (void)setupScan {

    self.scanView.center = CGPointMake(self.view.size.width / 2, self.view.size.height / 2);

    __weak typeof(self)weakSelf = self;
    self.scanView.scanBolck = ^ (BOOL scan){
        
        if (scan) {
            [weakSelf takeScanCard];
        } else {
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    [self.view addSubview:self.scanView];
}

- (ScanView *)scanView {
    
    if (!_scanView) {
        
        CGRect screenRect = self.view.bounds;
        
        if (self.usageType == ControllerUsageTypeNOMask) {
            _scanView = [[ScanView alloc] initWithFrame:screenRect isMask:NO];
        }
        else
        {
            _scanView = [[ScanView alloc] initWithFrame:screenRect isMask:YES];
        }
        
        _scanView.transparentArea = CGSizeMake(600, 400);
        
        _scanView.backgroundColor = [UIColor clearColor];
        
        
    }
    return _scanView;
}

#pragma mark - UI初始化
- (void) setupCamare{
    CGFloat width = 80;
    CGFloat margin = 20;
    
    // 底部View
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - BOTTOM_WIDTH, 0, BOTTOM_WIDTH, self.view.height)];
    //    controlView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.controlView = controlView;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = controlView.bounds;
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = ControlViewAlpha;
    [controlView addSubview:contentView];
    
    //取消
    UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(0, self.view.height - margin - width, width, width);
    cancalBtn.center = CGPointMake(controlView.width/2, self.view.height - margin - width/2);
    //    [cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancalBtn setImage:[UIImage imageNamed:@"Camera_close.png"] forState:UIControlStateNormal];
    [cancalBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [cancalBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:cancalBtn];
    
    
    if (self.usageType == ControllerUsageTypeCamera) {
        
        //视频/照片切换按钮
        self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.videoButton setTitle:@"视频" forState:UIControlStateNormal];
        [self.videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.videoButton setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        self.videoButton.frame = CGRectMake(0, 0, width, width/2);
        self.videoButton.center = CGPointMake(cancalBtn.center.x,CGRectGetMinY(cancalBtn.frame) - 64);
        
        [self.videoButton addTarget:self action:@selector(changeVideoOrPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        [controlView addSubview:self.videoButton];
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.photoButton setTitle:@"照片" forState:UIControlStateNormal];
        [self.photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.photoButton setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        self.photoButton.frame = CGRectMake(0, 0, width, width/2);
        self.photoButton.center = CGPointMake(self.videoButton.center.x, CGRectGetMinY(self.videoButton.frame) - _photoButton.bounds.size.height);
        [self.photoButton addTarget:self action:@selector(changeVideoOrPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        [controlView addSubview:self.photoButton];
        
        [self.photoButton setSelected:YES];
        
        //控制条添加切换手势
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeVideoOrPhoto:)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeVideoOrPhoto:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        
        [controlView addGestureRecognizer:swipeUp];
        [controlView addGestureRecognizer:swipeDown];
    }

    //切换镜头
    UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deviceBtn.frame = CGRectMake(0, margin, width, width);
    deviceBtn.center = CGPointMake(controlView.width/2, margin + width/2.0);
    [deviceBtn setImage:[UIImage imageNamed:@"Camera_deviceChange"] forState:UIControlStateNormal];
    [deviceBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [deviceBtn addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:deviceBtn];
    
    [self.view addSubview:controlView];
    //拍照
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *cameraBtnImage = [UIImage imageNamed:@"Cramera_photoAction"];
    _cameraBtn.frame = CGRectMake(0, 0, width, width);
    _cameraBtn.center = CGPointMake(ScreenWidth - controlView.width/2, controlView.height/2);
    //    CGPointMake(controlView.width/2, controlView.height/2);
    _cameraBtn.showsTouchWhenHighlighted = YES;
    _cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_cameraBtn setImage:cameraBtnImage forState:UIControlStateNormal];
    [_cameraBtn addTarget:self action:@selector(stillImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];
    
    _timeLabel = [[UILabel alloc] initWithFrame:_cameraBtn.bounds];
    _timeLabel.center = CGPointMake(_cameraBtn.center.x, _cameraBtn.center.y - _cameraBtn.height*2 +20);
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:18];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.text = @"00:00:00";
    _timeLabel.hidden = YES;
    [self.view addSubview:_timeLabel];
    
    self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - BOTTOM_WIDTH - 120 - 10, self.view.height - 100, CameraColletionViewWidth,  ScreenHeight/ScreenWidth *CameraColletionViewWidth)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
    [self.videoImageView addGestureRecognizer:tap];
    self.videoImageView.hidden = !self.videoModel.videoUrl;
    self.videoImageView.image = [ZLCamera thumbnailImageForVideo:self.videoModel.videoUrl atTime:1];
//    [self.videoImageView sd_setImageWithURL:self.videoModel.videoUrl];//self.videoModel.thumbImage;
    self.videoImageView.userInteractionEnabled = YES;
    UIImageView *playbtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _videoImageView.bounds.size.width/2, _videoImageView.bounds.size.height/2)];
    playbtn.center = CGPointMake(_videoImageView.width/2, _videoImageView.height/2);
    playbtn.image = [UIImage imageNamed:@"billing_right_play_bt_pic.png"];
    playbtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.videoImageView addSubview:playbtn];
    
    _videoImageView.layer.borderWidth = 2.0;
    _videoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _videoImageView.layer.cornerRadius = 4;
    _videoImageView.clipsToBounds = YES;
    [self.view addSubview:_videoImageView];

}
- (void)addPhoto:(ZLCamera *)camera
{
    [self.images addObject:camera];
    [self reloadData];
}
#pragma mark - collectionView代理
- (NSInteger ) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger ) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PHOTO_INDENTIFIER forIndexPath:indexPath];
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    
    ZLCamera *camera = self.images[indexPath.item];
    
    ZLCameraImageView *lastView = [cell.contentView.subviews lastObject];
    if(![lastView isKindOfClass:[ZLCameraImageView class]]){
        // 解决重用问题
        ZLCameraImageView *imageView = [[ZLCameraImageView alloc] init];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.delegatge = self;
        imageView.edit = NO;
        imageView.tag = CellImageViewTag;
        imageView.frame = cell.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:imageView];
    }
    
    // 获取imageView
    ZLCameraImageView *imageView = (ZLCameraImageView *)[cell.contentView viewWithTag:CellImageViewTag];
    if ([camera.editImageUrl.absoluteString  length]) {
        [imageView sd_setImageWithURL:camera.editImageUrl placeholderImage:[UIImage imageNamed:PlaceHolderSmallImageName]];
    } else {
        imageView.image = camera.thumbImage;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZLCamera *camera = [self.images objectAtIndex:indexPath.row];
    if ([camera.videoUrl absoluteString].length) {
        
        [self avPlayer:camera.videoUrl videoId:camera.cameraID];
        return ;
    }

    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.collectionView;
    browser.collectionCell = cell;
    browser.imageCount = self.images.count;
    browser.currentImageIndex = (int)indexPath.row;
    browser.delegate = self;
    [browser showOnWindow];
}
#pragma mark - 图片浏览器代理
//浏览器对应index的图片
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    return [UIImage imageNamed:PlaceHolderImageNormalName];

//    if (self.images.count <= index) {
//      
//        return nil;
//    }
//    ZLCamera *camera = [self.images objectAtIndex:index];
//    return camera.editImage;
}
//浏览器对应index的信息
- (NSString *)photoBrowser:(HZPhotoBrowser *)browser markContentForIndex:(NSInteger)index {
    
    if (self.images.count <= index) {
     
        return @"";
    }
    
    ZLCamera *camera = [self.images objectAtIndex:index];
    
    return camera.markString;
}

//
- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (self.images && self.images.count > index) {
        ZLCamera *camera = [self.images objectAtIndex:index];
        return camera.editImageUrl;
    }
    return nil;
}
//浏览器对应index的图片开始编辑
- (void)photoBrowser:(HZPhotoBrowser *)browser EditImageForIndex:(NSInteger)index {
    
    [self reDrawImageControllerWithIndex:index photoBrowser:browser];
    
}

#pragma mark - 录像代理

- (void)deleteImageView:(ZLCameraImageView *)imageView{
    NSMutableArray *arrM = [self.images mutableCopy];
    for (ZLCamera *camera in self.images) {
        UIImage *image = camera.thumbImage;
        if ([image isEqual:imageView.image]) {
            [arrM removeObject:camera];
        }
    }
    self.images = arrM;
    [self.collectionView reloadData];
}

- (void)showPickerVc:(UIViewController *)vc{
    __weak typeof(vc)weakVc = vc;
    if (weakVc != nil) {
        [weakVc presentViewController:self animated:YES completion:nil];
    }
}

-(void)Captureimage
{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    __weak typeof(self)weakself = self;
    [self.captureImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         
         // Continue as appropriate.
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [UIImage imageWithData:imageData];
         t_image = [weakself cutImage:t_image];
         t_image = [weakself fixOrientation:t_image];
         //         NSData *data = UIImageJPEGRepresentation(t_image, 0.5);
         ZLCamera *camera = [[ZLCamera alloc] init];
         camera.photoImage = t_image;
         //         camera.thumbImage = [UIImage imageWithData:data];
         
         switch (weakself.usageType) {
             case ControllerUsageTypeScan:
             case ControllerUsageTypeNOMask:
                 
             {
                 camera.photoImage = [weakself cutCarImage:camera.photoImage];
                 NSData *data = UIImageJPEGRepresentation(camera.photoImage, 0.6);
                 UIImage *scanImage = [UIImage imageWithData:data];
                 [weakself goScanInfoTableView:scanImage];
             }
                 break;
                 
             case ControllerUsageTypeCamera:
             case ControllerUsageTypeOnlyPhoto:
                 [weakself drawImageController:camera];
                 break;
                 
             default:
                 break;
         }
         
//         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//             
//             UIImageWriteToSavedPhotosAlbum(camera.photoImage, self, nil, nil);
//         });
//         [weakself uploadImage:camera IsEdit:NO];


         [weakself delegeteNewOriginal:camera];
     }];
}

//剪裁行驶证
- (UIImage *)cutCarImage:(UIImage *)image {
    
    //修正扫描区域
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat scale = image.size.width/screenWidth;
    CGRect cropRect = CGRectMake(_scanView.scanRect.origin.x  * scale,
                                 _scanView.scanRect.origin.y  * scale,
                                 self.scanView.transparentArea.width * scale,
                                 self.scanView.transparentArea.height * scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

//裁剪image
- (UIImage *)cutImage:(UIImage *)srcImg {
    //注意：这个rect是指横屏时的rect，即屏幕对着自己，home建在右边
    CGRect rect = CGRectMake(0, 0, srcImg.size.width*self.view.width/self.view.height, srcImg.size.height);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(srcImg.CGImage, rect);
    CGFloat subWidth = CGImageGetWidth(subImageRef);
    CGFloat subHeight = CGImageGetHeight(subImageRef);
    CGRect smallBounds = CGRectMake(0, 0, subWidth, subHeight);
    //旋转后，画出来
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, subWidth);
    transform = CGAffineTransformRotate(transform, -M_PI_2);
    CGContextRef ctx = CGBitmapContextCreate(NULL, subHeight, subWidth,
                                             CGImageGetBitsPerComponent(subImageRef), 0,
                                             CGImageGetColorSpace(subImageRef),
                                             CGImageGetBitmapInfo(subImageRef));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, smallBounds, subImageRef);
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}

//旋转image
- (UIImage *)fixOrientation:(UIImage *)srcImg
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGFloat width = srcImg.size.width;
    CGFloat height = srcImg.size.height;
    
    //获取摄像头 后置frontF为1.0
    BOOL frontF = NO ;
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            
            frontF = device.position == AVCaptureDevicePositionBack ? YES : NO;
            break;
        }
    }
    
    CGContextRef ctx;
    
    switch ([[UIDevice currentDevice] orientation]) {
            
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
                if (!frontF) {
                    transform = CGAffineTransformTranslate(transform, height, 0);
                    transform = CGAffineTransformRotate(transform, M_PI_2);
                } else {
                    
                    transform = CGAffineTransformTranslate(transform, 0, width);
                    transform = CGAffineTransformRotate(transform, -M_PI_2);
                }
                ctx = CGBitmapContextCreate(NULL, height, width,
                                            CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                            CGImageGetColorSpace(srcImg.CGImage),
                                            CGImageGetBitmapInfo(srcImg.CGImage));
            } else if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                
                if (frontF) {
                    transform = CGAffineTransformTranslate(transform, height, 0);
                    transform = CGAffineTransformRotate(transform, M_PI_2);
                } else {
                    
                    transform = CGAffineTransformTranslate(transform, 0, width);
                    transform = CGAffineTransformRotate(transform, -M_PI_2);
                }
                ctx = CGBitmapContextCreate(NULL, height, width,
                                            CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                            CGImageGetColorSpace(srcImg.CGImage),
                                            CGImageGetBitmapInfo(srcImg.CGImage));
            }
            break;
            
        case UIDeviceOrientationPortrait: //竖屏，不旋转
            ctx = CGBitmapContextCreate(NULL, width, height,
                                        CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                        CGImageGetColorSpace(srcImg.CGImage),
                                        CGImageGetBitmapInfo(srcImg.CGImage));
            break;
        case UIDeviceOrientationPortraitUpsideDown: //竖屏，旋转180
            transform = CGAffineTransformTranslate(transform, width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            ctx = CGBitmapContextCreate(NULL, width, height,
                                        CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                        CGImageGetColorSpace(srcImg.CGImage),
                                        CGImageGetBitmapInfo(srcImg.CGImage));
            break;
            
            
        case UIDeviceOrientationLandscapeLeft:  //横屏，home键在右手边，逆时针旋转90°
            
            if (frontF) {
                transform = CGAffineTransformTranslate(transform, height, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
            } else {
                
                transform = CGAffineTransformTranslate(transform, 0, width);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
            }
            ctx = CGBitmapContextCreate(NULL, height, width,
                                        CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                        CGImageGetColorSpace(srcImg.CGImage),
                                        CGImageGetBitmapInfo(srcImg.CGImage));
            
            break;
            
            
        case UIDeviceOrientationLandscapeRight:  //横屏，home键在左手边，顺时针旋转90°
            if (!frontF) {
                transform = CGAffineTransformTranslate(transform, height, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
            } else {
                
                transform = CGAffineTransformTranslate(transform, 0, width);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
            }
            ctx = CGBitmapContextCreate(NULL, height, width,
                                        CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                        CGImageGetColorSpace(srcImg.CGImage),
                                        CGImageGetBitmapInfo(srcImg.CGImage));
            break;
            
        default:
            break;
    }
    
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, CGRectMake(0,0,width,height), srcImg.CGImage);
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

#pragma mark - 涂鸦页面
- (void)drawImageController:(ZLCamera *)camera {

    DrawViewController *drawVC = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
    drawVC.image = camera.photoImage;
    drawVC.pathArray = camera.pathArray;
    drawVC.fromType = DrawViewControllerFromCamera;
    
    __weak typeof(self)weakself = self;
    drawVC.doneBlock = ^(UIImage *image,NSString *markStr,BOOL isCovers ,NSMutableArray *pathArray) {
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        camera.editImage = image;
        camera.markString = markStr;
        camera.thumbImage = [UIImage imageWithData:data];
        camera.isCovers = isCovers;
        camera.pathArray = pathArray;
        
//        if (weakself.cameraType == ZLCameraSingle) {
//            [weakself.images removeAllObjects];//由于当前只需要一张图片
////            [weakself.images addObject:camera];
//            [weakself.images insertObject:camera atIndex:0];
//            //[self displayImage:camera.photoImage];
//        } else if (weakself.cameraType == ZLCameraContinuous) {
//            
////            [weakself.images addObject:camera];
//            [weakself.images insertObject:camera atIndex:0];
//            [weakself.collectionView reloadData];
//            [weakself.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:weakself.images.count - 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
//        }
//        [weakself uploadImage:camera IsEdit:YES];
        //
        
        [weakself delegeteNewEdit:camera];
    };
    [self presentViewController:drawVC animated:NO completion:nil];
}

- (void)reDrawImageControllerWithIndex:(NSInteger)index photoBrowser:(HZPhotoBrowser *)photoBrowser{
    
    ZLCamera *camera = [self.images objectAtIndex:index];
    DrawViewController *drawVC = [[DrawViewController alloc] initWithNibName:@"DrawViewController" bundle:nil];
    drawVC.image = camera.photoImage;
    drawVC.imageUrl = camera.photoImageUrl;
    drawVC.pathArray = camera.pathArray;
    drawVC.markString = camera.markString;
    __weak typeof(self)weakself = self;
    drawVC.doneBlock = ^(UIImage *image, NSString *markStr,BOOL isCovers,NSMutableArray *pathArray) {
        
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        camera.editImage = image;
        camera.markString = markStr;
        camera.thumbImage = [UIImage imageWithData:data];
        camera.isCovers = isCovers;
        camera.pathArray = pathArray;
        _coverImage = camera.thumbImage;
        
        if (weakself.cameraType == ZLCameraSingle) {
            [weakself.images removeAllObjects];//由于当前只需要一张图片2015-11-6
            [weakself.images addObject:camera];
            //[self displayImage:camera.photoImage];
        } else if (weakself.cameraType == ZLCameraContinuous) {
            
            [weakself.images replaceObjectAtIndex:index withObject:camera];
            [weakself.collectionView reloadData];
//            [photoBrowser reloadPhotoWithIndex:index];
            [photoBrowser closePhotoBrowser];
        }
//        [weakself uploadImage:camera IsEdit:YES];
        [weakself delegeteNewEdit:camera];
    };
    drawVC.deleteBlock = ^() {
        ZLCamera *deleteImage = [weakself.images objectAtIndex:index];
        [weakself.images removeObjectAtIndex:index];
        if (weakself.images.count ==0) {
            
            [photoBrowser closePhotoBrowser];
        } else {
             [photoBrowser deletePhotoWithIndex:index];
        }
        [weakself.collectionView reloadData];
        //删除代理回调
        [weakself delegeteDeleteImage:deleteImage];
    };
    [self presentViewController:drawVC animated:NO completion:nil];
}


- (void)goScanInfoTableView:(UIImage *)image {

    if (!_scanInfoView) {
        _scanInfoView = [[ScanInfoView alloc] initWithFrame:self.view.bounds];
    }
    self.scanView.hidden = YES;
    _scanInfoView.picImage.image = image;
    
    __weak typeof(self)weakSelf = self;
    
    if (self.usageType == ControllerUsageTypeNOMask)
    {
        _scanInfoView.viewType = ScanInfoViewTypeVIN;
    }
    else
    {
        _scanInfoView.viewType = ScanInfoViewTypeNormal;
    }
    
    self.scanInfoView.scanfinishBlock = ^(ScanInfoModel *model) {
        
        if (model) {
            if (weakSelf.scanBlock) {
                model.image = image;
                weakSelf.scanBlock(model);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else {
            
            [weakSelf.scanInfoView removeFromSuperview];
            [weakSelf.scanInfoView.lineTimer invalidate];
            weakSelf.scanInfoView.lineTimer = nil;
            weakSelf.scanInfoView = nil;
            weakSelf.scanView.hidden = NO;
        }
  
    };
    
    [self.view addSubview:self.scanInfoView];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    
//                          UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
//                      });
    [PHTTPManager recognizeDrivingLicenseWithImage:image uploadToBaseUrl:nil response:^(NSURLResponse *response, id responser, NSError *error) {
        
        NSLog(@"responser -- %@",responser);
        
        NSDictionary *info;
        int tureInfo = [[responser valueForKey:@"rtn"] intValue];
        if (tureInfo == 0 && !error) {
            NSDictionary *value = [responser valueForKey:@"value"];
            NSString *vin = [value valueForKey:@"vin"];
            if (vin.length > 5) {
                info = [responser valueForKey:@"value"];
                NSLog(@"有数据");
            }
        }
        [weakSelf.scanInfoView showInfo:info];
    }];
}

-(void)CaptureStillImage
{
    [self  Captureimage];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}

#pragma mark - 前后镜头切换
- (void)changeCameraDevice:(id)sender
{
    // 翻转
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];
    
    NSArray *inputs = self.session.inputs;
    for ( AVCaptureDeviceInput *input in inputs ) {
        AVCaptureDevice *device = input.device;
        if ( [device hasMediaType:AVMediaTypeVideo] ) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;
            
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            [self.session beginConfiguration];
            
            [self.session removeInput:input];
            [self.session addInput:newInput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.session commitConfiguration];
            break;
        }
    }
}

#pragma 外部删除方法
- (void)deleteDataSourceVideo:(BOOL)isVideo orImage:(NSInteger)index {
    
    if (isVideo) {
        self.videoImageView.hidden = YES;
        [self deleteAllVideos];
    } else {
        if (index > self.images.count - 1) return;
        [self.images removeObjectAtIndex:index];
        [self.collectionView reloadData];
    }
}

#pragma mark - timer
-(void)startTimer{
    
    _totalTime = 60;
    
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [_countTimer fire];
    
//    _timeLabel.hidden = NO;
}

-(void)stopTimer{
    _cameraBtn.backgroundColor = [UIColor clearColor];
    
    [_countTimer invalidate];
    _countTimer = nil;
    
//    _timeLabel.hidden = YES;
    
}
- (void)onTimer:(NSTimer *)timer
{
    _currentTime += TIMER_INTERVAL;
    
    NSLog(@"%f",_currentTime);
    
    _timeLabel.text = [self timeFormatted:_currentTime];
//    [NSString stringWithFormat:@"%.f",_currentTime];
    
    //时间到了停止录制视频
    
    if (_currentTime>=_totalTime) {
        [_countTimer invalidate];
        _countTimer = nil;
        [_captureMovieFileOutput stopRecording];
    }
    
}
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
-(void)finishBtTap{
    
    if (_countTimer) {
        [_countTimer invalidate];
        _countTimer = nil;
    }
    
    //正在拍摄
    if (_captureMovieFileOutput.isRecording) {
        [_captureMovieFileOutput stopRecording];
    }else{//已经暂停了

    }
    if ([self.delegete respondsToSelector:@selector(cameraViewController:FinishedDidCamera:)])
    {
        [self.delegete cameraViewController:self FinishedDidCamera:nil];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 视频录制
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
    [self.cameraBtn setImage:[UIImage imageNamed:@"Camera_video_selected"] forState:UIControlStateNormal];
    [self startTimer];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.controlView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.controlView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.cameraBtn setImage:[UIImage imageNamed:@"Camera_video_normal"] forState:UIControlStateNormal];
    NSLog(@"录制完成。。。%@",outputFileURL);
    _currentTime = 0;
    _timeLabel.text = @"00:00:00";
//    [_urlArray addObject:outputFileURL];
    
    UIImage *videoImage = [UIImage thumbnailImageForVideo:outputFileURL atTime:2.0];
    NSData *data = UIImageJPEGRepresentation(videoImage, 0.5);
    UIImage *thumImage = [UIImage addImage:[UIImage imageWithData:data] toImage:[UIImage imageNamed:@"billing_right_play_bt_pic.png"]];
    
    self.videoModel = [ZLCamera new];
    self.videoModel.photoImage = videoImage;
    self.videoModel.thumbImage = thumImage;
    self.videoModel.videoUrl = outputFileURL;

    self.videoImageView.hidden = NO;
    self.videoImageView.image = thumImage;
    //时间到了
    [self avPlayer:self.videoModel.videoUrl videoId:nil];
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(cameraViewController:createDidNewVideo:)]) {
        [self.delegete cameraViewController:self createDidNewVideo:self.videoModel];
    }
}

- (void)playVideo {
    
    [self avPlayer:self.videoModel.videoUrl videoId:self.videoModel.cameraID];
}

- (void)avPlayer:(NSURL *)url videoId:(NSNumber *)videoId{
    
    PorscheVideoPlayer *player = [[PorscheVideoPlayer alloc] initWithURL:url videoId:videoId];
    
    __weak typeof(self)weakself = self;
    player.deleteBlock = ^(NSNumber *videoId) {
        weakself.videoImageView.hidden = YES;
        [weakself deleteAllVideos];
    };
    
    [self presentViewController:player animated:YES completion:nil];
}

//最后合成为 mp4
- (NSString *)getVideoMergeFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"merge.mp4"];
    
    return fileName;
}

//录制保存的时候要保存为 mov
- (NSString *)getVideoSaveFilePathString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mov"];
    
    return fileName;
}

- (void)createVideoFolderIfNotExist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建保存视频文件夹失败");
        }
    }
}

#pragma mark - 删除视频文件
- (void)deleteAllVideos
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[self.videoModel.videoUrl absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            NSError *error = nil;
            [fileManager removeItemAtPath:filePath error:&error];
            
            if (error) {
                NSLog(@"delete All Video 删除视频文件出错:%@", error);
            } else {
                
                NSLog(@"删除视频文件成功:%@",filePath);
            }
        }
    });

    self.videoModel = nil;
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(cameraViewController:deleteDidCamera:)]) {
        [self.delegete cameraViewController:self deleteDidCamera:self.videoModel];
    }
}

- (void)shootButtonClick{
    
    [self deleteAllVideos];

    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //根据连接取得设备输出的数据
    if (![self.captureMovieFileOutput isRecording]) {
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.preview connection].videoOrientation;
        [self.captureMovieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:[self getVideoMergeFilePathString]] recordingDelegate:self];
    }
    else{
        [self stopTimer];
        [self.captureMovieFileOutput stopRecording];//停止录制
    }
}

#pragma mark - 拍照
//拍照
- (void)stillImage:(id)sender
{
    
    if (self.takeType == videoRecord) {
        [self shootButtonClick];
        return;
    }
    // 判断图片的限制个数
    if (self.maxCount > 0 && self.images.count >= self.maxCount) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"拍照的个数不能超过%ld",(long)self.maxCount]delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    [self Captureimage];
    
    [self takePhotoflash];
}

- (void)takeScanCard {
    
    [self Captureimage];
    
    [self takePhotoflash];
    
}

#pragma mark - 拍照一闪动画
- (void)takePhotoflash {
    
    UIView *maskView = [[UIView alloc] init];
    maskView.frame = self.view.bounds;
    maskView.backgroundColor = [UIColor whiteColor];
    maskView.alpha = 0.7;
    [self.view addSubview:maskView];
    [UIView animateWithDuration:.5 animations:^{
        maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
    }];
}

#pragma mark - 是否允许自动旋转
//- (BOOL)shouldAutorotate{
//
//    return NO;
//}

#pragma mark - 屏幕方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//}
// 支持屏幕旋转
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    return NO;
//}
//// 画面一开始加载时就是竖向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeRight;
//}

//完成、取消
- (void)doneAction
{
    //关闭照相界面
    if(self.callback && self.images>0){

        self.callback(self.images,self.videoModel,_coverImage);
    }
    
    [self finishBtTap];
}

- (void)uploadImage:(ZLCamera *)camera IsEdit:(BOOL)editImage {
    
    WeakObject(camera);
    [PorscheRequestManager uploadCameraImages:@[camera] editImage:editImage video:[NSURL URLWithString:@""] parameModel:nil completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (error) return ;
        
        NSDictionary *objc = [responser objectForKey:@"object"];
        PorscheResponserPictureVideoModel *responModel = [PorscheResponserPictureVideoModel yy_modelWithDictionary:objc];
        if (!editImage) {
            cameraWeak.cameraID = responModel.aiid;
            NSLog(@"获取到原图id -- %ld",responModel.aiid.integerValue);
        }
        NSLog(@"上传照片成功 -- %@",responser);
    }];
}

- (void)cancelCamera {
    
    if (_countTimer) {
        [_countTimer invalidate];
        _countTimer = nil;
    }
    

    [self dismissViewControllerAnimated:YES completion:^{
        [self.session stopRunning];
        [self.preview removeFromSuperlayer];
        self.preview = nil;
        self.session = nil;
    }];
}

#pragma mark - 代理方法集合
- (void)delegeteNewOriginal:(ZLCamera *)camera {
    if (self.delegete && [self.delegete respondsToSelector:@selector(cameraViewController:createDidNewOriginalPhoto:)]) {
        [self.delegete cameraViewController:self createDidNewOriginalPhoto:camera];
    }
}

- (void)delegeteNewEdit:(ZLCamera *)camera {
    if (self.delegete && [self.delegete respondsToSelector:@selector(cameraViewController:createDidNewEditPhoto:)]) {
        [self.delegete cameraViewController:self createDidNewEditPhoto:camera];
    }
}

- (void)delegeteDeleteImage:(ZLCamera *)camera {
    if (self.delegete && [self.delegete respondsToSelector:@selector(cameraViewController:deleteDidCamera:)]) {
        [self.delegete cameraViewController:self deleteDidCamera:camera];
    }
}

#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

- (void)dealloc {
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"~~~~~~~~~~~~~~~相机页面被释放啦~~~~~~~~~~~~~~~~");
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

@end

