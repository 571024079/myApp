//
//  ScanView.h
//  CrameraDemo
//
//  Created by GoodRobin on 16/9/19.
//  Copyright © 2016年 GoodRobin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ScanActionBlock)(BOOL scan);

@interface ScanView : UIView

/**
 *  透明的区域
 */
@property (nonatomic, assign) CGSize transparentArea;

@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) UILabel *hintLabelB;

@property (nonatomic, assign, readonly) CGRect scanRect;

@property (nonatomic, copy) ScanActionBlock scanBolck;

@property (nonatomic) BOOL isMask;  // 是否需要遮罩
- (instancetype)initWithFrame:(CGRect)frame isMask:(BOOL)isMask;
@end
