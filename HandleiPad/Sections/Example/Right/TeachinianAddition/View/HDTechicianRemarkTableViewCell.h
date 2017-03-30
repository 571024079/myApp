//
//  HDTechicianRemarkTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDTechicianRemarkTableViewCellStyle) {
    HDTechicianRemarkTableViewCellStyleCamera = 1,// 相机
    HDTechicianRemarkTableViewCellStylePhoto,//相册
    HDTechicianRemarkTableViewCellStyleTFBegin,//输入框开始输入
    HDTechicianRemarkTableViewCellStyleTFReturn,//输入框完成
};

typedef void(^HDTechicianRemarkTableViewCellBlock)(HDTechicianRemarkTableViewCellStyle style,NSString *text);

@interface HDTechicianRemarkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *remarkTF;
@property (weak, nonatomic) IBOutlet UIView *imageRemark;

@property (weak, nonatomic) IBOutlet UIButton *cameraBt;

@property (weak, nonatomic) IBOutlet UIButton *photoBt;

@property (nonatomic, strong) PorscheNewScheme *tmpModel;

@property (nonatomic, strong) NSNumber *saveStatus;

@property (nonatomic, copy) HDTechicianRemarkTableViewCellBlock HDTechicianRemarkTableViewCellBlock;

//- (instancetype)initWithCustomFrame:(CGRect)frame;

- (IBAction)cameraBtAction:(UIButton *)sender;

- (IBAction)photoBtAction:(UIButton *)sender;

@end
