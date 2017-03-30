//
//  KandanLeftTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDLeftListModel;

@interface KandanLeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
//添加小保和小内结
@property (weak, nonatomic) IBOutlet UIImageView *littleBaoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *littleNeiJieImageView;

@property (weak, nonatomic) IBOutlet UILabel *carCategoryLb;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLb;
@property (weak, nonatomic) IBOutlet UIImageView *progressOneImageView;

@property (weak, nonatomic) IBOutlet UIImageView *progressTwoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *progressThreeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *progressFourImageView;
@property (weak, nonatomic) IBOutlet UIImageView *progressFiveImageView;

@property (weak, nonatomic) IBOutlet UIView *shadowSuperView;


- (void)setShadow;

- (void)setImage:(NSString *)imageStr color:(UIColor *)color;


//设置cell右侧图片的状态
- (void)setCellStyleForData:(PorscheNewCarMessage *)data withSelect:(BOOL)isSelect;


@end
