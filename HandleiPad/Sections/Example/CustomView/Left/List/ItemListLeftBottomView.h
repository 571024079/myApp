//
//  ItemListLeftBottomView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ItemListLeftBottomViewStyle) {
    ItemListLeftBottomViewStyleFullScreen = 1,//全屏
    ItemListLeftBottomViewStyleChooseMyCar,//我的车辆
};

typedef void(^ItemListLeftBottomViewBlock)(ItemListLeftBottomViewStyle,UIButton *,NSInteger);

@interface ItemListLeftBottomView : UIView
//全屏按钮
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBt;
//选择我的车辆按钮
@property (weak, nonatomic) IBOutlet UIButton *statusBt;
//我的车辆label，复用可换label
@property (weak, nonatomic) IBOutlet UILabel *rightLb;

@property (weak, nonatomic) IBOutlet UIButton *chooseMyCarBt;
@property (nonatomic, copy) ItemListLeftBottomViewBlock itemListLeftBottomViewBlock;


@property (nonatomic, assign) NSInteger tapCount;

- (instancetype)initWithCustomFrame:(CGRect)frame;

- (IBAction)fullScreenBtAction:(UIButton *)sender;
- (IBAction)chooseMyCarBtAction:(UIButton *)sender;

@end
