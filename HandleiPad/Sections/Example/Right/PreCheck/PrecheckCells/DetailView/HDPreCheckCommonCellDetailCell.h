//
//  HDPreCheckCommonCellDetailCell.h
//  HandleiPad
//
//  Created by 程凯 on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDPreCheckViewController;

typedef enum {
    SelectButtonType_none = 0,//不选
    SelectButtonType_one = 1,//第一个 button
    SelectButtonType_two = 2,//第二个 button
    SelectButtonType_three = 3,//第三个 button
}SelectButtonType;



@interface HDPreCheckCommonCellDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *titleView;//显示标题的 cell
@property (weak, nonatomic) IBOutlet UIView *dataView;//显示选择和内容的 cell

@property (weak, nonatomic) IBOutlet UILabel *contentLb;//内容 label

@property (weak, nonatomic) IBOutlet UIButton *oneSelectBtn;//第一个选择的 btn
@property (weak, nonatomic) IBOutlet UIButton *twoSelectBtn;//第二个选择的 btn
@property (weak, nonatomic) IBOutlet UIButton *threeSelectBtn;//第三个选择的 btn
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectBtnArray;
@property (weak, nonatomic) IBOutlet UIImageView *oneSelectImage;//第一个选择的 UIImageView
@property (weak, nonatomic) IBOutlet UIImageView *twoSelectImage;//第二个选择的 UIImageView
@property (weak, nonatomic) IBOutlet UIImageView *threeSelectImage;//第三个选择的 UIImageView

@property (strong, nonatomic) NSNumber *viewForm;//界面从什么地方过来


@property (strong, nonatomic) NSNumber *hpcistate;//选中状态: 检车状态 0:不选 1：正常  2：有待检查  3：不正常',

@property (copy, nonatomic) void(^selectBtnBlock)(SelectButtonType selectBtnType);//回调选择按钮的点击事件


@end
