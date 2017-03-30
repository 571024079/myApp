//
//  HDNetworkTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/11/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDNetworkTableViewCell.h"

@interface HDNetworkTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation HDNetworkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addBottomLine];
    [self setArrowTinColor];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    HDNetworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDNetworkTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDNetworkTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)addBottomLine {
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.webLabel.text attributes:attribtDic];
    self.webLabel.attributedText = attribtStr;
}

- (void)setArrowTinColor {
    
    UIImage *image = [[UIImage imageNamed:@"down_list_View_right_arrow.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.arrowImageView.image = image;
    self.arrowImageView.tintColor = MAIN_BLUE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
