//
//  AlertViewHelpers.m
//
//  Created by huwei_macmini1 on 16/4/9.
//  Copyright © 2016年 huwei123. All rights reserved.
//

#import "AlertViewHelpers.h"
#import "UILabel+Addition.h"
#import "HDBillingSaveAlertView.h"
#import "HDPoperDeleteView.h"
@implementation AlertViewHelpers

//poperVC
// 生成poperView
+ (UIPopoverController *)getPoperVCWithCustomView:(UIView *)customView popoverContentSize:(CGSize)size {
    
    UIViewController *contentVC = [UIViewController new];
    
     contentVC.view.frame = customView.frame;
    [contentVC.view addSubview:customView];
    UIPopoverController *poperVC = [[UIPopoverController alloc]initWithContentViewController:contentVC];
    poperVC.popoverContentSize = size;
    NSLog(@"%@",customView);
    
    return poperVC;
}

+ (void)setAlertViewWithViewController:(UIViewController *)viewController button:(UIView *)sender {
    [AlertViewHelpers setAlertViewWithMessage:@"暂未开放" viewController:viewController button:sender];
}


//针对pad的弹窗，避免被dismiss至登录界面
+ (void)setAlertViewWithMessage:(NSString *)message viewController:(UIViewController *)viewController button:(UIView *)sender {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:message forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:22];
    button.frame = CGRectMake(0, 0, 200, 50);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIPopoverController *popverController = [AlertViewHelpers getPoperVCWithCustomView:button popoverContentSize:CGSizeMake(200, 50)];
    
    [popverController presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popverController dismissPopoverAnimated:YES];
    });
}


+ (UIView *)setHelperViewWith:(UITextField *)tf rectView:(UIView *)view{
    NSString *string;
    UIColor *textColor;
    if (![tf.text isEqualToString:@""] ) {
        string = tf.text;
        textColor = [UIColor blackColor];
    }else {
        string = tf.placeholder;
        textColor = MAIN_PLACEHOLDER_GRAY;
        
    }
    
    return  [AlertViewHelpers creatTotalViewWith:view string:string color:textColor];
    
}

#pragma mark  ------合成 图片方法------

//合成view
+ (UIView *)creatTotalViewWith:(UIView *)view string:(NSString *)str color:(UIColor *)color{
    
    CGRect rect = [view convertRect:view.bounds toView:KEY_WINDOW];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width - rect.size.height, 0, rect.size.height, rect.size.height)];
    imageView.image = [UIImage imageNamed:@"hd_work_list_item_category.png"];
    
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.placeholder = str;
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [tf setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [tf  setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    tf.backgroundColor = [UIColor whiteColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:rect];
    bgView.backgroundColor = [UIColor clearColor] ;
    [bgView addSubview:tf];
    tf.userInteractionEnabled = NO;
    
    [bgView addSubview:imageView];
    
    return bgView;
}


+ (void)setAlertViewWithMessage:(NSString *)message title:(NSString *)title viewController:(UIViewController *)viewController {
    __weak typeof(viewController) weakSelf = viewController;
    
    //登陆失败
    UIAlertController * alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // 呈现警告视图
    [weakSelf presentViewController:alertDialog animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
}
/*
 * @brief   网络连接失败....
 *
 * @param   <#param#>
 */

+ (void)setAlertViewFailureWithViewController:(UIViewController *)viewController {
    __weak typeof(viewController) weakSelf = viewController;
    
    //登陆失败
    UIAlertController * alertDialog = [UIAlertController alertControllerWithTitle:@"" message:@"网络连接失败..." preferredStyle:UIAlertControllerStyleAlert];
    // 呈现警告视图
    [weakSelf presentViewController:alertDialog animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
}

/*
 * @brief   发布成功
 *
 * @param   <#param#>
 */
+ (void)setAlertViewSucessWithViewController:(UIViewController *)viewController {
    __weak typeof(viewController) weakSelf = viewController;
    
    //登陆成功
    UIAlertController * alertDialog = [UIAlertController alertControllerWithTitle:@"" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
    // 呈现警告视图
    [weakSelf presentViewController:alertDialog animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
}

/*
 * @brief   调起本地相机相册
 *
 * @param   <#param#>
 */

+ (UIAlertController *)setAlertViewForAddImageWithAlertStyle:(UIAlertControllerStyle)alertStyle array:(NSArray<NSString *> *)titleArray local:(StatusBlock)local camera:(StatusBlock)camera {
    
    UIAlertController * userIconAlert = [UIAlertController alertControllerWithTitle:titleArray[0] message:@"" preferredStyle:alertStyle];
    if (titleArray[1]) {
        
        UIAlertAction * chooseFromPhotoAlbum = [UIAlertAction actionWithTitle:titleArray[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            local();
            
        }];
        [userIconAlert addAction:chooseFromPhotoAlbum];
    }
    
    if (titleArray[2]) {
        UIAlertAction * chooseFromCamera = [UIAlertAction actionWithTitle:titleArray[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            camera();
        }];
        [userIconAlert addAction:chooseFromCamera];
    }
    
    UIAlertAction * canelAction = [UIAlertAction actionWithTitle:[titleArray lastObject] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }];
    [userIconAlert addAction:canelAction];
    
    return userIconAlert;
}

/*
 * @brief   带有按钮的Alert
 *
 * @param   <#param#>
 */
+ (void)setAlertWithViewController:(UIViewController *)viewController  alertStyle:(UIAlertControllerStyle)style sender:(UIView *)sender Title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle cancle:(StatusBlock)cancle sure:(StatusBlock)sure {
    
    __weak typeof(viewController) weakSelf = viewController;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    
    if (sureTitle) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            sure();
        }];
        
        [alertVC addAction:sureAction];
    }
    
    if (cancelTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            cancle();
        }];
        [alertVC addAction:cancelAction];
        
    }
    if (sender) {
        alertVC.popoverPresentationController.sourceView = sender;
        alertVC.popoverPresentationController.sourceRect = sender.bounds;
        alertVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    

    
    [weakSelf presentViewController:alertVC animated:YES completion:nil];
}

/*
 * @brief   状态显示
 *
 * @param   <#param#>
 */
+ (UIActivityIndicatorView *)setAlertViewAndFlowersWithViewController:(UIViewController *)viewController {
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth / 2.0 - 40, ScreenHeight/2.0 -40, 80, 80)];
    UIView *view = [UIView new];
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    view.layer.masksToBounds = YES;
    
    view.layer.cornerRadius = 5;
    
    [viewController.view addSubview:view];
    
    UIActivityIndicatorView *flowerView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    flowerView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    flowerView.hidesWhenStopped = YES;
    [flowerView startAnimating];
    [view addSubview:flowerView];
    
    return flowerView;
}



+ (void)alertControllerWithTitle:(NSString *)title message:( NSString *)message viewController:(UIViewController *)viewController preferredStyle:(UIAlertControllerStyle)preferredStyle textFieldPlaceHolders:(NSArray<NSString *> *) placeholders  sureHandel:(void(^)(NSArray <NSString *>* alterTextFs)) sureHandel cancelHandel:(void(^)()) cancelHander{
    
    __weak typeof(viewController) weakSelf = viewController;

    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    UIAlertAction *shureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (sureHandel) {
            
            NSMutableArray *temArr = [NSMutableArray array];
            
            [alertC.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [temArr addObject:obj.text];
            }];
            
            sureHandel([temArr copy]);
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (cancelHander) {
            cancelHander();
        }
    }];
    
    [alertC addAction:shureAction];
    [alertC addAction:cancelAction];
    
    [placeholders enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = placeholders[idx];
        }];
        
    }];
    
    [weakSelf presentViewController:alertC animated:YES completion:nil];

}
+ (UIView *)showViewAtBottomWithViewController:(UIViewController *)viewController string:(NSString *)string{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth / 2.0 - 100, ScreenHeight - 90, 200, 40)];
    UIView *view = [UIView new];

    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 190, 30)];
    
    label.text = string;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    
//    CGFloat width = [UILabel getWidthWithTitle:string font:[UIFont systemFontOfSize:14]];
//    if (width > ScreenWidth - 80)
//    {
//        view.frame = CGRectMake(40, ScreenHeight - 90, ScreenWidth - 80, 40);
//        label.frame = CGRectMake(5, 5, ScreenWidth - 80 - 10, 30);
//    }
//    else
//    {
//        view.frame = CGRectMake((ScreenWidth - width)/2, ScreenHeight - 90, width + 10, 40);
//        label.frame = CGRectMake(5, 5, width, 30);
//    }
    [view addSubview:label];
    [viewController.view addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [view removeFromSuperview];
    });
    return view;
}


#pragma mark  ------小提示框，内结，保修不能打折------

//默认是保存相关 宽度 80 + 文字长度
+ (void)saveDataActionWithImage:(UIImage *)image message:(NSString *)message height:(CGFloat)height center:(CGPoint)center superView:(UIView *)superView {
    NSString *messageNew = @"网络错误";
    if (message) {
        messageNew = message;
    }
    CGRect rectNew = [messageNew boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGRect rect = CGRectMake(0, 0, rectNew.size.width + 80, height);
    
    HDBillingSaveAlertView *view = [HDBillingSaveAlertView getCustomFrame:rect];
    
    if (image) {
        view.imageView.image = image;
    }
    
    if (messageNew) {
        view.messageLb.text = messageNew;
    }
    view.center = center;
    
    [superView addSubview:view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
        
    });
}

+ (void)setupTview:(UITextView *)tView color:(UIColor *)color string:(NSString *)string maxLength:(NSInteger)maxlength {
    tView.contentSize = tView.frame.size;
    tView.text = string;
    tView.textColor = color;
    if (string.length > maxlength) {
        tView.contentInset = UIEdgeInsetsMake(-5, 0, 0, 0);
    }else {
        tView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
//cell 保存编辑状态下，TF的边框，交互
+ (void)setupCellTFView:(UIView *)view save:(BOOL)issave {
    view.userInteractionEnabled = !issave;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderColor = issave ? [UIColor clearColor].CGColor : Color(200, 200, 200).CGColor;
    view.layer.borderWidth = issave ? 0 : 0.5;
    if ([view isKindOfClass:[UITextField class]]) {
        UITextField *tf = (UITextField *)view;
        tf.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5,CGRectGetHeight(tf.frame))];
        tf.leftViewMode = UITextFieldViewModeAlways;
    }
    
}

@end
