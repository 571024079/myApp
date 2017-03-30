//
//  HDWorkListTVHFViewOne.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/5.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListTVHFViewOne.h"

@interface HDWorkListTVHFViewOne ()<UITextFieldDelegate>

@end

@implementation HDWorkListTVHFViewOne

- (instancetype)initWithCustomFrame:(CGRect)frame {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListTVHFViewOne" owner:nil options:nil];
    self = [array objectAtIndex:0];
    [self layoutIfNeeded];
    self.frame = frame;
    _itemNameTF.delegate = self;
    _materalTF.delegate = self;
    _itemTimeTF.delegate = self;
    _itemTotal.delegate = self;
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.hdWorkListTVHFViewOneBlock) {
        self.hdWorkListTVHFViewOneBlock(HDWorkListTVHFViewOneStyleTF,nil);
    }
}


- (IBAction)deleteBtAction:(UIButton *)sender {
    if (self.hdWorkListTVHFViewOneBlock) {
        self.hdWorkListTVHFViewOneBlock(HDWorkListTVHFViewOneStyleDelete,sender);
    }
    
    
    
}
@end
