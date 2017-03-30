//
//  HDServiceLeftBottomView.h
//  HandleiPad
//
//  Created by handou on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ServiceLeftBottomViewStyle_all = 1,//全部
    ServiceLeftBottomViewStyle_mycar,//我的车辆
}ServiceLeftBottomViewStyle;


//typedef void(^ServiceLeftBottomViewBlock)(ServiceLeftBottomViewStyle,UIButton *,NSInteger);

@interface HDServiceLeftBottomView : UIView
//全部按钮
@property (weak, nonatomic) IBOutlet UIButton *allButton;
//选择我的车辆按钮
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
//我的车辆label，复用可换label
@property (weak, nonatomic) IBOutlet UILabel *MyCarLabel;

@property (weak, nonatomic) IBOutlet UIButton *myCarButton;
//@property (nonatomic, copy) ServiceLeftBottomViewBlock serviceLeftBottomViewBlock;
@property (nonatomic, copy) void(^serviceLeftBottomViewBlock)(ServiceLeftBottomViewStyle style, UIButton *button, NSInteger count);

@property (nonatomic, assign) NSInteger tapCount;//判断我的车辆点击
@property (nonatomic, assign) NSInteger allCount;//判断全部按钮点击

- (instancetype)initWithCustomFrame:(CGRect)frame;

- (IBAction)allButtonAction:(UIButton *)sender;
- (IBAction)myCarButtonAction:(UIButton *)sender;
@end
