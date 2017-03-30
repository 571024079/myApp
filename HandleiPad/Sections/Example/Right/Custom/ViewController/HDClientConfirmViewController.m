//
//  HDClientConfirmViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDClientConfirmViewController.h"
#import "NSDate+HD.h"

//顶部视图
#import "HDMaterialHeaderView.h"

//签字视图
#import "HDClientBottomHelperView.h"
//底部视图
#import "HDClientBottomView.h"

//分区区头
#import "HDClientTableViewHeaderView.h"
//工时备件cell
#import "HDClientTableViewTableViewCell.h"
//项目小计cell
#import "HDCilentItemTotalTableViewCell.h"


//#import "AlertViewHelpers.h"

//保存弹窗，进入服务沟通
#import "HDdeleteView.h"

#import "HDLeftSingleton.h"

//签字版
#import "PenSigner.h"
//分享
#import "ServiceShareListView.h"

// 单选TableView
#import "HDSingleSelectView.h"
//保存弹窗
#import "HDNewSaveView.h"
//打印提示弹窗
#import "PorschePrintAffirmView.h"

#import "SpareSettingViewController.h"

#import "SpareSettingModel.h"

#import "PrintPreviewViewController.h"

#import "Printer.h"

#define SelectCategoryViewTag 300
@interface HDClientConfirmViewController ()<UITableViewDelegate,UITableViewDataSource,SpareSettingViewControllerDelegate>
//工单model
@property (nonatomic, strong) PorscheNewCarMessage *carMessage;

@property (nonatomic, strong) UITableView *tableView;
//滑动
@property (strong, nonatomic) UIView *containerView;

//底层滑动视图
@property (strong, nonatomic)  UIScrollView *baseView;

//备件确认数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
//底部签字
/* HDClientBottomHelperView
 //工时
 @property (weak, nonatomic) IBOutlet UILabel *itemTimeLb;
 //备件
 @property (weak, nonatomic) IBOutlet UILabel *materialLb;
 //优惠
 @property (weak, nonatomic) IBOutlet UILabel *preferentialLb;
 //总计
 @property (weak, nonatomic) IBOutlet UILabel *totalPriceLb;
 //签字日期
 @property (weak, nonatomic) IBOutlet UILabel *signDateLb;
 //签字按钮
 @property (weak, nonatomic) IBOutlet UIButton *signBt;
 @property (weak, nonatomic) IBOutlet UIImageView *imageView;
 */
@property (nonatomic, strong) HDClientBottomHelperView *bottomHelperView;
//底部视图
@property (nonatomic, strong) HDClientBottomView *bottomView;

//
@property (nonatomic, strong) PorscheNewCarMessage *carmessage;

//空白占位图
@property (nonatomic, strong) UIButton *emptyView;

//区头分类标志，图片数组
@property (nonatomic, strong) NSArray *customImgArray;

//签字版传出的签字图片
@property (nonatomic, strong) UIImage *signImage;
//签字日期字符串
@property (nonatomic, strong) NSString *signDateString;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) Printer *printer;
@end

@implementation HDClientConfirmViewController

- (void)dealloc {
    NSLog(@"HDClientConfirmViewController.dealloc");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49);
    _bottomHelperView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 87, CGRectGetWidth(self.view.frame), 87);
    
    self.baseView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 87 - 49);
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame));
    
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame));
    
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    
    self.emptyView.frame = self.containerView.frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HDLeftSingleton shareSingleton].stepStatus = 5;

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self setheaderViewAndBottomView];
    
    [self setupBaseScrollView];
    
    [self setUpTableView];
    
    
//    [self addNotifination];
    
    [self addEmptyView];
    
    [self bottomViewForCustomSure:NO];

    [self getOrderList];
    
}

- (void)baseReloadData
{
    [self getOrderList];
}

- (void)getOrderList {

//    if ([HDLeftSingleton shareSingleton].maxStatus >= [HDLeftSingleton shareSingleton].stepStatus) {
        [self getWorkOrderListTest];
//    }else {
//        self.carMessage = [PorscheNewCarMessage new];
//        self.dataArray = nil;
//        [self reloadSelfView];
//    }
    
}

- (void)reloadSelfView {
    self.bottomHelperView.carMessage = self.carMessage;
    [self setSelectCountLabelContent];
    [self addEmptyView];
    [self bottomViewForCustomSure:NO];
    [self.tableView reloadData];

}


//工单列表
- (void)getWorkOrderListTest {
    WeakObject(self);
    if ([HDStoreInfoManager shareManager].carorderid) {
        MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
        
        [PorscheRequestManager getWorkOrderListComplate:^(PorscheNewCarMessage * _Nonnull carMessage, PResponseModel * _Nonnull responser) {
            [hud hideAnimated:YES];
 
            if (![PorscheNewCarMessage isOnFactoryHintWithWostatus:carMessage.orderstatus.wostatus])
            {
                [HDStoreInfoManager shareManager].carorderid = nil;
                selfWeak.carMessage = nil;
                selfWeak.dataArray = nil;
                [selfWeak reloadSelfView];
                return;
            }
            
            if (carMessage) {
                [HDLeftSingleton shareSingleton].maxStatus = [carMessage.wostatus integerValue];
                if([[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:nil]) {
                    return ;
                }
                selfWeak.carMessage = carMessage;
                NSLog(@"获取工单方案信息成功！");
                selfWeak.dataArray = carMessage.solutionList;
                [[HDLeftSingleton shareSingleton] setCarModel:carMessage];
                [selfWeak reloadSelfView];
                [[HDLeftSingleton shareSingleton] setupSingleNoticeWithNumber:carMessage.msgcount.allnum];
            }else {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
                [selfWeak.tableView reloadData];
            }
        }];
    }else {
        NSLog(@"未选择车辆,获取不到工单信息");
    }
    
}

//更新顶部  总价的值
- (void)setSelectCountLabelContent
{
    PorscheNewCarMessage *newCarMessage;
    if (self.carMessage) {
        newCarMessage = self.carMessage;
    }else {
        newCarMessage = [PorscheNewCarMessage new];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:TECHICIANADDITION_SELECTED_NOTIFINATION object:@{@"carmessage":newCarMessage}];
    [[HDLeftSingleton shareSingleton] reloadRightViewVCHeaderContent:@{@"carmessage":newCarMessage}];
}

/*
- (void)addNotifination {
    //点击在场车辆切换车辆信息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCarMessage:) name:BILLING_CAR_MESSAGE_NOTIFINATION object:nil];
}

- (void)showCarMessage:(NSNotification *)noti {
    [self getOrderList];
}
 */
#pragma mark  ------scroll------


- (UIView *)containerView {
    if (!_containerView) {
        
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.baseView.frame))];
    }
    return _containerView;
}

//设置缩放内容

#pragma mark - 缩放

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}



- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidZoom");
    
    
    //捏合或者移动时，确定正确的center
    CGFloat centerX = scrollView.center.x;
    
    CGFloat centerY = scrollView.center.y;
    
    //随时获取center位置
    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX;
    
    centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : centerY;
    
    if (scrollView.contentSize.height > scrollView.frame.size.height) {
        _tableView.scrollEnabled = NO;
    }else {
        _tableView.scrollEnabled = YES;
    }
    
    self.containerView.center = CGPointMake(centerX, centerY);
}

- (void)setupBaseScrollView {
    //滑动
    _baseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- 64 - 87)];
    
    
    _baseView.contentSize = CGSizeMake(CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame));
    
    _baseView.bounces = NO;
    
    _baseView.maximumZoomScale = 2;
    
    _baseView.minimumZoomScale = 1;
    
    [self.view addSubview:_baseView];
    
    _baseView.backgroundColor = [UIColor whiteColor];
    
    [_baseView addSubview:self.containerView];
    
    self.baseView.delegate = self;
}

- (void)addEmptyView {
    if (self.dataArray.count == 0) {
        
        [self.view addSubview:self.emptyView];
        
    }else {
        [self.emptyView removeFromSuperview];
    }
}

#pragma mark -- 选择打印分类

// 加载打印分类视图
- (void)loadPrintCategorysSelectViewWithPrintType:(SparePrintType)printType
{
//    // 高度210
//    HDSingleSelectView *selectCategoryView = [HDSingleSelectView loadSingleSelectViewWithOrigin:CGPointMake(326, self.view.bounds.size.height - self.bottomView.bounds.size.height - 210)];
//    selectCategoryView.tag = SelectCategoryViewTag;
//    selectCategoryView.dataSource = [self configPrintTypeModel];
//    selectCategoryView.selectFinishedBlock = ^(NSInteger index){
//        [selfWeak maskViewDidSelectView:nil];
//    };
//    self.maskView.hidden = NO;
//    [self.view addSubview:selectCategoryView];

    
    PorschePrintAffirmView *printView = [PorschePrintAffirmView showPrinAffirmViewAndComplete:^(NSArray *pays, NSInteger count) {
        //type 打印类型
        //count 打印份数
        // 进入打印页面
        // 获取打印pdf数据
        [self getPDFFileWithType:PDF_Quotation spareInfo:nil printType:SparePrintTypePreView printCategory:pays printCount:count];
//        [self gotoPrintViewWithPrintType:pdftype];
    }];
    
    if (printType == SparePrintTypePrint)
    {
        printView.titleLabel.text = @"打印";
    }
    else
    {
        printView.titleLabel.text = @"预览";
    }
    
    [HD_FULLView addSubview:printView];
}


// 遮罩View
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidSelectView:)];
        [_maskView addGestureRecognizer:tap];
        [self.view addSubview:_maskView];
    }
    return _maskView;
}

- (void)maskViewDidSelectView:(id)sender
{
    _maskView.hidden = YES;
    [[self.view viewWithTag:SelectCategoryViewTag] removeFromSuperview];
}

- (NSArray *)configPrintTypeModel
{
    NSArray *array = @[@"全部",@"保修",@"自费",@"内结"];
    return array;
}

- (void)setUpTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49 - 87) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 分区区头
    [_tableView registerNib:[UINib nibWithNibName:@"HDClientTableViewHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HDClientTableViewHeaderView"];
    
    //工时或者配件cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDClientTableViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDClientTableViewTableViewCell"];

    //项目小计cell
    [_tableView registerNib:[UINib nibWithNibName:@"HDCilentItemTotalTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDCilentItemTotalTableViewCell"];
    WeakObject(self);
    self.bottomHelperView.hDClientBottomHelperViewBlock = ^ () {
        
        BOOL isShowAlert = [[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:nil];
        if (isShowAlert) {
            return;
        }
        [selfWeak penSignerViewAction];
    };
    [self.containerView addSubview:self.tableView];
}


#pragma mark  ------签字版------
- (void)penSignerViewAction {
    
    if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Affirm])
    {
        return;
    }
    
    WeakObject(self);
    
    PenSigner *penSignerView = [PenSigner viewFromXibWithFrame:KEY_WINDOW.frame];
    
    [HD_FULLView addSubview:penSignerView];
    
    WeakObject(penSignerView);
    
    penSignerView.signerImageBlock = ^(UIImage *image,NSString *dateString,UIButton *button) {
        
        if (button.tag == 1) {
            selfWeak.signImage = image;
//            selfWeak.signDateString = dateString;
//            selfWeak.bottomHelperView.signDateLb.text = dateString;
//            [selfWeak.bottomHelperView.signBt setTitle:@"" forState:UIControlStateNormal];
//            [selfWeak.bottomHelperView.signBt setImage:image forState:UIControlStateNormal];
            
            if (selfWeak.signImage) {
                [selfWeak updateImage:selfWeak.signImage];
                
            }
        }
        
        [penSignerViewWeak removeFromSuperview];

    };
    
}

#pragma mark  ------区头 区尾------

- (void)setheaderViewAndBottomView {
    
    self.bottomView = [[HDClientBottomView alloc]initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64, CGRectGetWidth(self.view.frame), 49)];
    
    self.bottomHelperView = [[HDClientBottomHelperView alloc]initWithCustomFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49 - 64 -87, CGRectGetWidth(self.view.frame), 87)];
   
    [self.view addSubview:self.bottomHelperView];
    
    [self.view addSubview:self.bottomView];
    
    WeakObject(self);
    
    self.bottomView.hDClientBottomViewBlock = ^ (UIButton *sender) {
        
        BOOL isShowAlert = [[HDLeftSingleton shareSingleton] showStepAlertViewShowStatus:nil];
        if (isShowAlert) {
            return;
        }
        
        switch (sender.tag) {
            case 1:
                #pragma mark  分享-权限
            {
                
//                if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share]) {
//                    return;
//                };
                CGRect rect = [sender convertRect:sender.bounds toView:KEY_WINDOW];
                ServiceShareListView *shareList = [ServiceShareListView viewFromXibWithItemRect:rect Item:1];
                
                shareList.frame = KEY_WINDOW.bounds;
                
                [HD_FULLView addSubview:shareList];
            }
                
                break;
            case 2:
                #pragma mark  预览
            {
/*                if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_PrePrint]) {
                    return;
                };*/
                HDNewSaveView *saveView = [HDNewSaveView showMakeSureViewAroundView:selfWeak.bottomView.preViewBt tittleArray:@[@"选择类型",@"报价单",@"备货单"] direction:UIPopoverArrowDirectionUp makeSure:^{
                    // 进入打印页面
                    if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_Price]) {
                        return;
                    };
                    [selfWeak loadPrintCategorysSelectViewWithPrintType:SparePrintTypePreView];
                } cancel:^{
                    if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_Goods]) {
                        return;
                    };
                    [selfWeak getSpareListWithSparePrintType:SparePrintTypePreView];
                }];
                [saveView setCancelButtonTitleColorNormal];
            }
                break;
            case 3:
                #pragma mark  打印
            {
      /*          if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_PrePrint]) {
                    return;
                };*/
                HDNewSaveView *saveView = [HDNewSaveView showMakeSureViewAroundView:selfWeak.bottomView.printBt tittleArray:@[@"选择类型",@"报价单",@"备货单"] direction:UIPopoverArrowDirectionUp makeSure:^{
                    if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_Price]) {
                        return;
                    };
                    [selfWeak loadPrintCategorysSelectViewWithPrintType:SparePrintTypePrint];
                } cancel:^{
                    if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_Share_Goods]) {
                        return;
                    };
                    // 打印备货单
                    [selfWeak getSpareListWithSparePrintType:SparePrintTypePreView];
                }];
                [saveView setCancelButtonTitleColorNormal];
            }
                break;
            case 4:
                //客户确认
            {
                [selfWeak sureCustomAction];
            }
                break;
            
            case 5://取消确认
            {
                [selfWeak userCancelAffirm];
            }
                break;
                
            default:
                break;
        }
    };
    
}


#pragma mark -- 进入备货单设置页面
- (void)enterSpareSettingVCWithDataSource:(NSArray *)dataSource
{
    SpareSettingViewController *spareVC = [[SpareSettingViewController alloc] init];
    spareVC.dataSource  = dataSource;
    spareVC.delegate = self;
    spareVC.view.frame = MAIN_SCREEN_FRAME;
    [HD_FULLViewController addChildViewController:spareVC];
    [HD_FULLViewController.view addSubview:spareVC.view];
}
- (void)getSpareListWithSparePrintType:(SparePrintType)printType
{//pdfPartsInfoDtos
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    [PHTTPRequestSender sendRequestWithURLStr:PRINT_SPARE_LIST parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        if (!error)
        {
            if (responser.status == 100)
            {
                // 获取备件列表
                NSArray *sparelistInfo = [responser.object objectForKey:@"pdfPartsInfoDtos"];
                
                NSMutableArray *spareArray = [NSMutableArray array];
                
                for (NSDictionary *info in sparelistInfo)
                {
                    SpareSettingModel *model = [SpareSettingModel yy_modelWithDictionary:info];
                    [spareArray addObject:model];
                }
                
                if (spareArray.count)
                {
                     [self enterSpareSettingVCWithDataSource:spareArray];
                }
                else
                {
                    // 获取pdf数据 进入打印页面
//                    NSDictionary *info = @{@"fromstyle":@0, @"ordertype":@2};
//                    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PREVIEW_NOTIFICATION object:info];
//                    [self gotoPrintViewWithPrintType:PDF_Spare];
#pragma mark -- 直接打印备货单 -----
//                    if (printType == SparePrintTypePrint)
//                    {
//                        
//                    }
//                    else
//                    {
                        [self getPDFFileWithType:PDF_Spare spareInfo:nil printType:printType printCategory:nil printCount:1];
//                    }
                }
            
            }
            else
            {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:self.tableView.center superView:self.view];
            }
        }
        
    }];
}


- (void)gotoPrintViewWithPrintType:(PDFType)pdftype count:(NSInteger)copies
{
    NSNumber *type = nil;
    if (pdftype == PDF_Spare)
    {
        type = @1;
    }
    else
    {
        type = @2;
    }
    // 进入打印页面
    NSDictionary *info = @{@"fromstyle":@0, @"ordertype":type,@"count":@(copies)};
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PREVIEW_NOTIFICATION object:info];
    [[HDLeftSingleton shareSingleton] showPreView:info];
}

#pragma mark -- 备货单设置 delegate -----
- (void)spareSettingViewController:(SpareSettingViewController *)viewController printType:(SparePrintType)printType WithInfo:(NSArray *)spareInfo
{
    switch (printType) {
        case SparePrintTypePreView:
        case SparePrintTypePrint:
            
            [self getPDFFileWithType:PDF_Spare
                           spareInfo:spareInfo
                           printType:printType
                       printCategory:nil
                          printCount:1];
            
            break;
        case SparePrintTypeNone:
            
            break;
        case SparePrintTypeSave:
            
            break;
        default:
            break;
    }
}

#pragma mark -- 获取PDF信息
- (void)getPDFFileWithType:(PDFType)type spareInfo:(NSArray *)spareInfo printType:(SparePrintType)printType printCategory:(NSArray *)category printCount:(NSUInteger)count
{
    
    if (![[[HDStoreInfoManager shareManager] carorderid] integerValue])
    {
        // 未选择工单
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未选择工单" height:60 center:HD_FULLView.center superView:HD_FULLView];
        return;
    }
    NSMutableDictionary *param = nil;
    NSString *URLStr = PRINT_SPAREPDF;
    if (type == PDF_Quotation)
    {
        NSString *typeStr = @"";
        if(category.count)
        {
            typeStr = [category componentsJoinedByString:@","];
        }
        param = [NSMutableDictionary dictionaryWithDictionary:@{@"type":typeStr}];

//        [param hs_setSafeValue:spareInfo forKey:@"pdfPartsInfoDtos"];
        
        URLStr = PRINT_QUOTATIONPDF;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    [PorscheRequestManager downloadPDFWithURLStr:URLStr params:param orderid:[[HDStoreInfoManager shareManager] carorderid] completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        if (!error)
        {
            if ([filePath absoluteString].length)
            {
//                [self initializerPDFInfoWithURL:filePath];
                if (printType == SparePrintTypePreView)
                {
                    [self gotoPrintViewWithPrintType:type count:count];
                }
                else
                {
#warning 直接弹打印 区分 报价单，备货单
                    //
                    [self beginPrintWithCopies:count];
                }
                
            }
        }
//        else
//        {
//            if (error.code != 100 && error.localizedDescription.length)
//            {
//                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:error.localizedDescription height:60 center:self.tableView.center superView:self.view];
//            }
//        }
    }];
}


#pragma mark --- 打印类打印

- (void)beginPrintWithCopies:(NSInteger)copies
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, PDF_NAME];
    //    NSData *pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullPath]];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* data = [fm contentsAtPath:fullPath];
    [self.printer selectPrinterToPrinterWithView:HD_FULLView copies:copies printPDFData:data];
    
}

- (Printer *)printer
{
    if (!_printer) {
        _printer = [[Printer alloc] init];
    }
    return _printer;
}
#pragma mark  ------deleagte------


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count) {
        PorscheNewScheme *cubScheme = self.dataArray[section];
        return cubScheme.projectList.count + 1;
        
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return  [self getHeaderViewWithTableView:tableView section:section];
    
}

#pragma mark  ------项目区头------
- (UIView *)getHeaderViewWithTableView:(UITableView *)tableView section:(NSInteger)section {
    HDClientTableViewHeaderView *singleItemHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HDClientTableViewHeaderView"];
    singleItemHeaderView.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    PorscheNewScheme *model = self.dataArray[section];

    singleItemHeaderView.tmpModel = model;

    return singleItemHeaderView;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PorscheNewScheme *cubScheme = self.dataArray[indexPath.section];
    
#pragma mark  ------一般项目相关cell------
    if (cubScheme.projectList.count > indexPath.row) {
        
        PorscheNewSchemews *indexModel = [cubScheme.projectList objectAtIndex:indexPath.row];
        
        //配件cell
        UITableViewCell *cell = [self getMaterialCellWith:tableView indexPath:indexPath model:indexModel withSupperModel:cubScheme];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
        //项目小计行
    }else if (cubScheme.projectList.count == indexPath.row) {
        
        UITableViewCell *cell = [self getRemarkCellWith:tableView indexPath:indexPath model:cubScheme];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    return nil;
    
}


#pragma mark  底部客户确认------
- (void)sureCustomAction {
    WeakObject(self);
    if ([HDPermissionManager isNotThisPermission:HDOrder_Kehuqueren]) {
        return;
    };
    
    [HDNewSaveView showMakeSureViewAroundView:self.bottomView.customSureBt tittleArray:@[@"客户确认完毕？",@"确定",@"取消"] direction:UIPopoverArrowDirectionUp makeSure:^{
        [selfWeak sureToCustom];
        
    } cancel:^{
        
    }];
}
- (void)sureToCustom {
    WeakObject(self);
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
    [PorscheRequestManager orderSureToNextOrder:5  buttonid:-1 Complete:^(NSInteger status,PResponseModel *responser) {
        [hud hideAnimated:YES];
        if (status == 100) {//
            self.carMessage.orderstatus = [OrderOptStatusDto yy_modelWithDictionary:responser.object];
            [selfWeak sendNotifinationToLeftToReloadDataType:@1];
            [selfWeak getOrderList];
            [selfWeak bottomViewForCustomSure:NO];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:KEY_WINDOW.center superView:HD_FULLView];
        }
    }];
}

- (void)bottomViewForCustomSure:(BOOL)save {
    [self.bottomView setupViewSave:self.carMessage isSave:save];
    self.bottomHelperView.carMessage = self.carMessage;
    [self.bottomHelperView setupViewSave:save];
}

#pragma mark - 客户取消确认
- (void)userCancelAffirm {
    if ([HDPermissionManager isNotThisPermission:HDOrder_ClientAffirm_CanCelAffirm]) {
        return;
    };
    
    [HDNewSaveView showMakeSureViewAroundView:self.bottomView.cancelAffirmBt tittleArray:@[@"是否取消确认？",@"是",@"否"] direction:UIPopoverArrowDirectionUp makeSure:^{
        MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:HD_FULLView];
        WeakObject(hud)
        [PorscheRequestManager userCancelAffirmCompletion:^(PResponseModel * _Nonnull responser) {
            [hudWeak hideAnimated:YES afterDelay:0.1];
            if ((responser.status = 100)) {
                [HDLeftSingleton shareSingleton].maxStatus = 4;
//                [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_RIGHT_STEP_NOTIFINATION object:@{@"left":@2,@"right":@3}];
                [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:@{@"left":@2,@"right":@3}];
            }
        }];
        
    } cancel:^{
        
    }];
}

#pragma mark  ------配件工时行cell------
- (UITableViewCell *)getMaterialCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(PorscheNewSchemews *)model withSupperModel:(PorscheNewScheme *)supperModel {
    HDClientTableViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDClientTableViewTableViewCell" forIndexPath:indexPath];
    cell.supperModel = supperModel;
    cell.tmpModel = model;

    [cell layoutIfNeeded];
    
    return cell;
}

#pragma mark  ------项目小计cell------
- (UITableViewCell *)getRemarkCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath model:(PorscheNewScheme *)model {
    HDCilentItemTotalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDCilentItemTotalTableViewCell" forIndexPath:indexPath];
    
    cell.tmpModel = model;
    [cell layoutIfNeeded];
    return cell;
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


//空白占位图
- (UIButton *)emptyView {
    if (!_emptyView) {
        _emptyView = [UIButton buttonWithType:UIButtonTypeCustom];
        _emptyView.frame = self.view.frame;
        [_emptyView setTitle:@"暂无信息" forState:UIControlStateNormal];
        [_emptyView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _emptyView.titleLabel.font =  [UIFont systemFontOfSize:26 weight:UIFontWeightThin];
    }
    return _emptyView;
}

/****
 *  type:1. 刷新网络数据 2.刷新tableView
 ****/
- (void)sendNotifinationToLeftToReloadDataType:(NSNumber *)type {
    [[HDLeftSingleton shareSingleton] reloadLeftBillingList:type];

}

- (void)updateImage:(UIImage *)image
{
    ZLCamera *photo = [ZLCamera new];
    photo.photoImage = image;
    PorscheRequestUploadPictureVideoModel *request = [PorscheRequestUploadPictureVideoModel new];
    request.edittype = @1;//原图
    request.aifiletype =  @1;//img
    request.aipictype = @4;//客户签字
    request.keytype = @1;//工单
    
    request.relativeid = [HDStoreInfoManager shareManager].carorderid;//工单id
    WeakObject(self);
    [PorscheRequestManager updateCustomSignImages:@[photo] parameModel:request completion:^(id  _Nullable responser, NSError * _Nullable error) {
        if (!error) {
            [selfWeak getOrderList];
        }
    }];
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
