//
//  HDClientBottomView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^HDClientBottomViewBlock)(UIButton *);
@interface HDClientBottomView : UIView
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBt;
//预览按钮

@property (weak, nonatomic) IBOutlet UIButton *preViewBt;
//打印按钮

@property (weak, nonatomic) IBOutlet UIButton *printBt;
//取消确认按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelAffirmBt;

@property (weak, nonatomic) IBOutlet UIButton *customSureBt;
@property (nonatomic, copy) HDClientBottomViewBlock hDClientBottomViewBlock;
@property (weak, nonatomic) IBOutlet UIImageView *cancelImageView;
@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

- (IBAction)buttonClickAction:(UIButton *)sender;

- (void)setupViewSave:(PorscheNewCarMessage *)message isSave:(BOOL)isSave;

- (instancetype)initWithCustomFrame:(CGRect)frame;




@end
