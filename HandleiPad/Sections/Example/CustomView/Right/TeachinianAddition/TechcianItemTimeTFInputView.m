//
//  TechcianItemTimeTFInputView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/26.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "TechcianItemTimeTFInputView.h"
//图号下拉辅助视图
#import "HDWorkListTableViews.h"

#import "HDPoperDeleteView.h"

#import "PorschePhotoGallery.h"

#import "ZLCameraViewController.h"

#import "TechcianNumberTFInputView.h"
#import "PorschePhotoModelController.h"//媒体类
#import "HDLeftSingleton.h"
@interface TechcianItemTimeTFInputView ()<UITextFieldDelegate>

//切换至工时弹窗

//图号编号下拉辅助视图frame
//@property (nonatomic, assign) CGRect pullDownRect;
//图号编号下拉辅助视图
//@property (nonatomic, strong) HDWorkListTableViews *numberPullDownView;

@property (nonatomic, strong) ProscheSchemewsSearchCondition *condition;

@property (nonatomic, strong) NSMutableArray *schemewsArray;

@property (nonatomic, strong) HDWorkListTableViews *listView;

@property (nonatomic, strong) PorscheSchemeWorkHourModel *workHourModel;

@property (nonatomic, strong) UITextField *textfield;
//保存点击展示的VC
@property (nonatomic, strong) UIViewController *supperVC;
// 媒体处理类
@property (nonatomic, strong) PorschePhotoModelController *modelController;

@property (nonatomic, assign) TechcianNumberLocationStyle locationStyle;

@end


@implementation TechcianItemTimeTFInputView



+ (TechcianItemTimeTFInputView *)showTechcianNumberTFInputViewModel:(PorscheNewSchemews *)model withSupperVC:(UIViewController *)supperVC addedBlock:(void(^)(NSInteger tag))addedBlock {
    TechcianItemTimeTFInputView *view = [[TechcianItemTimeTFInputView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    view.tmpModel  = model;
    view.addedBlock = addedBlock;
    view.supperVC = supperVC;
    [HD_FULLView addSubview:view];
    [view.ItemTimeOneTF becomeFirstResponder];
    
    return view;
}

- (void)removeSelf {
    [_textfield resignFirstResponder];
    [self removeFromSuperview];
}

//默认尺寸 <750...325> <需固定>
- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TechcianItemTimeTFInputView" owner:nil options:nil];
    
    self = [array objectAtIndex:0];
    self.frame = frame;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.shadowOpacity = 0.5;
    self.contentView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.contentView.layer.shadowRadius = 3;
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    self.locationStyle = TechcianNumberLocationStyleFactory;

    _changeToMaterialLb.attributedText = [@"切换至备件" changeToBottomLine];
    return self;
}


//厂方点击方法
- (IBAction)factoryButtonAction:(UIButton *)sender {
    self.locationStyle = TechcianNumberLocationStyleFactory;
    _loctionLb.textColor = Color(100, 100, 100);
    _factoryLb.textColor = [UIColor whiteColor];
    [_topBgImageView setImage:[UIImage imageNamed:@"Item_time_headerView_image_new_changfang"]];
    
}
//本店点击方法
- (IBAction)loctionButtonAction:(UIButton *)sender {
    self.locationStyle = TechcianNumberLocationStyleLocation;

    _factoryLb.textColor = Color(100, 100, 100);
    _loctionLb.textColor = [UIColor whiteColor];
    [_topBgImageView setImage:[UIImage imageNamed:@"Item_time_headerView_image_new_bendian"]];
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self removeSelf];
    if (self.workHourModel) {
        [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:self.tmpModel.wospwosid type:@1 source:@1 stockid:@[self.workHourModel.workhourid]];
    }else {
        [self saveData];
        
        [self editWorkHourOrMaretialWithSchemews:self.tmpModel type:kWorkType];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   

    if ([textField isEqual:self.itemTimeCountTF]) {
        if (![string isEqualToString:@""]) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"TU" withString:@""];
            string = [NSString stringWithFormat:@"%@TU",string];
            textField.text = [textField.text stringByAppendingString:string];
            return NO;
        }else {
            if (textField.text.length > 2) {
                NSString *tmpString = [textField.text stringByReplacingOccurrencesOfString:@"TU" withString:@""];
                string = [tmpString substringToIndex:tmpString.length - 1];
                if (string.length == 0) {
                    textField.text = @"";
                }else {
                    textField.text = [NSString stringWithFormat:@"%@TU",string];
                }
                return NO;
            }
        }
        
    }
    
    
    
    if ([textField isEqual:_ItemTimeOneTF]) {
        
        if (textField.text.length < 1) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.workhourcode1 = [textField.text substringToIndex:textField.text.length - 1];
                }
            }else {
                self.condition.workhourcode1 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.workhourcode1 && ![self.condition.workhourcode1 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:1];
            }
            
            return YES;
        }else if (textField.text.length == 1){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.workhourcode1 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchWorkOrderPartWithCondition:self.condition aroundView:_itemTimeTwoTF idx:2];
                [_itemTimeTwoTF becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.workhourcode1 = @"";
                [self.listView removeFromSuperview];
                return YES;
            }
        }else {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            [_itemTimeTwoTF becomeFirstResponder];
            
            return NO;
        }
    }
    
    
    
    if ([textField isEqual:_itemTimeTwoTF]) {
        
        if (textField.text.length < 1) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.workhourcode2 = [textField.text substringToIndex:textField.text.length - 1];
                }
            }else {
                self.condition.workhourcode2 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.workhourcode2 && ![self.condition.workhourcode2 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:2];
            }
            
            return YES;
        }else if (textField.text.length == 1){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.workhourcode2 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchWorkOrderPartWithCondition:self.condition aroundView:_itemTimeThreeTF idx:3];
                [_itemTimeThreeTF becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.workhourcode2 = @"";
                _itemTimeTwoTF.text = @"";
                [_ItemTimeOneTF becomeFirstResponder];
                return NO;
            }
        }else {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            [_itemTimeThreeTF becomeFirstResponder];
            
            return NO;
        }
    }
    
    
    
    if ([textField isEqual:_itemTimeThreeTF]) {
        
        if (textField.text.length < 1) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.workhourcode3 = [textField.text substringToIndex:textField.text.length - 1];
                }
            }else {
                self.condition.workhourcode3 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.workhourcode3 && ![self.condition.workhourcode3 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:3];
            }
            
            return YES;
        }else if (textField.text.length == 1){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.workhourcode3 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchWorkOrderPartWithCondition:self.condition aroundView:_itemTimeFourTF idx:4];
                [_itemTimeFourTF becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.workhourcode3 = @"";
                _itemTimeThreeTF.text = @"";
                [_itemTimeTwoTF becomeFirstResponder];
                return NO;
            }
        }else {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            [_itemTimeFourTF becomeFirstResponder];
            
            return NO;
        }
    }
    
    
    
    if ([textField isEqual:_itemTimeFourTF]) {
        
        if (textField.text.length < 1) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.workhourcode4 = [textField.text substringToIndex:textField.text.length - 1];
                }
            }else {
                self.condition.workhourcode4 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.workhourcode4 && ![self.condition.workhourcode4 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:4];
            }
            
            return YES;
        }else if (textField.text.length == 1){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.workhourcode4 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:4];
                [_itemTimeNameTF becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.workhourcode4 = @"";
                _itemTimeFourTF.text = @"";
                [_itemTimeThreeTF becomeFirstResponder];
                return NO;
            }
        }else {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            [_itemTimeNameTF becomeFirstResponder];
            
            return NO;
        }
    }

    return YES;
    
   
}


- (NSString *)getFigueStringWithBaseString:(NSString *)figueStr tf:(UITextField *)tf {
    NSString *figue = figueStr;
    if (tf.text && ![tf.text isEqualToString:@""]) {
        NSString *endStr;
        if ([figueStr  isEqualToString:@""]) {
            endStr = tf.text;
        }else {
            endStr = [NSString stringWithFormat:@" %@",tf.text];
        }
        figue =  [figueStr stringByAppendingString:endStr];
    }
    return figue;
    
}

- (NSString *)getListCode {
    NSString *figue = @"";
    for (UITextField *tf in @[_ItemTimeOneTF,_itemTimeTwoTF,_itemTimeThreeTF,_itemTimeFourTF]) {
        figue = [self getFigueStringWithBaseString:figue tf:tf];
    }
    return figue;
}

- (NSString *)getItemName {
    return [self getFigueStringWithBaseString:@"" tf:_itemTimeNameTF];
}

- (NSString *)getmaterialCount {
    return [self getFigueStringWithBaseString:@"" tf:_itemTimeCountTF];
}
- (void)saveData {
    //编辑
    self.tmpModel.schemewscode = [self getListCode];
    self.tmpModel.schemewsname = [self getItemName];
    self.tmpModel.schemewscount = @([[self getmaterialCount] floatValue]);
}



#pragma mark  ------加入工单------
- (IBAction)makeSureBtAction:(UIButton *)sender {
    /*
    NSString *countStr;
    if (_itemTimeCountTF.text.length > 0) {
        countStr = [_itemTimeCountTF.text substringToIndex:_itemTimeCountTF.text.length - 2];
    }
    if ([_tmpModel.isCanAddItemTime integerValue] == 0) {//新增工时
        //工时只有编号
        _tmpModel.schemewscode = [NSString stringWithFormat:@"%@%@%@%@",_ItemTimeOneTF.text,_itemTimeTwoTF.text,_itemTimeThreeTF.text,_itemTimeFourTF.text];
        _tmpModel.schemewsname = _itemTimeNameTF.text;
        _tmpModel.schemewscount = countStr;
        if (self.techcianItemTimeTFInputViewBlock) {
            self.techcianItemTimeTFInputViewBlock(TechcianItemTimeTFInputViewStyleTFReturn,nil);
        }
    }else {//添加行model
        PorscheSchemews *model = [PorscheSchemews new];
        model.schemewscode = [NSString stringWithFormat:@"%@%@%@%@",_ItemTimeOneTF.text,_itemTimeTwoTF.text,_itemTimeThreeTF.text,_itemTimeFourTF.text];;
        model.schemewsname = _itemTimeNameTF.text;
        model.schemewscount = countStr;
        model.schemesubtype = @1;
        if (self.saveBtBlock) {
            self.saveBtBlock(model);
        }
    }
    */
    
    [self removeSelf];
    if (self.workHourModel) {
        [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:self.tmpModel.wospwosid type:@1 source:@1 stockid:@[self.workHourModel.workhourid]];
    }else {
        [self saveData];
        
        [self editWorkHourOrMaretialWithSchemews:self.tmpModel type:kWorkType];
    }

}

- (void)adddedWorkHour {
    if (!self.workHourModel) {//自定义工时
    }
}



- (IBAction)stepToItemTimeBtAction:(UIButton *)sender {
    [self removeSelf];
    [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleWorkTimeCub right:HDRightStatusStyleWorkTimeCub];
}

- (PorschePhotoModelController *)modelController
{
    if (!_modelController)
    {
        _modelController = [[PorschePhotoModelController alloc] init];
        _modelController.supporterViewController = self.supperVC;
    }
    return _modelController;
}
- (IBAction)cameraBtAction:(UIButton *)sender {
//    [self removeSelf];
    
    //    ZLCameraViewController *camera = [[ZLCameraViewController alloc] initWithUsageType:ControllerUsageTypeCamera];
    //    camera.cameraType = ZLCameraContinuous;
    //    [KEY_WINDOW.rootViewController.presentedViewController presentViewController:camera animated:YES completion:^{
    //
    //    }];
    self.modelController.shootType = PorschePhotoCarImage;
    self.modelController.fileType = PorschePhotoGalleryFileTypeImage;
    self.modelController.keyType = PorschePhotoGalleryKeyTypeScheme;
    self.modelController.relativeid = self.tmpModel.wospwosid;
    [self.modelController cycleTakePhoto:nil video:nil];
}
- (IBAction)photoBtAction:(UIButton *)sender {
//    [self removeSelf];
//    [self showPhotoGallery];
    WeakObject(self)
    [PorschePhotoModelController getPhotoListCompletion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            PorscheGalleryModel *model = [PorscheGalleryModel yy_modelWithDictionary:responser.object];
            [selfWeak.modelController showPhotoGalleryWithModel:model viewType:PorschePhotoGalleryPreviewAndShoot];
        }
    }];
}

- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    [self setupListCode:tmpModel.schemewscode];
    
    /*
    if (endCode.length) {
        if (endCode.length < 3) {
            _ItemTimeOneTF.text = endCode;
        }else if (endCode.length < 5){
            _ItemTimeOneTF.text = [endCode substringToIndex:2];
            _itemTimeTwoTF.text = [endCode substringFromIndex:3];
        }else if (endCode.length < 7){
            _ItemTimeOneTF.text = [endCode substringToIndex:2];
            _itemTimeTwoTF.text = [endCode substringWithRange:NSMakeRange(3, 2)];
            _itemTimeThreeTF.text = [endCode substringFromIndex:5];
        }else {
            _ItemTimeOneTF.text = [endCode substringToIndex:2];
            _itemTimeTwoTF.text = [endCode substringWithRange:NSMakeRange(2, 2)];
            _itemTimeThreeTF.text = [endCode substringWithRange:NSMakeRange(4, 2)];
            _itemTimeFourTF.text = [endCode substringFromIndex:6];
        }
    }
    */
    
    _itemTimeNameTF.text = tmpModel.schemewsname;
    
    _itemTimeCountTF.text = tmpModel.schemewscount ? [NSString stringWithFormat:@"%@",tmpModel.schemewscount] : @"";
}

- (void)setupListCode:(NSString *)listCode {
    NSArray *codeArr = [listCode componentsSeparatedByString:@" "];
    switch (codeArr.count) {
        case 8:
        case 7:
        case 6:
        case 5:
            
        case 4:
            _itemTimeFourTF.text = codeArr[3];
        case 3:
            _itemTimeThreeTF.text = codeArr[2];

        case 2:
            _itemTimeTwoTF.text = codeArr[1];

        case 1:
            _ItemTimeOneTF.text = codeArr[0];

            break;
        default:
            break;
    }
}




- (IBAction)cancelBtAction:(UIButton *)sender {
    [self removeSelf];
}

- (void)cleanTF {
    _ItemTimeOneTF.text = @"";
    _itemTimeTwoTF.text = @"";
    _itemTimeThreeTF.text = @"";
    _itemTimeFourTF.text = @"";
    _itemTimeNameTF.text = @"";
    _itemTimeCountTF.text = @"";
}



- (IBAction)ItemTimeAction:(UIButton *)sender {
    [self removeSelf];

}

- (void)showPhotoGallery {
//    PorschePhotoGallery *photoView = [PorschePhotoGallery viewWithCarVideo:nil carPics:[NSMutableArray arrayWithArray:@[]] schemePics:[NSMutableArray arrayWithArray:@[]] viewType:PorschePhotoGalleryPreviewAndShoot];
//    
//    [HD_FULLView addSubview:photoView];
}

//切换至备件事件
- (IBAction)changeToMaterialAction:(UIButton *)sender {
    WeakObject(self);
    
    [selfWeak removeSelf];
    __block PorscheNewSchemews *schemews = [PorscheNewSchemews new];
    
    [TechcianNumberTFInputView showTechcianNumberTFInputViewModel:schemews withSupperVC:selfWeak.supperVC addedBlock:selfWeak.addedBlock];
    
//    [HDPoperDeleteView showAlertViewAroundView:sender titleArr:@[@"保存已编辑的工时信息?",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
//        
//        
//    } refuse:^{
//        
//    } cancel:^{
//        
//    }];
}

- (BOOL)hasEdit {
    BOOL isEdit = NO;
    
    for (UITextField *tf in @[_itemTimeCountTF,_itemTimeNameTF,_itemTimeTwoTF,_ItemTimeOneTF,_itemTimeThreeTF,_itemTimeFourTF]) {
        if (tf.text.length) {
            isEdit = YES;
        }
    }
    
    return isEdit;
}




#pragma mark  工时匹配
- (void)matchWorkOrderPartWithCondition:(ProscheSchemewsSearchCondition *)condition aroundView:(UITextField *)view idx:(NSInteger)idex {
    //工时模糊搜索中  没有车系车型code  不给匹配
    if (![HDLeftSingleton shareSingleton].carModel.wocarcatenacode || ![HDLeftSingleton shareSingleton].carModel.wocarmodelcode) {
        return;
    }
    WeakObject(view);
    WeakObject(self);
    selfWeak.workHourModel = nil;
    condition.findtype = [NSString stringWithFormat:@"%@",@(self.locationStyle)];//1.厂方 2.本地
    
    PorscheNewCarMessage *carModel = [HDLeftSingleton shareSingleton].carModel;
    condition.wocarcatena = carModel.wocarcatena;
    condition.wocarmodel = carModel.wocarmodel;
    condition.woyearstyle = carModel.woyearstyle;

    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self];
    WeakObject(hud)
    [PorscheRequestManager searchWorkHour:condition complete:^(NSMutableArray *list,PResponseModel* responser) {
        [hudWeak hideAnimated:YES];
        if (list.count) {
            __block NSMutableArray *array = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PorscheSchemeWorkHourModel *model = obj;
                switch (idex) {
                    case 1:
                        [array addObject:model.workhourcode1];
                        break;
                    case 2:
                        [array addObject:model.workhourcode2];

                        break;
                    case 3:
                        [array addObject:model.workhourcode3];

                        break;
                    case 4:
                        [array addObject:model.workhourcode4];

                        break;
                    default:
                        break;
                }
                [selfWeak.schemewsArray addObject:model];
            }];
            [selfWeak.listView removeFromSuperview];
           selfWeak.listView = [HDWorkListTableViews showTableViewlistViewAroundView:viewWeak superView:selfWeak.contentView direction:UIPopoverArrowDirectionDown dataSource:array size:CGSizeMake(CGRectGetWidth(viewWeak.frame), 120) seletedNeedDelete:YES complete:^(NSNumber *idx, BOOL isshowArrow, HDWorkListTableViewsStyle style) {
               viewWeak.text = array[[idx integerValue]];

                selfWeak.workHourModel = selfWeak.schemewsArray[[idx integerValue]];
               
            }];
        }else if (!list){
            NSLog(@"获取匹配信息失败");
        }else {
            NSLog(@"获取匹配数据为空!");
        }
    }];
}

- (void)setWorkHourModel:(PorscheSchemeWorkHourModel *)workHourModel {
    
    if (!workHourModel) {
        _workHourModel = nil;
        return;
    }
    
    _workHourModel = workHourModel;
    
    _ItemTimeOneTF.text = workHourModel.workhourcode1;
    _itemTimeTwoTF.text = workHourModel.workhourcode2;
    _itemTimeThreeTF.text = workHourModel.workhourcode3;
    _itemTimeFourTF.text = workHourModel.workhourcode4;
    _itemTimeNameTF.text = workHourModel.workhourname;
    _itemTimeCountTF.text = workHourModel.workhourcount ? [NSString stringWithFormat:@"%@TU",workHourModel.workhourcount] : @"";
}


//编辑工时/备件
- (void)editWorkHourOrMaretialWithSchemews:(PorscheNewSchemews *)schemews type:(NSNumber *)type{
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(self);
    [PorscheRequestManager editProjectWorkHourOrMaterial:schemews type:type complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"方案工时修改成功！");
            if (selfWeak.addedBlock) {
                selfWeak.addedBlock(3);
            }
        }else {
            NSLog(@"方案工时修改失败！");
        }
    }];
}


//添加工时备件 type:1.工时  2.备件  source:1.库 2.自定义 stocked添加自定义不需要，添加库多工时配件，存id数组  删除时，将单一的配件或者工时id存入数组。
- (void)upDateProjectMaterialTestWithAddedType:(NSNumber *)addedType schemeid:(NSNumber *)schemeid type:(NSNumber *)type source:(NSNumber *)source stockid:(NSArray *)stockList {
    NSString *stockid = stockList.count ? [stockList componentsJoinedByString:@","] :@"";
    ProscheAdditionCondition *tmp = [ProscheAdditionCondition new];
    if ([addedType isEqual:kAddition]) {
        tmp.processstatus = @([HDLeftSingleton shareSingleton].stepStatus - 1);
        tmp.schemeid = schemeid;
        tmp.source = source;
        tmp.type = type;
        tmp.stockidbatch = stockid;
    }else if ([addedType isEqual:kDeletion]) {
        tmp.schemeid = schemeid;
        tmp.type = type;
        tmp.wsid = stockList.firstObject;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    WeakObject(self);
    [PorscheRequestManager inscreaseProjectSubObjectAddedType:addedType Condition:tmp complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        [hud hideAnimated:YES];
        if (status == 100) {
            NSLog(@"工时/备件添加/删除至方案成功");
            if (selfWeak.addedBlock) {
                selfWeak.addedBlock(3);
            }
        }else {
            NSLog(@"工时/备件添加/删除至方案失败");
        }
        
    }];
}



- (NSMutableArray *)schemewsArray {
    if (!_schemewsArray) {
        _schemewsArray = [NSMutableArray array];
    }
    return _schemewsArray;
}

- (ProscheSchemewsSearchCondition *)condition {
    if (!_condition) {
        _condition = [ProscheSchemewsSearchCondition new];
    }
    return _condition;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.contentView.frame, point)) {
        return [super hitTest:point withEvent:event];
    }
    
    [self removeSelf];
    return nil;
    
}
@end
