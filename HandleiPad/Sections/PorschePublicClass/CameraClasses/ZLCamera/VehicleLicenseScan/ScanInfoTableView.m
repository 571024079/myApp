//
//  ScanInfoTableView.m
//  CrameraDemo
//
//  Created by Robin on 16/9/23.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "ScanInfoTableView.h"
#import "HDInputCarCadastralView.h"
#import "HDInputVINView.h"


@interface ScanInfoTableView () <HDInputCarCadastralViewDelegate, HDInputVinViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@property (nonatomic, strong) UIPopoverController *carCardastralPoperController;

//VIN键盘辅助
@property (nonatomic, strong) HDInputVINView *VINaccessoryView;


@end

@implementation ScanInfoTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ScanInfoTableView" owner:nil options:nil];
        self = [array objectAtIndex:0];
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    _cancleButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _vinTextField.keyboardType = UITextAutocapitalizationTypeAllCharacters;
    _vinTextField.inputAccessoryView = self.VINaccessoryView;
    _vinTextField.tintColor = [UIColor clearColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark - 选择地域
- (IBAction)addressAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanInfoTableViewcarCardastralWillShow)]) {
        [self.delegate scanInfoTableViewcarCardastralWillShow];
    }
    
    [self endEditing:YES];
    __weak typeof(self)weakSelf = self;
    if (!weakSelf.carCardastralPoperController) {
        
        weakSelf.carCardastralPoperController = [AlertViewHelpers getPoperVCWithCustomView:[[HDInputCarCadastralView alloc]initViewWithDelegate:weakSelf] popoverContentSize:CGSizeMake(400, 450)];
        weakSelf.carCardastralPoperController.backgroundColor = ColorHex(0xd8dbde);
    }
    [weakSelf.carCardastralPoperController presentPopoverFromRect:weakSelf.addressButton.bounds inView:weakSelf.addressButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
  
}
#pragma mark - VIN Input
- (IBAction)VINInputAction:(id)sender {
    

    
    [self.VINaccessoryView showInputView:self originalVINNo:self.vinTextField.text textField:self.vinTextField];
}




//VIN辅助弹框
- (HDInputVINView *)VINaccessoryView {
    if (!_VINaccessoryView) {
        //frame 根据文字框大小
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HDInputVINView" owner:self options:nil];
        
        _VINaccessoryView = [nib objectAtIndex:0];
        _VINaccessoryView.frame = CGRectMake(0, 0, HD_WIDTH, (HD_WIDTH + 120) / 18 + 10);
        
        _VINaccessoryView.btSuperView.layer.masksToBounds = YES;
        _VINaccessoryView.btSuperView.layer.cornerRadius = 5;
        
        
    }
    return _VINaccessoryView;
}


#pragma mark - 确定&重拍
- (IBAction)confilrm:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(scanInfoTableViewConfilrmWidth:)]) {
        
        ScanInfoModel *model = [[ScanInfoModel alloc] init];
        model.carCardArea = self.addressLabel.text;
        model.carCardNum = self.carNumTextFied.text;
        model.vin = self.vinTextField.text;
        [self.delegate scanInfoTableViewConfilrmWidth:model];
        NSLog(@"确定");
    }
    
}
- (IBAction)cancel:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(scanInfoTableViewCancleClick)]) {
        [self.delegate scanInfoTableViewCancleClick];
        NSLog(@"重拍");
    }
}

#pragma mark - 地域输入板代理
- (void)inputCarCadastralView:(HDInputCarCadastralView *)view didSelectString:(NSString *)string {
    
    if (string) {
        self.addressLabel.text = string;
        [self sendDismissDeleagete];
        [self.carCardastralPoperController dismissPopoverAnimated:YES];
        [self.carNumTextFied becomeFirstResponder];
    }
}
- (void)inputCarCadastralView:(HDInputCarCadastralView *)view cancelButtonAction:(UIButton *)button {
    
    [self sendDismissDeleagete];
    
    [self.carCardastralPoperController dismissPopoverAnimated:YES];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    
//    return NO;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self endEditing:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _carNumTextFied || textField == _vinTextField) {
        string = [string uppercaseString];
        
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        return NO;
    }
    return YES;
}

- (void)sendDismissDeleagete {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanInfoTableViewcarCardastralWillDismiss)]) {
        [self.delegate scanInfoTableViewcarCardastralWillDismiss];
    }
}

- (void)dealloc {
    
    
}

@end
