//
//  MaterialTaskTimeDetailsView.m
//  KeyBoardDemo
//
//  Created by Robin on 2016/10/15.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialTaskTimeDetailsView.h"


//配件/工时的列表cell
#import "ProjectDetailTableView.h"
//适用车型，公里数cell
#import "ProjectCarStyleAndDisTableViewCell.h"
//新公里数cell
#import "ProjectMileageStyleTableViewCell.h"
//方案分类cell
//#import "HDWorkListCollectionViewCell.h"
#import "ProjectDetailPlanTableViewCell.h"
//上面的tableVIew编辑样式cell
#import "ProjectDetialEditTableViewCell.h"
//公里数编辑页面
#import "ProjectDetialEditMileageView.h"
//车型选择框
#import "HDWorkListTableViews.h"
//车型选择模型
#import "PorscheCustomModel.h"
//方案编辑页面
#import "ProjectDetialEditPlanView.h"
//车型model
#import "ProjectCarStyleCollectionViewCellModel.h"
//选择器
#import "PorscheCustomView.h"
//间隔时间范围选择器
#import "ProjectDetialEditTimerView.h"

#import "PorscheCarTypeChooser.h"

#import "MBProgressHUD+PorscheHUD.h"
#import "HDLeftSingleton.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define BackGroudColor [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:249.0/255.0]
#define DETAILVIEW_WIDTH 744
//[UIScreen mainScreen].bounds.size.width*2/3

//适用车型cell
NSString *carStyleCellID = @"ProjectCarStyleAndDisTableViewCell";


NSString *carSectionName = @"适用车型";
NSString *mileageSectionName = @"公里数范围";

@class MaterialTaskTimeDetailsView;
@interface MaterialTaskTimeDetailsView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewLeadingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdViewWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewCentYLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthViewLeadingLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveAndAddToOrderButtonLeadingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secodeButtonTrailingLayout;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ThirdViewLeadingLayout;



@property (nonatomic, copy) NSArray *dataSource;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveAndAddToOrderButton;
//自定义数据
//@property (nonatomic, strong) NSArray *carCellNames;
//添加方案分类
@property (nonatomic, strong) NSMutableArray *addPicArray;
//分类背景图字典
@property (nonatomic, strong) NSMutableDictionary *picDic;
//数据类型图标
@property (nonatomic, strong) NSMutableArray *categoryArray;
//备件数量
@property (nonatomic ,assign) NSInteger materialCount;
//适用车型的cell高度
@property (nonatomic, assign) CGFloat cartypeCellHeight;

@property (nonatomic, copy) NSString *carLine;
@property (nonatomic, copy) NSString *carType;
@property (nonatomic, copy) NSString *carYear;
@property (nonatomic, copy) NSString *carCC;

@property (nonatomic, strong) UIView *clearView; //放车型选择器的空白view
@property (nonatomic, strong) ProjectDetialEditMileageView *editMileageView; //公里编辑view
@property (nonatomic, strong) ProjectDetialEditTimerView *editTimerView;//时间间隔编辑View
@property (nonatomic, strong) ProjectDetialEditPlanView *editPlanView; //公里编辑view

@property (nonatomic, strong) UIView *cleanView;

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) PorscheSchemeModel *schemeModel; //方案的model
@property (nonatomic, strong) PorscheWorkHoursModel *workHourModel; //方案的model
@property (nonatomic, strong) PorscheSperaModel *speraModel; //备件model

@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;

@property (nonatomic, assign) BOOL is_formNotice;//来自本店方案提醒
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (nonatomic, copy) NSNumber *modelId;
@end

@implementation MaterialTaskTimeDetailsView {
    
    BOOL _keyBoardVisible;
}


+ (void)showNotificationSchemeDetail:(NSInteger)schemeid noticeID:(NSInteger)noticeid shouldAddToOrder:(BOOL)isShould clickAction:(MaterialTaskTimeDetailsCustomViewClickBlock)clickAction{
    
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    
    WeakObject(hub);
    [PorscheRequestManager notificationSchemeDetailWithSchemeID:schemeid noticeID:noticeid completion:^(PorscheSchemeModel * _Nullable porschemeModel, PResponseModel * _Nullable responser) {
        
        if (responser.status != 100 || !porschemeModel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hubWeak changeTextModeMessage:responser.msg toView:KEY_WINDOW];
                [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_DETAIL_REFRESH_MYFAVORITE_NOTIFICATION object:nil];

            });
            return ;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hubWeak hideAnimated:YES];
        });
//        MaterialTaskTimeDetailsView *detailView = [MaterialTaskTimeDetailsView showSchemeDetailViewWithModel:porschemeModel];
//        detailView.is_formNotice = YES;
//        detailView.detailType = MaterialTaskTimeDetailsTypeScheme;
//        detailView.backBlock = clickAction;
//        detailView.edit = NO;
//        if (!isShould)
//        {
//            detailView.secondViewWidthLayout.constant = 0;
//            detailView.leftViewWidthLayout.constant = DETAILVIEW_WIDTH / 2.0f;
//        }
//        [detailView show];
        
        MaterialTaskTimeDetailsView *detailView = [MaterialTaskTimeDetailsView showSchemeDetailViewWithModel:porschemeModel];
        detailView.detailType = MaterialTaskTimeDetailsTypeScheme;
        detailView.is_formNotice = YES;

        detailView.edit = NO;
        detailView.backBlock = clickAction;
        [detailView show];
    }];

}

+ (void)showOrderSchemeWithScheme:(PorscheSchemeModel *)orderSchemeModel clickAction:(MaterialTaskTimeDetailsOrderViewClickBlock)clickAction {
    
    MaterialTaskTimeDetailsView *detailView = [MaterialTaskTimeDetailsView showSchemeDetailViewWithModel:orderSchemeModel];
    detailView.detailType = MaterialTaskTimeDetailsTypeScheme;
    detailView.edit = YES;
    detailView.orderBackBlock = clickAction;
    [detailView.saveAndAddToOrderButton setTitle:@"保存方案并更新工单" forState:UIControlStateNormal];
    [detailView show];
}


+ (void)showWithID:(NSInteger)modelid detailType:(MaterialTaskTimeDetailsType)detailType {
    
    [MaterialTaskTimeDetailsView showWithID:modelid detailType:detailType clickAction:NULL];
}

+ (void)showWithID:(NSInteger)modelid detailType:(MaterialTaskTimeDetailsType)detailType clickAction:(MaterialTaskTimeDetailsCustomViewClickBlock)clickAction {
    
    if (!modelid) { //新建
        switch (detailType) {
            case MaterialTaskTimeDetailsTypeScheme:
            {
                
            }
                break;
            case MaterialTaskTimeDetailsTypeMaterial:
            {
                PorscheSperaModel *speraModel = [PorscheSperaModel new];
                speraModel.parts.parts_type = @(99);
                MaterialTaskTimeDetailsView *detailView = [MaterialTaskTimeDetailsView showSperaDetailViewWithModel:speraModel];
                detailView.detailType = detailType;
                detailView.new_object = YES;
                detailView.backBlock = clickAction;
                [detailView show];
            }
                break;
            case MaterialTaskTimeDetailsTypeWorkHours:
            {
                PorscheWorkHoursModel *workHourModel = [PorscheWorkHoursModel new];
                workHourModel.workhour.workhourtype = @(99);
                MaterialTaskTimeDetailsView *detailView = [MaterialTaskTimeDetailsView showWorkHourDetailViewWithModel:workHourModel];
                detailView.detailType = detailType;
                detailView.new_object = YES;
                detailView.backBlock = clickAction;
                [detailView show];
            }
                break;
            default:
            {
            }
                break;
        }
        return;
    }
    
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    
    WeakObject(hub);
    
    switch (detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            [PorscheRequestManager schemeDetailWithSchemeID:modelid completion:^(PorscheSchemeModel * _Nullable porschemeModel, NSError * _Nullable error) {
                
                if (error || !porschemeModel) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *hint = error ? @"网络错误" : @"系统报错";
                        [hubWeak changeTextModeMessage:hint toView:KEY_WINDOW];
                    });
                    return ;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hubWeak hideAnimated:YES];
                });
                MaterialTaskTimeDetailsView *detailView = [MaterialTaskTimeDetailsView showSchemeDetailViewWithModel:porschemeModel];
                detailView.detailType = detailType;
                detailView.edit = NO;
                detailView.backBlock = clickAction;
                [detailView show];
            }];
            
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            [PorscheRequestManager speraDetailWithSperaID:modelid completion:^(PorscheSperaModel * _Nullable speraModel, NSError * _Nullable error) {
                
                if (error || !speraModel) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *hint = error ? @"网络错误" : @"系统报错";
                        [hubWeak changeTextModeMessage:hint toView:KEY_WINDOW];
                    });
                    return ;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hubWeak hideAnimated:YES];
                });
                MaterialTaskTimeDetailsView *detailView = [MaterialTaskTimeDetailsView showSperaDetailViewWithModel:speraModel];
                detailView.detailType = detailType;
                detailView.edit = NO;
                detailView.backBlock = clickAction;
                [detailView show];
            }];
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            
            [PorscheRequestManager workHourDetailWithWorkHourID:modelid completion:^(PorscheWorkHoursModel * _Nullable workHourModel, NSError * _Nullable error) {
                
                if (error || !workHourModel) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *hint = error ? @"网络错误" : @"系统报错";
                        [hubWeak changeTextModeMessage:hint toView:KEY_WINDOW];
                    });
                    return ;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hubWeak hideAnimated:YES];
                });
                MaterialTaskTimeDetailsView *detailView = [MaterialTaskTimeDetailsView showWorkHourDetailViewWithModel:workHourModel];
                detailView.detailType = detailType;
                detailView.edit = NO;
                detailView.backBlock = clickAction;
                [detailView show];
            }];
        }
            break;
        default:
        {
        }
            break;
    }
}


- (void)show {
    
    UIView *clear = [[UIView alloc] initWithFrame:KEY_WINDOW.bounds];
    clear.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = clear.bounds;
    [btn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [clear addSubview:btn];
    [clear addSubview:self];
    [HD_FULLView addSubview:clear];
}

- (void)closeView:(UIButton *)btn {
    
    if (self.edit) return;
    //通知界面刷新
    [self postNotificationMyFavoriteToRefresh];
    [btn.superview removeFromSuperview];
}

+ (instancetype)showSchemeDetailViewWithModel:(PorscheSchemeModel *)schemeModel {

    NSInteger count = schemeModel.workhourlist.count + schemeModel.sparelist.count;
    NSInteger rowCount = count > 4 ? 4 : count;
    
    return [MaterialTaskTimeDetailsView prepareShowDetailViewWithItemCount:rowCount speraModel:nil workHourModel:nil schemeModel:schemeModel detailType:MaterialTaskTimeDetailsTypeScheme];
}

+ (instancetype)showSperaDetailViewWithModel:(PorscheSperaModel *)speraModel {

    return [MaterialTaskTimeDetailsView prepareShowDetailViewWithItemCount:1 speraModel:speraModel workHourModel:nil schemeModel:nil detailType:MaterialTaskTimeDetailsTypeMaterial];
}

+ (instancetype)showWorkHourDetailViewWithModel:(PorscheWorkHoursModel *)workHourModel {
    
    return [MaterialTaskTimeDetailsView prepareShowDetailViewWithItemCount:1 speraModel:nil workHourModel:workHourModel schemeModel:nil detailType:MaterialTaskTimeDetailsTypeWorkHours];
}

+ (instancetype)prepareShowDetailViewWithItemCount:(NSInteger)count speraModel:(PorscheSperaModel *)speraModel workHourModel:(PorscheWorkHoursModel *)workHourModel schemeModel:(PorscheSchemeModel *)schemeModel detailType:(MaterialTaskTimeDetailsType)detailType{
    
    MaterialTaskTimeDetailsView *detailsView = [[[NSBundle mainBundle] loadNibNamed:@"MaterialTaskTimeDetailsView" owner:nil options:nil] lastObject];
    detailsView.is_formNotice = NO;
    detailsView.speraModel = speraModel;
    detailsView.workHourModel = workHourModel;
    detailsView.schemeModel = schemeModel;
    detailsView.edit = NO;
    
    detailsView.materialCount = count;
    CGFloat viewH = 410 + detailsView.materialCount * 44;
    switch (detailType) {
        case MaterialTaskTimeDetailsTypeMaterial:
            viewH = 410 - 44;
            break;
        case MaterialTaskTimeDetailsTypeScheme:
            viewH += 44;
            break;
        default:
            break;
    }

    detailsView.frame = CGRectMake(100, 100, DETAILVIEW_WIDTH, viewH);
    detailsView.viewHeight = viewH;
    detailsView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
    detailsView.cartypeCellHeight = 85.0;
    detailsView.detailType = detailType;
    detailsView.layer.cornerRadius = 6;
    detailsView.clipsToBounds = YES;
    
    
    [detailsView setupConfig];
    [detailsView registerForKeyBoardNotifinations];
    
    return detailsView;

}

+ (instancetype)viewWithDataSource:(NSArray *)dataSource DetailType:(MaterialTaskTimeDetailsType)detailType {
    
    MaterialTaskTimeDetailsView *detailsView = [[[NSBundle mainBundle] loadNibNamed:@"MaterialTaskTimeDetailsView" owner:nil options:nil] lastObject];
    /*
     调试配置
     */
//    detailsView.detailType = MaterialTaskTimeDetailsTypeWorkHours;
    detailsView.materialCount = detailType == MaterialTaskTimeDetailsTypeScheme ? 4:1;

    //
    CGFloat viewH = 410 + detailsView.materialCount * 44;
    switch (detailType) {
        case MaterialTaskTimeDetailsTypeMaterial:
            viewH = 410 - 44;
            break;
        case MaterialTaskTimeDetailsTypeScheme:
            viewH += 44;
            break;
        default:
            break;
    }

    detailsView.frame = CGRectMake(100, 100, DETAILVIEW_WIDTH, viewH);
    detailsView.viewHeight = viewH;
    detailsView.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
    detailsView.dataSource = dataSource;
    detailsView.cartypeCellHeight = 85.0;
    detailsView.detailType = detailType;
    detailsView.layer.cornerRadius = 6;
    detailsView.clipsToBounds = YES;
    
    [detailsView setupConfig];
    [detailsView registerForKeyBoardNotifinations];
    
    return detailsView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIEdgeInsets imageEdgeInset = UIEdgeInsetsMake(12, 0, 12, 0);
    
    self.firstButton.imageEdgeInsets = imageEdgeInset;
    self.secondButton.imageEdgeInsets = imageEdgeInset;
    self.thirdButton.imageEdgeInsets = imageEdgeInset;
    self.fourthButton.imageEdgeInsets = imageEdgeInset;
}

- (void)setupConfig {
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            
            self.titleLabel.text = self.edit ? @"编辑方案" : self.schemeModel.schemename ;
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            self.titleLabel.text = self.edit ? @"编辑备件" : self.speraModel.parts.parts_name;
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {

            self.titleLabel.text = self.edit ? @"编辑工时" : self.workHourModel.workhour.workhourname;
        }
            break;
        default:
            break;
    }
}

- (void)setNew_object:(BOOL)new_object {
    _new_object = new_object;
    
    self.edit = new_object;
}

//观察键盘
- (void)registerForKeyBoardNotifinations {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardShow:(NSNotificationCenter *)notificationCenter {
    
    _keyBoardVisible = YES;
}
- (void)keyBoardHidden:(NSNotificationCenter *)notificationCenter {
    
    _keyBoardVisible = NO;
}

- (void)setEdit:(BOOL)edit {
    _edit = edit;
    
    NSString *firstTitle = edit ? @"保存":@"编辑";
    NSString *firstImageName = edit ? @"hd_item_detial_project_buy.png":@"hd_item_detial_project_edit.png";
    UIImage *firstImage = [[UIImage imageNamed:firstImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.firstButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.firstButton setTitle:firstTitle forState:UIControlStateNormal];
    [self.firstButton setImage:firstImage forState:UIControlStateNormal];
    
    NSString *secondTitle = edit ? @"保存为我的":@"加入工单";
    NSString *secondImageName = edit ? @"materialtime_edit_save.png":@"hd_item_detial_project_buy.png";
    UIImage *secondImage = [[UIImage imageNamed:secondImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.secondButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.secondButton setTitle:secondTitle forState:UIControlStateNormal];
    [self.secondButton setImage:secondImage forState:UIControlStateNormal];
    
    
    self.saveAndAddToOrderButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.saveAndAddToOrderButton setImage:secondImage forState:UIControlStateNormal];

    NSString *thirtdTitle = edit ? @"删除":@"删除";
    NSString *thirtdImageName = @"porsche_icon_trash";
    UIImage *thirtdImage = [[UIImage imageNamed:thirtdImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.thirdButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.thirdButton setTitle:thirtdTitle forState:UIControlStateNormal];
    [self.thirdButton setImage:thirtdImage forState:UIControlStateNormal];
    
    NSString *fourthTitle = edit ? @"取消":@"返回";
    NSString *fourthImageName = @"materialtime_list_backArrow";
    UIImage *fourthImage = [[UIImage imageNamed:fourthImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.fourthButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.fourthButton setTitle:fourthTitle forState:UIControlStateNormal];
    [self.fourthButton setImage:fourthImage forState:UIControlStateNormal];
    
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
            [self setupButtonLayoutWithFrom:self.schemeModel.schemetype.integerValue];
            [self setupButtonTitleWithFrom:self.schemeModel.schemetype.integerValue];
            [self setupButtonPermissionWithFrom:self.schemeModel.schemetype.integerValue];
            [self setSaveAndAddToOrderShouldShow:edit];
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
            [self setupButtonLayoutWithFrom:self.speraModel.parts.parts_type.integerValue];
            [self setupButtonTitleWithFrom:self.speraModel.parts.parts_type.integerValue];
            [self setupButtonPermissionWithFrom:self.speraModel.parts.parts_type.integerValue];
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
            [self setupButtonLayoutWithFrom:self.workHourModel.workhour.workhourtype.integerValue];
            [self setupButtonTitleWithFrom:self.workHourModel.workhour.workhourtype.integerValue];
            [self setupButtonPermissionWithFrom:self.workHourModel.workhour.workhourtype.integerValue];
            break;
        default:
            break;
    }

    [self setupConfig];
}

- (void)setSaveAndAddToOrderShouldShow:(BOOL)isShow
{
    
    // 如果有工单并且是编辑状态，则把 保存并加入工单按钮放出
    if ([[HDStoreInfoManager shareManager].carorderid integerValue] && isShow)
    {
        self.secondViewWidthLayout.constant = self.edit ? DETAILVIEW_WIDTH/2.0 : DETAILVIEW_WIDTH/3.0;
        self.saveAndAddToOrderButton.hidden = NO;
        self.secodeButtonTrailingLayout.constant =  self.secondViewWidthLayout.constant / 2.0f + 1;
        self.saveAndAddToOrderButtonLeadingLayout.constant =  self.secondViewWidthLayout.constant / 2.0f;
    }
    else
    {
        self.secodeButtonTrailingLayout.constant = 0;

        self.saveAndAddToOrderButton.hidden = YES;
    }
}
- (void)setupButtonTitleWithFrom:(NSInteger)fromType {
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            
            switch (fromType) {
                case 1:
                case 2:
                case 3:
                {
                    [self.secondButton setTitle:self.edit ? @"保存为我的方案" : @"加入工单" forState:UIControlStateNormal];
                    [self.firstButton setTitle:self.edit ? @"替换原方案" :@"编辑" forState:UIControlStateNormal];
                }
                    break;
                case 4: //未完成方案
                {
                    [self.secondButton setTitle:self.edit ? @"保存并加入工单" : @"加入工单" forState:UIControlStateNormal];
                    [self.secondButton setImage:[UIImage imageNamed:@"hd_item_detial_project_buy.png"] forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
//            //方案提醒 不可以编辑  不可以加入工单
//            if (_is_formNotice) {
//                [self.firstButton setTitle: @"保存为我的方案" forState:UIControlStateNormal];
//                [self.firstButton setImage:[UIImage imageNamed:@"materialtime_edit_save.png"] forState:UIControlStateNormal];
//
//            }
            
            
//            if (self.schemeModel.ordersolutionid.integerValue) {//工单详情
//                
//                [self.firstButton setTitle:@"保存" forState:UIControlStateNormal];
//                if (fromType != 1) {
//                    [self.thirdButton setTitle:@"替换原方案" forState:UIControlStateNormal];
//                    UIImage *thirdImage = [[UIImage imageNamed:@"materialtime_edit_save.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                    [self.thirdButton setImage:thirdImage forState:UIControlStateNormal];
//                }
//            }

        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            
            switch (fromType) {
                case 1:
                case 2:
                case 3:
                {
                    [self.secondButton setTitle:self.edit ? @"保存为我的备件" : @"加入工单" forState:UIControlStateNormal];
                    [self.firstButton setTitle:self.edit ? @"替换原备件" :@"编辑" forState:UIControlStateNormal];
                }
                    break;
                case 99: //新建
                {
                    [self.firstButton setTitle:self.edit ? @"保存并加入工单" :@"编辑" forState:UIControlStateNormal];
                    [self.secondButton setTitle:@"保存为我的备件" forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }

        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
           
            switch (fromType) {
                case 1:
                case 2:
                case 3:
                {
                    [self.secondButton setTitle:self.edit ? @"保存为我的工时" : @"加入工单" forState:UIControlStateNormal];
                    [self.firstButton setTitle:self.edit ? @"替换原工时" :@"编辑" forState:UIControlStateNormal];
                }
                    break;
                case 99: //新建
                {
                    [self.firstButton setTitle:self.edit ? @"保存并加入工单" :@"编辑" forState:UIControlStateNormal];
                     [self.secondButton setTitle:@"保存为我的工时" forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }
}

#pragma mark - 初始化按钮
- (void)setupButtonLayoutWithFrom:(NSInteger)fromType { //1.厂方 2.本店 3.我的 4.自定义 99.新建
    
    switch (fromType) {
        case 1:
        {
            CGFloat editWidth = DETAILVIEW_WIDTH/2.0;
            if (self.detailType == MaterialTaskTimeDetailsTypeWorkHours || self.detailType == MaterialTaskTimeDetailsTypeMaterial)
            {
                editWidth = DETAILVIEW_WIDTH/3.0;
            }
            
            self.thirdViewWidthLayout.constant = 0;
            self.ThirdViewLeadingLayout.constant = 0;
            self.fourthViewLeadingLayout.constant = 0;
            self.secondViewWidthLayout.constant = self.edit ?editWidth : DETAILVIEW_WIDTH/3.0;
            self.leftViewWidthLayout.constant = self.edit ? editWidth : DETAILVIEW_WIDTH/3.0;
            self.secondViewCentYLayout.constant = self.edit ? -DETAILVIEW_WIDTH/4.0 : 0;
            
            if (![HDStoreInfoManager shareManager].carorderid && !self.edit) { //首页菜单进入
                self.secondViewWidthLayout.constant = 0;
                self.secondViewLeadingLayout.constant =  0;
                self.leftViewWidthLayout.constant = DETAILVIEW_WIDTH / 2.0;
            }
        }
            break;
        case 2:
        {
            CGFloat editWidth =  DETAILVIEW_WIDTH/4.0;
            if (self.detailType == MaterialTaskTimeDetailsTypeWorkHours || self.detailType == MaterialTaskTimeDetailsTypeMaterial)
            {
                editWidth = DETAILVIEW_WIDTH/3.0;
            }
            self.thirdViewWidthLayout.constant = 0;
            self.fourthViewLeadingLayout.constant = 0;
            self.ThirdViewLeadingLayout.constant = 0;
            self.secondViewWidthLayout.constant = DETAILVIEW_WIDTH/3.0;
            self.leftViewWidthLayout.constant =  self.edit ? editWidth : DETAILVIEW_WIDTH/3.0;
            self.secondViewCentYLayout.constant = 0;
            
            if (![HDStoreInfoManager shareManager].carorderid && !self.edit) { //首页菜单进入
                self.secondViewWidthLayout.constant = 0;
                self.secondViewLeadingLayout.constant =  0;
                self.leftViewWidthLayout.constant = DETAILVIEW_WIDTH / 2.0;
            }
            else if(![HDStoreInfoManager shareManager].carorderid && self.edit)
            {
                self.leftViewWidthLayout.constant =  DETAILVIEW_WIDTH/3.0;
            }

        }
            break;
        case 3:
        {
            CGFloat editWidth =  DETAILVIEW_WIDTH/4.0;
            if (self.detailType == MaterialTaskTimeDetailsTypeWorkHours || self.detailType == MaterialTaskTimeDetailsTypeMaterial)
            {
                editWidth = self.edit ?  DETAILVIEW_WIDTH/3.0 : DETAILVIEW_WIDTH/4.0;
            }
            
            self.thirdViewWidthLayout.constant = self.edit ? 0 : DETAILVIEW_WIDTH/4.0;
            self.ThirdViewLeadingLayout.constant = self.edit ? 0 : 1.0;;
            self.fourthViewLeadingLayout.constant = self.edit ? 0 : 1.0;
            self.secondViewWidthLayout.constant = self.edit ? DETAILVIEW_WIDTH/3.0 : DETAILVIEW_WIDTH/4.0;
            self.secondViewCentYLayout.constant = self.edit ? 0 : -DETAILVIEW_WIDTH/4.0/2.0;
            self.leftViewWidthLayout.constant =  editWidth;

 
            
            if (![HDStoreInfoManager shareManager].carorderid && !self.edit) { //首页菜单进入
                self.secondViewWidthLayout.constant = 0;
                self.secondViewLeadingLayout.constant =  0;
                self.thirdViewWidthLayout.constant = DETAILVIEW_WIDTH/3.0;
                self.secondViewCentYLayout.constant = self.edit ? 0 : -DETAILVIEW_WIDTH/3.0/2.0;
                self.leftViewWidthLayout.constant =  DETAILVIEW_WIDTH/3.0;
            }
            else if(![HDStoreInfoManager shareManager].carorderid && self.edit)
            {
                self.leftViewWidthLayout.constant =  DETAILVIEW_WIDTH/3.0;
            }
        }
            break;
        case 4:
        {
            self.thirdViewWidthLayout.constant = 0;
            self.ThirdViewLeadingLayout.constant = 0;
            self.fourthViewLeadingLayout.constant = 0;
            self.secondViewWidthLayout.constant = self.edit ? DETAILVIEW_WIDTH/2.0 : DETAILVIEW_WIDTH/3.0;
            self.leftViewWidthLayout.constant = self.edit ? DETAILVIEW_WIDTH/2.0 : DETAILVIEW_WIDTH/3.0;
            self.secondViewCentYLayout.constant = self.edit ? -DETAILVIEW_WIDTH/4.0 : 0;
        }
            break;
        case 99: //新建
        {
            self.ThirdViewLeadingLayout.constant = 0;
            self.secondViewWidthLayout.constant = DETAILVIEW_WIDTH/3.0;
            self.secondViewCentYLayout.constant = 0;
            self.thirdViewWidthLayout.constant = 0;
            self.fourthViewLeadingLayout.constant = 0;
            self.leftViewWidthLayout.constant = DETAILVIEW_WIDTH/3.0;

        }
            break;
        default:
            break;
    }
    
    //工单详情
//    if (self.schemeModel.ordersolutionid.integerValue) {
//        self.thirdViewWidthLayout.constant = 0;
//        self.fourthViewLeadingLayout.constant = 0;
//        self.secondViewWidthLayout.constant = fromType == 1 ? 0 : DETAILVIEW_WIDTH/3.0;
//        self.secondViewCentYLayout.constant =fromType == 1 ? -DETAILVIEW_WIDTH/4.0 : -DETAILVIEW_WIDTH/4.0/2.0;
//    }
}

#pragma mark - 权限设置
- (void)setupButtonPermissionWithFrom:(NSInteger)fromType { //1.厂方 2.本店 3.我的 4.自定义 99.新建
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            // 方案库方案加入工单权限
            BOOL isHasAddToOrder = [[HDLeftSingleton shareSingleton] isHasAddToOrderPermissionShowMessage:NO];
            BOOL isHasNoticeAddToOrder = [[HDLeftSingleton shareSingleton] isHasNoticeAddToOrderPermission];
            switch (fromType) {
                case 1:
                {

                    BOOL saveToMy = _is_formNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_SaveBecomeMyScheme isNeedShowMessage:NO] : YES;
                    BOOL addToOrder = _is_formNotice ? isHasNoticeAddToOrder : isHasAddToOrder;

                    
                    self.secondButton.permission = self.edit ?
                    saveToMy : //保存为我的方案
                   addToOrder; //加入工单
                    
                    self.saveAndAddToOrderButton.permission = saveToMy && addToOrder;

                }
                    break;
                case 2:
                {
                    BOOL edit = _is_formNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] : YES;
                    
                    self.firstButton.permission = self.edit ?
                    [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_ReplaceOldSchemeAfterChangeMyShop isNeedShowMessage:NO] : //替换原方案
                    edit; //编辑
                    
                    BOOL saveToMy = _is_formNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_SaveBecomeMyScheme isNeedShowMessage:NO] : YES;
                    
                    BOOL addToOrder = _is_formNotice ? isHasNoticeAddToOrder : isHasAddToOrder;
                    
                    
                    self.secondButton.permission = self.edit ?
                    saveToMy : //保存为我的
                    addToOrder; //加入工单
                    
                    self.saveAndAddToOrderButton.permission = saveToMy && addToOrder;
                }
                    break;
                case 3:
                {
                    BOOL edit = _is_formNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] : YES;

                    self.firstButton.permission = self.edit ?
                    [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_ReplaceOldSchemeAfterChangeMyShop isNeedShowMessage:NO] : //替换原方案
                    edit; //编辑
                    
                    BOOL saveToMy = _is_formNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_SaveBecomeMyScheme isNeedShowMessage:NO] : YES;

                    BOOL addToOrder = _is_formNotice ? isHasNoticeAddToOrder : isHasAddToOrder;

                    self.secondButton.permission = self.edit ?
                    saveToMy : //保存为我的
                    addToOrder; //加入工单
                    
                    self.saveAndAddToOrderButton.permission = saveToMy && addToOrder;
                }
                    break;
                case 4:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            switch (fromType) {
                case 1:
                {
                    self.secondButton.permission = self.edit ?
                    YES : //保存为我的备件
                    [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO]; //加入工单
                    
                    self.firstButton.permission = self.edit ?   NO : // 替换
                    [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO]; //编辑
                }
                    break;
                case 2:
                {
                    self.firstButton.permission = self.edit ?
                    [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_ReplaceOldSpacePartAfterChangeMyShop isNeedShowMessage:NO] : //替换原备件
                     [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO]; //编辑
                    
                    self.secondButton.permission = self.edit ?
                    YES : //保存为我的
                    [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO]; //加入工单
                }
                    break;
                case 3:
                {
                    self.firstButton.permission = self.edit ?
                    [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_ReplaceOldSchemeAfterChangeMyShop isNeedShowMessage:NO] : //替换原方案
                     [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO]; //编辑
                    
                    self.secondButton.permission = self.edit ?
                    YES : //保存为我的
                    [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_Edit isNeedShowMessage:NO]; //加入工单
                }
                    break;
                default:
                    break;
            }

        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            switch (fromType) {
                case 1:
                {
                    self.secondButton.permission = self.edit ?
                    YES : //保存为我的工时
                    [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO]; //加入工单
                    
                    self.firstButton.permission = self.edit ?
                    NO : //替换原工时
                    [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO] ; //编辑
                    
                }
                    break;
                case 2:
                {
                    self.firstButton.permission = self.edit ?
                    [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_ReplaceOldTimeAfterChangeMyShop isNeedShowMessage:NO] : //替换原工时
                    [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO] ; //编辑
                    
                    self.secondButton.permission = self.edit ?
                    YES : //保存为我的
                    [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO]; //加入工单
                }
                    break;
                case 3:
                {
                    self.firstButton.permission = self.edit ?
                    [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_ReplaceOldTimeAfterChangeMyShop isNeedShowMessage:NO] : //替换原工时
                    [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO] ; //编辑
                    
                    self.secondButton.permission = self.edit ?
                    YES : //保存为我的
                    [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_Edit isNeedShowMessage:NO]; //加入工单
                }
                    break;
                default:
                    break;
            }

        }
            break;
        default:
            break;
    }
}

- (void)dsld
{
    
}

- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
}

- (UIView *)clearView {
    
    if (!_clearView) {
        _clearView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _clearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _clearView.bounds;
        [btn addTarget:self action:@selector(closeCarListView) forControlEvents:UIControlEventTouchUpInside];
        [_clearView addSubview:btn];
    }
    return _clearView;
}

#pragma mark - UItableViewDetegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            switch (self.detailType) {
            case MaterialTaskTimeDetailsTypeScheme:
                return 30 + 44*self.materialCount + 44; //方案库 有一个头视图
                break;
            default:
                return 30 + 44*self.materialCount;
                break;
        }
            break;
        case 1:
            {
               return [self getCarTypeHeightWith:self.carArray edit:self.edit cellWidth:self.frame.size.width];
            }
            break;
        case 2:
            {
                switch (self.detailType) {
                    case MaterialTaskTimeDetailsTypeMaterial:
                        return 0;
                        break;
                    default:
                        return 85;
                        break;
                }
            }
            break;
        case 3:
            return 135;
            break;
        default:
            return 0;
            break;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0: //备件工时
        {
            NSArray *speras;;
            NSArray *workHours;
            if (self.detailType == MaterialTaskTimeDetailsTypeScheme) {
                speras = self.schemeModel.sparelist;
                workHours = self.schemeModel.workhourlist;
            } else {
                speras = [[NSArray alloc] initWithObjects:self.speraModel.parts,nil];
                workHours = [[NSArray alloc] initWithObjects:self.workHourModel.workhour,nil];
            }
            
            ProjectDetailTableView *cell = [ProjectDetailTableView cellWithTableView:tableView workHours:workHours speras:speras cellType:self.detailType];
            cell.isFromNotice = _is_formNotice;
            if (self.detailType == MaterialTaskTimeDetailsTypeScheme) cell.schemeModel = self.schemeModel;
            cell.backgroundColor = BackGroudColor;
            cell.editCell = self.edit;
            if (!self.dataSource) {
                cell.newcell = YES;
            }
            cell.new_object = self.new_object;
            
            if (self.detailType == MaterialTaskTimeDetailsTypeScheme)
            {
                // 编号名称不可编辑
                cell.numberAndNameCannotEdit = YES;
            }
            
            return cell;
        }
            break;
        case 1: //适用车型
        {
            ProjectCarStyleAndDisTableViewCell *cell = [ProjectCarStyleAndDisTableViewCell cellWithTableView:tableView withType:self.detailType];
            cell.dataArray = self.carArray;
            BOOL canEdit = NO;
            switch (self.detailType) {
                case MaterialTaskTimeDetailsTypeScheme:
                {
                    
                    canEdit = _is_formNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] : [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditProperty isNeedShowMessage:NO];
                }
                    break;
                case MaterialTaskTimeDetailsTypeMaterial:
                    
                    canEdit = _new_object ? YES : [HDPermissionManager isHasThisPermission:HDOrder_GoSpacePartLibrary_EditProperty isNeedShowMessage:NO];
                    break;
                case MaterialTaskTimeDetailsTypeWorkHours:

                    canEdit = _new_object ? YES : [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_EditProperty isNeedShowMessage:NO];
                    break;
                default:
                    break;
            }
            
            cell.editCell = self.edit ? canEdit : NO;
            cell.backgroundColor = BackGroudColor;
            __weak typeof(self)weakself = self;
            
            cell.clickBlock = ^(NSInteger cellRow,CGRect cellFrame) {
                
                [weakself.tableView reloadData];
            };
            return cell;
        }
            
            break;
        case 2: //公里数范围
        {
            PorscheSchemeMilesModel *milesModel;
            PorscheSchemeMonthModel *monthModel;
            BOOL canEdit = NO;
            switch (self.detailType) {
                case MaterialTaskTimeDetailsTypeScheme:
                {
                    if (!self.schemeModel.miles) self.schemeModel.miles = [[PorscheSchemeMilesModel alloc] init];
                    if (!self.schemeModel.month) self.schemeModel.month = [[PorscheSchemeMonthModel alloc] init];
                    milesModel = self.schemeModel.miles;
                    monthModel = self.schemeModel.month;
                    
                    canEdit = _is_formNotice ? [HDPermissionManager isHasThisPermission:HDTaskNotice_MyShopNotice_Edit isNeedShowMessage:NO] : [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditProperty isNeedShowMessage:NO];

                    //canEdit = [HDPermissionManager isHasThisPermission:HDOrder_GoSchemeLibrary_EditProperty isNeedShowMessage:NO];
                }
                    break;
                case MaterialTaskTimeDetailsTypeWorkHours:
                    if (!self.workHourModel.km) self.workHourModel.km = [[PorscheSchemeMilesModel alloc] init];
                    if (!self.workHourModel.month) self.workHourModel.month = [[PorscheSchemeMonthModel alloc] init];
                    milesModel = self.workHourModel.km;
                    monthModel = self.workHourModel.month;
                    canEdit = _new_object ? YES :  [HDPermissionManager isHasThisPermission:HDOrder_GoTimeLibrary_EditProperty isNeedShowMessage:NO];
                    break;
                default:
                    break;
            }
            ProjectMileageStyleTableViewCell *cell = [ProjectMileageStyleTableViewCell cellWithTableView:tableView withMilesModel:milesModel MonthModel:monthModel];
            cell.clipsToBounds = YES;
            cell.editCell = self.edit ? canEdit : NO;
            
            cell.backgroundColor = BackGroudColor;

            return cell;
        }
            break;
        case 3: //业务、级别、组别、收藏
        {
            ProjectDetailPlanTableViewCell *cell;
            switch (self.detailType) {
                case MaterialTaskTimeDetailsTypeScheme:
                    cell = [ProjectDetailPlanTableViewCell schemeCellWithTableView:tableView withSchemeModel:self.schemeModel];
                    cell.isFromNotice = _is_formNotice;
                    break;
                case MaterialTaskTimeDetailsTypeMaterial:
                    cell = [ProjectDetailPlanTableViewCell speraCellWithTableView:tableView withSperaModel:self.speraModel];
                    break;
                case MaterialTaskTimeDetailsTypeWorkHours:
                    cell = [ProjectDetailPlanTableViewCell workHourCellWithTableView:tableView withWorkHourModel:self.workHourModel];
                    break;
                default:
                    break;
            }
            cell.newObject = self.new_object;
            cell.cellType = self.detailType;
            cell.editCell = self.edit;
            cell.backgroundColor = BackGroudColor;

            return cell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - 获取车辆数组
- (NSMutableArray *)carArray {
    NSMutableArray *cars;
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
            cars = self.schemeModel.carlist;
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
            cars = self.speraModel.cars;
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
            cars = self.workHourModel.cars;
            break;
        default:
            break;
    }
    return cars;
}

- (CGFloat)getCarTypeHeightWith:(NSArray *)array edit:(BOOL)edit cellWidth:(CGFloat)width {
    
    CGFloat total;
    for (NSInteger i = 0; i < array.count ; i ++) {
        
        CGFloat mager = 0;
        if (edit) {
            mager = 60;
        }
        PorscheSchemeCarModel *car = array[i];
        NSString *str = car.carSting;
        total += [self getStringlength:str] + mager + 10 + 50;
    }
    
    
    
    CGRect rect = self.frame;
    CGFloat h = total > width ? 45 : 0;
    rect.size.height = self.viewHeight + h;
    self.frame = rect;
    self.center = self.superview.center;
    
    return total < width ? 85:130;
}
- (CGFloat)getStringlength:(NSString *)string {
    
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width;
}

- (void)closeCarListView {
    
    if (_keyBoardVisible) {
       [[UIApplication sharedApplication].keyWindow endEditing:YES];
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.clearView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.clearView removeFromSuperview];
        self.clearView.alpha = 1.0;
        self.clearView = nil;
    }];
    
    [self.tableView reloadData];
}


#pragma mark - 保存详情
- (void)saveDetailDataAndComplete:(void(^)(BOOL success))complete {
    
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    
    WeakObject(hub);
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
           [PorscheRequestManager schemeDetailSaveWithSchemeModel:self.schemeModel completion:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
               
               if (responser.status != 100)
               {
                   [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
               }
               else
               {
                   [hubWeak hideAnimated:YES];
               }
               if (complete) {
                   complete(success);
               }
           }];
            
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            [PorscheRequestManager speraDetailSaveWithSperaModel:self.speraModel completion:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
                
                if (responser.status != 100)
                {
                    [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
                }
                else
                {
                    [hubWeak hideAnimated:YES];
                }
                if (complete) {
                    complete(success);
                }
                
            }];
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            [PorscheRequestManager workHourDetailSaveWithWorkHourModel:self.workHourModel completion:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
                if (responser.status != 100)
                {
                    [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
                }
                else
                {
                    [hubWeak hideAnimated:YES];
                }
                if (complete) {
                    complete(success);
                }
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 添加详情
- (void)addDetailDataAndComplete:(void(^)(BOOL success,PResponseModel* _Nullable responser))complete {
    
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    
    WeakObject(hub);
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            [PorscheRequestManager schemeDetailAddToMeWithSchemeModel:self.schemeModel schemeType:3 completion:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
                if (responser.status != 100)
                {
                    [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
                }
                else
                {
                    [hubWeak hideAnimated:YES];
                }
                if (complete) {
                    complete(success,responser);
                }
            }];
            
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            [PorscheRequestManager speraDetailAddToMeWithSperaModel:self.speraModel speraType:3 completion:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
                if (responser.status != 100)
                {
                    [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
                }
                else
                {
                    [hubWeak hideAnimated:YES];
                }
                
                if (success) {
                    NSString *newid  = responser.object[@"parts_id"];
                    self.speraModel.parts.parts_id = @(newid.integerValue);
                }
                if (complete) {
                    complete(success,responser);
                }
            }];
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            [PorscheRequestManager workHourDetailAddToMeWithWorkHourModel:self.workHourModel workHourType:3 completion:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
                if (responser.status != 100)
                {
                    [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
                }
                else
                {
                    [hubWeak hideAnimated:YES];
                }
                if (success) {
                    NSString *newid  = responser.object[@"workhourid"]; //新增成功后重新赋值id
                    self.workHourModel.workhour.workhourid = @(newid.integerValue);
                }
                if (complete) {
                    complete(success,responser);
                }
            }];
        }
            break;
        default:
            break;
    }

}

#pragma mark - 按钮事件
//编辑/保存
- (IBAction)firstAction:(id)sender {
    //通知界面刷新
    [self endEditing:YES];
    [self postNotificationMyFavoriteToRefresh];
//    if (_is_formNotice) {//
//        [self addDetailDataAction];
//        [self.superview removeFromSuperview];
//        return;
//    }
    
    if (!self.isModelFull && self.edit) return;
    
    if (self.orderBackBlock) {
        [self saveDetailDataAction];
        return;
    }
    
    if (self.edit == NO) {
        
        self.edit = !self.edit;
        [self.tableView reloadData];
        
    } else if (self.new_object) {
        
        [self addDetailDataAction];
        
    } else {
        [self saveDetailDataAction];
    }
}

- (void)saveDetailDataAction {
    [self endEditing:YES];

    //通知界面刷新
    [self postNotificationMyFavoriteToRefresh];
    WeakObject(self);
    [self saveDetailDataAndComplete:^(BOOL success) {
        
        if (success) {
            selfWeak.edit = !selfWeak.edit;
            [selfWeak.tableView reloadData];
            
            if (selfWeak.backBlock) {
                selfWeak.backBlock(DetailViewBackTypeSave,selfWeak.detailId, selfWeak.responderModel);
            }
            
            if (selfWeak.schemeModel.ordersolutionid) {
                [selfWeak postNotificationMyFavoriteToRefresh];
            }
            
            if (selfWeak.new_object) { //新建方案
                [selfWeak.superview removeFromSuperview];
            }
            
            if (selfWeak.orderBackBlock) { //工单方案
                selfWeak.orderBackBlock(DetailViewBackTypeSave,selfWeak.schemeModel);
                [selfWeak.superview removeFromSuperview];
                return ;
            }
        }
    }];

}

//保存为我的
- (IBAction)secondAction:(id)sender {
    [self endEditing:YES];

    if (sender == nil) {
        self.schemeModel.saveType = @1;
    }
    else
    {
        self.schemeModel.saveType = @0;
    }

    //通知界面刷新
    [self postNotificationMyFavoriteToRefresh];
    if (self.edit) {
        if (!self.isModelFull) return;
        [self addDetailDataAction];
    } else {
        DetailViewBackType backType = DetailViewBackTypeJoinWorkOrder;
        if ([self.schemeModel.saveType isEqualToNumber:@1])
        {
            backType = DetailViewBackTypeSaveToMySchemeAndAddToOrder;
        }
        
        if (self.backBlock) {
            self.backBlock(backType,self.detailId,self.responderModel);
        }
        [self.superview removeFromSuperview];
    }
}

#pragma mark -- 保存我的并加入工单
- (IBAction)saveAndAddToOrderAction:(id)sender {
    [self endEditing:YES];
    [self secondAction:nil];
}

- (void)addDetailDataAction { //添加到我的
    //通知界面刷新
    [self postNotificationMyFavoriteToRefresh];
    WeakObject(self);
    [self addDetailDataAndComplete:^(BOOL success,PResponseModel* _Nullable responser) {
        NSNumber *itemId = @0;
        
        if ([responser.object isKindOfClass:[NSDictionary class]])
        {
            if (self.detailType == MaterialTaskTimeDetailsTypeMaterial)
            {
                itemId = [responser.object objectForKey:@"parts_id"];
            }
            else
            {
                itemId = [responser.object objectForKey:@"workhourid"];
            }
        }
        else
        {
            itemId = responser.object;
        }

        if (success) {
            if (selfWeak.orderBackBlock) { //工单方案
                selfWeak.orderBackBlock(DetailViewBackTypeSaveToMyScheme,selfWeak.schemeModel);
                [selfWeak.superview removeFromSuperview];
                return ;
            }
            if (selfWeak.new_object) {
                if (selfWeak.backBlock) {
                    selfWeak.backBlock(DetailViewBackTypeSaveToMyScheme,[itemId integerValue],selfWeak.responderModel);
                    [selfWeak.superview removeFromSuperview];
                }
            }
            else
            {
                
                
                DetailViewBackType backType = DetailViewBackTypeSaveToMyScheme;
                if ([selfWeak.schemeModel.saveType isEqualToNumber:@1])
                {
                    backType = DetailViewBackTypeSaveToMySchemeAndAddToOrder;
                }
                
                if (selfWeak.backBlock) {
                    selfWeak.backBlock(backType,[itemId integerValue],selfWeak.responderModel);
                    if (backType == DetailViewBackTypeSaveToMySchemeAndAddToOrder)
                    {
                        [selfWeak.superview removeFromSuperview];
                        return ;
                    }
                }
            }
            
            // 刷新数据
            selfWeak.edit = !selfWeak.edit;
            //17-02-04 czz 要求在添加到工单之后就将本店方案的显示改成我的方案
            selfWeak.schemeModel.schemetype = @3;
//            selfWeak.detailId = [responser.object integerValue];
            MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
            WeakObject(hub);

            switch (selfWeak.detailType) {
                case MaterialTaskTimeDetailsTypeScheme:
                {
                    [PorscheRequestManager schemeDetailWithSchemeID:[itemId integerValue] completion:^(PorscheSchemeModel * _Nullable porschemeModel, NSError * _Nullable error) {
                        
                        if (error || !porschemeModel) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString *hint = error ? @"网络错误" : @"系统报错";
                                [hubWeak changeTextModeMessage:hint toView:KEY_WINDOW];
                            });
                            return ;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hubWeak hideAnimated:YES];
                        });
                        selfWeak.schemeModel = porschemeModel;
                        [selfWeak.tableView reloadData];
                    }];
                }
                    break;
                case MaterialTaskTimeDetailsTypeMaterial:
                {
                    [PorscheRequestManager speraDetailWithSperaID:[itemId integerValue] completion:^(PorscheSperaModel * _Nullable speraModel, NSError * _Nullable error) {
                        
                        if (error || !speraModel) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString *hint = error ? @"网络错误" : @"系统报错";
                                [hubWeak changeTextModeMessage:hint toView:KEY_WINDOW];
                            });
                            return ;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hubWeak hideAnimated:YES];
                        });
                        selfWeak.speraModel = speraModel;
                        [selfWeak.tableView reloadData];
                    }];
                }
                    break;
                case MaterialTaskTimeDetailsTypeWorkHours:
                {
                    
                    [PorscheRequestManager workHourDetailWithWorkHourID:[itemId integerValue] completion:^(PorscheWorkHoursModel * _Nullable workHourModel, NSError * _Nullable error) {
                        
                        if (error || !workHourModel) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString *hint = error ? @"网络错误" : @"系统报错";
                                [hubWeak changeTextModeMessage:hint toView:KEY_WINDOW];
                            });
                            return ;
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hubWeak hideAnimated:YES];
                        });
                        selfWeak.workHourModel = workHourModel;
                        [selfWeak.tableView reloadData];
                    }];

                }
                    break;
                default:
                    break;
            }

        }
        
    }];
}

//删除
- (IBAction)thirdAction:(id)sender {
    [self deleteItem];
}
//取消/返回
- (IBAction)lastAction:(id)sender {
    
    if (self.edit && !self.new_object && !self.orderBackBlock) {
        self.edit = !self.edit;
        [self.tableView reloadData];
    } else {
        //通知界面刷新
        [self postNotificationMyFavoriteToRefresh];
        [self.superview removeFromSuperview];
    }
}

- (void)postNotificationMyFavoriteToRefresh {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_DETAIL_REFRESH_MYFAVORITE_NOTIFICATION object:nil userInfo:@{@"type":@(self.detailType)}];
}

- (void)deleteItem {
    
    WeakObject(self);
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
            WeakObject(hub);
            [PorscheRequestManager schemeListDeleteWithSchemeID:self.schemeModel.schemeid.stringValue complete:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
                if (self.backBlock) {
                    self.backBlock(DetailViewBackTypeDelete,self.detailId,self.schemeModel);
                }
                if (self.orderBackBlock)
                {
                    self.orderBackBlock(DetailViewBackTypeDelete,self.schemeModel);
                }
                
                if (responser.status != 100)
                {
                    [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
                }
                else
                {
                    [hubWeak hideAnimated:YES];
                }
                if (success) [selfWeak.superview removeFromSuperview];
            }];

        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
            WeakObject(hub);
            [PorscheRequestManager speraDeleteWithID:self.speraModel.parts.parts_id.integerValue completion:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
                if (self.backBlock) {
                    self.backBlock(DetailViewBackTypeDelete,self.detailId,nil);
                }
                if (responser.status != 100)
                {
                    [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
                }
                else
                {
                    [hubWeak hideAnimated:YES];
                }
                if (success) [selfWeak.superview removeFromSuperview];
            }];
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
            WeakObject(hub);
            [PorscheRequestManager workHourDeleteWithID:self.workHourModel.workhour.workhourid.integerValue completion:^(BOOL success,PResponseModel* _Nullable responser, NSString * _Nullable message) {
                
                if (self.backBlock) {
                    self.backBlock(DetailViewBackTypeDelete,self.detailId,nil);
                }
                
                if (responser.status != 100)
                {
                    [hubWeak changeTextModeMessage:message toView:KEY_WINDOW];
                }
                else
                {
                    [hubWeak hideAnimated:YES];
                }
                if (success)  [selfWeak.superview removeFromSuperview];
            }];

        }
            break;
        default:
            break;
    }
}

- (NSInteger)detailId {
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            return self.schemeModel.schemeid.integerValue;
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            return self.speraModel.parts.parts_id.integerValue;
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            return self.workHourModel.workhour.workhourid.integerValue;
        }
            break;
        default:
            break;
    }
}

- (id)responderModel {
    
    switch (self.detailType) {

        case MaterialTaskTimeDetailsTypeMaterial:
        {
            return self.speraModel.parts;
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
           PorscheSchemeCarModel *carmodel = [self.workHourModel.cars firstObject];
            self.workHourModel.workhour.cartypename = [carmodel cartypename];
            return self.workHourModel.workhour;
        }
            break;
        case MaterialTaskTimeDetailsTypeScheme:
        {
            return self.schemeModel;
        }
        default:
            return nil;
            break;
    }
}

- (BOOL)isModelFull {
    
    if (!self.edit) return YES;
    
    switch (self.detailType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            NSString *hint = [self.schemeModel checkParameter];
            if (![hint isEqualToString:@""]) {
                [MBProgressHUD showMessageText:hint toView:self anutoHidden:YES];
            }
            return [hint isEqualToString:@""];
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            NSString *hint = [self.speraModel.parts checkParameter];
            if (![hint isEqualToString:@""]) {
                [MBProgressHUD showMessageText:hint toView:self anutoHidden:YES];
            }
            return [hint isEqualToString:@""];
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            NSString *hint = [self.workHourModel.workhour checkParameter];
            if (![hint isEqualToString:@""]) {
                [MBProgressHUD showMessageText:hint toView:self anutoHidden:YES];
            }
            return [hint isEqualToString:@""];
        }
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
