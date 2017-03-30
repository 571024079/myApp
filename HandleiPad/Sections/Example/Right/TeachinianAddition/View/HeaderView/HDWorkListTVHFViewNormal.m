//
//  HDWorkListTVHFViewNormal.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/8.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListTVHFViewNormal.h"
#import "HDLeftSingleton.h"

@interface HDWorkListTVHFViewNormal ()
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@end

@implementation HDWorkListTVHFViewNormal

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _sureHeaderLbSpview.layer.masksToBounds = YES;
    _sureHeaderLbSpview.layer.cornerRadius = 2;
    _allBt.layer.masksToBounds = YES;
    _allBt.layer.cornerRadius = 8;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    
    [self addGestureRecognizer:longPress];
    
    _isGuarantee = NO;

}

#pragma mark  工单保存/编辑状态下，边框的显示/隐藏
//保存/编辑状态下 小计赋值
- (void)setTotalPriceLbShowWithSavestatus:(BOOL)issave totalPrice:(NSNumber *)price{
    if (issave) {
        _itemPrice.text = [NSString formatMoneyStringWithFloat:[price floatValue]] ;
    }else {
        _itemPrice.attributedText = [[NSString formatMoneyStringWithFloat:[price floatValue]] changeToBottomLine];
    }
}
//UI
//功能按钮的隐藏 hd_project_delete_new_cell.png//work_list_29
- (void)setupButtonWithsaveStatus:(NSNumber *)saveStatus {
    _guatanteeBt.hidden = [saveStatus integerValue];
    _deleteBt.hidden = [saveStatus integerValue];
    _deleteSuperBt.hidden = [saveStatus integerValue];
    _chooseSuperView.backgroundColor = [saveStatus integerValue] == 1 ? Color(255, 255, 255) : Color(170, 170, 170);
    [self setMarkImageViewShouldShow:![saveStatus integerValue]];
}


- (void)setMarkImageViewShouldShow:(BOOL)isShould
{
    if ([_tmpModel.isnew integerValue])
    {
        self.markImageView.hidden = NO;
    }
    else
    {
        self.markImageView.hidden = YES;
    }
}

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListTVHFViewNormal" owner:nil options:nil];
    
    self = [array objectAtIndex:0];

    self.frame = frame;
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return self;
    
}

- (void)longPressAction:(UIGestureRecognizer *)longPress {
    
    if ([_saveStatus integerValue] == 1 && _isMaterial == NO) {
        return;
    }
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
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

- (IBAction)updateSchemeLevel:(UIButton *)sender {
    if (self.updateLevelBlock) {
        self.updateLevelBlock(sender);
    }
}

- (IBAction)deleteBtAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedView:ofBt:model:)]) {
        [self.delegate didSelectedView:self ofBt:_deleteBt model:self.tmpModel];
    }
    
}

- (IBAction)confirmAction:(id)sender {
    if ([_saveStatus integerValue] == 1) {
        return;
    }
    if (self.confirmActionBlock) {
        self.confirmActionBlock(sender);
    }
}

/*
 //工时价格
 @property (weak, nonatomic) IBOutlet UILabel *workTimePriceLb;
 //备件小计价格
 @property (weak, nonatomic) IBOutlet UILabel *sparePartPrice;
 
 //方案小计价格
 @property (weak, nonatomic) IBOutlet UILabel *itemPrice;
 */


- (void)setTmpModel:(PorscheNewScheme *)tmpModel {
    
    _tmpModel = tmpModel;
    _isMaterial = NO;
    [self setupHeaderImageView];
    
    [self setHeaderHidden];
    
    [self setdefaultSureImage];
    //保存/编辑
    [self setupButtonWithsaveStatus:_saveStatus];
    
    [self setupText];
    [self setupGuarantee];

    [self setupChooseImage];
}

- (void)setupChooseImage {
    
    [self isConformWithStatus:[_tmpModel.wosisconfirm integerValue] == 0  ? NO : YES];
}

- (void)setupText {
    _headerLb.text = _tmpModel.schemename;
    [self setupTF];
}

- (void)setupTF {
    
    if ([_tmpModel.wossettlement isEqualToNumber:@3]) {//自费
        if ([HDLeftSingleton shareSingleton].stepStatus != 4) {//原价(技师和备件)
            //工时小计
            _workTimePriceLb.text = _tmpModel.workhouroriginalpriceforscheme1? [NSString formatMoneyStringWithFloat:[_tmpModel.workhouroriginalpriceforscheme1 floatValue]] : @"------";
            //备件小计
            _sparePartPrice.text = _tmpModel.partsoriginalpriceforscheme1? [ NSString formatMoneyStringWithFloat:[_tmpModel.partsoriginalpriceforscheme1 floatValue]]: @"-----";
            
            //方案小计
            [self setupTotalPrice:_tmpModel.solutiontotaloriginalpriceforscheme1];
        }else {//折扣价(服务顾问)
            //工时小计
            _workTimePriceLb.text = _tmpModel.workhourpriceforscheme? [NSString formatMoneyStringWithFloat:[_tmpModel.workhourpriceforscheme floatValue]] : @"------";
            //备件小计
            _sparePartPrice.text = _tmpModel.partspriceforscheme? [ NSString formatMoneyStringWithFloat:[_tmpModel.partspriceforscheme floatValue]]: @"-----";
            //方案小计
            [self setupTotalPrice:_tmpModel.solutiontotalpriceforscheme];
            
        }
    }else {
        //工时小计
        _workTimePriceLb.text = [NSString formatMoneyStringWithFloat:0.00];
        //备件小计
        _sparePartPrice.text = [ NSString formatMoneyStringWithFloat:0.00];
        
        //方案小计
        [self setupTotalPrice:@0.00];
    }
    
}

- (void)setupTotalPrice:(NSNumber *)price {
    //方案保修
    if (_isGuarantee) {
        if (price) {
            
            [self setTotalPriceLbShowWithSavestatus:[_saveStatus integerValue] totalPrice:price];
        }else {
            _itemPrice.text = @"------";
        }
    }else {
        _itemPrice.text = price ? [NSString formatMoneyStringWithFloat:[price floatValue]] : @"------";
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
        {
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

- (void)setBtActionStatusWithSaveStatus:(BOOL)issave {
    _guatanteeBt.hidden = issave;
    _deleteBt.hidden = issave;
    [self setMarkImageViewShouldShow:!issave];
}

- (void)setTotalPriceShowWithSaveStatus:(BOOL)issave {
    
}

- (void)setupHeaderImageView {
    //设置项目的分类图标 1.安全2.隐患3.信息4.自定义
    _headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"work_list_scheme_level_%@.png",_tmpModel.schemelevelid]];
}

- (IBAction)guaranteeBtAction:(UIButton *)sender {
    if (self.guaranteeblock) {
        self.guaranteeblock(sender,_tmpModel);
    }
}
- (IBAction)upAndDownBtAction:(UIButton *)sender {
    
    [self setSureImageBtImage];
    
    if (self.shadowBlock) {
        self.shadowBlock(sender,_tmpModel);
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
    self.guatanteeBt.hidden = NO;
}
@end
