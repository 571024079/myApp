//
//  PorscheMultipleListTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheMultipleListTableViewCell.h"

@interface PorscheMultipleListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *tickButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeadingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tickButtonWidthlayout;

@end

@implementation PorscheMultipleListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableVIew:(UITableView *)tableView {
    
    PorscheMultipleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PorscheMultipleListTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PorscheMultipleListTableViewCell" owner:nil options:nil] lastObject];
        
    }
    return cell;
}

- (void)setMutltiple:(BOOL)mutltiple {
    
    _mutltiple = mutltiple;
    
    self.tickButton.hidden = !mutltiple;
    self.labelLeadingLayout.constant = mutltiple? 8 : 0;
    self.tickButtonWidthlayout.constant = mutltiple? 15 : 0;
}

- (void)setSelect:(BOOL)select {
    
    _select = select;
    
    [self tickButton:select];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.contentView.backgroundColor = selected ? Color(148, 0, 8) : MAIN_BLUE;
    // Configure the view for the selected state
}

- (void)tickButton:(BOOL)tick {
    
    NSString *tickImageName = tick ? @"work_list_29":@"work_list_30";
    
    [self.tickButton setImage:[UIImage imageNamed:tickImageName] forState:UIControlStateNormal];
//    self.contentView.backgroundColor = tick ? Color(148, 0, 8) : MAIN_BLUE;
}

@end
