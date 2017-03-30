//
//  HDServiceRightCell.m
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRightCell.h"
#import "HDServiceRightDetailCell.h"
#import "RemarkListView.h"
#import "PorschePhotoGallery.h"
#import "PorschePhotoModelController.h"
//打印提示弹窗
#import "PorschePrintAffirmView.h"
#import "SpareSettingViewController.h"
// 打印类
#import "Printer.h"
#import "HDLeftSingleton.h"
#import "HDPreCheckViewController.h"
@interface HDServiceRightCell ()<UITableViewDelegate, UITableViewDataSource, HDServiceRightDetailCelldelegate>
@property (nonatomic, assign) NSInteger left;
@property (nonatomic, assign) NSInteger right;
//下面的view（点点点）
@property (weak, nonatomic) IBOutlet UIView *LeftBottomView;
// 媒体处理类
@property (nonatomic, strong) PorschePhotoModelController *modelController;
@property (nonatomic, strong) Printer *printer;
@end

@implementation HDServiceRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    
    for (UIView *view in self.subviews) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 3;
    }
    
}
- (void)setDetailModel:(HDServiceRecordsRightDetailCellModel *)detailModel {
    _detailModel = detailModel;
    
    if (_detailModel.finishedSolutionlist.count < 5) {
        _LeftBottomView.hidden = YES;
    }else {
        _LeftBottomView.hidden = NO;
    }
    if (!_detailModel.unfinishedSolutionlist.count) {
        _rightView.hidden = YES;
    }else {
        _rightView.hidden = NO;
        
    }
    
    [_leftTableView reloadData];
    [_rightTableView reloadData];
}
- (void)setViewStyle:(ServiceRightBottomViewStyle)viewStyle {
    _viewStyle = viewStyle;
    [_rightTableView reloadData];
}
#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        return 21;
    }else {
        return 30;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return _detailModel.finishedSolutionlist.count;
    }else {
        return _detailModel.unfinishedSolutionlist.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    
    if (tableView == _leftTableView) {
        HDServiceRightDetailCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"serviceRightDetailOne"];
        leftCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (leftCell == nil) {
            leftCell = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRightDetailCell" owner:self options:nil] objectAtIndex:0];
        }
        leftCell.backgroundColor = [UIColor clearColor];
        HDserviceDetailCellCustomModel *leftModel = _detailModel.finishedSolutionlist[indexPath.row];
        //添加长按方法
//        UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(serviceRightDetailOneLongPress:)];
//        [leftCell addGestureRecognizer:longG];
        
        leftCell.neiImageView.hidden = YES;
        leftCell.baoImageView.hidden = YES;
        [leftCell.baoImageView setImage:nil];
        [leftCell.neiImageView setImage:nil];
        leftCell.leftContentLbDisPriceLb.constant = 5;
        
        //数据展示
        leftCell.leftContentLabel.text = leftModel.schemename;
        leftCell.priceLabel.text = [self setStringStyleWithNumber:leftModel.schemeprice withStyle:NSNumberFormatterCurrencyStyle];
        
        if ([leftModel.guranteeflag integerValue] == 1 || [leftModel.innerflag integerValue] == 1) {
            if ([leftModel.guranteeflag integerValue] == 1 && [leftModel.innerflag integerValue] == 1) {
                leftCell.baoImageView.hidden = NO;
                [leftCell.baoImageView setImage:[UIImage imageNamed:@"fullLeftListForRight_insureBule"]];
                leftCell.neiImageView.hidden = NO;
                [leftCell.neiImageView setImage:[UIImage imageNamed:@"billing_pay_inside"]];
                leftCell.leftContentLbDisPriceLb.constant = 36;
            }else if ([leftModel.guranteeflag integerValue] != 1 || [leftModel.innerflag integerValue] == 1) {
                leftCell.neiImageView.hidden = NO;
                [leftCell.neiImageView setImage:[UIImage imageNamed:@"billing_pay_inside"]];
                leftCell.leftContentLbDisPriceLb.constant = 19;
            }else {
                leftCell.neiImageView.hidden = NO;
                [leftCell.neiImageView setImage:[UIImage imageNamed:@"fullLeftListForRight_insureBule"]];
                leftCell.leftContentLbDisPriceLb.constant = 19;
            }
        }
        return leftCell;
    }else {
        HDServiceRightDetailCell *rightCell = [tableView dequeueReusableCellWithIdentifier:@"serviceRightDetailTwo"];
        rightCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (rightCell == nil) {
            rightCell = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRightDetailCell" owner:self options:nil] objectAtIndex:1];
        }
        rightCell.backgroundColor = [UIColor clearColor];
        rightCell.delegate = self;
        
        HDserviceDetailCellCustomModel *rightModel = _detailModel.unfinishedSolutionlist[indexPath.row];
        
        if ([rightModel.doneflag integerValue])
        {
            rightCell.markImageView.image = [UIImage imageNamed:@"finished_mark.png"];
        }
        else
        {
            rightCell.markImageView.image = nil;
        }
        //选中状态判断
        if (_viewStyle == ServiceRightBottomViewStyle_shoppingCart_yes) {
            rightCell.selectButton.hidden = NO;
            if (rightModel.isSelect) {
                [rightCell.selectButton setImage:[UIImage imageNamed:@"work_list_29"] forState:UIControlStateNormal];
            }else {
                [rightCell.selectButton setImage:[UIImage imageNamed:@"work_list_30"] forState:UIControlStateNormal];
            }
        }else {
            rightCell.selectButton.hidden = YES;
        }
        
        
        //添加长按方法
        UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(serviceRightDetailTwoLongPress:)];
        [rightCell addGestureRecognizer:longG];
        
        //添加左滑方法
        UISwipeGestureRecognizer *swipeG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(serviceRightDetailTwoSwipe:)];
        swipeG.direction = UISwipeGestureRecognizerDirectionLeft;
        [rightCell addGestureRecognizer:swipeG];
        
        //数据展示
        rightCell.rightContentLabel.text = rightModel.schemename;
        rightCell.LeftPriceLabel.text = [self setStringStyleWithNumber:rightModel.schemeprice withStyle:NSNumberFormatterCurrencyStyle];
        
        return rightCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        return;
    }else {
        if (_viewStyle == ServiceRightBottomViewStyle_shoppingCart_yes) {
            HDserviceDetailCellCustomModel *model = (HDserviceDetailCellCustomModel *)_detailModel.unfinishedSolutionlist[indexPath.row];
            HDServiceRightDetailCell *rightCell = [_rightTableView cellForRowAtIndexPath:indexPath];
            UIButton *btn = rightCell.selectButton;
            btn.selected = !btn.selected;
            if (btn.selected) {
                model.isSelect = YES;
                if (_selectRightCellBlock) {
                    _selectRightCellBlock(ServiceRightCellSelect_selected, _detailModel, model);
                }
            }else {
                model.isSelect = NO;
                if (_selectRightCellBlock) {
                    _selectRightCellBlock(ServiceRightCellSelect_noSelected, _detailModel, model);
                }
            }
        }else {
            return;
        }
    }
}
#pragma mark - cell代理
- (void)cellButtonActionWithcell:(HDServiceRightDetailCell *)cell withButton:(UIButton *)sender {
    HDServiceRightDetailCell *rightCell = cell;
    NSIndexPath *indexPath = [_rightTableView indexPathForCell:cell];
    HDserviceDetailCellCustomModel *model = (HDserviceDetailCellCustomModel *)_detailModel.unfinishedSolutionlist[indexPath.row];
    
    UIButton *btn = rightCell.selectButton;
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        model.isSelect = YES;
        if (_selectRightCellBlock) {
            _selectRightCellBlock(ServiceRightCellSelect_selected, _detailModel, model);
        }
    }else {
        model.isSelect = NO;
        if (_selectRightCellBlock) {
            _selectRightCellBlock(ServiceRightCellSelect_noSelected, _detailModel, model);
        }
    }
}
#pragma mark - 处理数字，添加逗号
- (NSString *)setStringStyleWithNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style {
    NSString *string = @"";
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:style];
    string = [currencyFormatter stringFromNumber:number];
    if ([[string substringToIndex:1] isEqualToString:@"$"]) {
        string = [NSString stringWithFormat:@"￥%@", [string substringFromIndex:1]];
    }
    return string;
}


#pragma mark -  长按方法（左侧）
- (void)serviceRightDetailOneLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
//        CGPoint location = [longPress locationInView:_leftTableView];
//        NSIndexPath *indexPath = [_leftTableView indexPathForRowAtPoint:location];
//        HDServiceRightDetailCell *cell = (HDServiceRightDetailCell *)longPress.view;
//        //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
//        [cell becomeFirstResponder];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PREVIEW_NOTIFICATION object:@{@"fromstyle":@0}];
        // 预览报价单
//        [self loadPrintCategorysSelectViewWithPrintType:SparePrintTypePreView];
        [self getPDFFileWithType:PDF_Quotation spareInfo:nil printType:SparePrintTypePreView printCategory:@[] printCount:2 isRightView:NO];
    }
}


#pragma mark - 长按方法（右侧）
- (void)serviceRightDetailTwoLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
//        CGPoint location = [longPress locationInView:_rightTableView];
//        NSIndexPath *indexPath = [_leftTableView indexPathForRowAtPoint:location];
        HDServiceRightDetailCell *cell = (HDServiceRightDetailCell *)longPress.view;
        //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
        [cell becomeFirstResponder];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PREVIEW_NOTIFICATION object:@{@"fromstyle":@0}];
        // 预览报价单
//        [self loadPrintCategorysSelectViewWithPrintType:SparePrintTypePreView];
        [self getPDFFileWithType:PDF_Quotation spareInfo:nil printType:SparePrintTypePreView printCategory:@[] printCount:2 isRightView:YES];
    }
}

#pragma mark - 左滑方法（右侧）
- (void)serviceRightDetailTwoSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
//        CGPoint location = [swipe locationInView:_leftTableView];
//        NSIndexPath *indexPath = [_rightTableView indexPathForRowAtPoint:location];
        HDServiceRightDetailCell *cell = (HDServiceRightDetailCell *)swipe.view;
        NSIndexPath *indexPath = [_rightTableView indexPathForCell:cell];
        //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
        [cell becomeFirstResponder];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:_detailModel.unfinishedSolutionlist];
        HDserviceDetailCellCustomModel *model = array[indexPath.row];
//        [array removeObject:model];
//        _detailModel.unfinishedSolutionlist = array;
        
        if (![HDPermissionManager isHasThisPermission:HDServiceRecords_IgnoreUnfinishProject]) {
            return;
        }
        
        //左滑删除方案
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param hs_setSafeValue:model.schemeid forKey:@"schemeid"];
        WeakObject(self)
        [PorscheRequestManager deleteUnfinishFanganForForServiceRecordsRightWithParam:param completion:^(PResponseModel * _Nonnull responser) {
            if (responser.status == 100) {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"save_already_billing.png"] message:@"方案忽略成功!" height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
                if (selfWeak.refreshVCBlock) {
                    selfWeak.refreshVCBlock();
                }
            }
        }];
        
        [_rightTableView reloadData];
    }
}


#pragma mark - cell上的button点击事件
- (IBAction)cellButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case 100://添加图片库
        {
            //点击 获取工单id
//            [HDStoreInfoManager shareManager].carorderid = _detailModel.orderid;
            [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_PHOTOLIST parameters:nil orderid:_detailModel.orderid completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
                if (responser.status == 100) {
                    PorscheGalleryModel *model = [PorscheGalleryModel yy_modelWithDictionary:responser.object];
                    [self.modelController showPhotoGalleryWithModel:model viewType:PorschePhotoGalleryPreview];
                }
            } isNeedShowPopView:NO];

//            [PorschePhotoModelController getPhotoListCompletion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
//                if (responser.status == 100) {
//                    PorscheGalleryModel *model = [PorscheGalleryModel yy_modelWithDictionary:responser.object];
//                    [self.modelController showPhotoGalleryWithModel:model viewType:PorschePhotoGalleryPreview];
//                }
//            }];
        }
            break;
        case 101://添加备注
        {
            //点击 获取工单id
//            [HDStoreInfoManager shareManager].carorderid = _detailModel.orderid;
//            [HDStoreInfoManager shareManager].carorderid = @2973;
            [PHTTPRequestSender sendRequestWithURLStr:TOP_MEMO_LIST parameters:nil orderid:_detailModel.orderid completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
                
                if (responser.status == 100) {
                    NSMutableArray *array = [NSMutableArray array];
                    for (NSDictionary *dic in responser.list) {
                        RemarkListModel *data = [RemarkListModel yy_modelWithDictionary:dic];
                        [array addObject:data];
                    }
                    
                    
                    if (array.count) {
                        [self popRemarkListViewFromView:sender.superview withData:[array mutableCopy]];
                    }else {
                        [MBProgressHUD showMessageText:responser.msg toView:KEY_WINDOW anutoHidden:YES];
                    }
                    
                }else {
                    [MBProgressHUD showMessageText:responser.msg toView:KEY_WINDOW anutoHidden:YES];
                }

                
            } isNeedShowPopView:NO];
            
        }
            break;
        case 102://预检单
        {
//            WeakObject(self)
//            NSMutableDictionary *param = [NSMutableDictionary dictionary];
//            MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
//            [PorscheRequestManager downloadPDFWithURLStr:PreCheck_Print params:param orderid:_detailModel.orderid completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
//                [hud hideAnimated:YES];
//                if (!error) {
//                    
//                    if ([filePath absoluteString].length) {
//                        [selfWeak gotoPrintViewWithPrintType:PDF_Quotation count:1];
//                    }
//                }
//            }];
            HDPreCheckViewController *precheckViewController = [[HDPreCheckViewController alloc] init];
            precheckViewController.carorderNum = _detailModel.orderid;
            precheckViewController.viewForm = @1;

            CGRect frame = precheckViewController.view.frame;
            ViewController *vc = [HDLeftSingleton shareSingleton].VC;
            frame = vc.view.frame;
            frame.size.width -= 100;
            frame.size.height -= 100;
            
            frame.origin.x = 30;
            frame.origin.y = 30;
            
            precheckViewController.view.frame = frame;
            
            
            //    [vc addChildViewController:precheckViewController];
            //    [vc.view addSubview:precheckViewController.view];
            //    [vc.navigationController pushViewController:precheckViewController animated:YES];
            [vc presentViewController:precheckViewController animated:YES completion:NULL];
            
        }
            break;
            
        default:
            break;
    }
    
}
#pragma mark -- 弹出备注列表
- (void)popRemarkListViewFromView:(UIView *)view withData:(NSMutableArray *)dataSource
{
    RemarkListView *remarkView = [[[NSBundle mainBundle] loadNibNamed:@"RemarkListView" owner:self options:nil] objectAtIndex:0];
    remarkView.viewFormStyle = ViewForm_serviceRecordsRightBtn;
    remarkView.dataSource = [NSMutableArray arrayWithArray:dataSource];
    
    
    UIViewController *contentVC = [[UIViewController alloc] init];
    contentVC.view.frame = remarkView.bounds;
    [contentVC.view addSubview:remarkView];
    contentVC.automaticallyAdjustsScrollViewInsets = NO;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:contentVC];
    popover.backgroundColor = [UIColor whiteColor];
    popover.popoverContentSize = remarkView.bounds.size;// CGSizeMake(300, 300); //弹出窗口大小，如果屏幕画不下，会挤小的。这个值默认是320x1100
    CGRect viewFrame = view.frame;
    viewFrame.origin.y += view.frame.size.height / 2;
    
    //    CGRect popoverRect = _detailv
    [popover presentPopoverFromRect:viewFrame  //popoverRect的中心点是用来画箭头的，如果中心点如果出了屏幕，系统会优化到窗口边缘
                             inView:self //上面的矩形坐标是以这个view为参考的
           permittedArrowDirections:UIPopoverArrowDirectionDown  //箭头方向
                           animated:YES];
}




#pragma mark - 图片列浏览库
- (PorschePhotoModelController *)modelController
{
    if (!_modelController)
    {
        _modelController = [[PorschePhotoModelController alloc] init];
//        _modelController.supporterViewController = self;
    }
    return _modelController;
}

#pragma mark -- 加载打印分类视图 ----
// 加载打印分类视图
- (void)loadPrintCategorysSelectViewWithPrintType:(SparePrintType)printType
{
    WeakObject(self)
    PorschePrintAffirmView *printView = [PorschePrintAffirmView showPrinAffirmViewAndComplete:^(NSArray *pays, NSInteger count) {
        //type 打印类型
        //count 打印份数
        // 进入打印页面
        // 获取打印pdf数据
        [selfWeak getPDFFileWithType:PDF_Quotation spareInfo:nil printType:printType printCategory:pays printCount:count isRightView:NO];
        //        [self gotoPrintViewWithPrintType:pdftype];
    }];
    [HD_FULLView addSubview:printView];
}
#pragma mark -- 获取PDF信息
- (void)getPDFFileWithType:(PDFType)type spareInfo:(NSArray *)spareInfo printType:(SparePrintType)printType printCategory:(NSArray *)category printCount:(NSUInteger)count isRightView:(BOOL)isRightView
{
    
    if (![_detailModel.orderid integerValue])
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
        if (isRightView) {
            [param hs_setSafeValue:@1 forKey:@"showuncompleteflag"];
        }
        
        //        [param hs_setSafeValue:spareInfo forKey:@"pdfPartsInfoDtos"];
        
        URLStr = PRINT_QUOTATIONPDF;
    }
    else
    {
        param = [NSMutableDictionary dictionary];
        [param hs_setSafeValue:spareInfo forKey:@"pdfPartsInfoDtos"];
    }
//    [HDStoreInfoManager shareManager].carorderid = _detailModel.orderid;
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    [PorscheRequestManager downloadPDFWithURLStr:URLStr params:param orderid:_detailModel.orderid completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        if (!error)
        {
            if ([filePath absoluteString].length)
            {
//               [self initializerPDFInfoWithURL:filePath];
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
    NSDictionary *info = @{@"fromstyle":@0, @"ordertype":type};
//    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PREVIEW_NOTIFICATION object:info];
    [[HDLeftSingleton shareSingleton] showPreView:info];

}
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
