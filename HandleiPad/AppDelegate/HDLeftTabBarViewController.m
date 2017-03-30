//
//  HDLeftTabBarViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/8.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftTabBarViewController.h"
//
#import "BaseNavigationViewController.h"
//开单信息
#import "KandanLeftViewController.h"
//方案库
#import "HDSlitViewLeftViewController.h"
//通知中心
#import "HDLeftNoticeViewController.h"
//设置
#import "MySettingLeftViewController.h"
//单例数据源
#import "HDLeftSingleton.h"
//备件库左侧
#import "MaterialTimeViewController.h"
//服务档案(左侧)
#import "HDServiceRecordsLeftVC.h"
//网络相关
#import "PorscheWebViewController.h"

//顶部按钮
#import "CustomBarItemView.h"

typedef NS_ENUM(NSInteger, HDLeftTabBarViewControllerSubViewsStyle) {
    HDLeftTabBarViewControllerSubViewsStyleList = 0,// 开单
    HDLeftTabBarViewControllerSubViewsStyleNotice,//通知
    HDLeftTabBarViewControllerSubViewsStyleItem,//方案库
    HDLeftTabBarViewControllerSubViewsStyleSet,//设置
    HDLeftTabBarViewControllerSubViewsStyleNet,//
    HDLeftTabBarViewControllerSubViewsStyleMaterialCub,//备件
    HDLeftTabBarViewControllerSubViewsStyleItemCub,//工时
    HDLeftTabBarViewControllerSubViewsStyleProjectCub,//方案
    HDLeftTabBarViewControllerSubViewsStyleService,//服务档案
    
};
@interface HDLeftTabBarViewController ()<UITabBarControllerDelegate>
//切换tabbar的selectedIndex 时 记录显示的index。
@property (nonatomic, assign) HDLeftTabBarViewControllerSubViewsStyle vcShowStyle;

//@0,@1,@2,@3,@4，导航栏lineView的位置，服务档案，工时库，备件库，网络，返回时切换回之前的控制器，
@property (nonatomic, strong) NSNumber *itemBtList;

@property (nonatomic, strong) NSMutableArray *selectedPicArray;
@property (nonatomic, strong) NSMutableArray *itemViewArray;
@property (nonatomic, strong) UIImageView *buttonLine;
@property (nonatomic, strong) NSMutableArray *defaultPicArray;
@end

@implementation HDLeftTabBarViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _style = [[HDLeftSingleton shareSingleton].entryStyle integerValue];
    
    _vcShowStyle = -1;
    [self setMainViewControllers];
    [self setupItem];
    [self addVCAndView];
//    [self getchangeNotifination];
}


/*
- (void)removeSelf:(NSNotification *)sender {
    [self inputSetActionWithType:@2];
}
 
 */
/*
- (void)getchangeNotifination {
    //流程改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtAction:) name:CHANGE_RIGHT_STEP_NOTIFINATION object:nil];
 
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSelf:) name:BACK_FROM_MATERIAL_AND_ITEM_TIME_NOTIFINATION object:nil];
}
*/
#pragma mark  入口 加载需控制器------
//---[dic[@"left"] integerValue]----0.开单接车 1.提醒  2.方案库左侧  3设置     5.备件库 6.工时库 7.方案库 8.服务档案
- (void)addVCAndView {
    switch (_style) {
            //1.开单
        case HDLeftTabBarViewControllerEntryStyleBilling:
            
            //1.在厂车辆
        case HDLeftTabBarViewControllerEntryStyleCarInFac:
        {
            
            [self inputSetActionWithType:@0];
            
        }
            break;
            //4.设置
        case HDLeftTabBarViewControllerEntryStyleSet:
            [self inputSetActionWithType:@3];
            
            break;
            //8.服务档案
        case HDLeftTabBarViewControllerEntryStyleHistory:
            [self inputSetActionWithType:@8];
            
            break;
            //7.方案库
        case HDLeftTabBarViewControllerEntryStyleProject:
        {
            [self inputSetActionWithType:@7];
            
        }
            
            break;
            //2.提醒
        case HDLeftTabBarViewControllerEntryStyleNotice:
        {
            
            [self inputSetActionWithType:@1];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)inputSetActionWithType:(NSNumber *)sender {
//    NSNotification *nottifination = [[NSNotification alloc]initWithName:@"leftBilling" object:@{@"left":sender,@"right":@0} userInfo:nil];
        [self changeBtAction:@{@"left":sender,@"right":@0}];
}

#pragma mark  左侧侧流程切换
//[dic[@"left"] integerValue]-0.开单接车 1.提醒  2.方案库左侧  3设置    5.备件库 6.工时库 7.方案库 8服务档案
- (void)changeBtAction:(NSDictionary *)dic {
    //属于 服务档案回退参数，为nil；
    if (!dic) {
        CustomBarItemView *view = self.itemViewArray[[_itemBtList integerValue]];
        
        [view buttonAction:view.button];//更改之前点击右侧导航栏中的添加时左侧展现方案库，现在展现开单信息
    }else {
//        NSDictionary *dic = sender.object;
        if ([dic[@"left"] integerValue] < 4 && [dic[@"left"] integerValue] >= 0) {
            
            if (_style == HDLeftTabBarViewControllerEntryStyleNotice && [dic[@"left"] integerValue] == 1) {//任务提醒
                BaseNavigationViewController *noticeNAV = self.viewControllers.count > 1 ? [self.viewControllers objectAtIndex:1] : nil;
                HDLeftNoticeViewController *noticeVC = noticeNAV.viewControllers.firstObject;
            }
            
            CustomBarItemView *view = self.itemViewArray[[dic[@"left"] integerValue]];
                [view buttonAction:view.button];
        }else {
            switch ([dic[@"left"] integerValue]) {
                case 5:
                {
                    //设置按钮  点击状态。
                    CustomBarItemView *itemView = self.itemViewArray[2];
                    self.selectedIndex = 5;
                    [self setupLineAndButtonWithView:itemView];
                    _vcShowStyle = 5;
                }
                    break;
                case 6:
                {
                    CustomBarItemView *itemView = self.itemViewArray[2];
                    self.selectedIndex = 6;
                    [self setupLineAndButtonWithView:itemView];
                    _vcShowStyle = 6;
                }
                    break;
                case 7:
                {
                    CustomBarItemView *itemView = self.itemViewArray[2];
                    self.selectedIndex = 7;

                    [self setupLineAndButtonWithView:itemView];
                    _vcShowStyle = 7;
                }
                    break;
                case 8:
                {
                    CustomBarItemView *itemView = self.itemViewArray[0];
                    self.selectedIndex = 8;
                    _vcShowStyle = 8;

                    [self setupLineAndButtonWithView:itemView];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    
}
- (void)setMainViewControllers {
    
    //开单信息
    KandanLeftViewController *listVC = [KandanLeftViewController new];
    BaseNavigationViewController *listNav = [[BaseNavigationViewController alloc]initWithRootViewController:listVC];
    //方案库界面
    HDSlitViewLeftViewController *itemVC = [HDSlitViewLeftViewController new];
    BaseNavigationViewController *itemNav = [[BaseNavigationViewController alloc]initWithRootViewController:itemVC];
    //左侧任务提醒界面
    HDLeftNoticeViewController *noticeVC = [HDLeftNoticeViewController new];
    noticeVC.dataCount = @20;
    BaseNavigationViewController *noticeNav = [[BaseNavigationViewController alloc]initWithRootViewController:noticeVC];
    //设置界面
    MySettingLeftViewController *setVC = [MySettingLeftViewController new];
    BaseNavigationViewController *setNav = [[BaseNavigationViewController alloc]initWithRootViewController:setVC];
    //网络界面
    PorscheWebViewController *netVC = [PorscheWebViewController new];
    BaseNavigationViewController *netNav = [[BaseNavigationViewController alloc]initWithRootViewController:netVC];
    
    //备件库
     MaterialTimeViewController *materialTimeVC = [[MaterialTimeViewController alloc]initWithType:MaterialTaskTimeDetailsTypeMaterial];
    BaseNavigationViewController *materialNav = [[BaseNavigationViewController alloc]initWithRootViewController:materialTimeVC];
    //工时库
     MaterialTimeViewController *itemTimeVC = [[MaterialTimeViewController alloc]initWithType:MaterialTaskTimeDetailsTypeWorkHours];
    BaseNavigationViewController *itemTimeNav = [[BaseNavigationViewController alloc]initWithRootViewController:itemTimeVC];
    //方案库
    MaterialTimeViewController *projectVC = [[MaterialTimeViewController alloc]initWithType:MaterialTaskTimeDetailsTypeScheme];
    BaseNavigationViewController *projectNav = [[BaseNavigationViewController alloc]initWithRootViewController:projectVC];
    //服务档案（左侧）
    HDServiceRecordsLeftVC *serviceLeftVC = [HDServiceRecordsLeftVC new];
    BaseNavigationViewController *serviceLeftNav = [[BaseNavigationViewController alloc]initWithRootViewController:serviceLeftVC];
    
    self.viewControllers = @[listNav,noticeNav,itemNav,setNav,netNav,materialNav,itemTimeNav,projectNav,serviceLeftNav];
    self.tabBar.hidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupItem {
    CGRect rect = CGRectMake(0, 0, 40, 40);
    
    UIBarButtonItem *backItem = [self setupbackCustomViewWith:rect];
    
    WeakObject(self);
    //入口变化时，设置lineView不同位置
    for (NSString *str in self.defaultPicArray) {
        CustomBarItemView *itemView = [[CustomBarItemView alloc]initWithFrame:rect];
        itemView.tag = [self.defaultPicArray indexOfObject:str];
        switch (_style) {
            case HDLeftTabBarViewControllerEntryStyleBilling:
            case HDLeftTabBarViewControllerEntryStyleCarInFac:
            {
                if (itemView.tag == 0) {
                    [itemView addSubview:selfWeak.buttonLine];
                }
                //入口是在场车辆
                if (_style == 2 && itemView.tag == 0) {
                    UINavigationController *listNav = self.viewControllers.firstObject;
                    KandanLeftViewController *listVC = listNav.viewControllers.firstObject;
                    listVC.fullScreenNumber = @1;
                }
            }
                
                break;
                
            case HDLeftTabBarViewControllerEntryStyleNotice:
                if (itemView.tag == 1) {
                    [itemView addSubview:selfWeak.buttonLine];
                }
                break;
            case HDLeftTabBarViewControllerEntryStyleHistory:
                if (itemView.tag == 0) {
                    [itemView addSubview:selfWeak.buttonLine];
                }
                break;
            case HDLeftTabBarViewControllerEntryStyleProject:
                if (itemView.tag == 2) {
                    [itemView addSubview:selfWeak.buttonLine];
                }
                break;
            case HDLeftTabBarViewControllerEntryStyleSet:
                if (itemView.tag == 3) {
                    [itemView addSubview:selfWeak.buttonLine];
                }
                break;
                
            default:
                break;
        }
        [itemView.button setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        WeakObject(itemView)
        itemView.buttonBlock = ^(UIButton *sender) {
            //点击事件
            [selfWeak changeVCWithItemView:itemViewWeak];
        };
        
        [self.itemViewArray addObject:itemView];
    }
    
    [self setNotice:[HDLeftSingleton shareSingleton].noticeCount];

    NSMutableArray *array = [NSMutableArray array];
    for (CustomBarItemView *view in self.itemViewArray) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
        [array addObject:item];
    }
    [array insertObject:backItem atIndex:0];
    self.navigationItem.leftBarButtonItems = array;
}
#pragma mark  设置提醒数量

- (void)setNotice:(NSNumber *)number {
    CustomBarItemView *view = self.itemViewArray[1];
    view.label.hidden = YES;
    if ([number integerValue] > 0) {
        view.label.hidden = NO;
        if ([number integerValue] < 10) {
            view.label.font = [UIFont systemFontOfSize:10];
        }
        if ([number integerValue] > 100) {
//            number = @99;
            view.label.font = [UIFont systemFontOfSize:6];
//            view.label.text = [NSString stringWithFormat:@"%@+",number];
        }
        view.label.text = [NSString stringWithFormat:@"%@",number];

    }
}

//切换控制器，顺带可以初始化设置界面显示
- (void)changeVCWithItemView:(CustomBarItemView *)itemView {
    _itemBtList = @(itemView.tag);
    self.selectedIndex = itemView.tag;
    if (_vcShowStyle != itemView.tag) {
        //设置点击变色，设置lineView
        [self setupButtonImage];
        [self setupLineAndButtonWithView:itemView];
        _vcShowStyle = itemView.tag;

        if (itemView.tag == 1) {
            BaseNavigationViewController *noticeNv = [self.viewControllers objectAtIndex:1];
//            HDLeftNoticeViewController *notice = noticeNv.viewControllers.firstObject;
        }
        
        self.selectedIndex = itemView.tag;
        
        if ((_style == 1 && itemView.tag == 0) || (_style == 2 && itemView.tag == 0) || (_style == 3 && itemView.tag == 1)) {
            
        }else {
            [self settabbarViewAnimation];
            _style = HDLeftTabBarViewControllerEntryStyleUnknow;
        }
    }
    
}
#pragma mark视图动画
- (void)settabbarViewAnimation {
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.3f];
    [animation setType:kCATransitionMoveIn];
    [animation setSubtype:kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [self.view.layer addAnimation:animation forKey:@"switchView"];
}

//返回首页按钮
- (UIBarButtonItem *)setupbackCustomViewWith:(CGRect)rect {
    CustomBarItemView *backItemView = [[CustomBarItemView alloc]initWithFrame:rect];
    WeakObject(self);
    [backItemView.button setImage:[UIImage imageNamed:@"first_view_Item_pic.png"] forState:UIControlStateNormal];
    backItemView.buttonBlock  = ^(UIButton *button) {
        [selfWeak backBtAction:button];
    };
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backItemView];
    return backItem;
}

//返回首页事件
- (void)backBtAction:(UIButton *)sender {
    
    [HDLeftSingleton shareSingleton].collectionViewArray = nil;
    [HDLeftSingleton shareSingleton].allCollectionArray = nil;
    
    [[HDLeftSingleton shareSingleton].VC billingBackToFirstView];
}


//设置按钮点击状态

- (void)setupLineAndButtonWithView:(CustomBarItemView *)itemView {
    WeakObject(self);
    
    [selfWeak setupButtonImage];
    
    [itemView.button setImage:[UIImage imageNamed:selfWeak.selectedPicArray[itemView.tag]] forState:UIControlStateNormal];
    
    if (![itemView.subviews containsObject:selfWeak.buttonLine]) {
        [itemView addSubview:selfWeak.buttonLine];
    }
}

//设置导航栏按钮的默认图片
- (void)setupButtonImage {
    __weak typeof(self) selfWeak = self;
    
    //设置item默认图片
    for (CustomBarItemView *itemView in selfWeak.itemViewArray) {
        [itemView.button setImage:[UIImage imageNamed:selfWeak.defaultPicArray[itemView.tag]] forState:UIControlStateNormal];
    }
}

- (UIImageView *)buttonLine {
    if (!_buttonLine) {
        
        _buttonLine = [[UIImageView alloc]initWithFrame:CGRectMake(6, 37, 28, 5)];
        _buttonLine.image = [UIImage imageNamed:@"header_item_status_pic.png"];
    }
    
    return _buttonLine;
}

- (NSMutableArray *)itemViewArray {
    if (!_itemViewArray) {
        _itemViewArray = [NSMutableArray array];
    }
    return _itemViewArray;
}

//未点击状态下，图片数组

- (NSMutableArray *)defaultPicArray {
    if (!_defaultPicArray) {
        _defaultPicArray = [NSMutableArray arrayWithObjects:@"work_list_35.png",@"work_list_36.png",@"work_list_39.png",@"hd_work_list_Item_setting.png",@"work_list_network_black.png", nil];
    }
    return _defaultPicArray;
}
//点击状态下 图片数组

- (NSMutableArray *)selectedPicArray {
    if (!_selectedPicArray) {
        _selectedPicArray = [NSMutableArray arrayWithObjects:@"work_list_35_selected",@"work_list_36_selected",@"work_list_39_selected",@"hd_work_list_Item_setting_selected", @"work_list_network.png",nil];
    }
    return _selectedPicArray;
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
