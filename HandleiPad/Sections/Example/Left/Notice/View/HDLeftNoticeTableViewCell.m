//
//  HDLeftNoticeTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftNoticeTableViewCell.h"

@interface HDLeftNoticeTableViewCell ()
//文本框数组
@property (nonatomic, strong) NSMutableArray *lbArray;

@end

@implementation HDLeftNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _statusImg.layer.masksToBounds = YES;
    _statusImg.layer.cornerRadius = 5;
    // Initialization code 测试主管
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShadow {
    //阴影
    self.layer.cornerRadius = 3;
    
    //    self.contentView.layer.masksToBounds = YES;
    //    self.contentView.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //边线
    self.layer.shadowColor = Color(200, 200, 200).CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.5;
    self.layer.masksToBounds = NO;
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:3].CGPath;
    

}

- (void)setModel:(PorscheCarMessage *)model {
    _model = model;
    _carNumberLb.text = [NSString stringWithFormat:@"%@%@",model.carLocation,model.carNumber];
    _vinNumberLb.text = model.vinNumber;
    _carDetialLb.text = model.carCategory;
    _noticeLb.text = model.message;
    if (model.modelStyle == PorscheCarMessageStyleUnread) {
        _statusImg.backgroundColor = MAIN_RED;
    }else {
        _statusImg.backgroundColor = MAIN_BLUE;
    }
    
    
}

//默认字体颜色
- (void)setDefaultTextColor:(UIColor *)color {
    for (UILabel *lb in self.lbArray) {
        lb.textColor = color;
    }
}
//点击字体颜色
- (void)setSelectedTextColor:(UIColor *)color {
    for (UILabel *lb in self.lbArray) {
        lb.textColor = color;
    }
}

- (NSMutableArray *)lbArray {
    if (!_lbArray) {
        _lbArray = [NSMutableArray arrayWithObjects:_carNumberLb,_carDetialLb,_vinNumberLb,_noticeLb, nil];
    }
    return _lbArray;
}


/**************************** 提醒列表下方方案本店提醒使用 **************************/
- (void)setCellDataFormNoticeLeft:(HDLeftNoticeListModel *)model {
    _carNumberLb.text = [NSString stringWithFormat:@"%@%@",model.plateplace,model.ccarplate];
    _vinNumberLb.text = model.wovincode;
    _carDetialLb.text = [NSString stringWithFormat:@"%@ %@ %@", model.wocarcatena, model.wocarmodel, model.woyearstyle];
    _noticeLb.text = model.content;
    if ([model.stateread integerValue] == 1 || [model.stateopt integerValue] == 1) {//已读已操作
        _statusImg.image = [UIImage imageNamed:@"carListCell_blue_filleCircle"];
    }else if ([model.stateopt integerValue] == 0 && [model.state integerValue] == 1) {//未操作
        _statusImg.image = [UIImage imageNamed:@"carListCell_red_filleCircle"];
    }else if ([model.state integerValue] == 0 && [model.stateread integerValue] == 0) {//未读
        _statusImg.image = [UIImage imageNamed:@"carListCell_red_circleRound"];
    }
}

- (void)setSelectedCellStyle:(HDLeftNoticeListModel *)model {
    self.backgroundColor = MAIN_BLUE;
    [self setSelectedTextColor:[UIColor whiteColor]];
    if ([model.stateread integerValue] == 1 || [model.stateopt integerValue] == 1) {//已读已操作
        _statusImg.image = [UIImage imageNamed:@"carListCell_white_point"];
    }else if ([model.stateopt integerValue] == 0 && [model.stateread integerValue] == 1) {//未操作
        _statusImg.image = [UIImage imageNamed:@"carListCell_red_point"];
    }else if ([model.state integerValue] == 0 && [model.stateread integerValue] == 0) {//未读
        _statusImg.image = [UIImage imageNamed:@"carListCell_red_circleRound"];
    }
}

@end
