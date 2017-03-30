//
//  ServiceShareListTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ServiceShareListTableViewCell.h"

@interface ServiceShareListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation ServiceShareListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *identifer = @"ServiceShareListTableViewCell";
    ServiceShareListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceShareListTableViewCell" owner:nil options:nil] firstObject];
    }

    cell.arrowImageView.image = [[UIImage imageNamed:@"down_list_View_right_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
