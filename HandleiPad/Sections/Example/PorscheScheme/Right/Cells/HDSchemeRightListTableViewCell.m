//
//  HDSchemeRightListTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSchemeRightListTableViewCell.h"

@interface HDSchemeRightListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *item1;
@property (weak, nonatomic) IBOutlet UILabel *item2;
@property (weak, nonatomic) IBOutlet UILabel *item3;
@property (weak, nonatomic) IBOutlet UILabel *item4;
@property (weak, nonatomic) IBOutlet UILabel *item5;
@property (weak, nonatomic) IBOutlet UILabel *item6;
@property (weak, nonatomic) IBOutlet UIView *chickView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chickButtonLayout;

@property (nonatomic ,strong) NSArray *labelArray;


@property (nonatomic, assign) PorscheItemModelCategooryStyle category;

@end

@implementation HDSchemeRightListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    HDSchemeRightListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDSchemeRightListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDSchemeRightListTableViewCell" owner:nil options:nil] firstObject];
    }
    [cell setupConfig];
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:cell action:@selector(longTapAction:)];
    [cell addGestureRecognizer:longTap];
    return cell;
}

- (void)setupConfig {
    NSString *str = @"燃油供应\n巡航控制起动机电源";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont boldSystemFontOfSize:12.f]
                   range:NSMakeRange(0, 4)];
    _item4.attributedText = attStr;
}

- (void)setDeleteButton:(BOOL)deleteButton {
    _deleteButton = deleteButton;
    
    if (deleteButton) {
        [self.chickButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    }
}

- (NSArray *)labelArray {
    
    if (!_labelArray) {
        _labelArray = @[_item2,_item3,_item4,_item5,_item6];
    }
    return _labelArray;
}

- (void)setModel:(PorscheSchemeModel *)model {
    
    _model = model;
    
    NSInteger safety = model.schemelevelid.integerValue;
    NSString *imageName = [PorscheImageManager getSafetyColorImage:safety selected:NO];
    self.item1.image = [UIImage imageNamed:imageName];
    self.item2.text = model.schemename ? model.schemename : @"";
    if ([model.source isEqualToNumber:@1])
    {
        PorscheBusinessModel *typeModel = model.typelist.firstObject;
        self.item3.text = typeModel.businesstypename ? typeModel.businesstypename : @"";
    }
    else
    {
        NSArray *business = [model.business componentsSeparatedByString:@","];
        
        if (business.count)
        {
            self.item3.text = [business firstObject];
        }
        else
        {
            self.item3.text = model.business;//typeModel.businesstypename ? typeModel.businesstypename : @"";
        }
    }
    
    PorscheSchemeCarModel * schemeCarModel = model.carlist.firstObject;
//    PorscheRequestSchemeListModel *requestModel =  [PorscheRequestSchemeListModel shareModel];
    NSString *carcatena;
    NSString *carmodel;
    NSString *caryear;
//    if ([requestModel.wocarcatena isEqualToString:@""] || !requestModel.wocarcatena) {
        carcatena = schemeCarModel.wocarcatena ? schemeCarModel.wocarcatena : @"";
//    } else {
//        carcatena = requestModel.wocarcatena;
//    }
//    if ([requestModel.wocarmodel isEqualToString:@""] || !requestModel.wocarmodel) {
        carmodel = schemeCarModel.wocarmodel ? schemeCarModel.wocarmodel : @"";
//    } else {
//        carmodel = requestModel.wocarmodel;
//    }
//    if ([requestModel.woyearstyle isEqualToString:@""] || !requestModel.woyearstyle) {
        caryear = schemeCarModel.woyearstyle ? schemeCarModel.woyearstyle : @"";
//    } else {
//        caryear = requestModel.woyearstyle ? requestModel.woyearstyle : @"";
//    }
    
    self.item4.text = [NSString stringWithFormat:@"%@ %@\n%@",carcatena,carmodel,caryear];
//    PorscheSchemeWorkHourModel *workHours = model.workhourlist.firstObject;
    self.item5.text = [NSString stringWithFormat:@"%@\n%@",model.workhourgroupfuname ? model.workhourgroupfuname : @"",model.workhourgroupsname ? model.workhourgroupsname : @""];
    self.item6.text = [NSString formatMoneyStringWithFloat:model.schemeprice.floatValue];
}

- (void)setHiddenSelected:(BOOL)hiddenSelected {
    _hiddenSelected = hiddenSelected;
    
    if (hiddenSelected) {
        self.chickButtonLayout.constant = 0;
        self.chickView.hidden = YES;
    };
}

- (void)setCellSelected:(BOOL)cellSelected {
    _cellSelected = cellSelected;

    NSString *cellName = [PorscheImageManager getSafetyColorImage:self.model.schemelevelid.integerValue selected:cellSelected];
    _item1.image = [UIImage imageNamed:cellName];
    
    if (cellSelected) {

        for (UILabel *subLabel in self.labelArray) {
            
            subLabel.textColor = [UIColor whiteColor];
            
            [_chickButton setImage:[UIImage imageNamed:@"materialtime_list_checkbox_selected"] forState:UIControlStateNormal];
        }
        
        for (UIView *view in self.contentView.subviews) {
            view.backgroundColor = MAIN_BLUE;
        }

    } else {
        for (UILabel *subLabel in self.labelArray) {
            
            subLabel.textColor = Color(76, 76, 76);
            
            [_chickButton setImage:[UIImage imageNamed:@"materialtime_list_checkbox_normal"] forState:UIControlStateNormal];
        }
        for (UIView *view in self.contentView.subviews) {
            view.backgroundColor = self.model.inFavorite ? MAIN_BEFOR_BLUE : [UIColor whiteColor];
        }
    }
}
- (IBAction)chickAction:(UIButton *)sender {
    
    if (self.chickBlock) {
        self.chickBlock();
    }
    
}

- (void)longTapAction:(UILongPressGestureRecognizer *)longTap {
    
    if (longTap.state == UIGestureRecognizerStateBegan) {
        if (self.longTapBlock) {
            self.longTapBlock();
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
