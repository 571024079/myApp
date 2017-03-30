//
//  HDWorkListHeaderView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/4.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
//车系选择界面 headerView
typedef NS_ENUM(NSInteger, HeaderViewBtActionStyle) {
    HeaderViewBtActionStyleCarStyle = 1,//车系1
    HeaderViewBtActionStyleCategory,//业务分类2
    HeaderViewBtActionStyleItem,//工时主子组3
    HeaderViewBtActionStyleMaterial,//备件主组4
    HeaderViewBtActionStyleClean,//搜索5
    
//    HeaderViewBtActionStyleRbt1,//开单信息5
//    HeaderViewBtActionStyleRbt2,//技师增项6
//    HeaderViewBtActionStyleRbt3,//备件确认7
//    HeaderViewBtActionStyleRbt4,//服务沟通8
//    HeaderViewBtActionStyleRbt5,//客户确认9
//    
//    HeaderViewBtActionStyleAddSingletonItem,//添加单独项目10
//    HeaderViewBtActionStyleFullScreen,//全屏11
//    
//    HeaderViewBtActionStyleService,//服务顾问12
//    HeaderViewBtActionStyleSave,//保存13
//    HeaderViewBtActionStyleOK,//技师确认14
    
};

typedef void(^HeaderViewBtActionBlock)(UIButton *button);

@interface HDWorkListHeaderView : UIView

@property (nonatomic, copy) HeaderViewBtActionBlock block;

//third
//车系选择bt
@property (weak, nonatomic) IBOutlet UIButton *carCategoryBt;
//业务分类bt
@property (weak, nonatomic) IBOutlet UIButton *itemCategoryBt;
//工时主子组
@property (weak, nonatomic) IBOutlet UIButton *itemMainBt;
//备件主子组
@property (weak, nonatomic) IBOutlet UIButton *materialMainBt;



//清空搜索按钮
@property (weak, nonatomic) IBOutlet UIButton *cleanBt;
//名字、VIN、搜索
@property (weak, nonatomic) IBOutlet UITextField *nameSearchTF;
//分类搜索
@property (weak, nonatomic) IBOutlet UITextField *categoryTF;
//业务搜索
@property (weak, nonatomic) IBOutlet UITextField *itemSearchTF;
//备件主子组TF
@property (weak, nonatomic) IBOutlet UITextField *materialMainTF;

//工时主子组TF
@property (weak, nonatomic) IBOutlet UITextField *itemMainTF;

@property (nonatomic, strong) PorscheNewCarMessage *carmodel;



- (instancetype)initWithCustomFrame:(CGRect)frame;
//1.车系 2.业务 3.工时子组 4.备件主组 5.搜索
- (IBAction)buttonAction:(UIButton *)sender;




@end
