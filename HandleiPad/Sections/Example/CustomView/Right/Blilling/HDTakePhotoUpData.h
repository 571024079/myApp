//
//  HDTakePhotoUpData.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HDTakePhotoUpDataBlock)(UIButton *sender);
@interface HDTakePhotoUpData : UIView
@property (nonatomic, copy) HDTakePhotoUpDataBlock hdupdatePhotoBlock;
- (IBAction)updatePhotoAction:(UIButton *)sender;
//130.85
+ (instancetype)getUpDatePhotoViewFrame:(CGRect)frame;
@end
