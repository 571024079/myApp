//
//  HDServiceRightBottomView.m
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRightBottomView.h"


@interface HDServiceRightBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation HDServiceRightBottomView

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRightBottomView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    //设置圆形的countLabel
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = 15 / 2;
    
    [self justfyLabelStyle];
    
    return self;
}
- (void)setRightModel:(HDServiceRecordsRightModel *)rightModel {
    _rightModel = rightModel;
    [self setViewData];
}
- (void)setPriceArr:(NSMutableArray *)priceArr {
    _priceArr = priceArr;   
    NSInteger count = _priceArr.count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
    CGFloat price = 0.0;
    for (HDserviceDetailCellCustomModel *model in _priceArr) {
        price += [model.schemeprice floatValue];
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"总金额：￥%.2f", price];
}

- (void)setViewStyle:(ServiceRightBottomViewStyle)viewStyle {
    _viewStyle = viewStyle;
    if (_viewStyle == ServiceRightBottomViewStyle_shoppingCart_no) {
        self.viewOne.hidden = YES;
        self.viewTwo.hidden = YES;
        self.viewFour.hidden = NO;
        [_rightButton setTitle:@"确认返回" forState:UIControlStateNormal];
    }else if (_viewStyle == ServiceRightBottomViewStyle_shoppingCart_yes) {
        self.viewOne.hidden = NO;
        self.viewTwo.hidden = NO;
        self.viewFour.hidden = YES;
        [_rightButton setTitle:@"加入工单" forState:UIControlStateNormal];
    }
}

#pragma mark - 右侧按钮的点击事件
- (IBAction)rightButtonAction:(id)sender {
    if (_buttomBackButtonBlock) {
        _buttomBackButtonBlock();
    }
}

#pragma mark - 将label显示两端对齐
- (void)justfyLabelStyle {
    //添加排序判断条件
    NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"text.length" ascending:NO];
    //第一数列
    NSArray *labelArray1 = @[self.label1, self.label2];
    labelArray1 = [labelArray1 sortedArrayUsingDescriptors:@[sortDes]];
    UILabel *maxLengthLabel1 = (UILabel *)labelArray1.firstObject;
    [self.label1 setJustfyForLabelWithText:self.label1.text withMaxValue:maxLengthLabel1.text.length withAlignment:NSTextAlignmentLeft];
    [self.label2 setJustfyForLabelWithText:self.label2.text withMaxValue:maxLengthLabel1.text.length withAlignment:NSTextAlignmentLeft];
    //第二数列
    NSArray *labelArray2 = @[self.label3, self.label4];
    labelArray2 = [labelArray2 sortedArrayUsingDescriptors:@[sortDes]];
    UILabel *maxLengthLabel2 = (UILabel *)labelArray2.firstObject;
    [self.label3 setJustfyForLabelWithText:self.label3.text withMaxValue:maxLengthLabel2.text.length withAlignment:NSTextAlignmentLeft];
    [self.label4 setJustfyForLabelWithText:self.label4.text withMaxValue:maxLengthLabel2.text.length withAlignment:NSTextAlignmentLeft];
    //第三数列
    NSArray *labelArray3 = @[self.label5, self.label6];
    labelArray3 = [labelArray3 sortedArrayUsingDescriptors:@[sortDes]];
    UILabel *maxLengthLabel3 = (UILabel *)labelArray3.firstObject;
    [self.label5 setJustfyForLabelWithText:self.label5.text withMaxValue:maxLengthLabel3.text.length withAlignment:NSTextAlignmentLeft];
    [self.label6 setJustfyForLabelWithText:self.label6.text withMaxValue:maxLengthLabel3.text.length withAlignment:NSTextAlignmentLeft];
}

- (void)setViewData {
    if ([_rightModel.cancelnum integerValue] != 0 && [_rightModel.infactorycount integerValue] != [_rightModel.cancelnum integerValue]) {
        self.label11.text = [NSString stringWithFormat:@"%@次(取消%@次)", [_rightModel.infactorycount stringValue], _rightModel.cancelnum];
    }else {
        self.label11.text = [NSString stringWithFormat:@"%@次", [_rightModel.infactorycount stringValue]];
    }
    self.label22.text = [NSString stringWithFormat:@"%@%%", [self setRecommendfinishedrateWithNum:_rightModel.recommendfinishedrate]];
    self.label33.text = [self setStringStyleWithNumber:_rightModel.totalcostprice withStyle:NSNumberFormatterCurrencyStyle];
    self.label44.text = [self setStringStyleWithNumber:_rightModel.unfinishedamount withStyle:NSNumberFormatterCurrencyStyle];
    self.label55.text = [NSString stringWithFormat:@"%@次", [_rightModel.lastyearinfactorycount stringValue]];
    self.label66.text = [NSString stringWithFormat:@"%@次", [_rightModel.unfinishedschemecount stringValue]];
}



#pragma mark - 处理数字，添加逗号
- (NSString *)setStringStyleWithNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style {
    NSString *string = @"";
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:style];
    string = [currencyFormatter stringFromNumber:number];
    if ([[string substringToIndex:1] isEqualToString:@"$"]) {
        string = [NSString stringWithFormat:@"￥%@", [string substringFromIndex:1]];
    }
    return string;
}
#pragma mark - 处理完成率
- (NSString *)setRecommendfinishedrateWithNum:(NSNumber *)num {
    return [NSString stringWithFormat:@"%.2f", [num floatValue]];
}

//#pragma mark - 处理进厂数量
//- (NSInteger)setJoinNum {
//    NSInteger count = 0;
//    for (HDServiceYearListModel *yearModel in _rightModel.workorderlist) {
//        count += yearModel.workorderlistdetail.count;
//    }
//    return [_rightModel.infactorycount integerValue] - count;
//}

@end
