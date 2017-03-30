//
//  RemarkInfoCollectionReusableView.h
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDPreCheckModel;

//typedef enum {
//    ServiceType_jiananjiyou = 1,//加满机油
//    ServiceType_baoliejiujian = 2,//保留旧件
//    ServiceType_biaozhunqingxi = 3,//标准清洗
//    ServiceType_gaojineishiqingxi = 4,//高级内饰清洗
//    ServiceType_gaojicheshenqingxi = 5,//高级车身清洗
//}ServiceType;

//其他服务:   1=加满机油, 2=保留旧件, 3=标准清洗, 4=高级内饰清洗, 5=高级车身清洗

@interface RemarkInfoCollectionReusableView : UICollectionReusableView

@property (strong, nonatomic) HDPreCheckModel *preCheckData;//数据源

@property (weak, nonatomic) IBOutlet UITextView *textView;//备注输入框
@property (weak, nonatomic) IBOutlet UILabel *beizhuNameLb;//备注标题
@property (weak, nonatomic) IBOutlet UILabel *qitafuwuNameLb;//备注标题
@property (weak, nonatomic) IBOutlet UIImageView *kehuSignatureImageView;//客户签名图片

@property (strong, nonatomic) NSNumber *viewForm;//界面从什么地方过来

@property (copy, nonatomic) void(^selectBtnBlock)(NSMutableArray *selectArray);//回调选择的项目
@property (copy, nonatomic) void(^textViewBlock)(UITextView *textView);//备注回调

@end
