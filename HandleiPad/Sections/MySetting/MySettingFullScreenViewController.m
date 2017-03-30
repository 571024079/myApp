//
//  MySettingFullScreenViewController.m
//  HandleiPad
//
//  Created by Handlecar on 10/17/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "MySettingFullScreenViewController.h"
#import "AppDelegate.h"

@interface MySettingFullScreenViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *passwordTextFields;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *originalPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmpasswordTextField;

@property (weak, nonatomic) IBOutlet UIView *notificationView;
- (IBAction)confirmButtonAction:(id)sender;
@end

@implementation MySettingFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTextFields];
    [self configSwitch];
    [self addBorderToView:_notificationView];
    [self addBorderToView:_passwordView];
    self.scrollView.contentSize = CGSizeMake(0, 768);
}

- (void)addBorderToView:(UIView *)view
{
    view.layer.cornerRadius = 5;
    view.layer.borderColor = ColorHex(0xB5B5B5).CGColor;
    view.layer.borderWidth = 1;
}

- (void)configTextFields
{
    for (UITextField *textField in self.passwordTextFields)
    {
        textField.delegate = self;
        textField.secureTextEntry = YES;
    }
}

- (void)configSwitch
{
    self.soundSwitch.onTintColor = MAIN_BLUE;
    self.notificationSwitch.onTintColor = MAIN_BLUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)logoutAction:(id)sender {
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate loadEnterViewController:PorscheEnterViewControllerTypeLoginView];
}

- (IBAction)notificationSwitchChangeAction:(id)sender {
}
- (IBAction)soundSwitchChangeAction:(id)sender {
}
- (IBAction)clearCacheButtonAction:(id)sender {
}

- (IBAction)confirmButtonAction:(id)sender {
    
    if (![HDPermissionManager isHasThisPermission:HDMySet_ChangePassWord]) {
        return;
    }
    
    if (!_originalPasswordTextField.text.length) {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"请输入原密码" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
        return;
    }
    if (!_newpasswordTextField.text.length || !_confirmpasswordTextField.text.length) {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"请输入新密码" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
        return;
    }else {
        if (![_newpasswordTextField.text isEqualToString:_confirmpasswordTextField.text]) {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"两次输入的新密码不一致" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
            return;
        }
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:_originalPasswordTextField.text forKey:@"password"];
    [param hs_setSafeValue:_newpasswordTextField.text forKey:@"newpassword"];
    
    [PorscheRequestManager userChangePasswordWithParam:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            [AlertViewHelpers saveDataActionWithImage:nil message:@"修改成功" height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate performSelector:@selector(loadEnterViewController:) withObject:PorscheEnterViewControllerTypeLoginView afterDelay:1];
        }
    }];
}
@end
