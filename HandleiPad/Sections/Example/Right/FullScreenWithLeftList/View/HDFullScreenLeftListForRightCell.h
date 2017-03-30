//
//  HDFullScreenLeftListForRightCell.h
//  HandleiPad
//
//  Created by handou on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDLeftListModel;

@interface HDFullScreenLeftListForRightCell : UITableViewCell
//view1
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel1;
//view2
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel2;
//view3
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel3;
//view保
@property (weak, nonatomic) IBOutlet UIImageView *imageBao;
//添加小保和小内结
@property (weak, nonatomic) IBOutlet UIImageView *littleBaoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *littleNeiJieImageView;

//view4
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel4;
//view5
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel5;


- (void)setCellWithData:(PorscheNewCarMessage *)data;
@end
