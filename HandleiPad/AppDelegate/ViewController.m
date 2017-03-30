//
//  ViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ViewController.h"
//#import "HDLeftViewController.h"
#import "HDRightViewController.h"
#import "PrintPreviewViewController.h"
#import "HDLeftSingleton.h"

#import "ZLCameraViewController.h"

#import "HDLeftTabBarViewController.h"

#import "BaseNavigationViewController.h"

#import "WebContentViewController.h"
@interface ViewController ()
//左右子视图导航栏控制器
//@property (nonatomic, strong) HDLeftViewController *leftVC;

@property (nonatomic, strong) HDRightViewController *rightVC;    // 流程右侧VC

@property (nonatomic, strong) HDLeftTabBarViewController *leftTabBarVC; // 流程左侧 切换VC

@property (nonatomic, strong) WebContentViewController *webContentViewController;  // 网页内容视图
//全屏显示时，rect数据
@property (nonatomic, strong) NSMutableArray *rectArray;
//日期datePicker


@end

@implementation ViewController


- (void)dealloc {

    NSLog(@"ViewController.dealloc");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [HDLeftSingleton shareSingleton].isHiddenTF = NO;
    [HDLeftSingleton shareSingleton].isBack = NO;    
    [HDLeftSingleton shareSingleton].isSelectedPreDate = NO;
    [HDLeftSingleton shareSingleton].VC = self;
    //右侧控制器(需要先加载右侧的控制器，便于将右侧控制器的通知创建)
    _leftTabBarVC = [HDLeftTabBarViewController new];
    self.masterNav = [[UINavigationController alloc]initWithRootViewController:_leftTabBarVC];
    [self addChildViewController:self.masterNav];
    self.masterNav.navigationBar.translucent = NO;
    
    _rightVC = [HDRightViewController new];
    _rightVC.style = _style;
    self.detailNav = [[UINavigationController alloc]initWithRootViewController:_rightVC];
    [self addChildViewController:self.detailNav];
    self.detailNav.navigationBar.translucent = NO;
    
    [self addGrayLine];
    [self.view addSubview:self.masterNav.view];
    [self.view addSubview:self.detailNav.view];
    
    
    [HDLeftSingleton shareSingleton].leftTabBarVC = _leftTabBarVC;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    // 点击网址点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebContentViewController:) name:WEB_URL_TAP_NOTIFICATION object:nil];
    
    //电池条
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.view addSubview:view];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

- (void)showPreView:(NSDictionary *)noti
{
    PrintPreviewViewController *ppvc = [[PrintPreviewViewController alloc] init];
    ppvc.info = noti;
    [self addChildViewController:ppvc];
    ppvc.view.frame = self.view.frame;
    [self.view addSubview:ppvc.view];
}

- (void)viewWillLayoutSubviews {
    self.masterNav.view.frame = [self.rectArray.firstObject CGRectValue];
    
    self.detailNav.view.frame = CGRectMake(365, 0, CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.masterNav.view.frame), CGRectGetHeight(self.view.frame));

}

- (void)billingBackToFirstView {
    
    [[HDLeftSingleton shareSingleton] cleanData];
    
    [[HDStoreInfoManager shareManager] cleanData];

    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --- 左右视图分割线 ---
- (void)addGrayLine {
    // 左右侧竖线
    UIView *lineRightView = [[UIView alloc] initWithFrame:CGRectMake(364, 0, 1, CGRectGetHeight(self.view.frame))];
    lineRightView.backgroundColor = [UIColor lightGrayColor];
    UIView *lineLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, CGRectGetHeight(self.view.frame))];
    lineLeftView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:lineRightView];
    [self.view addSubview:lineLeftView];
}


- (NSMutableArray *)rectArray {
    
    if (!_rectArray) {
        CGRect rect1 = CGRectMake(0, 0, 364, CGRectGetHeight(self.view.frame));
        CGRect rect2 = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _rectArray = [NSMutableArray arrayWithObjects:[NSValue valueWithCGRect:rect1],[NSValue valueWithCGRect:rect2], nil];
    }
    return _rectArray;
}

- (WebContentViewController *)webContentViewController
{
    if (!_webContentViewController)
    {
        _webContentViewController = [[WebContentViewController alloc] init];
        _webContentViewController.view.frame =  CGRectMake(365, 0, CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.masterNav.view.frame), CGRectGetHeight(self.view.frame));
    }
    return _webContentViewController;
}


- (void)showWebContentViewController:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    NSString *urlStr = [userinfo objectForKey:@"URL"];
    if (urlStr.length)
    {
        if ([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"])
        {
            NSURL *url = [NSURL URLWithString:urlStr];
            self.webContentViewController.safariURL = url;
            
            if (self.webContentViewController.parentViewController == nil)
            {
                // 右侧控制器切换
                [self webContentViewControllerChangeToFront];
            }
        }
    }
    else
    {
        [self webContentViewControllerChangeToDestroy];
    }
}

- (void)webContentViewControllerChangeToFront
{
    [self.detailNav removeFromParentViewController];
    [self.detailNav.view removeFromSuperview];
    
    [self addChildViewController:self.webContentViewController];
    [self.view addSubview:self.webContentViewController.view];
}

- (void)webContentViewControllerChangeToDestroy
{
    [self.webContentViewController removeFromParentViewController];
    [self.webContentViewController.view removeFromSuperview];
    self.webContentViewController = nil;
    if (![self.childViewControllers containsObject:self.detailNav]) {
        [self addChildViewController:self.detailNav];
    }
    if (![self.view.subviews containsObject:self.detailNav.view]) {
        [self.view addSubview:self.detailNav.view];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
