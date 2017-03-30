//
//  GuaranteeChooseView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "GuaranteeChooseView.h"

@interface GuaranteeChooseView ()<UIPickerViewDelegate,UIPickerViewDataSource>

//
@property (nonatomic, strong) NSArray *dataArray;//结算方式ProscheProjectSettlement

@property (nonatomic, assign) NSInteger idx;


@end


@implementation GuaranteeChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)getClassCustomFrame:(CGRect)frame dataSource:(NSArray *)dataSource idx:(NSInteger)idx{
    
    GuaranteeChooseView *view =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GuaranteeChooseView class]) owner:nil options:nil].firstObject;
    
    view.frame = frame;
    view.idx = idx;
    view.dataArray = dataSource;
    [view.pickerView reloadAllComponents];
    [view.pickerView selectRow:idx inComponent:0 animated:YES];
    return view;
}


#pragma mark  ------dataSource------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    PorscheConstantModel *settle = self.dataArray[row];
    
    return settle.cvvaluedesc;

}

- (IBAction)buttonClickAction:(UIButton *)sender {
    
    NSInteger integer = [_pickerView selectedRowInComponent:0];
    
    if (self.guaranteeChooseViewBlock) {
        self.guaranteeChooseViewBlock(sender,integer);
    }
    
}






















@end
