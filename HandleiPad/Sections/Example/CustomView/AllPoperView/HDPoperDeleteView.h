//
//  HDPoperDeleteView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDdeleteView.h"
#import "AlertViewHelpers.h"
#import "HDLeftBillingDateChooseView.h"
#import "HDWorkListDateChooseView.h"
#import "HDRightDateChooseView.h"

#import "GuaranteeChooseView.h"
// 开单中本地和拍照上传
#import "HDTakePhotoUpData.h"
#import "HDPopSelectTableView.h"//列表类型的弹出框

//删除block
typedef void(^HDPoperDeleteViewBlock)(HDdeleteViewStyle);
//时间筛选pop <2016年 10月 14日 星期五 下午> 默认尺寸<480.280>  ---block
typedef void(^HDTimePredicateViewBlock)(HDLeftBillingDateChooseViewStyle);

@interface HDPoperDeleteView : UIView

@property (nonatomic, strong) UIPopoverController *poperVC;
#pragma mark  ------ 删除弹窗属性
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) HDdeleteView *deleteView;
@property (nonatomic, copy) HDPoperDeleteViewBlock hDPoperDeleteViewBlock;

#pragma mark  ------时间筛选pop <2016年 10月 14日 星期五 下午> 默认尺寸<480.280>
@property (nonatomic, strong) HDLeftBillingDateChooseView *datepickerView;
@property (nonatomic, copy) HDTimePredicateViewBlock timeBlock;

#pragma mark  ------时间筛选pop <2016年 10月 14日 星期五 下午 1 51> 默认尺寸<500.300>
@property (nonatomic, strong) HDWorkListDateChooseView *secondPickerView;

#pragma mark  ------时间筛选pop <2016年 10月 14日 星期五> 默认尺寸<400.300>
@property (nonatomic, strong) HDRightDateChooseView *weekDatePickerView;
#pragma mark  ------保修------默认需设置尺寸<240.203>
@property (nonatomic, strong) GuaranteeChooseView *guaranteeChooseView;


#pragma mark  ------中间删除弹窗pop
//价格试用全店尺寸 <295.155>
- (instancetype)initWithSize:(CGSize)size;
#pragma mark  ------时间弹窗------
//时间筛选pop <2016年 10月 14日 星期五 下午> 默认尺寸<480.280>
+ (UIPopoverController *)showDateTimePredicateFrame:(CGRect)frame aroundView:(UIView *)view direction:(UIPopoverArrowDirection)direction headerTitle:(NSString *)title isLimit:(BOOL)isLimit style:(HDLeftBillingDateChooseViewStyle)style complete:(void(^)(HDLeftBillingDateChooseViewStyle style,NSString *endStr))complete;

//时间筛选pop <2016年 10月 14日 星期五 下午 1 51> 默认尺寸<500.300>
+ (void)showTimeAndSecondViewFrame:(CGRect)frame aroundView:(UIView *)view style:(HDWorkListDateChooseViewStyle)style direction:(UIPopoverArrowDirection)direction sure:(void (^)(NSString *string))sure cancel:(void (^)())cancel;

//时间筛选pop <2016年 10月 14日 星期五> 默认尺寸<400.300>
+ (UIPopoverController *)showDateAndWeekViewWithFrame:(CGRect)frame aroundView:(UIView *)view direction:(UIPopoverArrowDirection)direction headerTitle:(NSString *)title isLimit:(BOOL)isLimit style:(HDRightDateChooseViewStyle)style complete:(void(^)(HDRightDateChooseViewStyle style,NSString *endStr))complete;

#pragma mark  ------保修选择弹窗------
//默认尺寸<240.203>
- (instancetype)initWithGuaranteeChooseViewFrame:(CGRect)frame dataSource:(NSArray *)dataSource idx:(NSInteger)idx;
#pragma mark  开单中本地和拍照上传
+ (void)showUpDatePhotoViewAroundView:(UIView *)view direction:(UIPopoverArrowDirection)direction Camera:(void(^)())camera location:(void (^)())location;
//删除弹窗包裹
+ (UIPopoverController *)showAlertViewAroundView:(UIView *)view titleArr:(NSArray *)titleArr direction:(UIPopoverArrowDirection)direction sure:(void (^)())sure refuse:(void (^)())refuse cancel:(void (^)())cancel;


+ (void)showAlertViewAroundView:(UIView *)view title:(NSString *)title style:(HDLeftBillingDateChooseViewStyle)style withDate:(NSDate *)date withResultBlock:(void(^)(NSString *resultStr))resultBlock;


#pragma mark - 列表类型的popView
+ (UIPopoverController *)showAlertTableViewWithAroundView:(UIView *)view withDataSource:(NSArray *)dataSource direction:(UIPopoverArrowDirection)direction selectBlock:(void(^)(NSInteger index))selectBolck;

@end
