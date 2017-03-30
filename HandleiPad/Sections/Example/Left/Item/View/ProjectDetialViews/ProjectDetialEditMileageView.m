//
//  ProjectDetialEditMileageView.m
//  HandleiPad
//
//  Created by Robin on 16/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetialEditMileageView.h"
#import "PorscheNumericKeyboard.h"
#import "HDAccessoryView.h"

#define noSelectColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]

#define selectColor [UIColor whiteColor]

NSString *const selectImageName = @"materialtime_detail_mileage_round_selected";
NSString *const normalImageName = @"materialtime_detail_mileage_round_normal";

@interface ProjectDetialEditMileageView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *rangeBtn; //第一行选中Button
@property (weak, nonatomic) IBOutlet UIButton *leftRightAboutBtn; //第二行选中Button
@property (weak, nonatomic) IBOutlet UIButton *recycleBtn; //第三行选中Button

@property (weak, nonatomic) IBOutlet UITextField *rangeTF1;
@property (weak, nonatomic) IBOutlet UITextField *rangeTF2;

@property (weak, nonatomic) IBOutlet UITextField *lrAboutTF1;
@property (weak, nonatomic) IBOutlet UITextField *lrAboutTF2;
@property (weak, nonatomic) IBOutlet UITextField *lrAboutTF3;

@property (weak, nonatomic) IBOutlet UITextField *recycleTF1;
@property (weak, nonatomic) IBOutlet UITextField *recycleTF2;
@property (weak, nonatomic) IBOutlet UITextField *recycleTF3;
@property (weak, nonatomic) IBOutlet UITextField *recycleTF4;

@property (nonatomic, strong) NSArray *allTFs;
@property (nonatomic, strong) NSMutableArray *selectTFs;

@property (nonatomic, strong) PorscheSchemeMilesModel *milesModel;

@end

@implementation ProjectDetialEditMileageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withMilesModel:(PorscheSchemeMilesModel *)milesModel
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProjectDetialEditMileageView" owner:nil options:nil];
        
        self = [array objectAtIndex:0];
        
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;

        self.milesModel = milesModel;
        [self registerForKeyBoardNotifinations];
        [self setupKeyBoard];
    }
    return self;
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

- (NSMutableArray *)selectTFs {
    
    if (!_selectTFs) {
        _selectTFs = [[NSMutableArray alloc] init];
    }
    return _selectTFs;
}

- (void)setMilesModel:(PorscheSchemeMilesModel *)milesModel {
    
    _milesModel = milesModel;
    
    switch (milesModel.rangetype.integerValue) { //1：公里范围 2:公里数浮动 3：公里数循环
        case 1: 
        {
            [self mileageAction:self.rangeBtn];
            
            self.rangeTF1.text = milesModel.beginmiles.stringValue;
            self.rangeTF2.text = milesModel.endmiles.stringValue;
        }
            break;
        case 2:
        {
            [self mileageAction:self.leftRightAboutBtn];
            
            self.lrAboutTF1.text = milesModel.allmiles.stringValue;
            self.lrAboutTF2.text = milesModel.upfloatmiles.stringValue;
            self.lrAboutTF3.text = milesModel.downfloatmiles.stringValue;
        }
            break;
        case 3:
        {
            [self mileageAction:self.recycleBtn];
            
            self.recycleTF1.text = milesModel.startmiles.stringValue;
            self.recycleTF2.text = milesModel.personmemiles.stringValue;
            self.recycleTF3.text = milesModel.upfloatmiles.stringValue;
            self.recycleTF4.text = milesModel.downfloatmiles.stringValue;
        }
            break;
        default:
            break;
    }
}

- (IBAction)mileageAction:(UIButton *)sender {
    
    if (sender == self.rangeBtn) {
        
        self.milesModel.rangetype = @(1);
        [self selectRange:YES];
        [self selectLRAbout:NO];
        [self selectRecycle:NO];
    }
    
    if (sender == self.leftRightAboutBtn) {
        self.milesModel.rangetype = @(2);
        [self selectRange:NO];
        [self selectLRAbout:YES];
        [self selectRecycle:NO];
    }
    
    if (sender == self.recycleBtn) {
        self.milesModel.rangetype = @(3);
        [self selectRange:NO];
        [self selectLRAbout:NO];
        [self selectRecycle:YES];
    }
    
}
- (IBAction)doneAction:(id)sender {
    
    
    for (UITextField *tf in self.selectTFs) {
        if ([tf.text isEqualToString:@"-"]) {
            
            [MBProgressHUD showMessageText:@"请输入完整的公里数范围" toView:KEY_WINDOW anutoHidden:YES];
            return;
        }
    }
    
    if ([[self textFiledString:0] isEqualToString:@"-"]) return;
    switch (self.selectTFs.count) {
        case 2:
        {
            self.milesModel.rangetype = @1;
            self.milesModel.beginmiles = @([self textFiledString:0].floatValue);
            self.milesModel.endmiles = @([self textFiledString:1].floatValue);
        }
            break;
        case 3:
        {
            self.milesModel.rangetype = @2;
            self.milesModel.allmiles = @([self textFiledString:0].floatValue);
            self.milesModel.upfloatmiles = @([self textFiledString:1].floatValue);
            self.milesModel.downfloatmiles = @([self textFiledString:2].floatValue);
        }
            break;
        case 4:
        {
            self.milesModel.rangetype = @3;
            self.milesModel.startmiles = @([self textFiledString:0].floatValue);
            self.milesModel.personmemiles = @([self textFiledString:1].floatValue);
            self.milesModel.upfloatmiles = @([self textFiledString:2].floatValue);
            self.milesModel.downfloatmiles = @([self textFiledString:3].floatValue);
        }
            break;
        default:
            break;
    }
    
    if (self.clickBlock) {
        self.clickBlock(self.milesModel);
    }
}

- (NSString *)textFiledString:(NSInteger)index {
    
    UITextField *tf = self.selectTFs[index];

    return tf.text;
}

- (IBAction)deleteAction:(id)sender {
    
    if (self.clickBlock) {
        self.clickBlock(self.milesModel);
    }
}

- (void)selectRange:(BOOL)select {
    
    NSString *imageName = select ? selectImageName : normalImageName;
    UIColor *color =  select ? selectColor : noSelectColor;
    
    [_rangeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.rangeTF1.backgroundColor = color;
    self.rangeTF2.backgroundColor = color;
    
    if (select) {
        [self.selectTFs removeAllObjects];
        [self.selectTFs addObjectsFromArray:@[_rangeTF1,_rangeTF2]];
 
    }
}

- (void)selectLRAbout:(BOOL)select {
    
    NSString *imageName = select ? selectImageName : normalImageName;
    UIColor *color =  select ? selectColor : noSelectColor;
    
    [self.leftRightAboutBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.lrAboutTF1.backgroundColor = color;
    self.lrAboutTF2.backgroundColor = color;
    self.lrAboutTF3.backgroundColor = color;
    
    if (select) {
        [self.selectTFs removeAllObjects];
        [self.selectTFs addObjectsFromArray:@[_lrAboutTF1,_lrAboutTF2,_lrAboutTF3]];
    }
   
}

- (void)selectRecycle:(BOOL)select {
    
    NSString *imageName = select ? selectImageName : normalImageName;
    UIColor *color =  select ? selectColor : noSelectColor;
    
    [self.recycleBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.recycleTF1.backgroundColor = color;
    self.recycleTF2.backgroundColor = color;
    self.recycleTF3.backgroundColor = color;
    self.recycleTF4.backgroundColor = color;
    
    if (select) {
        [self.selectTFs removeAllObjects];
        [self.selectTFs addObjectsFromArray:@[_recycleTF1,_recycleTF2,_recycleTF3,_recycleTF4]];
    }
}

- (NSArray *)allTFs {
    
    if (!_allTFs) {
        _allTFs = @[_rangeTF1,_rangeTF2,_lrAboutTF1,_lrAboutTF2,_lrAboutTF3,_recycleTF1,_recycleTF2,_recycleTF3,_recycleTF4];
    }
    
    return _allTFs;
}

- (void)registerForKeyBoardNotifinations {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanViewKeyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanViewKeyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)scanViewKeyBoardShow:(NSNotification *)sender {
    
    NSDictionary* info = [sender userInfo];
    //kbSize键盘尺寸 (有width, height)
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到键盘的高度
    
    self.center = CGPointMake(self.center.x, [UIScreen mainScreen].bounds.size.height - self.bounds.size.height/2 - kbSize.height);
}

- (void)scanViewKeyBoardHidden:(NSNotification *)sender {

     self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    rangeTF1;
//    lrAboutTF1;
//    recycleTF1;
    if (textField == self.rangeTF1) {
        [self.rangeTF2 becomeFirstResponder];
    }
    
    if (textField == self.rangeTF2) {
        [self closeKeyBoard];
    }
    
    if (textField == self.lrAboutTF1) {
        [self.lrAboutTF2 becomeFirstResponder];
    }
    
    if (textField == self.lrAboutTF2) {
        [self.lrAboutTF3 becomeFirstResponder];
    }
    
    if (textField == self.lrAboutTF3) {
        [self closeKeyBoard];
    }
    
    if (textField == self.recycleTF1) {
        [self.recycleTF2 becomeFirstResponder];
    }
    
    if (textField == self.recycleTF2) {
        [self.recycleTF3 becomeFirstResponder];
    }
    
    if (textField == self.recycleTF3) {
        [self.recycleTF4 becomeFirstResponder];
    }
    
    if (textField == self.recycleTF4) {
        [self closeKeyBoard];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    
    if (textField == self.rangeTF1 || textField == self.rangeTF2) {
        [self mileageAction:self.rangeBtn];
    }
    
    if (textField == self.lrAboutTF1 || textField == self.lrAboutTF2 || textField == self.lrAboutTF3) {
        [self mileageAction:self.leftRightAboutBtn];
    }
    
    if (textField == self.recycleTF1 || textField == self.recycleTF2 || textField == self.recycleTF3 || textField == self.recycleTF4) {
        [self mileageAction:self.recycleBtn];
    }
    
    if ([textField.text isEqualToString:@"-"] || [textField.text isEqualToString:@"0"]) {
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"-";
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [textField isFloatStringChangeRange:range replacementString:string];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
}

- (void)closeKeyBoard {
    [self endEditing:YES];
}

@end
