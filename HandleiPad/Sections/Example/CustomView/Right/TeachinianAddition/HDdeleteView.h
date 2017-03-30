//
//  HDdeleteView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDdeleteViewStyle) {
    HDdeleteViewStyleSure = 1,// 确定
    HDdeleteViewStyleCancel,//取消
    HDdeleteViewStyleRefuse,//拒绝
};


typedef void(^HDdeleteViewBlock)(HDdeleteViewStyle);

@interface HDdeleteView : UIView
//block
@property (nonatomic, copy) HDdeleteViewBlock hDdeleteViewBlock;


//删除Lb
@property (weak, nonatomic) IBOutlet UILabel *deleteLb;
//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBt;
//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *refuseBtWidth;


//确定
- (IBAction)sureBtAction:(UIButton *)sender;
//取消
- (IBAction)cancelBtAction:(UIButton *)sender;

- (instancetype)initWithCustom;

+ (instancetype)setupCustomTitlleArr:(NSArray *)titleArr;
//拒绝
- (IBAction)refuseBtAction:(UIButton *)sender;

- (void)setupViewAboutBottomViewThreeBt:(BOOL)isThree;

@end
