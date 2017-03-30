//
//  HDWorkListTVHFViewOne.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/5.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDWorkListTVHFViewOneStyle) {
    HDWorkListTVHFViewOneStyleDelete = 1,// 删除
    HDWorkListTVHFViewOneStyleTF,
};


typedef void(^HDWorkListTVHFViewOneBlock)(HDWorkListTVHFViewOneStyle,UIButton *);
@interface HDWorkListTVHFViewOne : UITableViewHeaderFooterView

//方案名称
@property (weak, nonatomic) IBOutlet UITextField *itemNameTF;
//工时小计
@property (weak, nonatomic) IBOutlet UITextField *itemTimeTF;

//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
//备件小计
@property (weak, nonatomic) IBOutlet UITextField *materalTF;
//方案小计
@property (weak, nonatomic) IBOutlet UITextField *itemTotal;
//左虚线
@property (weak, nonatomic) IBOutlet UILabel *leftLine;
//右虚线
@property (weak, nonatomic) IBOutlet UILabel *rightLine;
//分类
@property (weak, nonatomic) IBOutlet UILabel *titleLb;




- (IBAction)deleteBtAction:(UIButton *)sender;


@property (nonatomic, copy) HDWorkListTVHFViewOneBlock hdWorkListTVHFViewOneBlock;

- (instancetype)initWithCustomFrame:(CGRect)frame;


@end
