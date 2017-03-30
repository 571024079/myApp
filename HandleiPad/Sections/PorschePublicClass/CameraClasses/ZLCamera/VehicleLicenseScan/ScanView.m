//
//  ScanView.m
//  CrameraDemo
//
//  Created by GoodRobin on 16/9/19.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import "ScanView.h"

static NSTimeInterval kQrLineanimateDuration = 0.02;

#define CONTROLBAR_WIDTH   217.f/[UIScreen mainScreen].scale
@implementation ScanView {
    
    UIImageView *_qrLine;
    UIButton *_scanButton;
    CGFloat _qrLineY;
    
//    CGRect _clearDrawRect;
    
    UIImageView *_shadowView;
    
    UIView *_scanNavigationBar;
    
    UILabel *_navigationTitleLabel;
    
    UIView *_scanControlBar;
}

- (instancetype)initWithFrame:(CGRect)frame isMask:(BOOL)isMask {
    
    self = [super initWithFrame:frame];
    if (self) {
        _isMask = isMask;
    }
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
//    if (!_scanButton) {
//        [self createScanButton];
//    }
    
    if (!_hintLabel) {
        [self createHintLabel];
        [self createHintLabelB];
    }

//    if (!_scanNavigationBar) {
//        [self createNavigationBar];
//    }
//    
    if (!_scanControlBar) {
        [self creatScanControlBar];
    }
 
}


- (void)createScanButton {
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.frame = CGRectMake(self.bounds.size.width - 130, self.bounds.size.height - 130, 85, 85);
    [_scanButton setImage:[UIImage imageNamed:@"Camera_Scan_Action"] forState:UIControlStateNormal];
//    [_scanButton setTitle:@"拍照识别" forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scanButton];
 
}

- (void)creatScanControlBar {
    
    _scanControlBar = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - CONTROLBAR_WIDTH, 0, CONTROLBAR_WIDTH, self.bounds.size.height)];
    _scanControlBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    CGFloat width = 80;
    CGFloat margin = 20;
    
    //取消按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, 0, width, width);
        cancleButton.center = CGPointMake(CONTROLBAR_WIDTH/2.0, width/2.0 + margin);
        [cancleButton setImage:[UIImage imageNamed:@"Camera_close.png"] forState:UIControlStateNormal];
    cancleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cancleButton addTarget:self action:@selector(scanCancleAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_scanControlBar addSubview:cancleButton];
    
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanButton.frame = CGRectMake(0, 0, width + 5, width +5);
    _scanButton.center = CGPointMake(cancleButton.center.x, self.bounds.size.height/2.0);
    [_scanButton setImage:[UIImage imageNamed:@"Cramera_photoAction"] forState:UIControlStateNormal];
    //    [_scanButton setTitle:@"拍照识别" forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [_scanControlBar addSubview:_scanButton];
    
    [self addSubview:_scanControlBar];
}

- (void)createNavigationBar {
    
    _scanNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    _scanNavigationBar.backgroundColor = [UIColor whiteColor];
    
    //navigation Title
    _navigationTitleLabel = [[UILabel alloc] initWithFrame:_scanNavigationBar.bounds];
    _navigationTitleLabel.backgroundColor = [UIColor whiteColor];
    _navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    _navigationTitleLabel.textColor = [UIColor blackColor];
    _navigationTitleLabel.font = [UIFont systemFontOfSize:20 weight:1];
    _navigationTitleLabel.text = @"行驶证拍照识别";
    
    //取消按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(10, 0, 44, 44);
    //    cancleButton.center = CGPointMake(_scanButton.center.x, self.bounds.size.height - 80);
    //    [cancleButton setImage:[UIImage imageNamed:@"Camera_Close.png"] forState:UIControlStateNormal];
    cancleButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cancleButton setTitle:@"关闭" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(scanCancleAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_scanNavigationBar addSubview:_navigationTitleLabel];
    [_scanNavigationBar addSubview:cancleButton];
    [self addSubview:_scanNavigationBar];

}

- (void)createHintLabel {
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, 44)];
    _hintLabel.center = CGPointMake(self.center.x, 44);
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.textColor = [UIColor redColor];
    _hintLabel.font = [UIFont systemFontOfSize:25 weight:3];
    _hintLabel.text = @"请横向手持iPad进行证件扫描";
    _hintLabel.hidden = YES;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationFaceUp:
            _hintLabel.hidden = YES;
            break;
            
        default:
            _hintLabel.hidden = NO;
            break;
    }
    [self addSubview:_hintLabel];
}

- (void)createHintLabelB {
    
    _hintLabelB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
    _hintLabelB.center = CGPointMake(self.center.x, CGRectGetMaxY(self.frame) - 100);
    _hintLabelB.backgroundColor = [UIColor clearColor];
    _hintLabelB.textAlignment = NSTextAlignmentCenter;
    _hintLabelB.textColor = [UIColor whiteColor];
    _hintLabelB.font = [UIFont systemFontOfSize:20 weight:0.5];
    if (_isMask)
    {
        _hintLabelB.text = @"将取景框对准行驶证，即可拍照扫描";
    }
    else
    {
        _hintLabelB.text = @"将取景框对准VIN，即可拍照扫描";
    }
    
    [self addSubview:_hintLabelB];
}

- (void)scanAction {
    
    if (self.scanBolck) {
        self.scanBolck(YES);
    }
}

- (void)scanCancleAction {
    
    if (self.scanBolck) {
        self.scanBolck(NO);
    }
}

- (void)initQRLine {
    
    CGRect screenBounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height);
    _qrLine  = [[UIImageView alloc] initWithFrame:CGRectMake(screenBounds.size.width / 2 - self.transparentArea.width / 2, screenBounds.size.height / 2 - self.transparentArea.height / 2, self.transparentArea.width, 2)];
//    qrLine.image = [UIImage imageNamed:@"qr_scan_line"];
//    qrLine.contentMode = UIViewContentModeScaleAspectFill;
    _qrLine.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
    [self addSubview:_qrLine];
    _qrLineY = _qrLine.frame.origin.y;
}


- (void)show {
    
    [UIView animateWithDuration:kQrLineanimateDuration animations:^{
        
        CGRect rect = _qrLine.frame;
        rect.origin.y = _qrLineY;
        _qrLine.frame = rect;
        
    } completion:^(BOOL finished) {
        
        CGFloat maxBorder = self.frame.size.height / 2 + self.transparentArea.height / 2 - 4;
        if (_qrLineY > maxBorder) {
            
            _qrLineY = self.frame.size.height / 2 - self.transparentArea.height /2;
        }
        _qrLineY++;
    }];
}

- (void)drawRect:(CGRect)rect {
    
    //整个二维码扫描界面的颜色
    CGSize screenSize =[UIScreen mainScreen].bounds.size;
    CGRect screenDrawRect =CGRectMake(0, 0, screenSize.width,screenSize.height);
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - self.transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - self.transparentArea.height / 2,
                                      self.transparentArea.width,self.transparentArea.height);
    _scanRect = clearDrawRect;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 31 /255.0, 99/255.0, 234/255.0, 1);//蓝色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x-0.7, rect.origin.y),
        CGPointMake(rect.origin.x-0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y -0.7),CGPointMake(rect.origin.x + 15, rect.origin.y-0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x- 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x -0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height + 0.7) ,CGPointMake(rect.origin.x-0.7 +15, rect.origin.y + rect.size.height + 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y -0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width+0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width+0.7,rect.origin.y + 15 -0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width +0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x+0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height + 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
    
    [self addShadowView];
}

- (void)addShadowView {
    
    _shadowView = [[UIImageView alloc] initWithFrame:_scanRect];
//                   CGRectMake(_scanRect.origin.x - 1, _scanRect.origin.y - 1, _scanRect.size.width + 2, _scanRect.size.height + 2)];
    _shadowView.image = [UIImage imageNamed:@"Camera_CardCoverNew"];
    [self addSubview:_shadowView];
    _shadowView.hidden = !_isMask;
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}


@end
