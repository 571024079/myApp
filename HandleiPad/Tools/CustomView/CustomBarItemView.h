//
//  CustomBarItemView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonActionBlock)(UIButton *sender);

@interface CustomBarItemView : UIView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIView *redView;

@property (nonatomic, copy) ButtonActionBlock buttonBlock;

//+ (void)addCustomViewWithFrame:(CGRect)rect;

- (void)buttonAction:(UIButton *)sender;

@end
