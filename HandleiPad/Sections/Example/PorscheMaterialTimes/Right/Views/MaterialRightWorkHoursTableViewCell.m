//
//  MaterialRightWorkHoursTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 2016/9/29.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MaterialRightWorkHoursTableViewCell.h"

@interface MaterialRightWorkHoursTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *item1;
@property (weak, nonatomic) IBOutlet UILabel *item2;
@property (weak, nonatomic) IBOutlet UILabel *item3;
@property (weak, nonatomic) IBOutlet UILabel *item4;
@property (weak, nonatomic) IBOutlet UILabel *item5;
@property (weak, nonatomic) IBOutlet UILabel *item6;
@property (weak, nonatomic) IBOutlet UILabel *item7;

@end

@implementation MaterialRightWorkHoursTableViewCell {
    
    NSArray *_labelArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _labelArray = @[_item1,_item2,_item3,_item4,_item5,_item6,_item7];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecginizer:)];
    [self addGestureRecognizer:longPress];
}

- (IBAction)changeBtnAction:(UIButton *)sender {
    
    switch (_celltype) {
        case HoursCellTypeTop:
            self.topBlock(YES);
            break;
        case HoursCellTypeBottom:
            if (self.topBlock) {
                self.topBlock(NO);
            }
            break;
        default:
            break;
    }

    
}

- (void)setModel:(PorscheSchemeWorkHourModel *)model {
    _model = model;
    
//    PorscheSchemeCarModel *car = model.cars.firstObject;
    //工时编号
    self.item1.text = model.workHourCode ? model.workHourCode : @"无";
    //工时名
    self.item2.text = model.workhourname ? model.workhourname : @"无";
    //适用车型
    self.item3.text = model.cartypename;
    //工时主组子组
    NSString *shString = [NSString stringWithFormat:@"%@\n%@",model.workhourgroupfuname ? model.workhourgroupfuname : @"",model.workhourgroupname ? model.workhourgroupname : @""];
    self.item4.attributedText = [self boldText:shString boldRange:NSMakeRange(0, model.workhourgroupfuname.length)];
    //工时单价
    self.item5.text = [NSString formatMoneyStringWithFloat:[model.workhourprice floatValue]];
    //工时数
    self.item6.text = [NSString stringWithFormat:@"%@TU",model.workhourcount ? model.workhourcount : @""];
    //工时小计
    self.item7.text = [NSString formatMoneyStringWithFloat:model.workhourpriceall.floatValue];
}

- (NSMutableAttributedString *)boldText:(NSString *)string boldRange:(NSRange)boldrange {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont boldSystemFontOfSize:12.f]
                   range:boldrange];
    return attStr;
}

- (void)longPressRecginizer:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        if (self.longTapBlock) {
            self.longTapBlock();
        }
    }
}


- (void)setCellSelected:(BOOL)cellSelected {
    
    _cellSelected = cellSelected;
    
    if (_celltype != HoursCellTypeTop) {
        return;
    }
    
    if (cellSelected) {
        for (UILabel *subLabel in _labelArray) {
            
            subLabel.textColor = [UIColor whiteColor];
            
            [_changeBtn setImage:[UIImage imageNamed:@"materialtime_list_checkbox_selected"] forState:UIControlStateNormal];
        }
        self.contentView.backgroundColor = MAIN_BLUE;
    } else {
        for (UILabel *subLabel in _labelArray) {
            
            subLabel.textColor = Color(76, 76, 76);
            
            [_changeBtn setImage:[UIImage imageNamed:@"materialtime_list_checkbox_normal"] forState:UIControlStateNormal];
        }
        self.contentView.backgroundColor = self.model.inFavorite ? MAIN_BEFOR_BLUE : [UIColor whiteColor];
    }
}
- (void)setCelltype:(HoursCellType)celltype {
    
    _celltype = celltype;
    
    if (_celltype == HoursCellTypeBottom) {
        [_changeBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_changeBtn setTitle:@"" forState:UIControlStateNormal];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
