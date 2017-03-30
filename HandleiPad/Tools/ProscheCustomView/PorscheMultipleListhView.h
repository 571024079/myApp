//
//  PorscheMultipleListhView.h
//  HandleiPad
//
//  Created by Robin on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PorscheSingleListhViewClickBlock)(PorscheConstantModel *constantModel,NSInteger idx);
typedef void(^PorscheTwoStageListhViewClickBlock)(PorscheConstantModel *constantModel,PorscheSubConstant *subConstantModel);
typedef void(^PorscheMultipleListhViewClickBlock)(NSArray<PorscheConstantModel *> *constantModelArray);
@interface PorscheMultipleListhView : UIView


/**
 单选列表

 @param view 选择起始的View 也是镂空的View
 @param dataSource 选择列表的数据源
 @param selected 初始选择的选项
 @param direction 列表出现的位置
 @param complete 返回选中的sting
 */
+ (void)showSingleListViewFrom:(UIView *)view dataSource:(NSArray<PorscheConstantModel *> *)dataSource selected:(NSString *)selected showArrow:(BOOL)showArrow direction:(ListViewDirection)direction complete:(PorscheSingleListhViewClickBlock)complete;
/**
 单选列表车型选择列表
 
 @param limitStyle 显示界面限制  0->没有限制,最大长度   1->车型选择
 */
+ (void)showSingleListViewFrom:(UIView *)view dataSource:(NSArray<PorscheConstantModel *> *)dataSource selected:(NSString *)selected showArrow:(BOOL)showArrow showClearButton:(BOOL)showClear direction:(ListViewDirection)direction withLimit:(NSNumber *)limitStyle complete:(PorscheSingleListhViewClickBlock)complete;

/**
 单选列表带清除按钮

 @param showClear 显示清除按钮  点击清除返回值为nil和0
 */
+ (void)showSingleListViewFrom:(UIView *)view dataSource:(NSArray<PorscheConstantModel *> *)dataSource selected:(NSString *)selected showArrow:(BOOL)showArrow showClearButton:(BOOL)showClear direction:(ListViewDirection)direction complete:(PorscheSingleListhViewClickBlock)complete;
/**
 多项选择

 @param view 选择起始的View 也是镂空的View
 @param dataSource 选择列表的数据源
 @param selecteds 初始选择的选项（数组）
 @param maxCount 最多选择个数
 @param minCount 最少选择个数
 @param direction 方向
 @param complete 返回选择的数组
 */
+ (void)showMultipleListViewFrom:(UIView *)view dataSource:(NSArray<PorscheConstantModel *> *)dataSource selecteds:(NSArray *)selecteds maxSelectCount:(NSInteger)maxCount MinSelectCount:(NSInteger)minCount direction:(ListViewDirection)direction complete:(PorscheMultipleListhViewClickBlock)complete;

/**
 两级选择框

 @param view 选择起始的View 也是镂空的View
 @param dataSource 选择列表的数据源
 @param selectedModel 选中的model
 @param direction 方向
 @param complete 返回选中一二级model
 */
+ (void)showTwoStageListViewFrom:(UIView *)view dataSource:(NSArray *)dataSource selected:(PorscheConstantModel *)selectedModel direction:(ListViewDirection)direction complete:(PorscheTwoStageListhViewClickBlock)complete;

@end
