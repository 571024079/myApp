//
//  HDServiceRightContentView.m
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRightContentView.h"
#import "HDServiceRightCell.h"
#import "HDServiceSectionHeaderView.h"
#import "HDLeftSingleton.h"
#import "Printer.h"
#import "SpareSettingViewController.h"

@interface HDServiceRightContentView ()<UITableViewDelegate, UITableViewDataSource>
//右侧cell选中的数据
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabelTwo;
@property (nonatomic, strong) Printer *printer;
@property (nonatomic, copy) NSNumber *currentOrderid;

@end

@implementation HDServiceRightContentView

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRightContentView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HDServiceRightCell" bundle:nil] forCellReuseIdentifier:@"serviceRightCell"];
    
    _selectArray = [NSMutableArray array];
    
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
}
- (void)setRightModel:(HDServiceRecordsRightModel *)rightModel {
    _rightModel = rightModel;
    [_tableView reloadData];
}
- (void)setViewStyle:(ServiceRightBottomViewStyle)viewStyle {
    _viewStyle = viewStyle;
    if (_viewStyle == ServiceRightBottomViewStyle_shoppingCart_no) {
        _rightTopLabelTwo.text = @"②左滑卡片内项目为忽略";
    }else if (_viewStyle == ServiceRightBottomViewStyle_shoppingCart_yes) {
        _rightTopLabelTwo.text = @"②左滑卡片内项目为忽略 ③点击卡片内项目为选中";
    }
    
    [_tableView reloadData];
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _rightModel.workorderlist.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDServiceYearListModel *yearModel = _rightModel.workorderlist[section];
    return yearModel.workorderlistdetail.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDServiceRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"serviceRightCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        NSArray *nibCells = [[NSBundle mainBundle] loadNibNamed:@"HDServiceRightCell" owner:nil options:nil];
        cell = [nibCells objectAtIndex:0];
    }
    HDServiceYearListModel *yearModel = _rightModel.workorderlist[indexPath.section];
    HDServiceRecordsRightDetailCellModel *model = yearModel.workorderlistdetail[indexPath.row];
    
    cell.detailModel = model;
    
    cell.leftTimeLabel.text = [self setTimeWithTimeString:model.finisheddate];
    if ([model.miles integerValue]) {
        cell.leftDistanceLabel.text = [NSString stringWithFormat:@"%@km", [self setStringStyleWithNumber:model.miles withStyle:NSNumberFormatterDecimalStyle]];
    }else {
        cell.leftDistanceLabel.text = [NSString stringWithFormat:@"--公里数"];
    }
    //处理数字
    cell.leftPriceLabel.text = [NSString stringWithFormat:@"总价：%@", [self setStringStyleWithNumber:model.ordertotalprice withStyle:NSNumberFormatterCurrencyStyle]];
    if ([model.miles integerValue]) {
        cell.rightDistanceLabel.text = [NSString stringWithFormat:@"%@km", [self setStringStyleWithNumber:model.miles withStyle:NSNumberFormatterDecimalStyle]];
    }else {
        cell.rightDistanceLabel.text = [NSString stringWithFormat:@"--公里数"];
    }
    
    cell.unfinishedTotalPriceLabel.text = [NSString stringWithFormat:@"总价：%@",[self setStringStyleWithNumber:model.orderundototalprice withStyle:NSNumberFormatterCurrencyStyle]];
    
    //显示取消接车的图标
    if ([model.wostatus integerValue] == 99) {
        cell.cancelImageView.hidden = NO;
    }else {
        cell.cancelImageView.hidden = YES;
    }
    
    
    cell.viewStyle = _viewStyle;
    
    // cell的回调方法
    WeakObject(self);
    WeakObject(cell);
    cell.selectRightCellBlock = ^(ServiceRightCellSelect selectType, HDServiceRecordsRightDetailCellModel *model, HDserviceDetailCellCustomModel *selectModel) {
        
        NSIndexPath *indexPathS = [_tableView indexPathForCell:cellWeak];
        HDServiceYearListModel *yearModelS = _rightModel.workorderlist[indexPathS.section];
        
        if (selectType == ServiceRightCellSelect_selected) {//选中
            [_selectArray addObject:selectModel];
        }else if (selectType == ServiceRightCellSelect_noSelected) {//未选中
            if (_selectArray.count) {
                NSMutableArray *arrId = [NSMutableArray array];
                for (HDserviceDetailCellCustomModel *model in _selectArray) {
                    [arrId addObject:model.schemeid];
                }
                if ([arrId containsObject:selectModel.schemeid]) {
                    [_selectArray removeObject:selectModel];
                }
            }
        }
        if (selfWeak.contentViewCellBlock) {
            selfWeak.contentViewCellBlock(_selectArray, _rightModel);
        }
    };
    //中间过度层刷新VC回调 
    cell.refreshVCBlock = ^() {
        if (selfWeak.refreshVCBlock) {
            selfWeak.refreshVCBlock();
        }
    };
    
    // 左边视图添加手势
    //添加长按方法
    UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(serviceRightDetailOneLongPress:)];
    [cell.leftView addGestureRecognizer:longG];
    cell.leftView.tag = [model.orderid integerValue];
    
    
    return cell;
}


#pragma mark -  长按方法（左侧）
- (void)serviceRightDetailOneLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //        CGPoint location = [longPress locationInView:_leftTableView];
        //        NSIndexPath *indexPath = [_leftTableView indexPathForRowAtPoint:location];
//        HDServiceRightDetailCell *cell = (HDServiceRightDetailCell *)longPress.view;
//        //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
//        [cell becomeFirstResponder];
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_PREVIEW_NOTIFICATION object:@{@"fromstyle":@0}];
        // 预览报价单
        //        [self loadPrintCategorysSelectViewWithPrintType:SparePrintTypePreView];
        
        self.currentOrderid = @(longPress.view.tag);
    
        [self getPDFFileWithType:PDF_Quotation spareInfo:nil printType:SparePrintTypePreView printCategory:@[] printCount:2];
    }
}

#pragma mark -- 获取PDF信息
- (void)getPDFFileWithType:(PDFType)type spareInfo:(NSArray *)spareInfo printType:(SparePrintType)printType printCategory:(NSArray *)category printCount:(NSUInteger)count
{
    
    if (![self.currentOrderid integerValue])
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
    else
    {
        param = [NSMutableDictionary dictionary];
        [param hs_setSafeValue:spareInfo forKey:@"pdfPartsInfoDtos"];
    }
//    [HDStoreInfoManager shareManager].carorderid = self.currentOrderid;
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    [PorscheRequestManager downloadPDFWithURLStr:URLStr params:param orderid:self.currentOrderid completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
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

- (Printer *)printer
{
    if (!_printer) {
        _printer = [[Printer alloc] init];
    }
    return _printer;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDServiceSectionHeaderView *sectionHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceSectionHeaderView" owner:self options:nil] firstObject];
    HDServiceYearListModel *yearModel = _rightModel.workorderlist[section];
    NSString *imageName = [NSString stringWithFormat:@"service_%@", yearModel.year];
    sectionHeaderView.yearImageView.image = [UIImage imageNamed:imageName];
    return sectionHeaderView;
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
#pragma mark - 处理后台返回的时间
- (NSString *)setTimeWithTimeString:(NSString *)timeString {
    NSString *time = timeString;
    if (timeString.length > 10) {
        NSArray *arr = [timeString componentsSeparatedByString:@" "];
        time = arr.firstObject;
    }
    
    return time;
}


@end
