//
//  HDFullScreenLeftListForRightCell.m
//  HandleiPad
//
//  Created by handou on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDFullScreenLeftListForRightCell.h"
#import "HDLeftListModel.h"

@implementation HDFullScreenLeftListForRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(NSString *)imageStr color:(UIColor *)color {
    UIImage *image = [UIImage imageNamed:imageStr];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    _imageBao.image = image;
    _imageBao.tintColor = color;
    
    _littleBaoImageView.image = image;
    _littleBaoImageView.tintColor = color;
    
    _littleNeiJieImageView.image = image;
    _littleNeiJieImageView.tintColor = color;
    
}

- (void)setCellWithData:(PorscheNewCarMessage *)data {
    
    [self setTypeDataImageType:data.statestart withImageView:self.image1 withLabel:self.statusLabel1 withText:@""];
    [self setTypeDataImageType:data.stateincrease withImageView:self.image2 withLabel:self.statusLabel2 withText:@""];
    [self setTypeDataImageType:data.statepart withImageView:self.image3 withLabel:self.statusLabel3 withText:@""];
    [self setTypeDataImageType:data.stateserice withImageView:self.image4 withLabel:self.statusLabel4 withText:@""];
    [self setTypeDataImageType:data.statecustomer withImageView:self.image5 withLabel:self.statusLabel5 withText:@""];
    
//    [self setTypeBaoDataImageType:data withImageView:self.imageBao];
    //包含内结和保修
    [self setTypeBaoDataImageType:data withImageView:self.imageBao withImageViewimageViewLittleBao:self.littleBaoImageView withImageViewLittleNeijie:self.littleNeiJieImageView];
}


- (void)setTypeBaoDataImageType:(PorscheNewCarMessage *)model withImageView:(UIImageView *)imageView withImageViewimageViewLittleBao:(UIImageView *)imageViewLittleBao withImageViewLittleNeijie:(UIImageView *)imageViewLittleNeijie {
    
    if ([model.existguarantee integerValue] != 0 || [model.existinternalsettlement integerValue] == 1) {//红保内结
        if ([model.existguarantee integerValue] == 1 && [model.existinternalsettlement integerValue] == 1) {
            [imageViewLittleBao setImage:[UIImage imageNamed:@"fullLeftListForRight_insureRed"]];
            [imageViewLittleNeijie setImage:[UIImage imageNamed:@"billing_pay_inside"]];
        }else if ([model.existguarantee integerValue] == 1 && [model.existinternalsettlement integerValue] == 0) {
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_insureRed"]];
        }else if ([model.existguarantee integerValue] == 0 && [model.existinternalsettlement integerValue] == 1) {
            [imageView setImage:[UIImage imageNamed:@"billing_pay_inside"]];
        }
        
        if ([model.existguarantee integerValue] == 2 && [model.existinternalsettlement integerValue] == 1) {
            [imageViewLittleBao setImage:[UIImage imageNamed:@"fullLeftListForRight_insureBule"]];
            [imageViewLittleNeijie setImage:[UIImage imageNamed:@"billing_pay_inside"]];
        }else if ([model.existguarantee integerValue] == 2 && [model.existinternalsettlement integerValue] == 0) {
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_insureBule"]];
        }else if ([model.existguarantee integerValue] == 0 && [model.existinternalsettlement integerValue] == 1) {
            [imageView setImage:[UIImage imageNamed:@"billing_pay_inside"]];
        }
    }else {
        
        [self setImage:@"" color:nil];
    }
}
//0.全部 1.进行中2.已完成3.备件通知4.确认通知6.增项通知 8.待开始，9.车间待确认 10.车间进行中 11.车间已确认
- (void)setTypeDataImageType:(NSNumber *)type withImageView:(UIImageView *)imageView withLabel:(UILabel *)label withText:(NSString *)text {
    NSInteger index = [type integerValue];
    switch (index) {
        case 1:
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_ing"]];
            label.text = @"进行中";
            break;
        case 2:
        case 11:
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_finish"]];
            switch (index) {
                case 2:
                    label.text = @"已完成";
                    break;
                case 11:
                    label.text = @"车间已确认";
                default:
                    break;
            }
            break;
        case 3:
        case 4:
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_notifition"]];
            switch (index) {
                case 3:
                    label.text = @"备件通知";
                    break;
                case 4:
                    label.text = @"确认通知";
                    break;
                default:
                    break;
            }
            break;
        case 6:
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_add"]];
            label.text = @"增项通知";
            break;
        case 8:
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_waltStart"]];
            label.text = @"待开始";
            break;
        case 9:
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_waltStart_workShopWait"]];
            label.text = @"车间待确认";
            break;
        case 10:
            [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_carShopIng"]];
            label.text = @"车间进行中";
            break;
        case 0:
        default:
            [imageView setImage:[UIImage imageNamed:@""]];
            label.text = @"";
            break;
    }
}

@end
