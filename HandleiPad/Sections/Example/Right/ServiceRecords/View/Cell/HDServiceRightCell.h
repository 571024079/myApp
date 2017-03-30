//
//  HDServiceRightCell.h
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDServiceRecordsHelper.h"
typedef enum {
    ServiceRightCellSelect_selected = 1,//选中
    ServiceRightCellSelect_noSelected,//未选中
}ServiceRightCellSelect;

@interface HDServiceRightCell : UITableViewCell

@property (nonatomic, strong) HDServiceRecordsRightDetailCellModel *detailModel;//右侧的数据
//显示状态
@property (nonatomic, assign) ServiceRightBottomViewStyle viewStyle;

//点击右测cell的回调方法(起始层)
@property (nonatomic, copy) void(^selectRightCellBlock)(ServiceRightCellSelect selectType, HDServiceRecordsRightDetailCellModel *model, HDserviceDetailCellCustomModel *selectModel);
//回调刷新VC数据(起始层)
@property (nonatomic, copy) void(^refreshVCBlock)();

//选择的数据列表
@property (nonatomic, strong) NSMutableArray *selectArray;

//左侧view
@property (weak, nonatomic) IBOutlet UIView *leftView;
//服务档案右侧cell上的左侧tableview
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;
//取消图标
@property (weak, nonatomic)IBOutlet UIImageView *cancelImageView;


//右侧view
@property (weak, nonatomic) IBOutlet UIView *rightView;
//服务档案右侧cell上的右侧tableview
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UILabel *rightDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unfinishedTotalPriceLabel;



@end
