//
//  HDServiceLeftHeaderView.h
//  HandleiPad
//
//  Created by handou on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ServiceLeftHeaderStyle_top_one = 1,//牌照/VIN/车型
    ServiceLeftHeaderStyle_top_two,//进厂时间
    ServiceLeftHeaderStyle_top_three,//搜索
    ServiceLeftHeaderStyle_middle_one,//车系
    ServiceLeftHeaderStyle_middle_two,//是否在厂
    ServiceLeftHeaderStyle_middle_three,//人员
    ServiceLeftHeaderStyle_bottom_one,//在厂
    ServiceLeftHeaderStyle_bottom_two,//常客
    ServiceLeftHeaderStyle_bottom_three,//VIP
    ServiceLeftHeaderStyle_bottom_four,//更多
    ServiceLeftHeaderStyle_top_four,//清空
}ServiceLeftHeaderStyle;


@protocol HDServiceLeftHeaderViewDelegate <NSObject>

- (void)serviceLeftHeaderButtonAction:(UIButton *)button withStyle:(ServiceLeftHeaderStyle)style;
- (void)serviceLeftHeaderViewShouldReturn:(UITextField *)textField;

@end


@interface HDServiceLeftHeaderView : UIView
//top
@property (nonatomic, weak) IBOutlet UIView *viewTopOne;
@property (nonatomic, weak) IBOutlet UITextField *textFTopOne;
@property (nonatomic, weak) IBOutlet UIView *viewTopTwo;
@property (nonatomic, weak) IBOutlet UITextField *textFTopTwo;
@property (nonatomic, weak) IBOutlet UIView *viewTopThree;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

//middle
@property (nonatomic, weak) IBOutlet UIView *viewMiddleOne;
@property (nonatomic, weak) IBOutlet UITextField *textFMiddleOne;
@property (nonatomic, weak) IBOutlet UIView *viewMiddleTwo;
@property (nonatomic, weak) IBOutlet UITextField *textFMiddleTwo;
@property (nonatomic, weak) IBOutlet UIView *viewMiddleThree;
@property (nonatomic, weak) IBOutlet UITextField *textFMiddleThree;
//bottom
@property (nonatomic, weak) IBOutlet UIImageView *imageBottomOne;
@property (nonatomic, weak) IBOutlet UIImageView *imageBottomTwo;
@property (nonatomic, weak) IBOutlet UIImageView *imageBottomThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottomOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottomTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonBottomThree;
@property (nonatomic, weak) IBOutlet UIView *viewBottomFour;
@property (nonatomic, weak) IBOutlet UITextField *textFieldBottomFour;
//代理
@property (nonatomic, assign) id<HDServiceLeftHeaderViewDelegate>delegate;

//初始化方法
- (instancetype)initWithCustomFrame:(CGRect)frame;

- (void)selectOnFactory;
- (void)clear;
@end
