//
//  ProjectDetialEditTimerView.m
//  HandleiPad
//
//  Created by Robin on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetialEditTimerView.h"
#import "PorscheNumericKeyboard.h"
#import "HDAccessoryView.h"

@interface ProjectDetialEditTimerView () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray *allTFs;
@property (weak, nonatomic) IBOutlet UITextField *firstTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *secondTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *upTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *downTimeTF;

@property (nonatomic, strong) PorscheSchemeMonthModel *monthModel;

@end

@implementation ProjectDetialEditTimerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewFromXibWithFrame:(CGRect)frame withMonthModel:(PorscheSchemeMonthModel *)monthModel
{
    
    ProjectDetialEditTimerView *editTimer = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetialEditTimerView" owner:nil options:nil] lastObject];
    editTimer.frame = frame;
    editTimer.monthModel = monthModel;
    editTimer.layer.masksToBounds = YES;
    editTimer.layer.cornerRadius = 6;
    return editTimer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupKeyBoard];
}

- (void)setupKeyBoard {
    //自定义数字键盘
    for (UITextField *tf in self.allTFs) {
        PorscheNumericKeyboard *inputView = [[PorscheNumericKeyboard alloc] init];
        tf.delegate = self;
        tf.inputView = inputView;
        [tf reloadInputViews];
        [HDAccessoryView accessoryViewWithTextField:tf target:self];
    }
}

- (NSArray *)allTFs {
    
    if (!_allTFs) {
        _allTFs = @[_firstTimeTF,_secondTimeTF,_upTimeTF,_downTimeTF];
    }
    return _allTFs;
}

- (void)setMonthModel:(PorscheSchemeMonthModel *)monthModel {

    _monthModel = monthModel;
    
    self.firstTimeTF.text = monthModel.startmonth.stringValue;
    self.secondTimeTF.text = monthModel.timeintervalmonth.stringValue;
    self.upTimeTF.text = monthModel.upfloatmonth.stringValue;
    self.downTimeTF.text = monthModel.upfloatmonth.stringValue;
}

- (IBAction)doneAction:(id)sender {

    for (UITextField *tf in self.allTFs) {
        if ([tf.text isEqualToString:@"-"]) {
            
            [MBProgressHUD showMessageText:@"请输入完整的时间范围" toView:KEY_WINDOW anutoHidden:YES];
            
            return;
        }
    }
    self.monthModel.startmonth = @(self.firstTimeTF.text.floatValue);
    self.monthModel.timeintervalmonth = @(self.secondTimeTF.text.floatValue);
    self.monthModel.upfloatmonth = @(self.upTimeTF.text.floatValue);
    self.monthModel.downfloatmonth = @(self.downTimeTF.text.floatValue);
    
    if (self.saveBlock) {
        self.saveBlock();
    }
}
- (IBAction)cancleAction:(id)sender {
    
    if (self.saveBlock) {
        self.saveBlock();
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@"-"]) {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"-";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [string validateNumber];
}

@end
