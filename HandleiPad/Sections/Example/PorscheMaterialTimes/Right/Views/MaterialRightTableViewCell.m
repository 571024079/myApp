//
//  MaterialRightTableViewCell.m
//  MaterialDemo
//
//  Created by Robin on 16/9/27.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialRightTableViewCell.h"

@interface MaterialRightTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *item1;
@property (weak, nonatomic) IBOutlet UILabel *item2;
@property (weak, nonatomic) IBOutlet UILabel *item3;
@property (weak, nonatomic) IBOutlet UILabel *item4;
@property (weak, nonatomic) IBOutlet UILabel *item5;


@end

@implementation MaterialRightTableViewCell {
    
    NSArray *_labelArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _labelArray = @[_item1,_item2,_item3,_item4,_item5];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecginizer:)];
    [self addGestureRecognizer:longPress];
}

- (void)longPressRecginizer:(UILongPressGestureRecognizer *)longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"长按了cell");
        if (self.longTapBlock) {
            self.longTapBlock();
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setSandowLine];
}

- (void)setSandowLine {
    
}
- (IBAction)changeAction:(UIButton *)sender {
    
    switch (_celltype) {
        case CellTypeWaiting:
        {
//            self.cellSelected = !self.cellSelected;
            
            if (self.topBlock) {
                self.topBlock(YES);
            }
            
        }
            break;
        case CellTypeSelected:
            if (self.topBlock) {
                self.topBlock(NO);
            }
            break;
        default:
            break;
    }  
}

//- (void)setModel:(PorscheSchemews *)model {
//    _model = model;
//    
////    self.item1.text = model.schemewscode;
//    self.item1.text = [self getSperaCode:nil];
//    self.item2.text = model.schemewsphotocode;
//    self.item3.text = model.schemewsname;
//    self.item5.text = [NSString formatMoneyStringWithFloat:[model.schemewsunitprice floatValue]];
//}

- (void)setModel:(PorscheSchemeSpareModel *)model {
    _model = model;
    
    self.item1.text = model.speraCode ? model.speraCode : @"";
    self.item2.text = model.speraImageCode ? model.speraImageCode : @"";
    self.item3.text = model.parts_name ? model.parts_name : @"";
    self.item4.text = model.group_name ? model.group_name : @"";
    self.item5.text = [NSString formatMoneyStringWithFloat:model.price_after_tax.floatValue];
}

- (void)setCellSelected:(BOOL)cellSelected {
    _cellSelected = cellSelected;
    
    if (_celltype != CellTypeWaiting) {
        return;
    }
    
    if (cellSelected) {
        for (UILabel *subLabel in _labelArray) {
            
            subLabel.textColor = [UIColor whiteColor];
        
            [_changeBtn setImage:[UIImage imageNamed:@"materialtime_list_checkbox_selected"] forState:UIControlStateNormal];
            
            self.contentView.backgroundColor = MAIN_BLUE;
            
            
        }
    } else {
        for (UILabel *subLabel in _labelArray) {
            
            subLabel.textColor = Color(76, 76, 76);
            
            [_changeBtn setImage:[UIImage imageNamed:@"materialtime_list_checkbox_normal"] forState:UIControlStateNormal];
            self.contentView.backgroundColor = self.model.inFavorite ? MAIN_BEFOR_BLUE : [UIColor whiteColor];
        }
    }
    
}


- (void)setCelltype:(CellType)celltype {
    
    _celltype = celltype;
    
    if (_celltype == CellTypeSelected) {
        [_changeBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [_changeBtn setTitle:@"" forState:UIControlStateNormal];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
