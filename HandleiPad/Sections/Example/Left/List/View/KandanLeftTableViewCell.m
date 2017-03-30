//
//  KandanLeftTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "KandanLeftTableViewCell.h"
#import "HDLeftListModel.h"

@implementation KandanLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShadow {
    //阴影
    self.shadowSuperView.layer.cornerRadius = 3;
    self.shadowSuperView.layer.borderWidth = 0.5;
    self.shadowSuperView.layer.borderColor = Color(200, 200, 200).CGColor;
    //边线
    self.shadowSuperView.layer.shadowColor = Color(200, 200, 200).CGColor;
    self.shadowSuperView.layer.shadowOffset = CGSizeMake(0, 1);
    self.shadowSuperView.layer.shadowRadius = 2;
    self.shadowSuperView.layer.shadowOpacity = 0.5;
    self.shadowSuperView.layer.masksToBounds = NO;
//    self.shadowSuperView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.shadowSuperView.bounds cornerRadius:3].CGPath;
}


- (void)setImage:(NSString *)imageStr color:(UIColor *)color {
    UIImage *image = [UIImage imageNamed:imageStr];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    _selectedImageView.image = image;
    _selectedImageView.tintColor = color;
    
    _littleBaoImageView.image = image;
    _littleBaoImageView.tintColor = color;
    
    _littleNeiJieImageView.image = image;
    _littleNeiJieImageView.tintColor = color;
    
}

- (void)setCellStyleForData:(PorscheNewCarMessage *)data withSelect:(BOOL)isSelect {
    //流程状态 图片
    [self setImageStatusWithImage:self.progressOneImageView withType:data.statestart withSelect:isSelect withStayType:data.wostatus];
    [self setImageStatusWithImage:self.progressTwoImageView withType:data.stateincrease withSelect:isSelect withStayType:data.wostatus];
    [self setImageStatusWithImage:self.progressThreeImageView withType:data.statepart withSelect:isSelect withStayType:data.wostatus];
    [self setImageStatusWithImage:self.progressFourImageView withType:data.stateserice withSelect:isSelect withStayType:data.wostatus];
    [self setImageStatusWithImage:self.progressFiveImageView withType:data.statecustomer withSelect:isSelect withStayType:data.wostatus];
    //包含内结和保修
    [self setTypeBaoDataImageType:data withImageView:self.selectedImageView withImageViewimageViewLittleBao:self.littleBaoImageView withImageViewLittleNeijie:self.littleNeiJieImageView withSelect:isSelect];
    
}
- (void)setTypeBaoDataImageType:(PorscheNewCarMessage *)model withImageView:(UIImageView *)imageView withImageViewimageViewLittleBao:(UIImageView *)imageViewLittleBao withImageViewLittleNeijie:(UIImageView *)imageViewLittleNeijie withSelect:(BOOL)isSelect {
    
    if ([model.existguarantee integerValue] != 0 || [model.existinternalsettlement integerValue] == 1) {
        if ([model.existguarantee integerValue] == 1 && [model.existinternalsettlement integerValue] == 1) {
            if (isSelect) {
                [imageViewLittleNeijie setImage:[UIImage imageNamed:@"billing_pay_inside_select"]];
                [imageViewLittleBao setImage:[UIImage imageNamed:@"fullLeftListForRight_insureRed"]];
            }else {
                [imageViewLittleBao setImage:[UIImage imageNamed:@"fullLeftListForRight_insureRed"]];
                [imageViewLittleNeijie setImage:[UIImage imageNamed:@"billing_pay_inside"]];
            }
        }else if ([model.existguarantee integerValue] == 1 && [model.existinternalsettlement integerValue] == 0) {
            if (isSelect) {
                [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_insureRed"]];
            }else {
                [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_insureRed"]];
            }
        }else if ([model.existguarantee integerValue] == 0 && [model.existinternalsettlement integerValue] == 1) {
            if (isSelect) {
                [imageView setImage:[UIImage imageNamed:@"billing_pay_inside_select"]];
            }else {
                [imageView setImage:[UIImage imageNamed:@"billing_pay_inside"]];
            }
        }
        if ([model.existguarantee integerValue] == 2 && [model.existinternalsettlement integerValue] == 1) {
            if (isSelect) {
                [imageViewLittleNeijie setImage:[UIImage imageNamed:@"billing_pay_inside_select"]];
                [imageViewLittleBao setImage:[UIImage imageNamed:@"fullLeftListForRight_insureRed_select"]];
            }else {
                [imageViewLittleBao setImage:[UIImage imageNamed:@"fullLeftListForRight_insureBule"]];
                [imageViewLittleNeijie setImage:[UIImage imageNamed:@"billing_pay_inside"]];
            }
        }else if ([model.existguarantee integerValue] == 2 && [model.existinternalsettlement integerValue] == 0) {
            if (isSelect) {
                [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_insureRed_select"]];
            }else {
                [imageView setImage:[UIImage imageNamed:@"fullLeftListForRight_insureBule"]];
            }
        }else if ([model.existguarantee integerValue] == 0 && [model.existinternalsettlement integerValue] == 1) {
            if (isSelect) {
                [imageView setImage:[UIImage imageNamed:@"billing_pay_inside_select"]];
            }else {
                [imageView setImage:[UIImage imageNamed:@"billing_pay_inside"]];
            }
        }
    }else {
        [self setImage:@"" color:nil];
    }
}
//0.全部 1.进行中2.已完成3.备件通知4.确认通知6.增项通知 8.待开始，9.车间待确认 10.车间进行中 11.车间已确认
- (void)setImageStatusWithImage:(UIImageView *)imageView withType:(NSNumber *)type withSelect:(BOOL)isSelect withStayType:(NSNumber *)stayType {
    
    if ([stayType integerValue] == 8) { //不在厂
        if (isSelect) {
            imageView.image = [UIImage imageNamed:@""];
            [self garyFilledCircleSelectedOrNormalImageWith:imageView];
        }else {
            [self garyFilledCircleSelectedOrNormalImageWith:imageView];
        }
    }else {
        NSInteger index = [type integerValue];
        
        switch (index) {
                //进行过
            case 1:
            case 9:
            // 进行中 红色实心
                if (isSelect) {
                    imageView.image = [UIImage imageNamed:@"carListCell_red_point"];
                }else {
                    imageView.image = [UIImage imageNamed:@"carListCell_red_filleCircle"];
                }
                break;
            /*case 9:  // 蓝圈
                if (isSelect) {
                    [self whiteCircleRoundSelectedImageWith:imageView];
                }else {
                    [self blueCircleRoundSelectedOrNormalImageWith:imageView];
                }
                break;*/
            case 2:
//            case 9:
            case 10:
            case 11:
                // 已结束  蓝色
                if (isSelect) {
                    imageView.image = [UIImage imageNamed:@"carListCell_white_point"];
                }else {
                    imageView.image = [UIImage imageNamed:@"carListCell_blue_filleCircle"];
                }
                break;
                
                //有通知
            case 3:
            case 4:
            case 8:
            case 6:
                        // 红圈
                if (isSelect) {
                    imageView.image = [UIImage imageNamed:@"carListCell_red_circleRound"];
                }else {
                    imageView.image = [UIImage imageNamed:@"carListCell_red_circleRound"];
                }
                break;
            
//            case 11:   //
//                if (isSelect) {
//                    [imageView circleRoundImageWithColor:MAIN_BLUE withImageView:imageView];
//                }else {
//                    [imageView circleRoundImageWithColor:[UIColor whiteColor] withImageView:imageView];
//                }
//                break;
                
                //没有进行
            case 0:
            default:
                if (isSelect) {
                    imageView.image = [UIImage imageNamed:@"carListCell_gary_circleRound"];
                    
                }else {
                    imageView.image = [UIImage imageNamed:@"carListCell_gary_circleRound"];
                }
                break;
        }
    }
}



//选中红点心
- (void)redPointSelectedImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_white_double.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = MAIN_RED;
}
//选中白点心
- (void)whitePointSelectedImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_white_double.png"];
    imageView.image = image;
}
//选中灰实心圆(正常灰实心圆)
- (void)garyFilledCircleSelectedOrNormalImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_blue"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = MAIN_PLACEHOLDER_GRAY;
}
//选中白圈
- (void)whiteCircleRoundSelectedImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_blue_white"];
    imageView.image = image;
}
//选中红圈(正常红圈)
- (void)redCircleRoundSelectedOrNormalImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_blue_white"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = MAIN_RED;
}


// 正常蓝圈
- (void)blueCircleRoundSelectedOrNormalImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_blue_white"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = MAIN_BLUE;
}

//正常蓝实心圆
- (void)blueFilledCircleNormalImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_blue"];
    imageView.image = image;
}
//正常红实心圆
- (void)redFilledCircleNormalImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_blue"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.image = image;
    imageView.tintColor = MAIN_RED;
}
//正常灰圈
- (void)garyCircleRoundNormalImageWith:(UIImageView *)imageView {
    UIImage *image = [UIImage imageNamed:@"hd_kaidan_leftcell_round_gray"];
    imageView.image = image;
}
@end
