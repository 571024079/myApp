//
//  HDLeftNoticeHeaderView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/11.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftNoticeHeaderView.h"

@interface HDLeftNoticeHeaderView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *nwTip;
@property (weak, nonatomic) IBOutlet UIView *increaseTip;
@property (weak, nonatomic) IBOutlet UIView *spareTip;
@property (weak, nonatomic) IBOutlet UIView *statusTip;


@end

@implementation HDLeftNoticeHeaderView

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
    [self setTipsCorner];
}

// 设置提示红点圆角
- (void)setTipsCorner
{
    [self setRoundCornerWithView:self.nwTip];
    [self setRoundCornerWithView:self.increaseTip];
    [self setRoundCornerWithView:self.spareTip];
    [self setRoundCornerWithView:self.statusTip];

}

- (void)tipsDisplayStatusWithModel:(RemindModel *)model
{
/*
 @interface RemindModel : NSObject
 
 @property (nonatomic, strong) NSNumber *allnum;//所有消息数量；
 @property (nonatomic, strong) NSNumber *increasenum;//增项通知数量
 @property (nonatomic, strong) NSNumber *newtasknum;//新任务数量
 @property (nonatomic, strong) NSNumber *partsnum;//所有消息数量；
 @property (nonatomic, strong) NSNumber *statenum;//状态变化数量
 
 @end
 */
    self.nwTip.hidden = ![model.newtasknum integerValue];
    self.increaseTip.hidden = ![model.increasenum integerValue];
    self.spareTip.hidden = ![model.partsnum integerValue];
    self.statusTip.hidden = ![model.statenum integerValue];

}

- (void)setRoundCornerWithView:(UIView *)view
{
    CGFloat radius = view.bounds.size.width / 2;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

#pragma mark  ------初始化------
- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    self = array.firstObject;
    
    self.frame = frame;
    
    //按钮背部边框
    NSArray *viewArray = @[_bgView1,_bgView2,_bgView3,_bgView4];
    for (UIView *view in viewArray) {
        [self setupBgView:view];
    }
    //暂时默认新任务被点击状态
    [self setupAllBt];
    [self specialBtAndimageViewAction:_resentWorkBt];
    
    return self;
    
}
- (IBAction)clearButtonAction:(id)sender {
    self.vinSearchTF.text = @"";
    self.timeSearchTF.text = @"";
    
    [self buttonAction:self.cleanBt];
}

//tag:1.新任务  2.增项通知  3.备件通知  4.状态更新  5.事件筛选  6. 清空
- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag < 5) {
        [self setupAllBt];
        [self specialBtAndimageViewAction:sender];
    }
//    else if (sender.tag == 6) {
//        _vinSearchTF.text = nil;
//        _timeSearchTF.text = nil;
//    }else if (sender.tag == 5) {
//    }
    if (self.hDLeftNoticeHeaderViewBlock) {
        self.hDLeftNoticeHeaderViewBlock(sender);
        
    }
}


- (void)setButtonStatus:(NSInteger)status
{
    UIButton *button = nil;
    
    button = [self getButtonWithStatus:status];
    
    [self setupAllBt];
    
    [self specialBtAndimageViewAction:button];
}

- (UIButton *)getButtonWithStatus:(NSInteger)status
{
    UIButton *button = nil;
    
    switch (status)
    {
        case 1:
            button = _resentWorkBt;
            break;
        case 2:
            button = _additionNoticeBt;
            break;
        case 3:
            button = _materialBt;
            break;
        case 4:
            button = _upStatusBt;
            break;
        default:
            break;
    }
    return button;
}


//统一设置按钮默认
- (void)setupAllBt {
    for (UIButton *bt in self.btArray) {
        
        [self setupBt:bt];
    }
}

- (void)setupBt:(UIButton *)sender {
    NSArray *array = @[@"新任务",@"增项通知",@"备件通知",@"状态更新"];
    [sender setTitle:array[sender.tag - 1] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//按钮背部灰色边缘和圆弧
- (void)setupBgView:(UIView *)sender {
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 3;
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

//特殊按钮
- (void)specialBtAndimageViewAction:(UIButton *)sender {
    
    //所有按钮 逻辑，新任务状态下，在次点击，取消显示点击状态
    UIImageView *img = self.bgArray[sender.tag - 1];

    // 12-01新需求，默认选中的是新任务，且选中按钮不能对其取消
//    if (img.image) {//
//        for (UIImageView *img in self.bgArray) {
//            [self setupDefaultImg:img];
//        }
//        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//    }else {
        for (UIImageView *img in self.bgArray) {
            [self setupDefaultImg:img];
        }
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        img.image = [UIImage imageNamed:@"hd_work_list_clean.png"];
//    }
    
    
    
}
//默认图片
- (void)setupDefaultImg:(UIImageView *)img {
    img.image = nil;
}


#pragma mark  ------textField代理------


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    [textField resignFirstResponder];
    
    if (textField == _vinSearchTF)
    {
        [self buttonAction:_cleanBt];
    }
    
    return YES;
}

- (NSMutableArray *)btArray {
    if (!_btArray) {
        _btArray  = [NSMutableArray arrayWithObjects:_resentWorkBt,_additionNoticeBt,_materialBt,_upStatusBt, nil];
    }
    return _btArray;
}

- (NSMutableArray *)bgArray {
    if (!_bgArray) {
        _bgArray = [NSMutableArray arrayWithObjects:_resentWorkImg,_additionNoticeImg,_materialImg,_upStatusImg, nil];
    }
    return _bgArray;
}








@end
