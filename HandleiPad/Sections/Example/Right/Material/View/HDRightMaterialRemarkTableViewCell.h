//
//  HDRightMaterialRemarkTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    HDRightMaterialRemarkTableViewCellStyleCamera = 1,// 相机
    HDRightMaterialRemarkTableViewCellStylePhoto,//相册
}HDRightMaterialRemarkTableViewCellStyle;

typedef void(^HDRightMaterialRemarkTableViewCellBlock)(HDRightMaterialRemarkTableViewCellStyle style, UIButton *button);
@interface HDRightMaterialRemarkTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *remarkLb;


@property (weak, nonatomic) IBOutlet UIButton *cameraBt;

@property (weak, nonatomic) IBOutlet UIButton *photoBt;

@property (nonatomic, strong) NSNumber *saveStatus;

@property (nonatomic, copy) HDRightMaterialRemarkTableViewCellBlock hDRightMaterialRemarkTableViewCellBlock;
@property (weak, nonatomic) IBOutlet UIView *imageRemark;


- (IBAction)cameraBtAction:(UIButton *)sender;

- (IBAction)photoBtAction:(UIButton *)sender;


- (void)setImageRemarkNumber:(NSNumber *)number;






@end
