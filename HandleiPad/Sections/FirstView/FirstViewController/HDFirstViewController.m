//
//  HDFirstViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/2.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDFirstViewController.h"
#import "FirstBtView.h"
#import "HDAnimations.h"
#import "ViewController.h"
#import "MySettingFullScreenViewController.h"
#import "HDLeftSingleton.h"
#import "RemindModel.h"
#define kAnimationDuration 3.0

#define kAnimationTimeOffset 0.35 * kAnimationDuration

#define kRippleMagnitudeMultiplier 0.25


@interface HDFirstViewController ()<FirstBtViewDelegate>
//用于显示端口号，只在测试的时候进行显示
@property (nonatomic, weak) IBOutlet UILabel *portLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *superView;

@property (nonatomic, strong) NSMutableArray *viewArray;

//@property (nonatomic, strong) ViewController *vc;
@property (nonatomic, strong) RemindModel *remindModel;
//@property (nonatomic, strong) ViewController *vc;

@property (nonatomic, strong) NSArray *labelArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *centerArray;
@property (nonatomic, assign) BOOL isRequest;
@end

@implementation HDFirstViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [_imageView layoutIfNeeded];
    [_superView layoutIfNeeded];
    
    [self supweViewChangeAlpha];
    [self setupBt];
    
    //显示端口号
    [self setPortLabelStyle];
    [self addNotifination];
    
    //17-02-13  预计交车的时间选择弹窗显示的时间过长, 现将弹窗放在单例中,提前创建,缩短创建的时间
    if (![HDLeftSingleton shareSingleton].yujiJiaocheTimeDatePopView) {
        [HDLeftSingleton shareSingleton].yujiJiaocheTimeDatePopView = [HDWorkListDateChooseView getCustomFrame:CGRectMake(0, 0, 500, 300)];
    }
    if (![HDLeftSingleton shareSingleton].keidanListLeftDatePopView) {
        [HDLeftSingleton shareSingleton].keidanListLeftDatePopView = [HDLeftBillingDateChooseView getCustomFrame:CGRectMake(0, 0, 480, 280) withDate:nil];
    }
    
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    _vc = nil;
//    _vc = [ViewController new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[HDLeftSingleton shareSingleton] setFirstVC:self];
    [self getNoticeData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[HDLeftSingleton shareSingleton] setFirstVC:nil];
}

- (void)viewWillLayoutSubviews {
}

- (void)supweViewChangeAlpha {
    self.superView.alpha = 0.1;
    [UIView animateWithDuration:1.0 animations:^{
        self.superView.alpha = 1;
    }];
}



- (void)addNotifination {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogined:) name:NOTICE_MESSAGE_AFTER_LOGINED_NOTIFINATION object:nil];
}

- (void)userLogined:(NSNotification *)sender {
    [self getNoticeData];
}

- (void)setupBt {
    if (self.viewArray.count == 6) {
        return;
    }

    _labelArray = @[@"开单接车",@"在厂车辆",@"任务提醒",@"服务档案",@"方案库",@"我的设置"];
    _imageArray = @[@"hd__first_creat_item.png",@"hd_first_car_in_factory.png",@"hd_first_notice.png",@"hd_first_detial.png",@"hd_first_item.png",@"hd_first_set.png"];
    
    CGPoint center1;
    
    center1.x = 50;
    
    center1.y = 65;
    
    CGPoint center2;
    center2.x = _superView.frame.size.width / 2;
    center2.y = center1.y;
    
    CGPoint center3;
    
    center3.x = _superView.frame.size.width - 50;
    
    center3.y = center1.y;
    
    CGPoint center4;
    center4.x = 50;
    center4.y = _superView.frame.size.height - 65;//间距70(合适)加上 一个View的高度
    
    CGPoint center5;
    center5.x = center2.x;
    center5.y = center4.y;
    
    CGPoint center6;
    center6.x = center3.x;
    center6.y = center4.y;
    
    _centerArray = @[[NSValue valueWithCGPoint:center1],[NSValue valueWithCGPoint:center2],[NSValue valueWithCGPoint:center3],[NSValue valueWithCGPoint:center4],[NSValue valueWithCGPoint:center5],[NSValue valueWithCGPoint:center6]];
    
    for (int i = 0; i < _labelArray.count; i ++) {
        FirstBtView *tmpView = [[FirstBtView alloc]initWithCustomFrame:CGRectMake(0, 0, 100, 130)];
        tmpView.center = [_centerArray[i] CGPointValue];
        
        [tmpView setNeedsLayout];
        tmpView.button.tag = i;
        tmpView.label.text = _labelArray[i];
        tmpView.numLb.hidden = YES;
        tmpView.imageView.image = [UIImage imageNamed:_imageArray[i]];
        tmpView.delegate = self;
        
        [self.viewArray addObject:tmpView];
        
        [self.superView addSubview:tmpView];
        
    }

}

#pragma mark  ------delegate------

- (void)buttonActionClickButton:(UIButton *)sender {
    
    NSInteger number = sender.tag + 1;
    [HDLeftSingleton shareSingleton].entryStyle = @(number);
    ViewController *_vc = [ViewController new];
    switch (sender.tag) {
        case 0:
            _vc.style = ViewControllerEntryStyleBilling;
            if ([HDPermissionManager isNotThisPermission:HDOrder_Kaidan]) {//开单权限
                return;
            } ;
            break;
        case 1:
            if ([HDPermissionManager isNotThisPermission:HDStayFactoryList_Scan])
            {
                return;
            }
            _vc.style = ViewControllerEntryStyleCarInFac;

            break;
        case 2:
            _vc.style = ViewControllerEntryStyleNotice;

            break;
        case 3:
            _vc.style = ViewControllerEntryStyleHistory;

            break;
        case 4:
            _vc.style = ViewControllerEntryStyleProject;

            break;
        case 5:
        {
            _vc.style = ViewControllerEntryStyleSet;
            MySettingFullScreenViewController *myvc = [[MySettingFullScreenViewController alloc] init];
            [self.navigationController pushViewController:myvc animated:YES];
            return;
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:_vc animated:YES];
}


- (void)getNoticeData {

    WeakObject(self);
    [PorscheRequestManager getNoticeWithOrderid:@0 complete:^(NSInteger status, PResponseModel * _Nullable responser) {
        if (status == 100) {
            selfWeak.remindModel = [RemindModel yy_modelWithDictionary:responser.object];
            [selfWeak setNoticeCountWithNumber:selfWeak.remindModel.allnum];
            [HDLeftSingleton shareSingleton].noticeCount = selfWeak.remindModel.allnum;
            [HDLeftSingleton shareSingleton].remindModel = selfWeak.remindModel;
        }
    }];
}

- (void)setNoticeCountWithNumber:(NSNumber *)number {
    if ([number integerValue] > 0) {
        FirstBtView *btView = _viewArray[2];
        btView.numLb.hidden = NO;
        btView.numLb.text = [NSString stringWithFormat:@"%@",number];
    }else {
        FirstBtView *btView = _viewArray[2];
        btView.numLb.hidden = YES;
    }
}
- (void)changeToRemindVC
{
    ViewController *_vc = [ViewController new];
    _vc.style = ViewControllerEntryStyleBilling;
    [self.navigationController pushViewController:_vc animated:NO];
    [self performSelector:@selector(changeWorkFlowWithInfo:) withObject:@{@"left":@1,@"right":@0} afterDelay:1];

}

- (void)changeWorkFlowWithInfo:(NSDictionary *)dict
{
    // vc切换到提醒页面
    [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:dict];
}


- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    
    return _viewArray;
}

- (void)setPortLabelStyle {
    NSURL *url = [NSURL URLWithString:BASE_URL];
    if (![url.port isEqualToNumber:@8689] && ![url.port isEqualToNumber:@9090]) { //开发使用服务器
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
