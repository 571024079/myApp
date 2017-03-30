//
//  HDProjectUserRangeTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HDProjectUserRangeTableViewCellBlock)(UIButton *sender);
@interface HDProjectUserRangeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *projectLb;

@property (weak, nonatomic) IBOutlet UILabel *projectnameLb;



@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) HDProjectUserRangeTableViewCellBlock hdProjectBlock;


- (IBAction)listAction:(UIButton *)sender;


//--------------------已弃用属性

@property (weak, nonatomic) IBOutlet UIImageView *momentChangeImg;
@property (weak, nonatomic) IBOutlet UIImageView *saveMineImg;
@property (weak, nonatomic) IBOutlet UIImageView *forAllImg;


- (IBAction)chooseRangeBtAction:(UIButton *)sender;

@end
