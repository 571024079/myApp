//
//  HDWorkListTVHFViewOneNormal.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListTVHFViewOneNormal.h"
#import "HDLeftSingleton.h"
@interface HDWorkListTVHFViewOneNormal ()<UITextFieldDelegate>

@property (nonatomic, strong) NSArray *customImgArray;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@end

@implementation HDWorkListTVHFViewOneNormal

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    _itemNameTF.delegate = self;
    _materialPriceTF.delegate = self;
    _itemPriceTF.delegate = self;
    _itemTotalPriceTF.delegate = self;
    
    _sureHeaderLbSpview.layer.masksToBounds = YES;
    _sureHeaderLbSpview.layer.cornerRadius = 2;
    _allBt.layer.masksToBounds = YES;
    _allBt.layer.cornerRadius = 8;
    _itemNameTF.attributedPlaceholder = [@"*请填写方案名称" setTFplaceHolderWithMainGrayWithColor:MAIN_RED];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        
    [self addGestureRecognizer:longPress];
}

- (void)longPressAction:(UIGestureRecognizer *)longPress {

    if ([_saveStatus integerValue] == 1) {
        return;
    }
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
    }
}

#pragma mark  工单保存/编辑状态下，边框的显示/隐藏
//保存/编辑状态下 小计赋值
- (void)setTotalPriceLbShowWithSavestatus:(BOOL)issave totalPrice:(NSNumber *)price{
    if (issave) {
        _itemTotalPriceTF.text = [NSString formatMoneyStringWithFloat:[price floatValue]] ;
    }else {
        _itemTotalPriceTF.attributedText = [[NSString formatMoneyStringWithFloat:[price floatValue]] changeToBottomLine];
    }
}
//UI
- (void)setupUIWithsaveStatus:(NSNumber *)issave {
    [self setupButtonWithsaveStatus:issave];
}

//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    _guaranteebt.hidden = [saveStatus integerValue];
    _deleteBt.hidden = [saveStatus integerValue];
    _deleteSuperBt.hidden = [saveStatus integerValue];
    _itemNameBackImg.hidden = [saveStatus integerValue];
    _chooseBt.hidden = [saveStatus integerValue];
    _chooseBgView.backgroundColor = [saveStatus integerValue] == 1 ? Color(255, 255, 255) : Color(170, 170, 170);
    [self setMarkImageViewShouldShow:![saveStatus integerValue]];
}


- (instancetype)initWithCustomFrame:(CGRect)frame {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListTVHFViewOne" owner:nil options:nil];
    self = [array objectAtIndex:0];
    [self layoutIfNeeded];
    self.frame = frame;
    _itemNameTF.delegate = self;
    _materialPriceTF.delegate = self;
    _itemPriceTF.delegate = self;
    _itemTotalPriceTF.delegate = self;
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return self;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

//完成----收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_itemNameTF]) {
        if (self.editBlock) {
            self.editBlock(_itemNameTF.text);
        }
    }
    
}

- (void)setupChooseImage {
    if ([_tmpModel.wosisconfirm integerValue] == 0) {
        _chooseImg.image = nil;
    }else {
        _chooseImg.image = [UIImage imageNamed:@"work_list_29.png"];
    }
}

- (void)isConformWithStatus:(BOOL)ret
{
    if (ret)
    {
        self.chooseImg.image = [UIImage imageNamed:@"work_list_29.png"];
    }
    else
    {
        self.chooseImg.image = nil;
    }
}

- (IBAction)chooseBtAction:(UIButton *)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    
    if (self.chooseBtBlock) {
        self.chooseBtBlock(sender);
    }
}

- (IBAction)deleteBtAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedView:ofButton:model:)]) {
        
        [self.delegate didSelectedView:self ofButton:sender model:self.tmpModel];
    }
}


- (void)setTmpModel:(PorscheNewScheme *)tmpModel {
    _tmpModel = tmpModel;
    _itemNameTF.text = _tmpModel.schemename;
    
    [self setupHeaderImageView];
    
    [self setHeaderHidden];
    
    [self setdefaultSureImage];
    [self setupChooseImage];
    //保寸，编辑下，按钮交互，显示
    [AlertViewHelpers setupCellTFView:_itemNameTF save: [_saveStatus integerValue]];
    [self setupUIWithsaveStatus:_saveStatus];
    [self setupTF];
    [self setupGuarantee];
    
    

}

- (void)setupTF {
    if ([_tmpModel.wossettlement isEqualToNumber:@3]) {//自费
        if ([HDLeftSingleton shareSingleton].stepStatus != 4) {//原价(技师和备件)
            //工时小计
            _itemPriceTF.text = _tmpModel.workhouroriginalpriceforscheme1? [NSString formatMoneyStringWithFloat:[_tmpModel.workhouroriginalpriceforscheme1 floatValue]] : @"------";
            //备件小计
            _materialPriceTF.text = _tmpModel.partsoriginalpriceforscheme1? [ NSString formatMoneyStringWithFloat:[_tmpModel.partsoriginalpriceforscheme1 floatValue]]: @"-----";
            //方案小计
            if (_tmpModel.solutiontotaloriginalpriceforscheme1) {
                
                [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:_tmpModel.solutiontotaloriginalpriceforscheme1];
            }else {
                _itemTotalPriceTF.text = @"-----";
            }
        }else {//折扣价(服务顾问)
            //工时小计
            _itemPriceTF.text = _tmpModel.workhourpriceforscheme? [NSString formatMoneyStringWithFloat:[_tmpModel.workhourpriceforscheme floatValue]] : @"------";
            //备件小计
            _materialPriceTF.text = _tmpModel.partspriceforscheme? [ NSString formatMoneyStringWithFloat:[_tmpModel.partspriceforscheme floatValue]]: @"-----";
            //方案小计
            //方案小计
            if (_tmpModel.solutiontotalpriceforscheme) {
                
                [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:_tmpModel.solutiontotalpriceforscheme];
            }else {
                _itemTotalPriceTF.text = @"-----";
            }
            
        }
    }else {
        //工时小计
        _itemPriceTF.text = [NSString formatMoneyStringWithFloat:0.00];
        //备件小计
        _materialPriceTF.text = [ NSString formatMoneyStringWithFloat:0.00];
        //方案小计
        [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:@0.00];
    }
}

- (void)setupGuarantee {
    //保修
    switch ([_tmpModel.wossettlement integerValue]) {
            //内结
        case 1:
        {
            _guaranteeImg.image = [UIImage imageNamed:@"billing_pay_inside.png"];
        }
            break;
            //b保修
        case 2:
        {   //1 未审核的保   2  已审核的保
            if ([_tmpModel.wosisguarantee isEqualToNumber:@2]) {
                UIImage *image = [UIImage imageNamed:@"fullLeftListForRight_insureBule"];
//                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                _guaranteeImg.tintColor = MAIN_BLUE;
                _guaranteeImg.image = image;
                
            }else {
                
                _guaranteeImg.image = [UIImage imageNamed:@"billing_guarantee.png"];
            }
            
        }
            break;
        case 3:
        {
            _guaranteeImg.image = [UIImage imageNamed:@""];
            
        }
            break;
            
        default:
            break;
            
    }
}

- (void)setupHeaderImageView {
    //设置项目的分类图标 1.安全2.隐患3.信息4.自定义
    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"work_list_scheme_level_%@.png",_tmpModel.schemelevelid]];

}


- (IBAction)guaranteeBtAction:(UIButton *)sender {
    if (self.guaranteeViewblock) {
        self.guaranteeViewblock(sender);
    }
}



#pragma mark  ------客户确认之后  区头显示------


- (IBAction)upAndDownBtAction:(UIButton *)sender {
    
    [self setSureImageBtImage];
    
    if (self.shadowBlock) {
        self.shadowBlock(sender,_tmpModel);
    }
}

- (IBAction)updateSchemeLevelid:(UIButton *)sender {
    if (self.updateLevelBlock) {
        self.updateLevelBlock(sender);
    }
}


//设置 带有确认 区头的显示和隐藏
- (void)setHeaderHidden {
    _sureHeaderSuperView.hidden = YES;
    _allBt.hidden = NO;
    
    //方案被客户确认
    if ([_tmpModel.wosisconfirm integerValue] == 2) {
        if ([_tmpModel.isshow integerValue] == 1) {
            _allBt.hidden = NO;
            
            _sureHeaderSuperView.hidden = NO;
            _sureHeaderLb.text = @"客户已确认";
            [self setLineColor:MAIN_BLUE];
        }
    }else {
        _allBt.hidden = YES;
        if ([_tmpModel.isshow integerValue] == 1) {
            _sureHeaderSuperView.hidden = NO;
            
            if ([_tmpModel.schemeaddstatus integerValue] == 2) {
                _sureHeaderLb.text = @"技师增项";
                [self setLineColor:MAIN_RED];
            }else {
                _sureHeaderLb.text = @"服务增项";
                [self setLineColor:MAIN_RED];
            }
        }
    }
    _allBt.hidden = YES;
}


//设置提示条颜色

- (void)setLineColor:(UIColor *)backgroundColor {
    _sureHeaderLbSpview.backgroundColor = backgroundColor;
    _sureHeaderLineView.backgroundColor = backgroundColor;
    _allBt.backgroundColor = backgroundColor;
}





//客户确认时，点击下拉 切换图片
- (void)setSureImageBtImage {
    if ([_tmpModel.shadowStatus isEqual:@1]) {//处于显示状态
        [_sureImageBt setImage:[UIImage imageNamed:@"hd_item_up_arrow.png"] forState:UIControlStateNormal];
        _tmpModel.shadowStatus = @0;
    }else {
        [_sureImageBt setImage:[UIImage imageNamed:@"hd_item_down_arrow.png"] forState:UIControlStateNormal];
        _tmpModel.shadowStatus = @1;
        
    }
}
//设置默认 图片
- (void)setdefaultSureImage {
    if ([_tmpModel.shadowStatus isEqual:@1]) {//处于显示状态
        [_sureImageBt setImage:[UIImage imageNamed:@"hd_item_down_arrow.png"] forState:UIControlStateNormal];
    }else {
        [_sureImageBt setImage:[UIImage imageNamed:@"hd_item_up_arrow.png"] forState:UIControlStateNormal];
        
    }
}

// 保修审批显示
- (void)guranteeShenPiStatus
{
    [self setTotalPriceLbShowWithSavestatus:NO totalPrice:_tmpModel.solutiontotaloriginalpriceforscheme1];
    self.guaranteebt.hidden = NO;
}

- (void)setMarkImageViewShouldShow:(BOOL)isShould
{
    if (isShould && [_tmpModel.isnew integerValue] && ![HDLeftSingleton isUserAdded:_tmpModel.schemeaddperson])
    {
        self.markImageView.hidden = NO;
    }
    else
    {
        self.markImageView.hidden = YES;
    }
}
@end
