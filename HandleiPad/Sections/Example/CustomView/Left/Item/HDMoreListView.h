//
//  HDMoreListView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    viewFormStyle_other,//其他使用这个界面的
    viewFormStyle_carType,//车系、车型、年款
}viewFormStyle;

@interface HDMoreListView : UIView

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, copy) void(^removewViewBlock)(NSArray *dataArray);

+ (void)showListViewWithView:(UIView *)aroundView Data:(NSMutableArray *)array direction:(UIPopoverArrowDirection)direction complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete;


+ (void)showListViewWithView:(UIView *)aroundView Data:(NSMutableArray *)array direction:(UIPopoverArrowDirection)direction withType:(viewFormStyle)type complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete;

+ (void)showListViewWithView:(UIView *)aroundView Data:(NSMutableArray *)array direction:(UIPopoverArrowDirection)direction withType:(viewFormStyle)type complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete removeComplete:(void(^)(NSArray *dataArray))removeComplete;

+ (void)showListViewWithView:(UIView *)aroundView Data:(NSMutableArray *)array direction:(UIPopoverArrowDirection)direction complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete removeComplete:(void(^)(NSArray *dataArray))removeComplete;

@end
