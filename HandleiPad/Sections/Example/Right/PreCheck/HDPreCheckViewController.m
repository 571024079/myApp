//
//  HDPreCheckViewController.m
//  HandleiPad
//
//  Created by Handlecar on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDPreCheckViewController.h"
#import "HDPreCheckCommonCollectionCell.h"//选择 cell
#import "PrecheckCarBodyCollectionViewCell.h"
#import "PrecheckFileTitleCollectionReusableView.h"
#import "PrecheckSubTitleCollectionReusableView.h"
#import "PrecheckTitleCollectionReusableView.h"
#import "RemarkInfoCollectionReusableView.h"
#import "HDPreCheckModel.h"
#import "Printer.h"
#import "HDLeftSingleton.h"
#import "PrintPreviewViewController.h"

@interface HDPreCheckViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *printView;
@property (weak, nonatomic) IBOutlet UIView *printCountView;
@property (weak, nonatomic) IBOutlet UILabel *printCountLabel;
@property (nonatomic, strong) Printer *printer;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) HDPreCheckModel *preCheckData;

@end

@implementation HDPreCheckViewController
- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCollectionViewStyle];
    [self setPrintViewStyle];
    [self loadPreCheckData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setCarorderNum:(NSNumber *)carorderNum {
    _carorderNum = carorderNum;
}
- (void)setViewForm:(NSNumber *)viewForm {
    _viewForm = viewForm;
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:
            [self.collectionView reloadData];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            [self.collectionView reloadData];
            break;
        case UIDeviceOrientationLandscapeLeft:
            
            [self.collectionView reloadData];
            break;
        case UIDeviceOrientationLandscapeRight:
            
            [self.collectionView reloadData];
            break;
        default:
            break;
    }
    
}


- (void)loadPreCheckData {
    WeakObject(self)
    
    NSNumber *order = [selfWeak.carorderNum integerValue] ? selfWeak.carorderNum : nil;
    
    [PorscheRequestManager preCheckGetDataWithOrderID:order completion:^(PResponseModel * _Nonnull responser) {
        if (responser) {
            selfWeak.preCheckData = nil;
            selfWeak.preCheckData = [HDPreCheckModel yy_modelWithDictionary:responser.object];
            
            
            [selfWeak.collectionView reloadData];
        }
    }];
}

- (void)setPrintViewStyle {
    self.printCountView.layer.borderColor = MAIN_BLUE.CGColor;
    self.printCountView.layer.borderWidth = 1.0;
    self.printCountView.layer.cornerRadius = 5;
    self.printCountView.layer.masksToBounds = YES;
}

//设置 CollectionView
- (void)setCollectionViewStyle {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.maximumZoomScale = 2;
    _scrollView.minimumZoomScale = 1;
    
    //注册选择的 cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HDPreCheckCommonCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"commonCollectionCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PrecheckCarBodyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"carbody"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PrecheckFileTitleCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"preview"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PrecheckSubTitleCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"subtitle"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PrecheckTitleCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"title"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"RemarkInfoCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"remark"];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:INTO_PHOTOLIBRARY_NOTIFICATION object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_PHOTOLIBRARY_NOTIFICATION object:nil];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}




#pragma mark - CollectionView 代理
// 设置 cell 的大小显示
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        NSInteger index = indexPath.item;
        BOOL firstOrSecond = _preCheckData.step1.count > _preCheckData.step2.count;
        BOOL thirdOrfourth = _preCheckData.step4.count > _preCheckData.step5.count;
        CGFloat firstHeight = firstOrSecond ? (_preCheckData.step1.count + 1 + 1) * 30 : (_preCheckData.step2.count + 1 + 1) * 30;
        CGFloat secondHeight = thirdOrfourth ? (_preCheckData.step4.count + 1 + 1) * 30 : (_preCheckData.step5.count + 1 + 1) * 30;
        
        if (index == 0) {
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame) / 2, firstHeight);
        }else if (index == 1) {
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame) / 2, firstHeight);
        }else if (index == 2) {
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 350);
        }else if (index == 3) {
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame) / 2, secondHeight);
        }else if (index == 4) {
            return CGSizeMake(CGRectGetWidth(self.collectionView.frame) / 2, secondHeight);
        }else {
            return CGSizeZero;
        }
    }else {
        return CGSizeZero;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//设置 cell 的数据显示
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 3) {
        return 5;
    }else {
        return 0;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 2)
    {
        PrecheckCarBodyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"carbody" forIndexPath:indexPath];
        cell.viewForm = _viewForm;
        cell.preCheckData = _preCheckData;
        WeakObject(self)
        cell.selectShifouPaizhaoBlock = ^(NSNumber *isStay) {
            selfWeak.preCheckData.photoinfo = isStay;
            [selfWeak saveDataNeedRefresh:YES WithSuccess:nil];
        };
        
        cell.saveDataBlock = ^(HDPreCheckModel *checkData) {
            selfWeak.preCheckData = checkData;
            [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
        };
        
        return cell;
    }
    else
    {
        HDPreCheckCommonCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"commonCollectionCell" forIndexPath:indexPath];
        cell.viewForm = _viewForm;
        if (indexPath.item != 0) {
            cell.topRightView.hidden = YES;
        }else {
            cell.topRightView.hidden = NO;
        }
        WeakObject(self)
        switch (indexPath.item) {
            case 0:
            {
                cell.titleLb.attributedText = [@"步骤1: 系统检查 (内部)" changeToBottomLine];
                cell.dataSource = [selfWeak.preCheckData.step1 mutableCopy];
                cell.wohasfuel = selfWeak.preCheckData.wohasfuel;
                cell.saveCellDataBlock = ^(NSMutableArray *array) {
                    selfWeak.preCheckData.step1 = array;
                    [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
                };
                cell.wohasfuelBlock = ^(NSNumber *wohasfuel) {
                    selfWeak.preCheckData.wohasfuel = wohasfuel;
                    [selfWeak saveDataToOrderWithOrderNum:nil withMiles:nil withWohasfuel:wohasfuel];
                };
                
            }
                break;
            case 1:
            {
                cell.titleLb.attributedText = [@"步骤2: 外观检查 (目视检查)" changeToBottomLine];
                cell.dataSource = [selfWeak.preCheckData.step2 mutableCopy];
                cell.saveCellDataBlock = ^(NSMutableArray *array) {
                    selfWeak.preCheckData.step2 = array;
                    [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
                };
            }
                break;
            case 3:
            {
                cell.titleLb.attributedText = [@"步骤4: 车辆位于举升机上 (半举升)" changeToBottomLine];
                cell.dataSource = [selfWeak.preCheckData.step4 mutableCopy];
                cell.saveCellDataBlock = ^(NSMutableArray *array) {
                    selfWeak.preCheckData.step4 = array;
                    [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
                };
            }
                break;
            case 4:
            {
                cell.titleLb.attributedText = [@"步骤5: 车辆位于举升机上 (全举升)" changeToBottomLine];
                cell.dataSource = [selfWeak.preCheckData.step5 mutableCopy];
                cell.saveCellDataBlock = ^(NSMutableArray *array) {
                    selfWeak.preCheckData.step5 = array;
                    [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
                };
            }
                break;
            default:
                break;
        }
        return cell;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat width = collectionView.bounds.size.width;
    switch (section) {
        case 0:
            return CGSizeMake(width, 50);
            break;
        case 1:
            return CGSizeMake(width, 151);
            break;
        case 2:
            return CGSizeMake(width, 170);
            break;
        case 3:
            return CGSizeZero;
            break;
        case 4:
            return CGSizeMake(width, 140 );
            break;
        default:
            return CGSizeZero;
            break;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 4) {
        CGFloat width = collectionView.bounds.size.width;
        return CGSizeMake(width, 30);
    }else {
        return CGSizeZero;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    WeakObject(self)
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            PrecheckTitleCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"title" forIndexPath:indexPath];
            return view;
        }
            break;
        case 1:
        {
            PrecheckSubTitleCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"subtitle" forIndexPath:indexPath];
            view.viewForm = _viewForm;
            view.preCheckData = selfWeak.preCheckData;
            
            view.textFieldBlock = ^(PrecheckSubTitleTF tfType, UITextField *textField, PorscheConstantModel *orderData) {
                switch (tfType) {
                    case PrecheckSubTitleTF_orderNumTF:
                        selfWeak.preCheckData.dmsno = textField.text;
                        [selfWeak saveDataToOrderWithOrderNum:textField.text withMiles:nil withWohasfuel:nil];
                        break;
                    case PrecheckSubTitleTF_checkStaffNameTF:
                        selfWeak.preCheckData.checkpersonname = textField.text;
                        selfWeak.preCheckData.checkpersonid = [orderData.cvsubid isEqual:@-1] ? @0 : orderData.cvsubid;
                        [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
                        break;
                    case PrecheckSubTitleTF_currentMileageTF:
                        selfWeak.preCheckData.curmiles = @([textField.text floatValue]);
                        [selfWeak saveDataToOrderWithOrderNum:nil withMiles:@([textField.text floatValue]) withWohasfuel:nil];
                        break;
                    default:
                        break;
                }
            };
            
            return view;
        }
            break;
        case 2:
        {
            PrecheckFileTitleCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"preview" forIndexPath:indexPath];
            view.viewForm = _viewForm;
            view.preCheckData = selfWeak.preCheckData;
            //订单概览
            view.selectDingdanGailanBlock = ^(DingdanGailanType selectBtnType) {
                selfWeak.preCheckData.orderinfo = @(selectBtnType);
                [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
            };
            //接受车辆客户是否在场
            view.selectShifouZaichangBlock = ^(NSNumber  *isStay) {
                selfWeak.preCheckData.isinfactory = isStay;
                [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
            };
            //是否在遇到噪音和驾驶动态问题时进行试驾
            view.selectJinxingShijiaBlock = ^(NSNumber *isShijia) {
                selfWeak.preCheckData.hastrycar = isShijia;
                [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
            };
            //所需文件
            view.selectSuoxuWenjianBlock = ^(NSMutableArray *selectArray) {
                selfWeak.preCheckData.needfiles = selectArray;
                [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
            };
            //付款方式
            view.selectPayTypeBlock = ^(NSMutableArray *selectArray) {
                selfWeak.preCheckData.paytypes = selectArray;
                [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
            };
            
            return view;
            
        }
            break;
        case 3:
            return nil;
            break;
        case 4:
        {
            RemarkInfoCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"remark" forIndexPath:indexPath];
            view.viewForm = _viewForm;
            view.preCheckData = selfWeak.preCheckData;
            
            view.selectBtnBlock = ^(NSMutableArray *selectArray){
                selfWeak.preCheckData.otherservices = selectArray;
                [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
            };
            
            view.textViewBlock = ^(UITextView *textView) {
                selfWeak.preCheckData.remark = textView.text;
                [selfWeak saveDataNeedRefresh:NO WithSuccess:nil];
            };
            
            return view;
            
        }
            break;
        default:
            return nil;
            break;
    }
}



//model转字典
- (NSMutableDictionary *)getDictionaryWithModel:(id)model withClass:(Class)modelClass {
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([modelClass class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if (propertyValue) {
            [userDic setObject:propertyValue forKey:propertyName];
        }
        
    }
    free(properties);
    return userDic;
}


#pragma mark - 缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //捏合或者移动时，确定正确的center
    CGFloat centerX = scrollView.center.x;
    
    CGFloat centerY = scrollView.center.y;
    
    //随时获取center位置
    centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX;
    
    centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : centerY;
    
    self.containerView.center = CGPointMake(centerX, centerY);
}

#pragma mark - 保存数据
- (void)saveDataNeedRefresh:(BOOL)needRefresh WithSuccess:(void(^)())successBlock {
    WeakObject(self)
    NSDictionary *param = [_preCheckData yy_modelToJSONObject];
    [PorscheRequestManager preCheckChangeDataWithParam:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            if (needRefresh) {
                [selfWeak.collectionView reloadData];
            }
            if (successBlock) {
                successBlock();
            }
        }
    }];
}
//保存工单数据
- (void)saveDataToOrderWithOrderNum:(NSString *)orderNum withMiles:(NSNumber *)miles withWohasfuel:(NSNumber *)wohasfuel {
    WeakObject(self);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (orderNum != nil) {
        [param hs_setSafeValue:orderNum forKey:@"wodmsno"];
    }
    if (miles != nil) {
        [param hs_setSafeValue:miles forKey:@"wocurmiles"];
    }
    if (wohasfuel != nil) {
        [param hs_setSafeValue:wohasfuel forKey:@"wohasfuel"];
    }
    [PorscheRequestManager saveBillingNewCarDic:param complete:^(NSInteger status,PResponseModel *responser) {
        if (status == 100) {
            [selfWeak.collectionView reloadData];
        }
    }];
}


#pragma mark - 打印界面操作事件
- (IBAction)printSubtractButtonAction:(UIButton *)sender {
    if ([_printCountLabel.text integerValue] == 1) {
        return;
    }
    _printCountLabel.text = [NSString stringWithFormat:@"%ld", [_printCountLabel.text integerValue] - 1];
    
}
- (IBAction)printAddButtonAction:(UIButton *)sender {
    if ([_printCountLabel.text integerValue] == 100) {
        return;
    }
    _printCountLabel.text = [NSString stringWithFormat:@"%ld", [_printCountLabel.text integerValue] + 1];
}

//关闭
- (IBAction)clooseButtonAction:(UIButton *)sender {
    WeakObject(self)
    [selfWeak dismissViewControllerAnimated:YES completion:nil];
//    [self saveDataNeedRefresh:NO WithSuccess:^{
//    }];
}
//预览
- (IBAction)yulanButtonAction:(UIButton *)sender {
    WeakObject(self)
    [selfWeak printViewActionWithStyle:@0];
//    [self saveDataNeedRefresh:NO WithSuccess:^{
//    }];
    
}
//打印
- (IBAction)printButtonAction:(UIButton *)sender {
    
    WeakObject(self)
    [selfWeak printViewActionWithStyle:@1];
//    [self saveDataNeedRefresh:NO WithSuccess:^{
//    }];
    
}

//style = 1  直接打印   style = 0  预览
- (void)printViewActionWithStyle:(NSNumber *)style {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    WeakObject(self)
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    
    [PorscheRequestManager downloadPDFWithURLStr:PreCheck_Print params:param orderid:[selfWeak.carorderNum integerValue] ? selfWeak.carorderNum : [HDStoreInfoManager shareManager].carorderid completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        if (!error) {
            
            if ([filePath absoluteString].length) {
                
                if ([style integerValue] == 1) {//直接弹打印
                    
                    [selfWeak beginPrintWithCopies:[selfWeak.printCountLabel.text integerValue]];
                    
                }else {//预览
                    
                    [selfWeak gotoPrintViewWithPrintType:PDF_Quotation count:[selfWeak.printCountLabel.text integerValue]];
                    
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
//    [[HDLeftSingleton shareSingleton] showPreView:info];
    PrintPreviewViewController *ppvc = [[PrintPreviewViewController alloc] init];
    ppvc.info = info;
    [self addChildViewController:ppvc];
    ppvc.view.frame = self.view.frame;
    [self.view addSubview:ppvc.view];
    
}

//直接打印
- (void)beginPrintWithCopies:(NSInteger)copies
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, PDF_NAME];
    //    NSData *pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullPath]];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* data = [[NSData alloc] init];
    data = [fm contentsAtPath:fullPath];
    [self.printer selectPrinterToPrinterWithView:self.view copies:copies printPDFData:data];
    
}
- (Printer *)printer
{
    if (!_printer) {
        _printer = [[Printer alloc] init];
    }
    return _printer;
}




@end
