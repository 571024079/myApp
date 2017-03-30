//
//  HDClientBottomHelperView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HDClientBottomHelperViewBlock)();
@interface HDClientBottomHelperView : UIView

//工时
@property (weak, nonatomic) IBOutlet UILabel *itemTimeLb;
//备件
@property (weak, nonatomic) IBOutlet UILabel *materialLb;
//优惠
@property (weak, nonatomic) IBOutlet UILabel *preferentialLb;
//总计
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLb;
//签字日期
@property (weak, nonatomic) IBOutlet UILabel *signDateLb;
//签字按钮
@property (weak, nonatomic) IBOutlet UIButton *signBt;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) PorscheNewCarMessage *carMessage;


@property (nonatomic, strong) HDClientBottomHelperViewBlock hDClientBottomHelperViewBlock;


//点击签字按钮事件
- (IBAction)signBtAction:(UIButton *)sender;

- (instancetype)initWithCustomFrame:(CGRect)frame;

- (void)setupViewSave:(BOOL)isSave;

@end
