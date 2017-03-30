//
//  HDWorkListTVHFView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

//带有分割线的区头
typedef NS_ENUM(NSInteger, HeaderViewActionStyle) {
    HeaderViewActionStyleDelete = 1,// <#content#>
    HeaderViewActionStyleLongPress
};

typedef void(^DeleteBlock)(HeaderViewActionStyle);
@interface HDWorkListTVHFView : UITableViewHeaderFooterView
//
@property (weak, nonatomic) IBOutlet UIView *containerView;
//安全标示
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
//项目名称
@property (weak, nonatomic) IBOutlet UILabel *serviceLb;
//详情标识
@property (weak, nonatomic) IBOutlet UIImageView *secondimageView;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBt;
//项目类型label   <新增，已确认>
@property (weak, nonatomic) IBOutlet UILabel *itemStyle;
//左侧虚线View
@property (weak, nonatomic) IBOutlet UIView *itemLeftLineView;
//右侧虚线View
@property (weak, nonatomic) IBOutlet UIView *itemRightLineView;
//左侧虚线label
@property (weak, nonatomic) IBOutlet UILabel *leftlabl;
//右侧虚线label
@property (weak, nonatomic) IBOutlet UILabel *rightlabel;




@property (nonatomic, copy) DeleteBlock block;

- (IBAction)deleteServiceAction:(UIButton *)sender;
//
- (instancetype)initWithCustomFrame:(CGRect)frame;
@end
