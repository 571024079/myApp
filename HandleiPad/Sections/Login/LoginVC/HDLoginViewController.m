//
//  HDLoginViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLoginViewController.h"
#import "ViewController.h"
#import "BaseNavigationViewController.h"
//首页
#import "HDFirstViewController.h"
#import "AppDelegate.h"
#import "HDLeftSingleton.h"
#import "HDServerSettingView.h"
@interface HDLoginViewController ()<UITextFieldDelegate>
//用于显示端口号，只在测试的时候进行显示
@property (nonatomic, weak) IBOutlet UILabel *portLabel;

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UIButton *loginBt;

@property (weak, nonatomic) IBOutlet UIButton *rememberPasswordBt;

//输入时，全屏按钮收键盘
@property (weak, nonatomic) IBOutlet UIButton *hiddenBt;

@property (nonatomic, assign) CGRect localRect;

//用户名rect
@property (nonatomic, assign) CGRect userTect;
//密码Rect
@property (nonatomic, assign) CGRect passwordRect;

@property (weak, nonatomic) IBOutlet UIImageView *rememberImg;


@end

@implementation HDLoginViewController

- (void)dealloc {
    
    NSLog(@"登录页面释放");
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[HDLeftSingleton shareSingleton] cleanData];
    
    [[HDStoreInfoManager shareManager] cleanData];
}

// 配置端口号
- (IBAction)configPort:(id)sender {
    NSLog(@"点击");
    
    HDServerSettingView *serverPopView = [[[NSBundle mainBundle] loadNibNamed:@"HDServerSettingView" owner:self options:nil] firstObject];
    
    [KEY_WINDOW addSubview:serverPopView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userNameTF.delegate = self;
    
    _passwordTF.delegate = self;
    
    _localRect = self.view.frame;
    
    CGRect rect = _localRect;
    
    rect.origin.y -= 100;
    
    _userTect = rect;
    
    rect.origin.y -= 100;
    
    _passwordRect = rect;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self configUserInfo];
    
    //显示端口号
    [self setPortLabelStyle];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)touchBegin {
    
    if (_userNameTF.isFirstResponder || _passwordTF.isFirstResponder) {
        
        __weak typeof(self) selfWeak = self;
        
        [UIView animateWithDuration:0.3 animations:^{
            selfWeak.view.frame = selfWeak.localRect;
        }];
    }
    
   // [super touchBegin];  
}


- (IBAction)loginBtAction:(UIButton *)sender {

    [self.view endEditing:YES];
    NSString *username = self.userNameTF.text;
    NSString *password = self.passwordTF.text;
    
    if (username.length < 1) {
        [MBProgressHUD showMessageText:@"请输入用户名" toView:KEY_WINDOW anutoHidden:YES];
        return;
    }
    if (password.length < 1) {
        [MBProgressHUD showMessageText:@"请输入密码" toView:KEY_WINDOW anutoHidden:YES];
        return;
    }
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
    hub.label.text = @"正在登录...";
    
    __weak typeof(self)weakself = self;
    [PorscheRequestManager loginRequestWith:username password:password complete:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
       
        if (error) {
            if (error.code == -1002 || error.code == 404) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    hub.mode = MBProgressHUDModeText;
                    hub.label.text = @"服务器地址错误";
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    hub.mode = MBProgressHUDModeText;
                    hub.label.text = @"网络错误";
                });
            }
        }  else if (responser.status != 100) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hub.mode = MBProgressHUDModeText;
                hub.label.text = @"用户名或密码有误";
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                hub.mode = MBProgressHUDModeText;
                hub.label.text = @"登录成功";
            });
            
            [weakself updateUserInfo];
            [weakself enterIntoFirstViewController];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hub hideAnimated:YES afterDelay:1.0];
        });
    }];
}

- (void)enterIntoFirstViewController {
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate loadEnterViewController:PorscheEnterViewControllerTypeMianView];
}

- (void)updateUserInfo {
    
    NSString *username = self.userNameTF.text;
//    NSString *password = self.rememberPasswordBt.selected ? self.passwordTF.text :@"";
    NSString *password = self.passwordTF.text.length ? self.passwordTF.text :@"";

    if (_rememberImg.image) {
        [PorscheUserTool saveUserName:username password:password];
    }else {
        [PorscheUserTool saveUserName:username password:@""];
    }
}

- (void)configUserInfo {
    
    NSDictionary *userinfo = [PorscheUserTool getUserInfo];
    
    NSString *username = [userinfo objectForKey:@"username"];
    NSString *password = [userinfo objectForKey:@"password"];
    
    self.userNameTF.text = username;
    self.passwordTF.text = password;
    if (![password isEqualToString:@""]) {
        [self rememberPasswordBtAction:self.rememberPasswordBt];
    }
}

- (IBAction)rememberPasswordBtAction:(UIButton *)sender {
    NSString *imagestring = nil;
    if (!sender.selected) {
        imagestring = @"work_list_29.png";
    }else {
        imagestring = nil;
    }
    _rememberImg.image = [UIImage imageNamed:imagestring];
    sender.selected = !sender.selected;
}

#pragma mark  ------delegate------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark  ------lazy------



#pragma mark  ------竖屏设置------

//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//
//- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;;
//}
//
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait |UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
//}




- (void)setPortLabelStyle {
    NSURL *url = [NSURL URLWithString:BASE_URL];
    if (![url.port isEqualToNumber:@8689]) { //开发使用服务器
        _portLabel.text = [url.port stringValue];
        _portLabel.hidden = NO;
        _portLabel.textColor = MAIN_RED;
    }else { //测试用服务器
        _portLabel.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
