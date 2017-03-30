//
//  HDServiceRightBottomView.h
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDServiceRecordsHelper.h"//助手

@interface HDServiceRightBottomView : UIView
//view1
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

//view2
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//view3
@property (weak, nonatomic) IBOutlet UIView *viewThree;
//view4(没有选择时的界面)
@property (weak, nonatomic) IBOutlet UIView *viewFour;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label11;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label22;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label33;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label44;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label55;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label66;


//显示状态
@property (nonatomic, assign) ServiceRightBottomViewStyle viewStyle;

@property (nonatomic, strong) HDServiceRecordsRightModel *rightModel;//右侧的数据

@property (nonatomic, copy) void(^buttomBackButtonBlock)();//右下角返回按钮
//当前显示的个数
@property (nonatomic, strong) NSMutableArray *priceArr;

- (instancetype)initWithCustomFrame:(CGRect)frame;
@end
