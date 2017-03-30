//
//  PorschePrintAffirmView.m
//  HandleiPad
//
//  Created by Robin on 16/11/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorschePrintAffirmView.h"



@interface PorschePrintAffirmView ()
@property (weak, nonatomic) IBOutlet UIView *chooseCountView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *selfPayButton;
@property (weak, nonatomic) IBOutlet UIButton *upKeepButton;
@property (weak, nonatomic) IBOutlet UIButton *innerButton;


@property (weak, nonatomic) IBOutlet UIButton *subtractButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, assign) PorschePrintAffirmViewPrintType type;
@property (nonatomic, assign) NSInteger printCount;

@property (nonatomic, copy) PorschePrintAffirmViewBlock backBlock;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *Buttons;
@property (nonatomic, strong) NSArray *constants;


@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *printCountTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *printChooseCountView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraints;

@end

@implementation PorschePrintAffirmView {
    
    UIButton *_selectedButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)showPrinAffirmViewAndComplete:(PorschePrintAffirmViewBlock)complete
{
    return [PorschePrintAffirmView showPrinAffirmViewType:PorschePrintAffirmViewPrint complete:complete];
}


+ (instancetype)showPrinAffirmViewType:(PorschePrintAffirmViewType)viewType complete:(PorschePrintAffirmViewBlock)complete
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PorschePrintAffirmView" owner:nil options:nil];
    PorschePrintAffirmView *printAffirm = [array objectAtIndex:0];
    
    printAffirm.frame = KEY_WINDOW.bounds;
    printAffirm.printCount = 2;
    printAffirm.countLabel.text = @"2";
    printAffirm.backBlock = complete;
    printAffirm.constants = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataPayWay];
    
    if (viewType == PorschePrintAffirmViewShare)
    {
//        printAffirm.printChooseCountView.hidden = YES;
//        printAffirm.printCountTitleLabel.hidden = YES;
        printAffirm.titleLabel.text = @"分享";
        printAffirm.subTitleLabel.text = @"分享分类:";
//        printAffirm.contentHeightConstraints.constant -= 50;
    }
    
    return printAffirm;
}

- (void)setConstants:(NSArray *)constants
{
    _constants = constants;
    PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
    model.cvsubid = @0;
    model.cvvaluedesc = @"全部";
    
    NSMutableArray *payWayModels = [NSMutableArray arrayWithObject:model];
    [payWayModels addObjectsFromArray:constants];
    
    NSInteger i = 0;
    for (UIButton *button in _Buttons)
    {
        PorscheConstantModel *constant = payWayModels[i];
        [button setTitle:constant.cvvaluedesc forState:UIControlStateNormal];
        button.tag = [constant.cvsubid integerValue];
        i++;
    }
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.clipsToBounds = YES;
    
    self.chooseCountView.layer.cornerRadius = 6;
    self.chooseCountView.clipsToBounds = YES;
    self.chooseCountView.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    self.chooseCountView.layer.borderColor = MAIN_BLUE.CGColor;
    
    self.allButton.imageEdgeInsets  = UIEdgeInsetsMake(4, 0, 4, 0);
    self.allButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.selfPayButton.imageEdgeInsets  = UIEdgeInsetsMake(4, 0, 4, 0);
    self.selfPayButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.upKeepButton.imageEdgeInsets  = UIEdgeInsetsMake(4, 0, 4, 0);
    self.upKeepButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.innerButton.imageEdgeInsets  = UIEdgeInsetsMake(4, 0, 4, 0);
    self.innerButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)makeLayer:(UIView *)view {
    
    view.layer.cornerRadius = 6;
    view.clipsToBounds = YES;
}
- (IBAction)subtractAction:(UIButton *)sender {
    
    if (self.printCount == 0) return;
    self.printCount --;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.printCount];
}
- (IBAction)addAction:(UIButton *)sender {
    
    self.printCount ++;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.printCount];
}
- (IBAction)printTypeAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        [sender setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_selected"] forState:UIControlStateNormal];
        if (sender == _allButton)
        {
            for (UIButton *oneButton in _Buttons)
            {
                oneButton.selected = YES;
                [oneButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_selected"] forState:UIControlStateNormal];
            }
        }
        else
        {
            NSInteger selectcount = 0;
            for (UIButton *oneButton in _Buttons)
            {
                if (oneButton != _allButton && oneButton.selected)
                {
                    selectcount++;
                }
            }
            if (selectcount == (_Buttons.count - 1))
            {
                _allButton.selected = YES;
                [_allButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_selected"] forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_normal.png"] forState:UIControlStateNormal];
        if (sender == _allButton)
        {
            for (UIButton *oneButton in _Buttons)
            {
                oneButton.selected = NO;
                [oneButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_normal.png"] forState:UIControlStateNormal];
            }
        }
        else
        {
            _allButton.selected = NO;
            [_allButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_normal.png"] forState:UIControlStateNormal];

        }
    }
    
    
    
    
//    if (_selectedButton) {
//        [_selectedButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_normal.png"] forState:UIControlStateNormal];
//    }
//    _selectedButton = sender;
//    
//    if (sender == self.allButton) {
//        
//        self.type = PorschePrintAffirmViewPrintTypeALL;
//        [self.allButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_selected"] forState:UIControlStateNormal];
//        
//    } else if (sender == self.selfPayButton) {
//        
//        self.type = PorschePrintAffirmViewPrintTypeSelfPay;
//        [self.selfPayButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_selected"] forState:UIControlStateNormal];
//        
//    } else if (sender == self.upKeepButton) {
//        
//        self.type = PorschePrintAffirmViewPrintTypeUpkeep;
//        [self.upKeepButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_selected"] forState:UIControlStateNormal];
//        
//    } else if (sender == self.innerButton) {
//        
//        self.type = PorschePrintAffirmViewPrintTypeInner;
//        [self.innerButton setImage:[UIImage imageNamed:@"materialtime_detail_mileage_round_selected"] forState:UIControlStateNormal];
//    }
}
- (IBAction)confirmAction:(UIButton *)sender {
    
    NSMutableArray *pays = [NSMutableArray array];
    
    for (UIButton *button in _Buttons)
    {
        if (button.selected)
        {
            [pays addObject:@(button.tag)];
        }
    }
    
    if (self.backBlock)
    {
        self.backBlock(pays,_printCount);
    }
    
    [self removeFromSuperview];
}

- (IBAction)closeAction:(id)sender {
    
    [self removeFromSuperview];
}

- (void)dealloc {
    
    NSLog(@"打印确认View销毁");
}

@end
