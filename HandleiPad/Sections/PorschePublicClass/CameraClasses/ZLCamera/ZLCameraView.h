//
//  BQCameraView.h
//  CameraDemo
//
//  Created by GoodRobin on 16/9/19.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLCameraView;

@protocol ZLCameraViewDelegate <NSObject>

@optional
- (void) cameraDidSelected : (ZLCameraView *) camera;

@end

@interface ZLCameraView : UIView

@property (assign, nonatomic) CGPoint point;

@property (weak, nonatomic) id <ZLCameraViewDelegate> delegate;

@end
