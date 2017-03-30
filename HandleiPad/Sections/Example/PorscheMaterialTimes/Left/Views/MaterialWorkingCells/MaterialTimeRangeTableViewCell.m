//
//  MaterialTimeRangeTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 16/10/28.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MaterialTimeRangeTableViewCell.h"
#import "HDAccessoryView.h"
@interface MaterialTimeRangeTableViewCell () <UITextFieldDelegate>

@end

@implementation MaterialTimeRangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    [self setupTF];
    [PorscheRequestSchemeListModel shareModel].month = @(-1);
}

- (void)setupTF {
    
    self.firstMileageTF.inputView = [[PorscheNumericKeyboard alloc] init];
    self.firstMileageTF.delegate = self;
    
    [HDAccessoryView accessoryViewWithTextField:_firstMileageTF target:self];

    
    self.secondMileageTF.inputView = [[PorscheNumericKeyboard alloc] init];
    self.secondMileageTF.delegate = self;
    
    [HDAccessoryView accessoryViewWithTextField:_secondMileageTF target:self];

//    [self.timeRangeTF addTarget:self action:@selector(setMileageConfig:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setMileageConfig:(UITextField *)textField {
    
//    if (textField == self.firstMileageTF) {
//        
//        [PorscheRequestSchemeListModel shareModel].beginmiles = [NSNumber numberWithFloat:[self.firstMileageTF.text floatValue]];
//    }
//    
//    if (textField == self.secondMileageTF) {
//        [PorscheRequestSchemeListModel shareModel].endmiles = [NSNumber numberWithFloat:[self.secondMileageTF.text floatValue]];
//    }
    
//    if (textField == self.timeRangeTF) {
//        
//        [PorscheRequestSchemeListModel shareModel].month = [NSNumber numberWithInteger:self.timeRangeId];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self endEditing:YES];
    return YES;
}

- (IBAction)chooseAction:(UIButton *)sender {
    
    if (self.clickBlock) {
        self.clickBlock(self.timeRangeTF);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.firstMileageTF) {
        if ([self.firstMileageTF.text floatValue] == 0)
        {
            self.firstMileageTF.text = @"0";
        }
        
        [PorscheRequestSchemeListModel shareModel].beginmiles = [NSNumber numberWithFloat:[self.firstMileageTF.text floatValue]];
    }
    
    if (textField == self.secondMileageTF) {
        
        if ([self.secondMileageTF.text floatValue] == 0)
        {
            self.secondMileageTF.text = @"0";
        }
        
        [PorscheRequestSchemeListModel shareModel].endmiles = [NSNumber numberWithFloat:[self.secondMileageTF.text floatValue]];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.firstMileageTF || textField == self.secondMileageTF)
    {
        if ([textField.text floatValue] == 0)
        {
            textField.text = @"";
        }
    }
}

- (void)refreshRequestSchemeMonth:(PorscheConstantModel *)month {
    
    self.timeRangeTF.text = month.cvvaluedesc;
    [PorscheRequestSchemeListModel shareModel].month = month.cvsubid ? @(month.cvsubid.integerValue) : @(-1);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
