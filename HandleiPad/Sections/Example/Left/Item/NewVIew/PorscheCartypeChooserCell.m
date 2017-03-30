//
//  PorscheCartypeChooserCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheCartypeChooserCell.h"

@interface PorscheCartypeChooserCell ()

@property (weak, nonatomic) IBOutlet UIButton *tickButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeadingLayout;

@end

@implementation PorscheCartypeChooserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView identifer:(NSString *)identifer{
    
    PorscheCartypeChooserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    return cell;
}

- (void)setMultipleCell:(BOOL)multipleCell {
    
    _multipleCell = multipleCell;
    
    self.labelLeadingLayout.constant = multipleCell ? 30 : 8;
    self.tickButton.hidden = !multipleCell;
}

- (void)setCellSelected:(BOOL)cellSelected {
    _cellSelected = cellSelected;
    
    NSString *imageName = [PorscheImageManager getTickImage:cellSelected];
    [self.tickButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    NSString *imageName = [PorscheImageManager getTickImage:selected];
//    [self.tickButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.contentView.backgroundColor = selected ? MAIN_BLUE : [UIColor whiteColor];
    self.titleLabel.textColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
}

@end
