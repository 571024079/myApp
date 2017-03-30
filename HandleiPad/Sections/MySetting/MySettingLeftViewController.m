//
//  MySettingFullScreenViewController.m
//  HandleiPad
//
//  Created by Handlecar on 10/17/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "MySettingLeftViewController.h"
#import "AppDelegate.h"
@interface MySettingLeftViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *passwordTextFields;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UITextField *originalPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmpasswordTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)logoutAction:(id)sender;

- (IBAction)confirmButtonAction:(id)sender;
@end

@implementation MySettingLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self configTextFields];
    [self configSwitch];
    _tableview.delegate = self;
    _tableview.dataSource = self;
}

- (void)configTextFields
{
    for (UITextField *textField in self.passwordTextFields)
    {
        textField.delegate = self;
        textField.secureTextEntry = YES;

        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftView;
        
        textField.layer.borderColor = Color(172, 172, 172).CGColor;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 5;
    }
}

- (void)configSwitch
{
    self.soundSwitch.onTintColor = MAIN_BLUE;
    self.notificationSwitch.onTintColor = MAIN_BLUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"aa"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aa"];
        UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 70, 44)];
        text.placeholder = @"请输入";
        [cell.contentView addSubview:text];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.scrollView.contentOffset = CGPointZero;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (IBAction)notificationSwitchChangeAction:(id)sender {
}
- (IBAction)soundSwitchChangeAction:(id)sender {
}
- (IBAction)clearCacheButtonAction:(id)sender {
}

- (IBAction)logoutAction:(id)sender {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] loadEnterViewController:PorscheEnterViewControllerTypeLoginView];
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
