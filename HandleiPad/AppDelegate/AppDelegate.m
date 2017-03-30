//
//  AppDelegate.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "AppDelegate.h"

#import "ScreenTapView.h"
//登录

//baseNAvi
#import "RootNavigationViewController.h"
#import "HDLoginViewController.h"

#import "HDFirstViewController.h"
#import "HDLeftNoticeViewController.h"
#import "IQKeyboardManager.h"
#import "HDLeftSingleton.h"
//微信SDK头文件
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

// 蒲公英自动更新SDK
#import <PgyUpdate/PgyUpdateManager.h>
#import <PgySDK/PgyManager.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "PorscheCarTypeChooserView.h"
#import <AudioToolbox/AudioToolbox.h>
// 引 JPush功能所需头 件
#import "JPUSHService.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max 
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<JPUSHRegisterDelegate>
{
    NSTimer *_timer;
}
@property(nonatomic, strong) ScreenTapView *tapView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.window makeKeyAndVisible];
    [self setServerAddressDic];//设置服务器地址
    [HDLeftSingleton shareSingleton].stepStatus = 0;
    [self setupRootViewController:PorscheEnterViewControllerTypeNone];;
    
    _tapView = [[ScreenTapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _tapView.backgroundColor = [UIColor clearColor];
    
    [self.window addSubview:_tapView];
    // Override point for customization after application launch.
    
    //设置IQKeyboardManager
    [self configKeyboardManager];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 设置 shareSDK
        [self configShareSDK];
        // 设置 JPush
        [self setupJPushWithOptions:launchOptions];
        // 设置蒲公英
        [self setupPgySDK];
    });

    //通知测试
    //[self setupNotifination:application];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSupportOrientation:) name:INTO_PHOTOLIBRARY_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSupportOrientation:) name:EXIT_PHOTOLIBRARY_NOTIFICATION object:nil];
    _currentOrientationMask = UIInterfaceOrientationMaskLandscape;
    [PorscheConstant shareConstant];
    NSLog(@"本地文件地址：%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
//    [self testSelectCartype];
    
    // 添加提醒轮询
    [self loopCheckNotice];
    
    [[VersionControlManager sharedInstance] checkVersion]; //检查版本更新情况
    return YES;
}

- (void)loopCheckNotice
{
//    NSTimer scheduledTimerWithTimeInterval:<#(NSTimeInterval)#> target:<#(nonnull id)#> selector:<#(nonnull SEL)#> userInfo:<#(nullable id)#> repeats:<#(BOOL)#>
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(changeToRemind:) userInfo:nil repeats:YES];
//    [_timer setFireDate:[NSDate date]];
}

// 测试代码 调试选择车型
- (void)testSelectCartype
{
    PorscheCarTypeChooserView *view = [PorscheCarTypeChooserView viewWithXib];
    view.multipleChoice = YES;
    [HD_FULLView addSubview:view];
}

// 配置蒲公英sdk
- (void)setupPgySDK
{
    // 设置是否反馈
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"3f4857315d3c15d68bed847c629fd7e5"];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"3f4857315d3c15d68bed847c629fd7e5"];

//    [[PgyUpdateManager sharedPgyManager] checkUpdate];

//    [self performSelector:@selector(update) withObject:nil afterDelay:5];
//    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(update:)];

}

- (void)update:(NSDictionary *)response
{
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}

- (void)configKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)setupRootViewController:(PorscheEnterViewControllerType)vcType {
    //获取用户信息
    BOOL logined = [PorscheUserTool userLogined];
    PorscheEnterViewControllerType enterType = logined ? PorscheEnterViewControllerTypeMianView : PorscheEnterViewControllerTypeLoginView;
    
    if (vcType == PorscheEnterViewControllerTypeReceiveRemoteNotification)
    {
        enterType = PorscheEnterViewControllerTypeReceiveRemoteNotification;
    }
    
    [self loadEnterViewController:enterType];
    
    //后台登录
    if (logined) {
        [self backUserLoginRequest];
    }
    else if (vcType == PorscheEnterViewControllerTypeReceiveRemoteNotification)
    {
        [self backUserLoginRequest];
    }
}

- (void)loadEnterViewController:(PorscheEnterViewControllerType)enterType {
    
    switch (enterType) {
        case PorscheEnterViewControllerTypeLoginView:
        {
            
            HDLoginViewController *loginVC = [HDLoginViewController new];
            RootNavigationViewController *baseNavi = [[RootNavigationViewController alloc]initWithRootViewController:loginVC];
            baseNavi.navigationBarHidden = YES;
            self.window.rootViewController = baseNavi;
            [PorscheUserTool setUserLogined:NO];
        }
            break;
        case PorscheEnterViewControllerTypeMianView:
        {
            HDFirstViewController *firstVC = [HDFirstViewController new];
            RootNavigationViewController *baseNavi = [[RootNavigationViewController alloc]initWithRootViewController:firstVC];
            firstVC.navigationController.navigationBarHidden = YES;
            baseNavi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.window.rootViewController = baseNavi;
            [PorscheUserTool setUserLogined:YES];
        }
            break;
        case PorscheEnterViewControllerTypeReceiveRemoteNotification:
        {
            HDFirstViewController *firstVC = [HDFirstViewController new];
            RootNavigationViewController *baseNavi = [[RootNavigationViewController alloc]initWithRootViewController:firstVC];
            firstVC.navigationController.navigationBarHidden = YES;
            baseNavi.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            self.window.rootViewController = baseNavi;
            [PorscheUserTool setUserLogined:YES];
            
            //
            [firstVC changeToRemindVC];
        }
            break;
        case PorscheEnterViewControllerTypeNone:
            break;
    }
    
}

- (void)backUserLoginRequest {
    
    [PorscheRequestManager loginRequestWithBackstagecomplete:^(id  _Nullable model, NSError * _Nullable error) {
        PResponseModel* responser = (PResponseModel *)model;
        if (responser.status != 100) {
            //用户登录失败，进入登录界面
            [self loadEnterViewController:PorscheEnterViewControllerTypeLoginView];
        }
    }];
}


#pragma  mark - 获取device Token
//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    //解析NSData获取字符串
    //正确写法
//    NSString *deviceString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//获取DeviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
   NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)setupJPushWithOptions:(NSDictionary *)launchOptions
{
    // Required
    // notice: 3.0.0及以后版本注册可以这样写，也可以继续 旧的注册 式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    // |JPAuthorizationOptionBadge
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加 定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册 法，改成可上报IDFA，如果没有使 IDFA直接传nil
    // 如需继续使 pushConfig.plist 件声明appKey等配置内容，请依旧使 [JPUSHService setupWithOption:launchOptions] 式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"f534f0841f74d773e4f9f95c"
                          channel:@"enterprise"
                 apsForProduction:0
            advertisingIdentifier:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)changeSupportOrientation:(NSNotification *)notification
{
    if ([notification.name isEqualToString:INTO_PHOTOLIBRARY_NOTIFICATION])
    {
        _currentOrientationMask = UIInterfaceOrientationMaskAll;
    }
    else if ([notification.name isEqualToString:EXIT_PHOTOLIBRARY_NOTIFICATION])
    {
        _currentOrientationMask = UIInterfaceOrientationMaskLandscape;
    }
//    [self application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.window];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return _currentOrientationMask;
}

#pragma mark -- shareSDK 配置 ---
- (void)configShareSDK
{
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/lo gin 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"19e1087cb1c07"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx94a18a3c249eb78e"
                                       appSecret:@"6b043e57eb92284aac74467b5354deac"];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support  前台收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger)
                                                               )completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]
        ]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [self changeToRemind:userInfo];
//        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive )
//        {
//            AudioServicesPlaySystemSound(1007);
//        }
    }
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound); // 需要执 这个 法，选择 是否提醒 户，有Badge、Sound、Alert三种类型可以选择设置 蒙
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)
                                                                          ())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        // 接收到通知后处理
//        self.remoteNotificationUserInfo = userInfo;
//        
        [self changeToRemind:userInfo];
    }
    completionHandler(); // 系统要求执 这个 法
}

- (void)changeToRemind:(NSDictionary *)userInfo
{

    
//    if ([[HDLeftSingleton shareSingleton].leftVC isKindOfClass:NSClassFromString(@"HDLeftNoticeViewController")])
//    {
//        HDLeftNoticeViewController *leftVC = (HDLeftNoticeViewController *)[HDLeftSingleton shareSingleton].leftVC;
//        [leftVC reloadDataWithInfo:userInfo];
//    }
//    else if ([HDLeftSingleton shareSingleton].VC)
//    {
//        [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:@{@"left":@1,@"right":@0}];
//    }
//    else
//    {
//        [self setupRootViewController:PorscheEnterViewControllerTypeReceiveRemoteNotification];
//    }

    // 请求总消息数量
    
#pragma mark -- 刷新消息数量

        //    NSNumber *orderid = [[HDStoreInfoManager shareManager] carorderid];
    
    if ([[HDUtils readCustomClassConfig:@"servivAddress"] length]) {
        [PorscheRequestManager getNoticeWithOrderid:@0 complete:^(NSInteger status, PResponseModel * _Nullable responser) {
            if (status == SUCCESS_STATUS)
            {
                RemindModel *remindModel = [RemindModel yy_modelWithDictionary:responser.object];
                [[HDLeftSingleton shareSingleton] setNoticeCount:remindModel.allnum];
                [[HDLeftSingleton shareSingleton] setRemindModel:remindModel];
            }
        }];
    }
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
        // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    // 接收到通知后处理
//    self.remoteNotificationUserInfo = userInfo;//
//    NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"消息提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看",nil];
//    [alertView show];
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive )
    {
        AudioServicesPlaySystemSound(1007);
    }
    
    [self changeToRemind:self.remoteNotificationUserInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != 0) {
        [self changeToRemind:self.remoteNotificationUserInfo];
    }
    else
    {
        self.remoteNotificationUserInfo = nil;
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
        // Required,For systems with less than or equal to iOS6
        [JPUSHService handleRemoteNotification:userInfo];
//    // 接收到通知后处理
//    self.remoteNotificationUserInfo = userInfo;
//    
    [self changeToRemind:userInfo];
}

#pragma mark -- 创建本地通知
- (void)createLocalNotification
{
    
}


#pragma mark - 添加服务其地址
- (void)setServerAddressDic {
    NSDictionary *serverAddressDic = @{@"8688":@"http://106.14.38.215:8688",
                                   @"8600":@"http://106.14.38.215:8600",
                                   @"8989":@"http://106.14.16.216:8989",
                                   @"长沙保时捷中心":@"http://106.14.16.216:9090"};
    [HDUtils setCustomClassConfig:@"serverAddressDic" value:serverAddressDic];
    [HDUtils saveConfig];
}


@end
