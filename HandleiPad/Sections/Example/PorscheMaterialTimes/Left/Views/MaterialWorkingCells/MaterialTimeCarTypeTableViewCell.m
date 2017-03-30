//
//  MaterialTimeCarTypeTableViewCell.m
//  MaterialDemo
//
//  Created by Robin on 16/9/28.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialTimeCarTypeTableViewCell.h"
#import "HDLeftSingleton.h"

@interface MaterialTimeCarTypeTableViewCell ()

@property (nonatomic, strong) PorscheConstantModel *carSeriesConstant; //车系
@property (nonatomic, strong) PorscheConstantModel *carTypeConstant; //车型
@property (nonatomic, strong) PorscheConstantModel *carYearConstant; //年款

@property (nonatomic, strong) PorscheCarSeriesModel *carSeries; //车系
@property (nonatomic, strong) PorscheCarTypeModel *carType; //车型
@property (nonatomic, strong) PorscheCarYearModel *carYear; //年款



@end

@implementation MaterialTimeCarTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSetupCar:(BOOL)setupCar {
    _setupCar = setupCar;
    
    if (!setupCar) return;
    
    PorscheCarSeriesModel *carSeries = [PorscheCarSeriesModel new];
    carSeries.cars = [HDLeftSingleton shareSingleton].carModel.wocarcatena;
    carSeries.carscode = [HDLeftSingleton shareSingleton].carModel.wocarcatenacode;
    carSeries.pctid = [HDLeftSingleton shareSingleton].carModel.carsid;
    self.carSeries = carSeries;
    
    PorscheCarTypeModel *carType = [PorscheCarTypeModel new];
    
    NSString *cars = [HDLeftSingleton shareSingleton].carModel.wocarcatena.length ? [HDLeftSingleton shareSingleton].carModel.wocarcatena : @"";
    NSString *cartype = [HDLeftSingleton shareSingleton].carModel.wocarmodel.length ? [HDLeftSingleton shareSingleton].carModel.wocarmodel : @"";
    
    NSString *cartypeString = [NSString stringWithFormat:@"%@ %@",cars,cartype];
    if (!cars.length && !cartype.length)
    {
        cartypeString = @"";
    }
    
    carType.cartype = cartypeString; // [HDLeftSingleton shareSingleton].carModel.wocarmodel;
    carType.cartypecode = [HDLeftSingleton shareSingleton].carModel.wocarmodelcode;
    carType.pctid = [HDLeftSingleton shareSingleton].carModel.cartypeid;

    self.carType = carType;
    
    PorscheCarYearModel *carYear =  [PorscheCarYearModel new];
    carYear.year = [HDLeftSingleton shareSingleton].carModel.woyearstyle;
    carYear.pctid = [HDLeftSingleton shareSingleton].carModel.caryearid;
    self.carYear = carYear;
    
    NSNumber *pctid = @0;
    NSNumber *wocarlevel = @0;
    if ([carSeries.pctid integerValue])
    {
        wocarlevel = @1;
        pctid = carSeries.pctid;
    }
    
    if ([carType.pctid integerValue])
    {
        wocarlevel = @2;
        pctid = carType.pctid;
    }
    
    if ([carYear.pctid integerValue])
    {
        pctid = carYear.pctid;
        wocarlevel = @3;
    }
    
    [PorscheRequestSchemeListModel shareModel].isSetupCar = _setupCar;
    [[PorscheRequestSchemeListModel shareModel] refleshDataWithPctid:pctid wocarlevel:wocarlevel];
}

- (void)setCarSeriesConstant:(PorscheConstantModel *)carSeriesConstant {
    _carSeriesConstant = carSeriesConstant;
    
    self.mainCarTF.text = carSeriesConstant.cvvaluedesc;
    self.subCarTF.text = @"";
    self.yearCarTF.text = @"";
    [PorscheRequestSchemeListModel shareModel].wocarcatena = [carSeriesConstant.cvvaluedesc isEqualToString:@"全部车系"] ? nil : carSeriesConstant.cvvaluedesc;
    [PorscheRequestSchemeListModel shareModel].wocarmodel = nil;
    [PorscheRequestSchemeListModel shareModel].woyearstyle = nil;
    if ([carSeriesConstant.cvvaluedesc isEqualToString:@"全部车系"])
    {
        [PorscheRequestSchemeListModel shareModel].wocarlevel = @0;
        [PorscheRequestSchemeListModel shareModel].scartypeid = @0;
    }
    else
    {
        [PorscheRequestSchemeListModel shareModel].wocarlevel = @1;
        [PorscheRequestSchemeListModel shareModel].scartypeid = carSeriesConstant.cvsubid;
    }
}

- (void)setCarTypeConstant:(PorscheConstantModel *)carTypeConstant {
    _carTypeConstant = carTypeConstant;
    
    self.subCarTF.text = carTypeConstant.cvvaluedesc;
    self.yearCarTF.text = @"";
    [PorscheRequestSchemeListModel shareModel].wocarmodel = carTypeConstant.descr;
    [PorscheRequestSchemeListModel shareModel].woyearstyle = nil;
    [PorscheRequestSchemeListModel shareModel].wocarlevel = @2;
    [PorscheRequestSchemeListModel shareModel].scartypeid = carTypeConstant.cvsubid;
    
    if ([carTypeConstant.cvvaluedesc isEqualToString:@"全部车型"])
    {
        [PorscheRequestSchemeListModel shareModel].wocarlevel = @1;
        [PorscheRequestSchemeListModel shareModel].scartypeid = _carSeriesConstant.cvsubid;
    }
    else
    {
        [PorscheRequestSchemeListModel shareModel].wocarlevel = @2;
        [PorscheRequestSchemeListModel shareModel].scartypeid = carTypeConstant.cvsubid;
    }
}

- (void)setCarYearConstant:(PorscheConstantModel *)carYearConstant {
    _carYearConstant = carYearConstant;
    
    self.yearCarTF.text = carYearConstant.cvvaluedesc;
    [PorscheRequestSchemeListModel shareModel].woyearstyle = [carYearConstant.cvvaluedesc isEqualToString:@"全部年款"] ? nil : carYearConstant.cvvaluedesc;
    
    if ([carYearConstant.cvvaluedesc isEqualToString:@"全部年款"])
    {
        [PorscheRequestSchemeListModel shareModel].wocarlevel = @2;
        [PorscheRequestSchemeListModel shareModel].scartypeid = _carTypeConstant.cvsubid;
    }
    else
    {
        [PorscheRequestSchemeListModel shareModel].wocarlevel = @3;
        [PorscheRequestSchemeListModel shareModel].scartypeid = carYearConstant.cvsubid;
    }
}

- (void)setCarSeries:(PorscheCarSeriesModel *)carSeries {
    _carSeries = carSeries;
    
    self.carSeriesConstant = carSeries.constantModel;
}

- (void)setCarType:(PorscheCarTypeModel *)carType {
    _carType = carType;
    
    self.carTypeConstant = carType.constantModel;
}

- (void)setCarYear:(PorscheCarYearModel *)carYear {
    
    _carYear = carYear;
    
    self.carYearConstant = carYear.constantModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaterialTimeCarTypeTableViewCell" owner:nil options:nil];
        self = [array objectAtIndex:0];
    }
    return self;
}
- (IBAction)carTypeA:(UIButton *)sender {
    
    [self selectCarWithType:MaterialTimeCarTypeClickMainGroup view:self.mainCarTF];
    
    //if (self.clickBlock) {
   //     self.clickBlock(MaterialTimeCarTypeClickMainGroup, self.mainCarTF);
   // }
}
- (IBAction)carTypeB:(UIButton *)sender {
    
    [self selectCarWithType:MaterialTimeCarTypeClickSubGroup view:self.subCarTF];
    
   // if (self.clickBlock) {
   //     self.clickBlock(MaterialTimeCarTypeClickSubGroup, self.subCarTF);
   // }
}
- (IBAction)carYear:(UIButton *)sender {
    
    [self selectCarWithType:MaterialTimeCarTypeClickYearGroup view:self.yearCarTF];
    
   // if (self.clickBlock) {
   //     self.clickBlock(MaterialTimeCarTypeClickYearGroup, self.yearCarTF);
   // }
}

- (void)selectCarWithType:(MaterialTimeCarTypeClick)carType view:(UIView *)senderView {
    
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:senderView];
    WeakObject(hub);
    __weak typeof(self)weakself = self;
    switch (carType) {
        case MaterialTimeCarTypeClickMainGroup:
        {
            [PorscheRequestManager getAllCarSeriersConstant:^(NSArray<PorscheConstantModel *> * _Nonnull carSeriers, PResponseModel * _Nonnull response) {
                if (!carSeriers) {
                    
                    [hubWeak changeTextModeMessage:response.msg toView:senderView];
                    return ;
                }
                [hubWeak hideAnimated:YES];
                
                NSMutableArray *newCarSeriers = [[NSMutableArray alloc] init];
                PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
                model.cvvaluedesc = @"全部车系";
                [newCarSeriers addObject:model];
                [newCarSeriers addObjectsFromArray:carSeriers];
                [weakself showListViewForView:senderView dataSource:newCarSeriers direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel) {
                    
                    weakself.carSeriesConstant = constantModel;
                }];
                
                
            }];
        }
            break;
        case MaterialTimeCarTypeClickSubGroup:
        {
            [PorscheRequestManager getAllCarTypeConstantWithCarsPctid:self.carSeriesConstant.cvsubid completion:^(NSArray<PorscheConstantModel *> * _Nullable carTypes, PResponseModel * _Nullable response) {
                if (!carTypes) {
                    
                    [hubWeak changeTextModeMessage:response.msg toView:senderView];
                    return ;
                }
                [hubWeak hideAnimated:YES];
                
                NSMutableArray *newCarTypes = [[NSMutableArray alloc] init];
                PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
                model.cvvaluedesc = @"全部车型";
                [newCarTypes addObject:model];
                [newCarTypes addObjectsFromArray:carTypes];
                
                [weakself showListViewForView:senderView dataSource:newCarTypes direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel) {
                    
                    weakself.carTypeConstant = constantModel;
                    
                }];
            }];
            
        }
            break;
        case MaterialTimeCarTypeClickYearGroup:
        {
            [PorscheRequestManager getAllCarYearConstantWithCartypePctid:self.carTypeConstant.cvsubid completion:^(NSArray<PorscheConstantModel *> * _Nullable caryears, PResponseModel * _Nullable response) {
                if (!caryears) {
                    
                    [hubWeak changeTextModeMessage:response.msg toView:senderView];
                    return ;
                }
                [hubWeak hideAnimated:YES];
                
                NSMutableArray *newCarYears = [[NSMutableArray alloc] init];
                PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
                model.cvvaluedesc = @"全部年款";
                [newCarYears addObject:model];
                [newCarYears addObjectsFromArray:caryears];
                
                [weakself showListViewForView:senderView dataSource:newCarYears direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel) {
                    
                    weakself.carYearConstant = constantModel;
                    
                }];
            }];
            
        }
            break;
        default:
            break;
    }

}

#pragma mark - 显示组选择器
- (void)showListViewForView:(UIView *)view dataSource:(NSArray *)dataSource direction:(ListViewDirection)direction complete:(void(^)(PorscheConstantModel *))complete{
    
    [PorscheMultipleListhView showSingleListViewFrom:view dataSource:dataSource selected:nil showArrow:NO showClearButton:NO direction:direction withLimit:@1 complete:^(PorscheConstantModel *constantModel, NSInteger idx) {
        
        complete (constantModel);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
