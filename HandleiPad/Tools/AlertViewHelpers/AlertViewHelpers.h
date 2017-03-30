//
//  AlertViewHelpers.h
//
//  Created by huwei_macmini1 on 16/4/9.
//  Copyright © 2016年 huwei123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^StatusBlock)();

@interface AlertViewHelpers : NSObject
//生成popController
+ (UIPopoverController *)getPoperVCWithCustomView:(UIView *)customView popoverContentSize:(CGSize)size;
//UI待设计
+ (void)setAlertViewWithViewController:(UIViewController *)viewController button:(UIView *)sender;
+ (void)setAlertViewWithMessage:(NSString *)message viewController:(UIViewController *)viewController button:(UIView *)sender ;
+ (void)setAlertViewWithMessage:(NSString *)message title:(NSString *)title viewController:(UIViewController *)viewController ;
+ (void)setAlertViewFailureWithViewController:(UIViewController *)viewController;

+ (void)setAlertViewSucessWithViewController:(UIViewController *)viewController;

//选项：本地，相机，
+ (UIAlertController *)setAlertViewForAddImageWithAlertStyle:(UIAlertControllerStyle)alertStyle array:(NSArray <NSString *>*)titleArray local:(StatusBlock)local camera:(StatusBlock)camera;

//ipad提示
+ (void)setAlertWithViewController:(UIViewController *)viewController  alertStyle:(UIAlertControllerStyle)style sender:(UIView *)sender Title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle cancle:(StatusBlock)cancle sure:(StatusBlock)sure;

+ (UIActivityIndicatorView *)setAlertViewAndFlowersWithViewController:(UIViewController *)viewController;

+ (void)alertControllerWithTitle:(NSString *)title message:( NSString *)message viewController:(UIViewController *)viewController preferredStyle:(UIAlertControllerStyle)preferredStyle textFieldPlaceHolders:(NSArray<NSString *> *) placeholders  sureHandel:(void(^)(NSArray <NSString *>* alterTextFs)) sureHandel cancelHandel:(void(^)()) cancelHander;
+ (UIView *)showViewAtBottomWithViewController:(UIViewController *)viewController string:(NSString *)string
    ;
#pragma mark  ------获取悬浮框--<参数，一个TF，和rectView>----
+ (UIView *)setHelperViewWith:(UITextField *)tf rectView:(UIView *)view;
//小提示，黑背景，自动隐藏
+ (void)saveDataActionWithImage:(UIImage *)image message:(NSString *)message height:(CGFloat)height center:(CGPoint)center superView:(UIView *)superView;
////主要删除按钮
//+ (void)shouldCancelAtBounds:(CGRect)bounds titles:(NSArray *)titleArray onView:(UIView *)superview completion:(void(^)())completion;
//tView 显示
+ (void)setupTview:(UITextView *)tView color:(UIColor *)color string:(NSString *)string maxLength:(NSInteger)maxlength;
//cell 保存编辑 设置TF边框
+ (void)setupCellTFView:(UIView *)view save:(BOOL)issave;

@end
