//
//  HDServiceRightHeaderView.h
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDServiceRecordsHelper.h"//助手
@class HDServiceRightTextFieldView;
typedef enum {
    ServiceRightHeaderViewButtonStyle_yewuleixing = 1,//业务类型
    ServiceRightHeaderViewButtonStyle_gognlishu = 2,//公里数
    ServiceRightHeaderViewButtonStyle_jinchangriqi = 3,//进厂日期
    ServiceRightHeaderViewButtonStyle_jiaocheruqi = 4,//交车日期
    ServiceRightHeaderViewButtonStyle_search = 5,//搜索
    ServiceRightHeaderViewButtonStyle_edit = 6,//添加标签
    ServiceRightHeaderViewButtonStyle_clear = 7,//清空
}ServiceRightHeaderViewButtonStyle;

@protocol HDServiceRightHeaderViewDelegage <NSObject>
- (void)serviceRightHeaderViewButtonAction:(UIButton *)sender withStyle:(ServiceRightHeaderViewButtonStyle)style;
- (BOOL)headerViewTextFieldShouldReturn:(UITextField *)textField withDataSource:(NSMutableArray *)dataSource;
//- (BOOL)headerViewTextFiel:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//- (void)headerViewTextFieldDidEndEditing:(UITextField *)textField;
- (void)headerViewTextDidEnd:(UITextField *)textField;
- (void)headerCarflgDeteleWith:(HDServiceRecordsCarflgModel *)model;
@end



@interface HDServiceRightHeaderView : UIView
@property (nonatomic, strong) HDServiceRecordsRightModel *rightModel;//右侧的数据
//车牌
@property (weak, nonatomic) IBOutlet UILabel *carPlateLabel;
//车型
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
//公里数
@property (weak, nonatomic) IBOutlet UILabel *carDistanceLabel;
//VIN
@property (weak, nonatomic) IBOutlet UILabel *carVINLabel;
//中间添加标签的collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//标签点击按钮
@property (weak, nonatomic) IBOutlet UIButton *titleAddButton;
//右侧辅助输入框
@property (weak, nonatomic) IBOutlet UITextField *headerViewTF;
//@property (nonatomic, weak) IBOutlet UITextField *headerViewtempTF;
//输入框
//@property (nonatomic, strong) HDServiceRightTextFieldView *headerViewTextFieldView;
//数据源
//@property (nonatomic, strong) NSMutableArray *dataSource;


//显示状态
@property (nonatomic, assign) ServiceRightBottomViewStyle viewStyle;
//代理
@property (nonatomic, assign) id<HDServiceRightHeaderViewDelegage>delegate;


//界面2
@property (weak, nonatomic) IBOutlet UIView *middleView;


//业务类型view
@property (weak, nonatomic) IBOutlet UIView *yewuleixingView;
@property (weak, nonatomic) IBOutlet UITextField *yewuleixingTF;
//公里数view
@property (weak, nonatomic) IBOutlet UIView *gonglishuView;
@property (weak, nonatomic) IBOutlet UITextField *gonglishuTF;
//进厂日期view
@property (weak, nonatomic) IBOutlet UIView *jinchangriqiView;
@property (weak, nonatomic) IBOutlet UITextField *jinchangriqiTF;
//交车日期view
@property (weak, nonatomic) IBOutlet UIView *jiaocheriqiView;
@property (weak, nonatomic) IBOutlet UITextField *jiaocheriqiTF;





- (instancetype)initWithCustomFrame:(CGRect)frame;
@end
