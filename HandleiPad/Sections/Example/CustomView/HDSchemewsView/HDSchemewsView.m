//
//  HDSchemewsView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/12/29.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSchemewsView.h"

#import "HDWorkListTableViews.h"//图号下拉辅助视图
#import "PorschePhotoModelController.h"//媒体类
#import "PorschePhotoGallery.h"//图片
#import "ZLCameraViewController.h"//相机
#import "HDLeftSingleton.h"//单例
#import "HDKeyInputTextField.h"

@interface HDSchemewsView ()<UITextFieldDelegate,keyInputTextFieldDelegate>

@property (nonatomic, strong) ProscheSchemewsSearchCondition *condition;//匹配条件

@property (nonatomic, strong) NSMutableArray *schemewsArray;//匹配数据源

@property (nonatomic, strong) PorscheSchemeSpareModel *materialModel;//点选的配件
@property (nonatomic, strong) PorscheSchemeWorkHourModel *workHourModel;//点选的工时


@property (nonatomic, strong) HDWorkListTableViews *listView;//匹配下拉

@property (nonatomic, strong) UIViewController *supperVC;//保存点击展示的VC

@property (nonatomic, strong) PorschePhotoModelController *modelController;// 媒体处理类

@property (nonatomic, strong) UITextField *textfield;//全局textField

@property (nonatomic, assign) BOOL needMatch;

@end

@implementation HDSchemewsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configKeyInputTextField:self];
}

- (void)configKeyInputTextField:(UIView *)view
{
    if (!view.subviews.count)
    {
        if ([view isKindOfClass:[HDKeyInputTextField class]])
        {
            ((HDKeyInputTextField *)view).deleteBackwardDelegate = self;
        }
        return;
    }
    
    for (UIView *aview in view.subviews)
    {
        if ([aview isKindOfClass:[HDKeyInputTextField class]])
        {
            ((HDKeyInputTextField *)aview).deleteBackwardDelegate = self;
        }
        else
        {
            [self configKeyInputTextField:aview];
        }
    }
}

+ (HDSchemewsView *)showHDSchemewsStyle:(HDSchemewsViewStyle)style model:(PorscheNewSchemews *)model withSupperVC:(UIViewController *)supperVC needMatch:(BOOL)needMatch addedBlock:(void(^)(HDSchemewsViewBlockStyle style))addedBlock {
    
    HDSchemewsView *view = [[HDSchemewsView alloc]initWithCustomFrame:KEY_WINDOW.frame style:style];
    view.style = style;
    view.tmpModel  = model;
    view.supperVC = supperVC;
    view.needMatch = needMatch;
    view.addedBlock = addedBlock;
    [HD_FULLView addSubview:view];
    
    [view setNumberShouldEdit];
    
    return view;
}

#pragma mark 设置编号是否能编辑
- (void)setNumberShouldEdit
{
    // 非临时 备件或工时
    if ([self.tmpModel.schemewsid integerValue] > 0 && [self.tmpModel.schemewstype integerValue] != 2)
    {
        // 备件编号
        _numberTFOne.enabled = NO;
        _numberTFOne.backgroundColor = Color(224, 224, 224);
        _numberTFTwo.enabled = NO;
        _numberTFTwo.backgroundColor = Color(224, 224, 224);
        _numberTFThree.enabled = NO;
        _numberTFThree.backgroundColor = Color(224, 224, 224);
        _numberTFFour.enabled = NO;
        _numberTFFour.backgroundColor = Color(224, 224, 224);
        _numberTFFive.enabled = NO;
        _numberTFFive.backgroundColor = Color(224, 224, 224);
        _numberTFSix.enabled = NO;
        _numberTFSix.backgroundColor = Color(224, 224, 224);
        
        // 工时编号
        _ItemTimeOneTF.enabled = NO;
        _ItemTimeOneTF.backgroundColor = Color(224, 224, 224);
        
        _itemTimeTwoTF.enabled = NO;
        _itemTimeTwoTF.backgroundColor = Color(224, 224, 224);
        
        _itemTimeThreeTF.enabled = NO;
        _itemTimeThreeTF.backgroundColor = Color(224, 224, 224);
        
        _itemTimeFourTF.enabled = NO;
        _itemTimeFourTF.backgroundColor = Color(224, 224, 224);
    }

}

- (instancetype)initWithCustomFrame:(CGRect)frame style:(HDSchemewsViewStyle)style
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDSchemewsView" owner:nil options:nil];
    
    self = [array objectAtIndex:0];
    self.frame = frame;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self setupMaterialView];
    [self setupWorkHourView];
    style == HDSchemewsViewStyleMaterial ? [self setupMaterialViewWithHidden:NO] : [self setupWorkHourViewWithHidden:NO];
    _locationStyle = 1;
    _numberTFSix.hidden = YES;
    return self;
}



- (void)setupMaterialViewWithHidden:(BOOL)hidden {
    self.contentViewMaterial.hidden = hidden;
    self.contentViewWorkHour.hidden = !hidden;
    [self materialInit];
}

- (void)setupWorkHourViewWithHidden:(BOOL)hidden {
    self.contentViewWorkHour.hidden = hidden;
    self.contentViewMaterial.hidden = !hidden;
    [self workhourInit];

}

- (void)removeSelf {
    [_textfield resignFirstResponder];
    [self removeFromSuperview];
}

- (void)materialInit {
    [self.figueTFOne becomeFirstResponder];
}

- (void)workhourInit{
    [self.ItemTimeOneTF becomeFirstResponder];
}

- (void)setupMaterialView {
    self.contentViewMaterial.layer.masksToBounds = YES;
    self.contentViewMaterial.layer.cornerRadius = 5;
    self.contentViewMaterial.layer.shadowOpacity = 0.5;
    self.contentViewMaterial.layer.shadowColor = [UIColor grayColor].CGColor;
    self.contentViewMaterial.layer.shadowRadius = 3;
    self.contentViewMaterial.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentViewMaterial.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
//    _changeToITimeLbMaterial.attributedText = [@"切换至工时" changeToBottomLine];
    [self locationAndFactoryWithColor:Color(255, 255, 255) enabled:YES];
}

- (void)setupWorkHourView {
    self.contentViewWorkHour.layer.masksToBounds = YES;
    self.contentViewWorkHour.layer.cornerRadius = 5;
    self.contentViewWorkHour.layer.shadowOpacity = 0.5;
    self.contentViewWorkHour.layer.shadowColor = [UIColor grayColor].CGColor;
    self.contentViewWorkHour.layer.shadowRadius = 3;
    self.contentViewWorkHour.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentViewWorkHour.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
//    _changeToMaterialLb.attributedText = [@"切换至备件" changeToBottomLine];
}



- (void)locationAndFactoryWithColor:(UIColor *)color enabled:(BOOL)enabled {
    _figueTFTwo.userInteractionEnabled = enabled;
    _figueTFOne.userInteractionEnabled = enabled;
    _figueTFThree.userInteractionEnabled = enabled;
    _LandRTF.userInteractionEnabled = enabled;
    _figueTFOne.backgroundColor = color;
    _figueTFTwo.backgroundColor = color;
    _figueTFThree.backgroundColor = color;
    _LandRTF.backgroundColor = color;
}

#pragma mark  ------点击保存，完成，实现数据的传出刷新------

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

- (NSString *)getFigueString {
    NSString *figue = @"";
    for (UITextField *tf in @[_figueTFOne,_figueTFTwo,_figueTFThree,_LandRTF]) {
        figue = [self getFigueStringWithBaseString:figue tf:tf];
    }
    return figue;
}

- (NSString *)getListCodeMaterial {
    NSString *figue = @"";
    for (UITextField *tf in @[_numberTFOne,_numberTFTwo,_numberTFThree,_numberTFFour,_numberTFFive,_numberTFSix]) {
        figue = [self getFigueStringWithBaseString:figue tf:tf];
    }
    return figue;
}
- (NSString *)getListCodeWorkHour {
    NSString *figue = @"";
    for (UITextField *tf in @[_ItemTimeOneTF,_itemTimeTwoTF,_itemTimeThreeTF,_itemTimeFourTF]) {
        figue = [self getFigueStringWithBaseString:figue tf:tf];
    }
    return figue;
}

- (NSString *)getMaterialName {
    return _materialNameTF.text;
}

- (NSString *)getmaterialCount {
    return _materialCountTF.text ;
}
- (NSString *)getWorkHourCount {
    return _itemTimeCountTF.text;
}
- (NSString *)getItemName {
    return _itemTimeNameTF.text;
}

- (void)saveMaterialData {
    //编辑
    self.tmpModel.schemewsphotocode = [self getFigueString];
    self.tmpModel.schemewscode = [self getListCodeMaterial];
    self.tmpModel.schemewsname = [self getMaterialName];
    self.tmpModel.schemewscount = @([[self getmaterialCount] floatValue]);
}
- (void)saveDataWorkHour {
    //编辑
    self.tmpModel.schemewscode = [self getListCodeWorkHour];
    self.tmpModel.schemewsname = [self getItemName];
    self.tmpModel.schemewscount = @([[self getWorkHourCount] floatValue]);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_style == HDSchemewsViewStyleMaterial) {
        //备件
        [self removeSelf];
        if (self.materialModel) {
            [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:self.tmpModel.wospwosid type:@2 source:@1 stockid:@[self.materialModel.parts_id]];
        }else {
            [self saveMaterialData];
            
            [self editWorkHourOrMaretialWithSchemews:self.tmpModel type:kMaterialType];
        }
    }else {
        [self removeSelf];
        if (self.workHourModel) {
            [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:self.tmpModel.wospwosid type:@1 source:@1 stockid:@[self.workHourModel.workhourid]];
        }else {
            [self saveDataWorkHour];
            
            [self editWorkHourOrMaretialWithSchemews:self.tmpModel type:kWorkType];
        }
    }
    
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _textfield = textField;
    [self.listView removeFromSuperview];
    //备件中的 左/右选择
    if ([textField isEqual:_LandRTF]) {
        WeakObject(self);
        self.listView = [HDWorkListTableViews showTableViewlistViewAroundView:textField superView:self.contentViewMaterial direction:UIPopoverArrowDirectionDown dataSource:[@[@"L",@"R"] mutableCopy] size:CGSizeMake(CGRectGetWidth(textField.frame), 120) seletedNeedDelete:YES complete:^(NSNumber *idx, BOOL isneed, HDWorkListTableViewsStyle style) {
            textField.text = [idx integerValue] == 0 ? @"L":@"R";
            [selfWeak.numberTFOne becomeFirstResponder];
        }];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
#pragma mark  备件图号匹配
    if ([textField isEqual:_figueTFOne]) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (!text.length)
        {
            [self.listView removeFromSuperview];
            return YES;
        }
        if (textField.text.length < 2) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.image_no_1 = [textField.text substringToIndex:textField.text.length - 1];
                }
            }else {
                self.condition.image_no_1 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.image_no_1 && ![self.condition.image_no_1 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:1];
            }
            
            return YES;
        }else if (textField.text.length == 2){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.image_no_1 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:_figueTFTwo idx:2];
                [_figueTFTwo becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.image_no_1 = [textField.text substringToIndex:1];
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:1];
                return YES;
            }
        }else {
            if ([string isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:1];
                return YES;
            }
            [_figueTFTwo becomeFirstResponder];
            
            return NO;
        }
    }
    if ([textField isEqual:_figueTFTwo]) {
        if (textField.text.length < 2) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.image_no_2 = [textField.text substringToIndex:textField.text.length - 1];
                    textField.text = @"";
                    [_figueTFOne becomeFirstResponder];
                    return NO;
                }else {
                    [_figueTFOne becomeFirstResponder];
                    return NO;
                }
            }else {
                self.condition.image_no_2 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.image_no_2 && ![self.condition.image_no_2 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:2];
            }
            
            return YES;
        }else if (textField.text.length == 2){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.image_no_2 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:_figueTFThree idx:3];
                [_figueTFThree becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.image_no_2 = [textField.text substringToIndex:1];
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:2];
                return YES;
            }
        }else {
            if ([string isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:2];
                return YES;
            }
            [_figueTFThree becomeFirstResponder];
            
            return NO;
        }
    }
    if ([textField isEqual:_figueTFThree]) {
        if (textField.text.length < 2) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.image_no_3 = [textField.text substringToIndex:textField.text.length - 1];
                    textField.text = @"";
                    [_figueTFTwo becomeFirstResponder];
                    return NO;
                    
                }else {
                    [_figueTFTwo becomeFirstResponder];
                    return NO;
                }
            }else {
                self.condition.image_no_3 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.image_no_3 && ![self.condition.image_no_3 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:3];
            }
            
            return YES;
        }else if (textField.text.length == 2){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.image_no_3 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:_LandRTF idx:0];
                [_LandRTF becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.image_no_3 = [textField.text substringToIndex:1];
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:3];
                return YES;
            }
        }else {
            if ([string isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:textField idx:3];

                return YES;
            }
            [_LandRTF becomeFirstResponder];
            
            return NO;
        }
    }
    
    
#pragma mark  获取全部图号的匹配数据之后，连带编号图号一起匹配，接口不一致
    if ([textField isEqual:_LandRTF] && textField.text.length == 0) {
        
        if (![string isEqualToString:@""]) {
            if ([[string uppercaseString] isEqualToString:@"L"] || [[string uppercaseString] isEqualToString:@"R"] || [string  isEqualToString:@"全部"] ) {
                textField.text = [textField.text stringByAppendingString:string];
                
                
                [_numberTFOne becomeFirstResponder];
            }
            return NO;
        }else {
            textField.text = @"";
            [_figueTFThree becomeFirstResponder];
            return NO;
        }
        
    }else if([textField isEqual:_LandRTF] && textField.text.length == 1) {
        if (![string isEqualToString:@""]) {
            [_numberTFOne becomeFirstResponder];
        }else {
            textField.text = nil;
            [_figueTFThree becomeFirstResponder];
            return NO;
        }
    }

#pragma mark  编号匹配
    if ([textField isEqual:_numberTFOne]) {
        
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (!text.length)
        {
            [self.listView removeFromSuperview];
            return YES;
        }
        
        if (textField.text.length < 2) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.parts_no_1 = [textField.text substringToIndex:textField.text.length - 1];
                    textField.text = @"";
                    //[_LandRTF becomeFirstResponder];
                    //return NO;
                }else {
                    //[_LandRTF becomeFirstResponder];
                    // return NO;
                }
            }else {
                self.condition.parts_no_1 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.parts_no_1 && ![self.condition.parts_no_1 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:1];
                
            }
            
            return YES;
        }else if (textField.text.length == 2){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.parts_no_1 = textField.text;
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFTwo idx:2];
                [_numberTFTwo becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.parts_no_1 = [textField.text substringToIndex:1];
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFOne idx:1];
                
                return YES;
            }
        }else {
            if ([string isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFOne idx:1];
                return YES;
            }
            [_numberTFTwo becomeFirstResponder];
            
            return NO;
        }
    }
    
    if ([textField isEqual:_numberTFTwo]) {
        
        if (textField.text.length < 2) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.parts_no_2 = [textField.text substringToIndex:textField.text.length - 1];
                    textField.text = @"";
                    [_numberTFOne becomeFirstResponder];
                    return NO;
                }else {
                    [_numberTFOne becomeFirstResponder];
                    return NO;
                }
            }else {
                self.condition.parts_no_2 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.parts_no_2 && ![self.condition.parts_no_2 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:2];
                
            }
            
            return YES;
        }else if (textField.text.length == 2){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.parts_no_2 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFThree idx:3];
                [_numberTFThree becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.parts_no_2 = [textField.text substringToIndex:1];
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFTwo idx:2];
                
                return YES;
            }
        }else {
            if ([string isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:2];
                return YES;
            }
            [_numberTFThree becomeFirstResponder];
            
            return NO;
        }
    }
    if ([textField isEqual:_numberTFThree]) {
        
        if (textField.text.length < 2) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.parts_no_3 = [textField.text substringToIndex:textField.text.length - 1];
                    textField.text = @"";
                    [_numberTFTwo becomeFirstResponder];
                    return NO;
                }else {
                    [_numberTFTwo becomeFirstResponder];
                    return NO;
                }
            }else {
                self.condition.parts_no_3 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.parts_no_3 && ![self.condition.parts_no_3 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:3];
                
            }
            
            return YES;
        }else if (textField.text.length == 2){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.parts_no_3 = textField.text;
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFFour idx:4];
                [_numberTFFour becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.parts_no_3 = [textField.text substringToIndex:1];
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFThree idx:3];
                
                return YES;
            }
        }else {
            if ([string isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:3];
                return YES;
            }
            [_numberTFFour becomeFirstResponder];
            
            return NO;
        }
    }
    if ([textField isEqual:_numberTFFour]) {
        
        if (textField.text.length < 1) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.parts_no_4 = [textField.text substringToIndex:textField.text.length - 1];
                    [_numberTFThree becomeFirstResponder];

                    return NO;
                }else {
                    [_numberTFThree becomeFirstResponder];
                    return NO;
                }
            }else {
                self.condition.parts_no_4 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.parts_no_4 && ![self.condition.parts_no_4 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:4];
                
            }
            
            return YES;
        }else if (textField.text.length == 1){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.parts_no_4 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFFive idx:5];
                [_numberTFFive becomeFirstResponder];
                
                return NO;
            }else {
                textField.text = @"";
                [_numberTFThree becomeFirstResponder];
                
                return NO;
            }
        }else {
            if ([string isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:4];
                return YES;
            }
            [_numberTFFive becomeFirstResponder];
            
            return NO;
        }
    }
    if ([textField isEqual:_numberTFFive]) {
        
        if (textField.text.length < 2) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.parts_no_5 = [textField.text substringToIndex:textField.text.length - 1];
                    textField.text = @"";
                    [_numberTFFour becomeFirstResponder];
                    return NO;
                }else {
                    [_numberTFFour becomeFirstResponder];
                    return NO;
                }
            }else {
                self.condition.parts_no_5 = [textField.text stringByAppendingString:string];
            }
            
            if (self.condition.parts_no_5 && ![self.condition.parts_no_5 isEqualToString:@""]) {
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:5];
                
            }
            
            return YES;
        }else if (textField.text.length == 2){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.parts_no_5 = textField.text;
                
                UITextField *nextField;
                NSInteger idx = -1;
                if (self.locationStyle == 1) {
                    nextField = _materialNameTF;
                    
                }else {
                    nextField = _numberTFSix;
                    idx = 6;
                    
                }
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:nextField idx:idx];
                [nextField becomeFirstResponder];
                
                return NO;
            }else {
                self.condition.parts_no_5 = [textField.text substringToIndex:1];
                [self.listView removeFromSuperview];
                
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFFive idx:5];
                return YES;
            }
        }else {
            if ([string isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:5];
                return YES;
            }
            [_numberTFFive becomeFirstResponder];
            
            return NO;
        }
    }
    
    if ([textField isEqual:_numberTFSix]) {
        
        if (textField.text.length < 2) {
            if ([string isEqualToString:@""]) {
                if (textField.text.length > 0) {
                    self.condition.parts_no_6 = [textField.text substringToIndex:textField.text.length - 1];
                    textField.text = @"";
                    [_numberTFFive becomeFirstResponder];
                    return NO;
                }else {
                    [_numberTFFive becomeFirstResponder];
                    return NO;
                }
            }else {
                self.condition.parts_no_6 = [textField.text stringByAppendingString:string];
            }
            
            [self.listView removeFromSuperview];
            if (self.condition.parts_no_6 && ![self.condition.parts_no_6 isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:6];
                
            }
            
            return YES;
        }
        else if (textField.text.length == 2){
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByAppendingString:string];
                self.condition.parts_no_6 = textField.text;
                
                [self.listView removeFromSuperview];
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFSix idx:6];
                
                return NO;
            }else {
                self.condition.parts_no_6 = [textField.text substringToIndex:1];
                [self.listView removeFromSuperview];
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFSix idx:6];
                return YES;
            }
        }
        else {
            if ([string isEqualToString:@""]) {
                [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:textField idx:6];
                return YES;
            }
            [_materialNameTF becomeFirstResponder];
            
            return NO;
        }
    }
    
    
    if ([textField isEqual:_materialNameTF]) {
        if (textField.text.length == 0) {
            if ([string isEqualToString:@""]) {
                if (self.locationStyle == 1) {//厂方
                    [_numberTFFive becomeFirstResponder];
                }else {
                    [_numberTFSix becomeFirstResponder];
                }
            }
            
        }
    }
    if ([textField isEqual:_materialCountTF]) {
        if (textField.text.length == 0) {
            if ([string isEqualToString:@""]) {
                [_materialNameTF becomeFirstResponder];
            }
            else
            {
                // 修改
                BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:range replacementString:string];
                return ret;
            }
        }
    }
    
    
    #pragma mark  工时匹配
    if ([textField isEqual:self.itemTimeCountTF]) {
        if (![string isEqualToString:@""]) {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"TU" withString:@""];
            
            NSRange realRange = NSMakeRange(range.location - 2, range.length);
            BOOL ret = [HDUtil textFieldFilter:textField shouldChangeCharactersInRange:realRange replacementString:string];
            if (!ret) {
                string = @"TU";//NSString stringWithFormat:@"TU",string];
                textField.text = [textField.text stringByAppendingString:string];
                return NO;
            }
            
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
        
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (!text.length)
        {
            [self.listView removeFromSuperview];
            return YES;
        }
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
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:1];
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
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:2];
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
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:3];
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
                [self.listView removeFromSuperview];
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
                [self matchWorkOrderPartWithCondition:self.condition aroundView:textField idx:4];
                return YES;
            }
            [self.listView removeFromSuperview];
            [_itemTimeNameTF becomeFirstResponder];
            
            return NO;
        }
    }

    return YES;
}
#pragma mark  工时匹配
- (void)matchWorkOrderPartWithCondition:(ProscheSchemewsSearchCondition *)condition aroundView:(UITextField *)view idx:(NSInteger)idex {
    if (!self.needMatch) {
        return;
    }
    //工时模糊搜索中  没有车系车型code  不给匹配
    if (![HDLeftSingleton shareSingleton].carModel.wocarcatena || ![HDLeftSingleton shareSingleton].carModel.wocarmodel) {
        return;
    }
    WeakObject(view);
    WeakObject(self);
    selfWeak.workHourModel = nil;
    condition.findtype = [NSString stringWithFormat:@"%@",@(self.locationStyle)];//1.厂方 2.本地
    
    PorscheNewCarMessage *carModel = [HDLeftSingleton shareSingleton].carModel;
    condition.pctid = carModel.cycartypeid;
    
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self];
    WeakObject(hud)
    [PorscheRequestManager searchWorkHour:condition complete:^(NSMutableArray *list,PResponseModel* responser) {
        [hudWeak hideAnimated:YES];
        if (list.count) {
            self.schemewsArray = nil;
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
            selfWeak.listView = [HDWorkListTableViews showTableViewlistViewAroundView:viewWeak superView:selfWeak.contentViewWorkHour direction:UIPopoverArrowDirectionDown dataSource:array size:CGSizeMake(CGRectGetWidth(viewWeak.frame), 120) seletedNeedDelete:YES complete:^(NSNumber *idx, BOOL isshowArrow, HDWorkListTableViewsStyle style) {
                viewWeak.text = array[[idx integerValue]];
                [selfWeak searchEndWithTF:viewWeak idx:idex type:nil selectedid:[idx integerValue]];
            }];
        }else if (!list){
            NSLog(@"获取匹配信息失败");
        }else {
            NSLog(@"获取匹配数据为空!");
        }
    }];
}
// int findflag;   //当前在编辑内容：1：编号，2：图号
- (NSNumber *)currentMatchTypeWithCurrentTextField:(UITextField *)textField
{
    if (textField == _figueTFOne || textField == _figueTFTwo || textField == _figueTFThree)
    {
        return @2;
    }
    else if (textField == _numberTFOne || textField == _numberTFTwo || textField == _numberTFThree || textField == _numberTFFour || textField == _numberTFFive || textField == _numberTFSix)
    {
        return @1;
    }
    return @2;
}

#pragma mark  图号编号匹配
//编号 目前采用 编号部分匹配
- (void)matchMaterialOrderWithType:(NSNumber *)type condition:(ProscheSchemewsSearchCondition *)condition aroundView:(UITextField *)view idx:(NSInteger)idex {
    if (!self.needMatch) {
        return;
    }
    WeakObject(self);
    WeakObject(view);
    condition.findtype = [NSString stringWithFormat:@"%@",@(self.locationStyle)];
    PorscheNewCarMessage *carModel = [HDLeftSingleton shareSingleton].carModel;

    /*
     int findflag;   //当前在编辑内容：1：编号，2：图号
     */
    
    
    condition.cartypeid = carModel.cycartypeid;
    
    self.materialModel = nil;
    [PorscheRequestManager searchMaterialNumber:condition type:type  complete:^(NSMutableArray * _Nonnull list, PResponseModel * _Nonnull responser) {
        if (list.count) {
            self.schemewsArray = nil;
            __block NSMutableArray *array = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PorscheSchemeSpareModel *model = obj;
                switch (idex) {
                    case 1:
                        if ([type isEqual:kMaterialPart]) {
                            [array addObject:model.parts_no_1];
                        }else {
                            [array addObject:model.image_no_1];
                        }
                        break;
                    case 2:
                        if ([type isEqual:kMaterialPart]) {
                            [array addObject:model.parts_no_2];
                        }else {
                            [array addObject:model.image_no_2];
                        }
                        
                        break;
                    case 3:
                        if ([type isEqual:kMaterialPart]) {
                            [array addObject:model.parts_no_3];
                        }else {
                            [array addObject:model.image_no_3];
                        }
                        
                        break;
                    case 4:
                        if ([type isEqual:kMaterialPart]) {
                            [array addObject:model.parts_no_4];
                        }else {
                            [array addObject:model.image_no_4];
                        }
                        
                        break;
                    case 5:
                        [array addObject:model.parts_no_5];
                        
                        break;
                    case 6:
                        [array addObject:model.parts_no_6];
                        
                        break;
                    default:
                        break;
                }
                [selfWeak.schemewsArray addObject:model];
            }];
            [selfWeak.listView removeFromSuperview];
            if (!viewWeak) {
                return ;
            }
            selfWeak.listView = [HDWorkListTableViews showTableViewlistViewAroundView:viewWeak superView:selfWeak.contentViewMaterial direction:UIPopoverArrowDirectionDown dataSource:array size:CGSizeMake(CGRectGetWidth(viewWeak.frame), 120) seletedNeedDelete:YES complete:^(NSNumber *idx, BOOL isshowArrow, HDWorkListTableViewsStyle style) {
                viewWeak.text = array[[idx integerValue]];
                
                [selfWeak searchEndWithTF:viewWeak idx:idex type:type selectedid:[idx integerValue]];
                
            }];
        }else if (!list){
            NSLog(@"获取匹配信息失败");
        }else {
            NSLog(@"获取匹配数据为空!");
        }
        
    }];
}

//点选时，最后一个编号框才赋值
- (void)searchEndWithTF:(UITextField *)tf idx:(NSInteger)idx type:(NSNumber *)materialType selectedid:(NSInteger)selectedid {
    if (self.style == HDSchemewsViewStyleWorkHour) {
        [self workHourSearchWithTF:tf idx:idx seletedid:selectedid];
    }else {
        [self materialSearchWithTF:tf idx:idx type:materialType selectedIdx:selectedid];
    }
}



- (void)workHourSearchWithTF:(UITextField *)tf idx:(NSInteger)idx seletedid:(NSInteger)selecteid {
    if ([tf isEqual:_itemTimeFourTF]) {
        self.workHourModel = self.schemewsArray[selecteid];
    }
    switch (idx) {
        case 1:
            self.condition.workhourcode1 = _ItemTimeOneTF.text;
            [self matchWorkOrderPartWithCondition:self.condition aroundView:_itemTimeTwoTF idx:2];
            [_itemTimeTwoTF becomeFirstResponder];
            break;
        case 2:
            self.condition.workhourcode1 = _ItemTimeOneTF.text;
            self.condition.workhourcode2 = _itemTimeTwoTF.text;
            [self matchWorkOrderPartWithCondition:self.condition aroundView:_itemTimeThreeTF idx:3];
            [_itemTimeThreeTF becomeFirstResponder];
            
            break;
        case 3:
            self.condition.workhourcode2 = _itemTimeTwoTF.text;
            self.condition.workhourcode3 = _itemTimeThreeTF.text;
            [self matchWorkOrderPartWithCondition:self.condition aroundView:_itemTimeFourTF idx:4];
             [_itemTimeFourTF becomeFirstResponder];
            
            break;
  
        default:
            break;
    }

}
- (void)materialSearchWithTF:(UITextField *)tf idx:(NSInteger)idx type:(NSNumber *)materialType selectedIdx:(NSInteger)selectedid{
    //备件图号
    if ([tf isEqual:_figueTFThree]) {
        self.materialModel = self.schemewsArray[selectedid];
    }
    //备件编号
    if (self.locationStyle == HDSchemewsViewLocationStyleFactory) {//厂方五个
        if ([tf isEqual:_numberTFFive]) {
            self.materialModel = self.schemewsArray[selectedid];
        }
    }else {
        if ([tf isEqual:_numberTFSix]) {
            self.materialModel = self.schemewsArray[selectedid];
        }
    }
    
    if ([materialType isEqual:kMaterialImgPart]) {//图号匹配
        switch (idx) {
            case 1:
                self.condition.image_no_1 = _figueTFOne.text;
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:_figueTFTwo idx:2];
                
                [_figueTFTwo becomeFirstResponder];
                break;
            case 2:
                self.condition.image_no_1 = _figueTFOne.text;
                self.condition.image_no_2 = _figueTFTwo.text;

                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:_figueTFThree idx:3];
                
                [_figueTFThree becomeFirstResponder];
                
                break;
            case 3:
                self.condition.image_no_2 = _figueTFTwo.text;
                self.condition.image_no_3 = _figueTFThree.text;
                if (_figueTFTwo.text.length == 3 && _figueTFThree.text.length < 3) {
                    [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:_figueTFThree idx:3];
                    
                    [_figueTFThree becomeFirstResponder];
                }
                
                
                break;
            default:
                break;
        }
    }else {

            switch (idx) {
                case 1:
                    self.condition.parts_no_1 = _numberTFOne.text;
                    [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFTwo idx:2];
                    [_numberTFTwo becomeFirstResponder];
                    break;
                case 2:
                    self.condition.parts_no_1 = _numberTFOne.text;
                    self.condition.parts_no_2 = _numberTFTwo.text;
                    [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFThree idx:3];
                    [_numberTFThree becomeFirstResponder];
                    
                    break;
                case 3:
                    self.condition.parts_no_2 = _numberTFTwo.text;
                    self.condition.parts_no_3 = _numberTFThree.text;
                    [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFFour idx:4];
                    [_numberTFFour becomeFirstResponder];

                    
                    break;
                case 4:
                    self.condition.parts_no_3 = _numberTFThree.text;
                    self.condition.parts_no_4 = _numberTFFour.text;
                    [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFFive idx:5];
                    [_numberTFFive becomeFirstResponder];
                    break;
                case 5:
                    self.condition.parts_no_4 = _numberTFFour.text;
                    self.condition.parts_no_5 = _numberTFFive.text;
                    if (self.locationStyle == HDSchemewsViewLocationStyleLocation) {
                        [self matchMaterialOrderWithType:kMaterialPart condition:self.condition aroundView:_numberTFSix idx:6];
                        [_numberTFSix becomeFirstResponder];
                    }
                    break;
                case 6:
                    break;
                default:
                    break;
            }
    
        
    }
    
}


- (void)setMaterialModel:(PorscheSchemeSpareModel *)materialModel {
    if (!materialModel) {
        _materialModel = nil;
        return;
    }
    
    _materialModel = materialModel;
    _figueTFOne.text = [materialModel.image_no_1 isEqualToString:@""] ? _figueTFOne.text : materialModel.image_no_1;
    _figueTFTwo.text = [materialModel.image_no_2 isEqualToString:@""] ? _figueTFTwo.text : materialModel.image_no_2;
    _figueTFThree.text = [materialModel.image_no_3 isEqualToString:@""] ? _figueTFThree.text : materialModel.image_no_3;
    _LandRTF.text = [materialModel.image_no_4 isEqualToString:@""] ? _LandRTF.text : materialModel.image_no_4;
    
    
    _numberTFOne.text = [materialModel.parts_no_1 isEqualToString:@""] ? _numberTFOne.text : materialModel.parts_no_1;
    _numberTFTwo.text = [materialModel.parts_no_2 isEqualToString:@""] ? _numberTFTwo.text : materialModel.parts_no_2;
    _numberTFThree.text = [materialModel.parts_no_3 isEqualToString:@""] ? _numberTFThree.text : materialModel.parts_no_3;
    _numberTFFour.text = [materialModel.parts_no_4 isEqualToString:@""] ? _numberTFFour.text : materialModel.parts_no_4;
    _numberTFFive.text = [materialModel.parts_no_5 isEqualToString:@""] ? _numberTFFive.text : materialModel.parts_no_5;
    _numberTFSix.text = [materialModel.parts_no_6 isEqualToString:@""] ? _numberTFSix.text : materialModel.parts_no_6;
    
    _materialNameTF.text = [materialModel.parts_name isEqualToString:@""] ? _materialNameTF.text : materialModel.parts_name;
    _materialCountTF.text = materialModel.parts_num ? [NSString stringWithFormat:@"%@",materialModel.parts_num] : _materialCountTF.text;
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



- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    if (_style == HDSchemewsViewStyleMaterial) {
        [self setupCodeListTextWithString:_tmpModel.schemewscode];
        [self setupImgCode:_tmpModel.schemewsphotocode];
        self.materialNameTF.text = tmpModel.schemewsname;
        self.materialCountTF.text = tmpModel.schemewscount ? [NSString stringWithFormat:@"%@",tmpModel.schemewscount] : @"";
    }else {
        _tmpModel = tmpModel;
        [self setupListCode:tmpModel.schemewscode];
        
        _itemTimeNameTF.text = tmpModel.schemewsname;
        
        _itemTimeCountTF.text = tmpModel.schemewscount ? [NSString stringWithFormat:@"%@",tmpModel.schemewscount] : @"";

    }
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

//备件图号
- (void)setupImgCode:(NSString *)imgCode {
    NSArray *codeArr = [imgCode componentsSeparatedByString:@" "];
    switch (codeArr.count) {
        case 7:
        case 6:
        case 5:
        case 4:
            _LandRTF.text = codeArr[3];
        case 3:
            _figueTFThree.text = codeArr[2];
        case 2:
            _figueTFTwo.text = codeArr[1];
        case 1:
            _figueTFOne.text = codeArr[0];
        default:
            break;
    }
}

//备件编号
- (void)setupCodeListTextWithString:(NSString *)listCode {
    NSArray *codeArr = [listCode componentsSeparatedByString:@" "];
    switch (codeArr.count) {
        case 7:
        case 6:
            _numberTFSix.text = codeArr[5];
        case 5:
            _numberTFFive.text = codeArr[4];
        case 4:
            _numberTFFour.text = codeArr[3];
        case 3:
            _numberTFThree.text = codeArr[2];
        case 2:
            _numberTFTwo.text = codeArr[1];
        case 1:
            _numberTFOne.text = codeArr[0];
        default:
            break;
    }
}

#pragma mark  事件
//tag 1001 切换工时/1002 切换备件
- (IBAction)changeToCubBtAction:(UIButton *)sender
{
    if (sender.tag == 1001) {
        [self setupMaterialViewWithHidden:YES];
    }else {
        [self setupWorkHourViewWithHidden:YES];
    }
    //    [HDPoperDeleteView showAlertViewAroundView:sender titleArr:@[@"保存已编辑的工时信息?",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
    //
    //
    //    } refuse:^{
    //
    //    } cancel:^{
    //
    //    }];
}


//进入工时库按钮事件
//tag 2001进入备件库 /2002进入工时库
- (IBAction)stepToCubBtAction:(UIButton *)sender
{
    [self removeSelf];
    if (sender.tag == 2001) {
        
        if ([HDPermissionManager isNotThisPermission:HDOrder_GoSpacePartLibrary])
        {
            return;
        }
        [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleMaterialCub right:HDRightStatusStyleMaterialCub];
    }else {
        
        if ([HDPermissionManager isNotThisPermission:HDOrder_GoTimeLibrary])
        {
            return;
        }
        [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleWorkTimeCub right:HDRightStatusStyleWorkTimeCub];
    }
}
//返回按钮
//
- (IBAction)backBtAction:(UIButton *)sender
{
    [self removeSelf];
}

//加入工单
//tag 3001备件加入工单 /3002工时加入工单
- (IBAction)saveAction:(UIButton *)sender
{
    if (sender.tag == 3001) {
        [self removeSelf];
        if (self.materialModel) {
            [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:self.tmpModel.wospwosid type:@2 source:@1 stockid:@[self.materialModel.parts_id]];
        }else {
            [self saveMaterialData];
            
            [self editWorkHourOrMaretialWithSchemews:self.tmpModel type:kMaterialType];
        }
    }else {
        [self removeSelf];
        if (self.workHourModel) {
            [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:self.tmpModel.wospwosid type:@1 source:@1 stockid:@[self.workHourModel.workhourid]];
        }else {
            [self saveDataWorkHour];
            
            [self editWorkHourOrMaretialWithSchemews:self.tmpModel type:kWorkType];
        }

    }
}
//相机按钮
//tag 4001备件相机 /4002工时相机
- (IBAction)cameraAction:(UIButton *)sender
{
    self.modelController.shootType = PorschePhotoCarImage;
    self.modelController.fileType = PorschePhotoGalleryFileTypeImage;
    self.modelController.keyType = PorschePhotoGalleryKeyTypeScheme;
    self.modelController.relativeid = self.tmpModel.wospwosid;
    [self.modelController cycleTakePhoto:nil video:nil];
}
//相册按钮
//tag 5001备件相册 /5002工时相册
- (IBAction)photoAction:(UIButton *)sender
{
    WeakObject(self)
    [PorschePhotoModelController getPhotoListCompletion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        if (responser.status == 100)
        {
            PorscheGalleryModel *model = [PorscheGalleryModel yy_modelWithDictionary:responser.object];
            [selfWeak.modelController showPhotoGalleryWithModel:model viewType:PorschePhotoGalleryPreviewAndShoot];
        }
    }];
}
//+p按钮
//tag 6001备件+p /6002工时+工时
- (IBAction)repairAction:(UIButton *)sender
{
    [self removeSelf];

}

//本店按钮
//tag 7001备件本店 /7002工时本店

#pragma mark 本店厂方切换
- (IBAction)locationBtAction:(UIButton *)sender
{
    if (sender.tag == 7001) {
        [self locationAndFactoryWithColor:Color(224, 224, 224) enabled:NO];
        
        [self cleanTFMaterial];
        
        [_numberTFOne becomeFirstResponder];
        
        _bgImageViewMaterial.image = [UIImage imageNamed:@"materialview_location_pic_header.png"];
        _factoryLbMaterial.textColor = Color(100, 100, 100);
        
        _locationLbMaterial.textColor = [UIColor whiteColor];
        self.locationStyle = HDSchemewsViewLocationStyleLocation;
        _numberTFFive.keyboardType = UIKeyboardTypeNumberPad;
        _numberTFSix.keyboardType = UIKeyboardTypeDefault;
        
        _numberTFSix.hidden = NO;
    }else {
        [_ItemTimeOneTF becomeFirstResponder];
        self.locationStyle = HDSchemewsViewLocationStyleLocation;
        _factoryLbWorkHour.textColor = Color(100, 100, 100);
        _loctionLbWorkHour.textColor = [UIColor whiteColor];
        [_topBgImageView setImage:[UIImage imageNamed:@"Item_time_headerView_image_new_bendian"]];
    }
}
//厂方按钮
//tag 8001备件厂方 /8002工时厂方
- (IBAction)factoryBtAction:(UIButton *)sender
{
    
    if (sender.tag == 8001) {
        [self locationAndFactoryWithColor:[UIColor whiteColor] enabled:YES];
        //[self locationAndFactoryWithColor:Color(224, 224, 224) enabled:NO];
        [self cleanTFMaterial];
        [_figueTFOne becomeFirstResponder];
        _bgImageViewMaterial.image = [UIImage imageNamed:@"materialview_factory_pic_header.png"];
        _locationLbMaterial.textColor = Color(100, 100, 100);
        _factoryLbMaterial.textColor = [UIColor whiteColor];
        self.locationStyle = HDSchemewsViewLocationStyleFactory;
        _numberTFFive.keyboardType = UIKeyboardTypeDefault;
        _numberTFSix.hidden = YES;
    }else {
        [_ItemTimeOneTF becomeFirstResponder];
        self.locationStyle = HDSchemewsViewLocationStyleFactory;
        _loctionLbWorkHour.textColor = Color(100, 100, 100);
        _factoryLbWorkHour.textColor = [UIColor whiteColor];
        [_topBgImageView setImage:[UIImage imageNamed:@"Item_time_headerView_image_new_changfang"]];
    }
}

- (void)cleanTFMaterial
{
    _figueTFOne.text = @"";
    _figueTFTwo.text = @"";
    _figueTFThree.text = @"";
    _numberTFOne.text = @"";
    _numberTFTwo.text = @"";
    _numberTFThree.text = @"";
    _numberTFFour.text = @"";
    _numberTFFive.text = @"";
    _LandRTF.text = @"";
    _numberTFSix.text = @"";
    _materialNameTF.text = @"";
    _materialCountTF.text = @"";
}

- (void)cleanTFWorkHour
{
    _ItemTimeOneTF.text = @"";
    _itemTimeTwoTF.text = @"";
    _itemTimeThreeTF.text = @"";
    _itemTimeFourTF.text = @"";
    _itemTimeNameTF.text = @"";
    _itemTimeCountTF.text = @"";
}






#pragma mark  获取图号
- (NSString *)getImgCode {
    NSString *endStr = [self getStrWithBaseStr:_figueTFOne.text Str:_figueTFTwo.text];
    endStr = [self getStrWithBaseStr:endStr Str:_figueTFThree.text];
    endStr = [self getStrWithBaseStr:endStr Str:_LandRTF.text];
    return endStr;
    
}
- (NSString *)getStrWithBaseStr:(NSString *)base Str:(NSString *)str {
    
    return  [base stringByAppendingString:[base isEqualToString:@""] ? @"" : [NSString stringWithFormat:@" %@",str]];
}


#pragma mark  库中的备件/工时 加入工单接口
/****
 *   添加工时备件 addedType:1.增加 2.删除 type:1.工时  2.备件  source:1.库 2.自定义 stocked添加自定义不需要，添加库多工时配件，存id数组  删除时，将单一的配件或者工时id存入数组。
 ****/
//
- (void)upDateProjectMaterialTestWithAddedType:(NSNumber *)addedType schemeid:(NSNumber *)schemeid type:(NSNumber *)type source:(NSNumber *)source stockid:(NSArray *)stockList {
    NSString *stockid = stockList.count ? [stockList componentsJoinedByString:@","] :@"";
    ProscheAdditionCondition *tmp = [ProscheAdditionCondition new];
    if ([addedType isEqual:kAddition]) {
        tmp.processstatus = @([HDLeftSingleton shareSingleton].stepStatus - 1);
        tmp.schemeid = schemeid;
        tmp.source = source;
        tmp.type = type;
        tmp.stockidbatch = stockid;
        if (_style == HDSchemewsViewStyleMaterial) {
            tmp.addnum = @([_materialCountTF.text integerValue]);
            tmp.partsname = _materialNameTF.text;
            tmp.sparephotocode = [self getImgCode];
        }
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

#pragma mark 自定义备件 接口
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

- (PorschePhotoModelController *)modelController
{
    if (!_modelController)
    {
        _modelController = [[PorschePhotoModelController alloc] init];
        _modelController.supporterViewController = self.supperVC;
    }
    return _modelController;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.contentViewMaterial.hidden) {
        if (CGRectContainsPoint(self.contentViewMaterial.frame, point)) {
            return [super hitTest:point withEvent:event];
        }
    }
    
    if (!self.contentViewWorkHour.hidden) {
        if (CGRectContainsPoint(self.contentViewWorkHour.frame, point)) {
            return [super hitTest:point withEvent:event];
        }
    }

    [self removeSelf];
    return nil;
    
}
 // default returns YES if point is in bounds
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

- (void)deleteBackward:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        if (textField == _LandRTF)
        {
            [_figueTFThree becomeFirstResponder];
        }
        else if (textField == _figueTFThree)
        {
            [_figueTFTwo becomeFirstResponder];
        }
        else if (textField == _figueTFTwo)
        {
            [_figueTFOne becomeFirstResponder];
        }
        else if (textField == _numberTFSix)
        {
            [_numberTFFive becomeFirstResponder];
        }
        else if (textField == _numberTFFive)
        {
            [_numberTFFour becomeFirstResponder];
        }
        else if (textField == _numberTFFour)
        {
            [_numberTFThree becomeFirstResponder];
        }
        else if (textField == _numberTFThree)
        {
            [_numberTFTwo becomeFirstResponder];
        }
        else if (textField == _numberTFTwo)
        {
            [_numberTFOne becomeFirstResponder];
        }
        else if (textField == _itemTimeFourTF)
        {
            [_itemTimeThreeTF becomeFirstResponder];
        }
        else if (textField == _itemTimeThreeTF)
        {
            [_itemTimeTwoTF becomeFirstResponder];
        }
        else if (textField == _itemTimeTwoTF)
        {
            [_ItemTimeOneTF becomeFirstResponder];
        }
    }
}

@end
