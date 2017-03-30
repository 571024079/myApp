//
//  HDProjectChangeRangeView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HDProjectChangeRangeViewBlock)(UIButton *);
@interface HDProjectChangeRangeView : UIView
//@"此工单中有99项方案库方案被修改，请设置此次方案修改的使用范围："
@property (weak, nonatomic) IBOutlet UILabel *noticeLb;
//临时修改
@property (weak, nonatomic) IBOutlet UIImageView *momentImg;
//存为我的方案
@property (weak, nonatomic) IBOutlet UIImageView *saveMineImg;
//替换原厂适用于全厂
@property (weak, nonatomic) IBOutlet UIImageView *forAllImg;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *sureImg;

@property (nonatomic, copy) HDProjectChangeRangeViewBlock hDProjectChangeRangeViewBlock;


@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)listBtAction:(UIButton *)sender;

//
- (IBAction)changeAllRangeBtAction:(UIButton *)sender;
//sender.tag 1.确定 2.取消
- (IBAction)sureOrCancelbtAction:(UIButton *)sender;

//展示
+ (HDProjectChangeRangeView *)showRangeViewWithProjectArray:(NSMutableArray *)projectArray block:(HDProjectChangeRangeViewBlock)block;

@end
