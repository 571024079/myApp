//
//  BlillingMessageBottomView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "BlillingMessageBottomView.h"
#import "HDLeftSingleton.h"

@interface BlillingMessageBottomView()
{
    BOOL _isEdit;
}
@end

@implementation BlillingMessageBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BlillingMessageBottomView" owner:nil options:nil];
    
    self = [array objectAtIndex:0];
    self.frame = frame;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    [AlertViewHelpers setupCellTFView:_nameTF save:NO];
    [AlertViewHelpers setupCellTFView:_positionTF save:NO];
    
    return self;
}

- (IBAction)creatBtAction:(UIButton *)sender {
    if (self.blillingMessageBottomViewBlock) {
        self.blillingMessageBottomViewBlock(BlillingMessageBottomViewStyleCreate,sender);
    }
}

- (IBAction)deleteBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    if (self.blillingMessageBottomViewBlock) {
        self.blillingMessageBottomViewBlock(BlillingMessageBottomViewStyleDelete,sender);
    }
}

- (IBAction)editingBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1 && ![HDStoreInfoManager shareManager].carorderid) {
        return;
    }
    
    if (self.blillingMessageBottomViewBlock) {
        self.blillingMessageBottomViewBlock(BlillingMessageBottomViewStyleEdit,sender);
    }
}

- (IBAction)saveBtAction:(UIButton *)sender {
    if (self.blillingMessageBottomViewBlock) {
        self.blillingMessageBottomViewBlock(BlillingMessageBottomViewStyleSave,sender);
    }
}

- (IBAction)BillingSureBtAction:(UIButton *)sender {
    if (self.blillingMessageBottomViewBlock) {
        self.blillingMessageBottomViewBlock(BlillingMessageBottomViewStyleBillingSure,sender);
    }
}

//设置 yes:编辑  no:保存
- (void)setBottomViewEditAction:(BOOL)isEdit {
    
    _isEdit = isEdit;
    
    if (!isEdit) {
        [_editTextBt setTitle:@"编辑" forState:UIControlStateNormal];
        [_editImageBt setImage:[UIImage imageNamed:@"Billing_right_bottom_edit.png"] forState:UIControlStateNormal];
    }else {
        [_editTextBt setTitle:@"保存" forState:UIControlStateNormal];
        [_editImageBt setImage:[UIImage imageNamed:@"Billing_right_bottom_save.png"] forState:UIControlStateNormal];
    }
    
    [self setupBottomViewHidden:!isEdit];
}



- (void)setupBottomViewHidden:(BOOL)isHidden {
    _saveStatus = isHidden ? @1: @0;
    [self setupTfWithBool:isHidden];
    [self setupImageHidden:isHidden];
    [self setupBillingSureisHidden:isHidden];
    [self setupDeleteBtWithHidden:isHidden];
    [self setupSaveBtHidden:isHidden];
    // 补丁
    if (_isEdit)
    {
        [self setupEditBtWithIsEditing:!isHidden];
    }
}



//Billing_right_bottom_delete.png
- (void)setupDeleteBtWithHidden:(BOOL)isHidden {
    UIImage *image = [UIImage imageNamed:@"Billing_right_bottom_delete.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (!_isEdit)
    {
        [_deleteImgBt.imageView setTintColor:MAIN_PLACEHOLDER_GRAY];
        [_deleteTextBt setTitleColor:MAIN_PLACEHOLDER_GRAY forState:UIControlStateNormal];
        _deleteBt.enabled = NO;
        [_deleteImgBt setImage:image forState:UIControlStateNormal];
        return;
    }
    
    if (self.carMessage.ccarplate.length && self.carMessage.plateplace.length) {
        [_deleteImgBt.imageView setTintColor:MAIN_BLUE];
        [_deleteTextBt setTitleColor:MAIN_BLUE forState:UIControlStateNormal];
        _deleteBt.enabled = YES;

    }else {
        [_deleteImgBt.imageView setTintColor:MAIN_PLACEHOLDER_GRAY];
        [_deleteTextBt setTitleColor:MAIN_PLACEHOLDER_GRAY forState:UIControlStateNormal];
        _deleteBt.enabled = NO;
    }
    [_deleteImgBt setImage:image forState:UIControlStateNormal];
}

- (void)setupEditBtWithIsEditing:(BOOL)isEditing
{
    UIImage *image = [UIImage imageNamed:@"Billing_right_bottom_save.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if (!_isEdit) {
        
        return;
    }
    else
    {
        if (self.carMessage.ccarplate.length && self.carMessage.plateplace.length) {
            [_editImageBt setTintColor:MAIN_BLUE];
            [_editTextBt setTitleColor:MAIN_BLUE forState:UIControlStateNormal];
            _editingBt.enabled = YES;
            
        }else {
            [_editImageBt setTintColor:MAIN_PLACEHOLDER_GRAY];
            [_editTextBt setTitleColor:MAIN_PLACEHOLDER_GRAY forState:UIControlStateNormal];
            _editingBt.enabled = NO;
        }
    }

    [_editImageBt setImage:image forState:UIControlStateNormal];
}

- (void)setupSaveBtHidden:(BOOL)isHidden {
    UIImage *image = [UIImage imageNamed:@"Billing_right_bottom_edit.png"];
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    
    if ([HDStoreInfoManager shareManager].carorderid) {
        [_editImageBt setTintColor:MAIN_BLUE];
        [_editTextBt setTitleColor:MAIN_BLUE forState:UIControlStateNormal];
        
    }else {
        [_editImageBt setTintColor:MAIN_PLACEHOLDER_GRAY];
        [_editTextBt setTitleColor:MAIN_PLACEHOLDER_GRAY forState:UIControlStateNormal];
//        _editImageBt.imageView.tintColor = MAIN_PLACEHOLDER_GRAY;
        [_editImageBt setImage:image forState:UIControlStateNormal];
        
    }
    if (isHidden) {
        [_editImageBt setImage:image forState:UIControlStateNormal];
    }
    
}

- (void)setupBillingSureisHidden:(BOOL)isHidden {
    [_billingSure setBackgroundImage:isHidden ? [UIImage imageNamed:@"gray_backGroundImage.png"] : [UIImage imageNamed:@"sure_bg_blue.png"] forState:UIControlStateNormal];
    _billingSure.userInteractionEnabled = !isHidden;
//#pragma mark  已开单的不可以再次开单
//    if (!isHidden) {
//        [self configSureWithCarMessage:_carMessage];
//    }
}

- (void)configSureWithCarMessage:(PorscheNewCarMessage *)carMessage {
    if ([_saveStatus integerValue] == 0) {
        if (carMessage) {
            if (![carMessage.orderstatus isShowBillingLighting]) {
                [_billingSure setBackgroundImage:[UIImage imageNamed:@"gray_backGroundImage.png"] forState:UIControlStateNormal];
                _billingSure.userInteractionEnabled = NO;
            }else {
                [_billingSure setBackgroundImage:[UIImage imageNamed:@"sure_bg_blue.png"] forState:UIControlStateNormal];
                _billingSure.userInteractionEnabled = YES;
            }
        }
    }
    
}

- (void)setBillButtonEnabel:(BOOL)isEnable
{
    if (isEnable) {
        [_billingSure setBackgroundImage:[UIImage imageNamed:@"sure_bg_blue.png"] forState:UIControlStateNormal];
        _billingSure.userInteractionEnabled = YES;
    }else {
        [_billingSure setBackgroundImage:[UIImage imageNamed:@"gray_backGroundImage.png"] forState:UIControlStateNormal];
        _billingSure.userInteractionEnabled = NO;
    }

}

- (void)setupImageHidden:(BOOL)isHidden {
    _pullBtNameImg.hidden = isHidden;
    _pullBtTechImg.hidden = isHidden;
}

- (void)setupTfWithBool:(BOOL)ishidden {
    [AlertViewHelpers setupCellTFView:_positionTF save:ishidden];
    [AlertViewHelpers setupCellTFView:_nameTF save:ishidden];
    _positionTF.textAlignment = ishidden ? NSTextAlignmentRight : NSTextAlignmentLeft;
}



#pragma mark  底部技师 或者服务顾问相关，需要后台理参数 然后给值，并且刷新界面
- (void)addObjectToDic:(NSMutableDictionary *)dic {
    [dic hs_setSafeEmptyValue:@4 forKey:@"serviceadvisorid"];//服务顾问
    [dic hs_setSafeEmptyValue:@3 forKey:@"wopartsmanid"];//备件员
    [dic hs_setSafeEmptyValue:@2 forKey:@"technicianid"];//技师
}

//名字选择
- (IBAction)selectedTechicianBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    if (self.blillingMessageBottomViewBlock) {
        self.blillingMessageBottomViewBlock(BlillingMessageBottomViewStyleTechicain,sender);
    }
}

- (IBAction)seletedPositionBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    //职位选择
    if (self.blillingMessageBottomViewBlock) {
        self.blillingMessageBottomViewBlock(BlillingMessageBottomViewStylePosition,sender);
    }
}

- (void)setCarMessage:(PorscheNewCarMessage *)carMessage {
    _carMessage = carMessage;

    if (![HDStoreInfoManager shareManager].carorderid) {
        return;
    }
    self.positionTF.text = @"";
    self.nameTF.text = @"";

    //刚开单  默认显示人员职位
    NSInteger positionid = [[HDStoreInfoManager shareManager].positionid integerValue];
    NSString *nickName = [HDStoreInfoManager shareManager].nickname;
    switch (positionid) {
        case 1:
            self.positionTF.text = @"技师";
            self.nameTF.text = nickName;
            break;
        case 3:
            self.positionTF.text = @"服务顾问";
            self.nameTF.text = nickName;
            break;
        default:
            break;
    }
    
    _techicianNameLb.text = nickName;
    
    [HDLeftSingleton shareSingleton].selectedPosid = @1;
    if ([carMessage.technicianid integerValue] != 0) {
        self.positionTF.text = @"技师";
        self.nameTF.text = carMessage.technicianname;
        //[HDLeftSingleton shareSingleton].selectedPosid = carMessage.technicianid;
    }else {
        if ([carMessage.serviceadvisorid integerValue] != 0) {
            self.positionTF.text = @"服务顾问";
            self.nameTF.text = carMessage.serviceadvisorname;
            [HDLeftSingleton shareSingleton].selectedPosid = @3;
        }
    }
    
}

- (void)setViewContentData:(PorscheNewCarMessage *)carMessage
{
    [self setViewContentWithData:carMessage isNew:NO];
}


/**
 新建设置页面数据

 @param carMessage 页面数据
 @param isnew 是否 新建
 */
- (void)setViewContentWithData:(PorscheNewCarMessage *)carMessage isNew:(BOOL)isnew
{
    if (![HDStoreInfoManager shareManager].carorderid) {
        return;
    }
    _carMessage = carMessage;
    _techicianNameLb.text = carMessage.createusername;
    self.positionTF.text = @"";
    self.nameTF.text = @"";
    
    //刚开单  默认显示人员职位
    NSInteger positionid = [[HDStoreInfoManager shareManager].positionid integerValue];
    NSString *nickName = [HDStoreInfoManager shareManager].nickname;
    
    [HDLeftSingleton shareSingleton].selectedPosid = @1;
    if ([carMessage.lastselectposition integerValue] == 1) {
        self.positionTF.text = @"技师";
        self.nameTF.text = carMessage.technicianname;
    }else {
        if ([carMessage.lastselectposition integerValue] == 2) {
            self.positionTF.text = @"服务顾问";
            self.nameTF.text = carMessage.serviceadvisorname;
            [HDLeftSingleton shareSingleton].selectedPosid = @3;
        }
    }
    

    
    //开单后 开单不可再次点击
    [self configSureWithCarMessage:carMessage];
    
    [self setupDeleteBtWithHidden:NO];

    [self setupEditBtWithIsEditing:_isEdit];
    if (isnew){
        if(positionid == 1 || positionid == 3){
            if ([carMessage.lastselectposition integerValue] == 1 || [carMessage.lastselectposition integerValue] == 2)
            {
                self.nameTF.text = nickName;
            }
        }
    }

}

- (void)setCancelButtonEnable:(BOOL)isEnable
{

    self.deleteBt.enabled = isEnable;
    self.deleteImgBt.enabled = isEnable;
    self.deleteTextBt.enabled = isEnable;
    [self setupDeleteBtWithHidden:isEnable];
}

- (void)selectViewContentData:(PorscheNewCarMessage *)carMessage
{
    if (![HDStoreInfoManager shareManager].carorderid) {
        return;
    }
    
    NSInteger positionid = [[HDLeftSingleton shareSingleton].selectedPosid integerValue];
    
    switch (positionid)
    {
        case 1:
            self.positionTF.text = @"技师";
            self.nameTF.text = carMessage.technicianname;
            break;
        case 3:
            self.positionTF.text = @"服务顾问";
            self.nameTF.text = carMessage.serviceadvisorname;
            break;
        default:
            break;
    }

}

@end
