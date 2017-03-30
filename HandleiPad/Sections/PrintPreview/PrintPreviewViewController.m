//
//  PrintPreviewViewController.m
//  HandleiPad
//
//  Created by Handlecar on 10/8/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "PrintPreviewViewController.h"
#import "PrintPreviewCollectionViewCell.h"
#import "RepairSecurityAgreementCollectionViewCell.h"
#import "PorscheStoreModel.h"
#import "PorscheCarModel.h"
#import "TiledPDFView.h"
#import "Printer.h"

#define MINUS_TAG   100  // 减号View
#define PLUS_TAG     101 // 加号View

#define PDFViewBounds   CGRectMake(0, 0, 434, 614)
#define PDFViewTag      100

static NSString *collectionReuseIdentifier = @"printCollection";
static NSString *collectionReuseIdentifier1 = @"repairAgreement"; // 告知书


@interface PrintPreviewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UILabel *printCountLabel;
@property (nonatomic) NSInteger printCount;
@property (weak, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (weak, nonatomic) IBOutlet UIView *printTypeSelectView;
@property (nonatomic, strong) NSArray *printTypes;
@property (weak, nonatomic) IBOutlet UITableView *printTypeTableView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (nonatomic) NSInteger pageIndex;
//打印分类按钮
@property (weak, nonatomic) IBOutlet UIButton *printTypeButton;
//中间分线
@property (weak, nonatomic) IBOutlet UIView *middleLine;

@property (weak, nonatomic) IBOutlet UIButton *printButton;
@property (nonatomic, strong) PorscheStoreModel *storeModel;
@property (nonatomic, strong) PorscheNewCarMessage *carModel;
@property (nonatomic) CGPDFDocumentRef pdf;
@property (nonatomic) NSUInteger numberOfPages;
@property (nonatomic, strong) NSArray *pdfViews;
@property (nonatomic, strong) Printer *printer;
@property (nonatomic) BOOL isZooming;
@property (nonatomic) PDFType pdfType;

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
- (IBAction)closeButtonAction:(id)sender;
- (IBAction)printCategoryAction:(id)sender;
- (IBAction)segmentAction:(id)sender;
- (IBAction)arrowAction:(id)sender;

@end

@implementation PrintPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置默认打印张数
    self.printCount = 2;
    self.leftArrowButton.hidden = YES;
    [self.printButton setImage:[UIImage imageNamed:@"hd_client_print_pic.png"] forState:UIControlStateNormal];
    self.printButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.printButton.imageEdgeInsets = UIEdgeInsetsMake(8, -20, 8, 0);
    self.printButton.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    
    self.contentView.maximumZoomScale = 2;
    
    self.contentView.minimumZoomScale = 1;
    self.contentView.delegate = self;
    self.rightArrowButton.hidden = YES;
    [self configSegmentView];
    [self configCollectionView];
    [self configPrintTypeModel];
    [self configTableView];
    self.collectionView.contentSize = CGSizeMake(1000, 0);
    
    [self upDataView];
    
    _pdfType = [[self.info objectForKey:@"ordertype"] integerValue];
    
    NSInteger printCount = [[self.info objectForKey:@"count"] integerValue];
    
    if (printCount)
    {
        self.printCount = printCount;
    }
    else
    {
        self.printCount = 2;
    }
    
    
//    if (_pdfType == 0)
//    {
//        _pdfType = PDF_Quotation;
//    }
//    
//    [self getPDFFileWithType:_pdfType];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, PDF_NAME];
    [self initializerPDFInfoWithURL:[[NSURL alloc]initFileURLWithPath:fullPath]];
}

#pragma mark - 缩放

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.collectionView;
}

- (instancetype)initWithPDFURL:(NSURL *)PDFUrl
{
    self = [super init];
    if (self) {
//        [self initializerPDFInfoWithURL:PDFUrl];
    }
    return self;
}


// 初始化 pdf 文件信息
- (void)initializerPDFInfoWithURL:(NSURL *)url
{
    NSLog(@"url %@",url);
    self.pdf = CGPDFDocumentCreateWithURL( (__bridge CFURLRef) url );
    self.numberOfPages = (int)CGPDFDocumentGetNumberOfPages( self.pdf );
//    if( self.numberOfPages % 2 ) self.numberOfPages++;
    self.pdfViews = [self initializerPDFViews];
    [self.collectionView reloadData];
    
    if (self.numberOfPages < 3)
    {
        self.rightArrowButton.hidden = YES;
    }
    else
    {
        self.rightArrowButton.hidden = NO;
    }
    
}


/**
 获取pdf指定页的信息

 @param index pdf 页数索引
 @return pdf 页面信息
 */
- (CGPDFPageRef)PDFPageWithIndex:(NSUInteger)index
{
   CGPDFPageRef page =  CGPDFDocumentGetPage( self.pdf, index + 1 );
    return page;
}

- (NSArray *)initializerPDFViews
{
    NSMutableArray *views = [NSMutableArray array];
    for (NSUInteger i  = 0; i < self.numberOfPages; i++)
    {
        TiledPDFView *pdfView = [[TiledPDFView alloc] initWithFrame:PDFViewBounds scale:0.73];
        [pdfView setPage: [self PDFPageWithIndex:i]];
        pdfView.tag = PDFViewTag;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:PDFViewBounds];
        imageView.image = [self cutViewWithInputView:pdfView];
        
        [views addObject:imageView];
    }
    return views;
}


- (UIImage *)cutViewWithInputView:(UIView *)inputView
{
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
    
}

//设置进入的样式
- (void)upDataView {
    _fromStyle = (PrintPreviewVCFromStyle)[[self.info objectForKey:@"fromstyle"] integerValue];
    if (_fromStyle == PrintPreviewVCFromStyle_userAffirm) {
//        self.printTypeButton.hidden = NO;
        self.printCountLabel.hidden = NO;
        self.segmentView.hidden = NO;
        self.middleLine.hidden = NO;
    }else if (_fromStyle == PrintPreviewVCFromStyle_Service) {
        self.printTypeButton.hidden = YES;
        self.printCountLabel.hidden = YES;
        self.segmentView.hidden = YES;
        self.middleLine.hidden = YES;
    }
}

- (void)configTableView
{
    self.printTypeTableView.delegate = self;
    self.printTypeTableView.dataSource = self;
    self.printTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPrintTypeSelectView:)];
    [_maskView addGestureRecognizer:tap];
    [self shouldShowPrintSelectView:NO];
}

- (void)getPDFFileWithType:(PDFType)type
{
    
    if (![[[HDStoreInfoManager shareManager] carorderid] integerValue])
    {
        // 未选择工单
      [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"未选择工单" height:60 center:HD_FULLView.center superView:HD_FULLView];
        return;
    }
    NSDictionary *param = nil;
    NSString *URLStr = PRINT_SPAREPDF;
    if (type == PDF_Quotation)
    {
        param = @{@"type":@1};
        URLStr = PRINT_QUOTATIONPDF;
    }
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    [PorscheRequestManager downloadPDFWithURLStr:URLStr params:param orderid:[[HDStoreInfoManager shareManager] carorderid] completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        if (!error)
        {
            if ([filePath absoluteString].length)
            {
                [self initializerPDFInfoWithURL:filePath];
            }
        }
    }];
}

- (void)hiddenPrintTypeSelectView:(id)sender
{
    [self shouldShowPrintSelectView:NO];
}

- (void)shouldShowPrintSelectView:(BOOL)isShould
{
    self.printTypeSelectView.hidden = !isShould;
    self.maskView.hidden = !isShould;
}


- (void)configPrintTypeModel
{
    _printTypes = @[@"全部",@"保修",@"自费",@"内结"];
    [_printTypeTableView reloadData];
}

- (void)setPrintCount:(NSInteger)printCount
{
    _printCount = printCount;
    _printCountLabel.text = [NSString stringWithFormat:@"打印份数：%ld",(long)_printCount];
}

- (void)configSegmentView
{
    self.segmentView.layer.cornerRadius = 5.0f;
    self.segmentView.layer.borderColor = MAIN_BLUE.CGColor;
    self.segmentView.layer.borderWidth = 1;
}

- (void)configCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"PrintPreviewCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:collectionReuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RepairSecurityAgreementCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:collectionReuseIdentifier1];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.numberOfPages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PrintPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionReuseIdentifier forIndexPath:indexPath];
    
    [[cell.contentView viewWithTag:PDFViewTag] removeFromSuperview];
    TiledPDFView *pdfView = [self.pdfViews objectAtIndex:indexPath.item];
    [cell.contentView addSubview:pdfView];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    _pageIndex = scrollView.contentOffset.x / self.collectionView.bounds.size.width;
    if (!self.isZooming) {
        
        if (self.collectionView.contentOffset.x > 0 )// self.collectionView.bounds.size.width / 2)
        {
            self.leftArrowButton.hidden = NO;
            //        if (self.leftArrowButton.isHidden == YES && self.collectionView.contentSize.width > self.collectionView.bounds.size.width)
            //        {
            //            self.leftArrowButton.hidden = NO;
            //        }
        }
        else
        {
            if (self.leftArrowButton.isHidden == NO) {
                self.leftArrowButton.hidden = YES;
            }
        }
    }
    
    if (!self.isZooming) {
        
        if (self.collectionView.contentSize.width > self.collectionView.bounds.size.width && self.collectionView.contentOffset.x + self.collectionView.bounds.size.width < self.collectionView.contentSize.width)
        {
            if (self.rightArrowButton.isHidden == YES)
            {
                self.rightArrowButton.hidden = NO;
            }
        }
        else
        {
            if (self.rightArrowButton.isHidden == NO) {
                self.rightArrowButton.hidden = YES;
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.leftArrowButton.userInteractionEnabled = YES;
    self.rightArrowButton.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.leftArrowButton.userInteractionEnabled = YES;
    self.rightArrowButton.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.leftArrowButton.userInteractionEnabled = YES;
    self.rightArrowButton.userInteractionEnabled = YES;
}
#pragma mark -- tableView delegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.printTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *printTypereuseStr = @"printType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:printTypereuseStr];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:printTypereuseStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 164, 42)];
        
        titleLabel.textColor = MAIN_BLUE;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.tag = 333;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
        
        UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(10, cell.bounds.size.height - 1, 144, 1)];
        line.backgroundColor = [UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1];
        [cell.contentView addSubview:line];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:333];
    titleLabel.text = [self.printTypes objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self shouldShowPrintSelectView:NO];
    
 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButtonAction:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (IBAction)printAction:(id)sender {
    
#pragma mark -- 添加异常判断

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, PDF_NAME];
//    NSData *pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullPath]];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* data = [[NSData alloc] init];
    data = [fm contentsAtPath:fullPath];
    [self.printer selectPrinterToPrinterWithView:self.view copies:_printCount printPDFData:data];
}

- (Printer *)printer
{
    if (!_printer) {
        _printer = [[Printer alloc] init];
    }
    return _printer;
}

- (IBAction)printCategoryAction:(id)sender {
    [self shouldShowPrintSelectView:YES];
}

- (IBAction)segmentAction:(id)sender {
    UIButton *segmentButton = (UIButton *)sender;
    
    if (segmentButton.tag == MINUS_TAG)
    {
        if (_printCount - 1 >= 1)
        {
            self.printCount -= 1;
        }
        else
        {
            self.printCount = 1;
        }
    }
    else
    {
        self.printCount += 1;
    }
}

- (IBAction)arrowAction:(id)sender {
    
    // 计算一共多少页
//    NSInteger count = ceil(self.collectionView.contentSize.width / self.collectionView.bounds.size.width);
    
    UIButton *arrowButton = (UIButton *)sender;
    if (arrowButton == self.leftArrowButton)
    {
            _pageIndex--;
    }
    else
    {
        _pageIndex++;
    }
    if (_pageIndex > 1) {
        _pageIndex = 1;
    }
    
    if (_pageIndex < 0) {
        _pageIndex = 0;
    }
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:_pageIndex * 2  inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    self.leftArrowButton.userInteractionEnabled = NO;
    self.rightArrowButton.userInteractionEnabled = NO;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidZoom");
    
    self.isZooming = YES;
    //捏合或者移动时，确定正确的center
    CGFloat centerX = scrollView.center.x;
    
    CGFloat centerY = scrollView.center.y;
    
    //随时获取center位置
    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX;
    
    centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : centerY;
    
    if (scrollView.contentSize.height > scrollView.frame.size.height) {
        _collectionView.scrollEnabled = NO;
    }else {
        _collectionView.scrollEnabled = YES;
    }
    _leftArrowButton.hidden = YES;
    _rightArrowButton.hidden = YES;
//    self.collectionView.center = CGPointMake(centerX, centerY);
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scale == 1)
    {
        self.isZooming = NO;
        [self scrollViewDidScroll:_collectionView];
    }
}
@end
