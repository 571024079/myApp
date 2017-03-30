//
//  PrintPreviewTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar on 10/17/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "PrintPreviewTableViewCell.h"
@interface PrintPreviewTableViewCell()
@property (nonatomic, weak) IBOutlet UIView *workhourNameView;
@property (nonatomic, weak) IBOutlet UIView *spareNameView;
@property (nonatomic, weak) IBOutlet UILabel *workhourNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *spareNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *unipriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *countLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *repairMarkImageView;


@end
@implementation PrintPreviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.repairMarkImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    self.repairMarkImageView.layer.shadowOffset = CGSizeMake(1, 1);
    UIImage *repairimage = _repairMarkImageView.image;//[UIImage imageNamed:@"billing_guarantee.png"];
    
    repairimage = [repairimage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _repairMarkImageView.image = repairimage;
    _repairMarkImageView.tintColor = MAIN_BLUE;
//    repairMarkImageView.image dd
}

- (void)setCellContentWithModel:(id)model
{

}

- (void)setCellType:(PrintPreviewTableViewCellType)cellType
{
    _cellType = cellType;
    if (self.cellType == PrintPreviewTableViewCell_WorkHour)
    {
        self.spareNameView.hidden = YES;
        self.workhourNameView.hidden = NO;
        self.repairMarkImageView.hidden = NO;
        self.discountPriceLabel.text = @"￥0.00";
    }
    else
    {
        self.spareNameView.hidden = NO;
        self.workhourNameView.hidden = YES;
        self.repairMarkImageView.hidden = YES;
        self.discountPriceLabel.text = @"￥6.20";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
