//
//  HDWorkListCollectionViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/31.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListCollectionViewCell.h"
//#import <UIKit/UIGestureRecognizerSubclass.h>
#import "HDLeftSingleton.h"

//extern NSString *const touchStartstr;
//extern NSString *const touchMovedstr;
//extern NSString *const touchEndedStr;

//#define cellWidth (LEFT_WITH - 40)/3 - 29
//#define cellHeight (LEFT_WITH - 40)/3 - 35


@interface HDWorkListCollectionViewCell ()
@end

@implementation HDWorkListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tapGeSingle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
    tapGeSingle.numberOfTapsRequired = 1;
    tapGeSingle.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGeSingle];
}

- (void)tapOne:(UITapGestureRecognizer *)sender {
    NSLog(@"单击");
    if (self.block) {
        self.userInteractionEnabled = NO;
        self.block(self,HDWorkListCollectionViewCellTapStyleOne);
        self.userInteractionEnabled = YES;
        NSLog(@"单击结束");
    }
    
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setDefaultHidden {
    _selectedImg.hidden = YES;
    _detialImg.hidden = YES;
}

//- (void)setPicTinColor:(UIColor *)color imageOne:(NSString *)imageOne imageTwo:(NSString *)imageTwo selectedImg:(NSString *)selectedImg {
//    UIImage *image1 = [UIImage imageNamed:imageOne];
//    UIImage *image2 = [UIImage imageNamed:imageTwo];
//    UIImage *image3 = [UIImage imageNamed:selectedImg];
//    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    image3 = [image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//    _oneCellBGImg.image = image1;
//    _oneCellBGImgTwo.image = image2;
//    _selectedImg.image = image3;
//    _oneCellBGImg.tintColor = color;
//    _oneCellBGImgTwo.tintColor = color;
//    _selectedImg.tintColor = color;
//}

- (void)setModel:(PorscheCarMessage *)model {
    _model = model;
    _selectedImg.image = [UIImage imageNamed:@"work_list_32.png"];
    NSString *endString = model.message;
    _contentLb.font = [UIFont systemFontOfSize:12];
    //工时文字个数7，显示为上5，下显示其余
    if (model.message.length == 7) {
        NSString *string = [model.message substringToIndex:5];
        NSString *lastString = [model.message substringFromIndex:5];
        endString = [NSString stringWithFormat:@"%@\n%@", string, lastString]; // 设置特定字符长度换行
        self.contentLb.text = endString;
        
    }else if (model.message.length > 7 && model.message.length<= 10){//工时文字小于7，价格和工时
        NSString *string = [model.message substringToIndex:6];
        NSString *lastString = [model.message substringFromIndex:6];
        endString = [NSString stringWithFormat:@"%@\n%@", string, lastString]; // 设置特定字符长度换行
        self.contentLb.text = endString;
        
    }else if (model.message.length < 7){
        self.contentLb.text = endString;
    }else {
        NSString *contentStr = [model.message substringToIndex:10];
        NSString *string = [contentStr substringToIndex:6];
        NSString *lastString = [contentStr substringFromIndex:6];
        NSString *endString = [NSString stringWithFormat:@"%@\n%@…", string, lastString]; // 设置特定字符长度换行
        self.contentLb.text = endString;
    }
/*
    if (![model.message isEqualToString:@"911保养促销"]) {
        _categoryLb.text = @"价格";
    }else {
        _categoryLb.text = @"方案";
    }
 */
    _categoryLb.text = @"方案";
    
    if (model.selectedStyle == PorscheItemModelUnselected) {
        _selectedImg.hidden = YES;
        _oneCellBGImgTwo.image = [UIImage imageNamed:@"item_blue_new_normal.png"];

    }else if (model.selectedStyle == PorscheItemModelSelected) {
        _selectedImg.hidden = NO;
        _oneCellBGImgTwo.image = [UIImage imageNamed:@"message_seleted.png"];
    }
    //是都已读优先
    if (model.modelStyle == PorscheCarMessageStyleUnread) {
        _oneCellBGImgTwo.image = [UIImage imageNamed:@"item_blue_new_normal.png"];
    }else {
        _oneCellBGImgTwo.image = [UIImage imageNamed:@"item_blue_normal.png"];
    }
    
    
}

@end
