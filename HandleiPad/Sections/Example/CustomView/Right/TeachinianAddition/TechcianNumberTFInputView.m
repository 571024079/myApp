//
//  TechcianNumberTFInputView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//
//图号编号辅助视图
#import "TechcianNumberTFInputView.h"

#import "HDPoperDeleteView.h"
//图号下拉辅助视图
#import "HDWorkListTableViews.h"

#import "PorschePhotoGallery.h"

#import "ZLCameraViewController.h"

#import "TechcianItemTimeTFInputView.h"
#import "PorschePhotoModelController.h"//媒体类
#import "HDLeftSingleton.h"

@interface TechcianNumberTFInputView ()<UITextFieldDelegate>

//切换至工时弹窗

@property (nonatomic, strong) ProscheSchemewsSearchCondition *condition;

@property (nonatomic, strong) NSMutableArray *schemewsArray;

@property (nonatomic, strong) PorscheSchemeSpareModel *materialModel;

@property (nonatomic, strong) HDWorkListTableViews *listView;

@property (nonatomic, strong) UITextField *textfield;
//保存点击展示的VC
@property (nonatomic, strong) UIViewController *supperVC;
// 媒体处理类
@property (nonatomic, strong) PorschePhotoModelController *modelController;

//@property (nonatomic, assign) CGRect viewRect;
@end
//默认尺寸 CGRectMake(137, 30, 750, 325) <需固定>
@implementation TechcianNumberTFInputView


//- (void)drawRect:(CGRect)rect {
//
//    //中间镂空的矩形框
//    CGRect myRect = self.viewRect;
//    //背景
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
//    //镂空
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:4];
//    [path appendPath:circlePath];
//    [path setUsesEvenOddFillRule:YES];
//
//    CAShapeLayer *fillLayer = [CAShapeLayer layer];
//    fillLayer.path = path.CGPath;
//    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
//    fillLayer.fillColor = [UIColor blackColor].CGColor;
//    fillLayer.opacity = 0.5;
//    [KEY_WINDOW.layer insertSublayer:fillLayer atIndex:0];
//
//}

+ (TechcianNumberTFInputView *)showTechcianNumberTFInputViewModel:(PorscheNewSchemews *)model withSupperVC:(UIViewController *)supperVC addedBlock:(void(^)(NSInteger tag))addedBlock {
    TechcianNumberTFInputView *view = [[TechcianNumberTFInputView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    view.tmpModel  = model;
    view.supperVC = supperVC;
    view.addedBlock = addedBlock;
    [HD_FULLView addSubview:view];
    
    [view.figueTFOne becomeFirstResponder];

    return view;
}

- (void)removeSelf {
    [_textfield resignFirstResponder];
    [self removeFromSuperview];
}

//默认尺寸 <750...325> <需固定>
- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TechcianNumberTFInputView" owner:nil options:nil];
    
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
        
    _numberTFSix.hidden = YES;
    //_changeToITimeLb.attributedText = [@"切换至工时" changeToBottomLine];
    //[self locationAndFactoryWithColor:Color(224, 224, 224) enabled:NO];

    _locationStyle = 1;
    
    return self;
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

- (NSString *)getListCode {
    NSString *figue = @"";
    for (UITextField *tf in @[_numberTFOne,_numberTFTwo,_numberTFThree,_numberTFFour,_numberTFFive,_numberTFSix]) {
        figue = [self getFigueStringWithBaseString:figue tf:tf];
    }
    return figue;
}

- (NSString *)getMaterialName {
    return [self getFigueStringWithBaseString:@"" tf:_materialNameTF];
}

- (NSString *)getmaterialCount {
    return _materialCountTF.text ;
}



- (void)saveData {
    //编辑
    self.tmpModel.schemewsphotocode = [self getFigueString];
    self.tmpModel.schemewscode = [self getListCode];
    self.tmpModel.schemewsname = [self getMaterialName];
    self.tmpModel.schemewscount = @([[self getmaterialCount] floatValue]);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self removeSelf];
    if (self.materialModel) {
        [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:self.tmpModel.wospwosid type:@2 source:@1 stockid:@[self.materialModel.parts_id]];
    }else {
        [self saveData];
        
        [self editWorkHourOrMaretialWithSchemews:self.tmpModel type:kMaterialType];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.listView removeFromSuperview];
    if ([textField isEqual:_LandRTF]) {
        WeakObject(self);
        self.listView = [HDWorkListTableViews showTableViewlistViewAroundView:textField superView:self.contentView direction:UIPopoverArrowDirectionDown dataSource:[@[@"L",@"R"] mutableCopy] size:CGSizeMake(CGRectGetWidth(textField.frame), 120) seletedNeedDelete:YES complete:^(NSNumber *idx, BOOL isneed, HDWorkListTableViewsStyle style) {
            textField.text = [idx integerValue] == 0 ? @"L":@"R";
            [selfWeak.numberTFOne becomeFirstResponder];
        }];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
#pragma mark  图号匹配
    if ([textField isEqual:_figueTFOne]) {
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
                [self matchMaterialOrderWithType:kMaterialImgPart condition:self.condition aroundView:_figueTFTwo idx:3];
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
        }
    }

#pragma mark  编号匹配
    if ([textField isEqual:_numberTFOne]) {
        
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
                    [_numberTFSix becomeFirstResponder];
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
        }
    }
    return YES;
}

//- (void)




- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _textfield = textField;
    if ([textField isEqual:_figueTFOne]) {
        
    }else if ([textField isEqual:_figueTFTwo]) {
   
    }
    else if ([textField isEqual:_figueTFThree]) {
    }
    
    else if ([textField isEqual:_LandRTF]) {
       
    }
    
    else if ([textField isEqual:_numberTFOne]) {
    }
    else if ([textField isEqual:_numberTFTwo]) {
    }
    else if ([textField isEqual:_numberTFThree]) {
    
    }
    else if ([textField isEqual:_numberTFFour]) {
       
    }
    else if ([textField isEqual:_numberTFFive]) {
        
        //材料名称
    }
    else if ([textField isEqual:_numberTFSix]) {

    }
    
    
    else if ([textField isEqual:_materialNameTF]) {
       
    }else if ([textField isEqual:_materialCountTF]) {
    }
    
    
    return YES;
}



- (IBAction)stepToManHourCubBtAction:(UIButton *)sender {
    [self removeSelf];
    //1.备件库     2.工时库     3.方案库
    [HDStatusChangeManager changeStatusLeft:HDLeftStatusStyleMaterialCub right:HDRightStatusStyleMaterialCub];
}

- (IBAction)cancelBtAction:(UIButton *)sender {
    [self removeSelf];
    
}


- (IBAction)saveBtAction:(UIButton *)sender {
    [self removeSelf];
    if (self.materialModel) {
        [self upDateProjectMaterialTestWithAddedType:kAddition schemeid:self.tmpModel.wospwosid type:@2 source:@1 stockid:@[self.materialModel.parts_id]];
    }else {
        [self saveData];
        
        [self editWorkHourOrMaretialWithSchemews:self.tmpModel type:kMaterialType];
    }
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

- (IBAction)cameraBt:(UIButton *)sender {
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
//
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

- (IBAction)repairBtAction:(UIButton *)sender {
    [self removeSelf];

}

- (void)showPhotoGallery {
    
//    PorschePhotoGallery *photoView = [PorschePhotoGallery viewWithCarVideo:nil carPics:[NSMutableArray arrayWithArray:@[]] schemePics:[NSMutableArray arrayWithArray:@[]] viewType:PorschePhotoGalleryPreviewAndShoot];
//    
//    [HD_FULLView addSubview:photoView];
}


- (void)cleanTF {
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


- (void)setTmpModel:(PorscheNewSchemews *)tmpModel {
    _tmpModel = tmpModel;
    [self setupCodeListTextWithString:_tmpModel.schemewscode];
    [self setupImgCode:_tmpModel.schemewsphotocode];
    self.materialNameTF.text = tmpModel.schemewsname;
    self.materialCountTF.text = tmpModel.schemewscount ? [NSString stringWithFormat:@"%@",tmpModel.schemewscount] : @"";
    /*
    if ([tmpModel.schemewstype integerValue] != 2) {
        _changeToITimeLb.textColor = Color(170, 170, 170);
        _changeToItemTimeBt.userInteractionEnabled = NO;
    }
     */
}

//编号
- (void)setupCodeListTextWithString:(NSString *)listCode {
    NSArray *codeArr = [listCode componentsSeparatedByString:@" "];
    switch (codeArr.count) {
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

- (void)setupImgCode:(NSString *)imgCode {
    NSArray *codeArr = [imgCode componentsSeparatedByString:@" "];
    switch (codeArr.count) {
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

#pragma mark  ------厂方按钮事件------
- (IBAction)factoryBtAction:(UIButton *)sender {
    
    [self locationAndFactoryWithColor:[UIColor whiteColor] enabled:YES];
    //[self locationAndFactoryWithColor:Color(224, 224, 224) enabled:NO];

    [self cleanTF];
    
    [_figueTFOne becomeFirstResponder];
    
    
    _bgImageView.image = [UIImage imageNamed:@"materialview_factory_pic_header.png"];
    _locationLb.textColor = Color(100, 100, 100);
    
    _factoryLb.textColor = [UIColor whiteColor];
    
    self.locationStyle = TechcianNumberLocationStyleFactory;
    
    _numberTFFive.keyboardType = UIKeyboardTypeDefault;
    _numberTFSix.hidden = YES;
}
#pragma mark  ------本地按钮事件------
- (IBAction)locationBtAction:(UIButton *)sender {

    

}
//切换至工时事件
- (IBAction)changeToItemCubBtAction:(UIButton *)sender {
    WeakObject(self);
    
    [selfWeak removeSelf];
    [TechcianItemTimeTFInputView showTechcianNumberTFInputViewModel:selfWeak.tmpModel withSupperVC:selfWeak.supperVC addedBlock:selfWeak.addedBlock];
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
    
    for (UITextField *tf in @[_figueTFOne,_figueTFTwo,_figueTFThree,_LandRTF,_numberTFOne,_numberTFTwo,_numberTFThree,_numberTFFour,_numberTFFive,_numberTFSix]) {
        if (tf.text.length) {
            isEdit = YES;
        }
    }
    
    return isEdit;
}


#pragma mark  工时图号编号匹配
//编号 目前采用 编号部分匹配
- (void)matchMaterialOrderWithType:(NSNumber *)type condition:(ProscheSchemewsSearchCondition *)condition aroundView:(UITextField *)view idx:(NSInteger)idex {
    
    WeakObject(self);
    WeakObject(view);
    condition.findtype = [NSString stringWithFormat:@"%@",@(self.locationStyle)];
    

    [PorscheRequestManager searchMaterialNumber:condition type:type  complete:^(NSMutableArray * _Nonnull list, PResponseModel * _Nonnull responser) {
        if (list.count) {
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
          selfWeak.listView = [HDWorkListTableViews showTableViewlistViewAroundView:viewWeak superView:selfWeak.contentView direction:UIPopoverArrowDirectionDown dataSource:array size:CGSizeMake(CGRectGetWidth(viewWeak.frame), 120) seletedNeedDelete:YES complete:^(NSNumber *idx, BOOL isshowArrow, HDWorkListTableViewsStyle style) {
                selfWeak.materialModel = selfWeak.schemewsArray[[idx integerValue]];
                viewWeak.text = array[[idx integerValue]];
                
            }];
        }else if (!list){
            NSLog(@"获取匹配信息失败");
        }else {
            NSLog(@"获取匹配数据为空!");
        }

    }];
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


//添加自定义备件
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


- (NSString *)getImgCode {
    NSString *endStr = [self getStrWithBaseStr:_figueTFOne.text Str:_figueTFTwo.text];
    endStr = [self getStrWithBaseStr:endStr Str:_figueTFThree.text];
    endStr = [self getStrWithBaseStr:endStr Str:_LandRTF.text];
    return endStr;
    
}

- (NSString *)getStrWithBaseStr:(NSString *)base Str:(NSString *)str {

    return  [base stringByAppendingString:[base isEqualToString:@""] ? @"" : [NSString stringWithFormat:@" %@",str]];
}



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
        tmp.addnum = @([_materialCountTF.text integerValue]);
        tmp.partsname = _materialNameTF.text;
        tmp.sparephotocode = [self getImgCode];
        
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
