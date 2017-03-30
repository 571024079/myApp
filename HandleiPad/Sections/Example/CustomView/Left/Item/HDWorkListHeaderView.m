//
//  HDWorkListHeaderView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/4.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListHeaderView.h"

@interface HDWorkListHeaderView ()<UITextFieldDelegate>

@end

@implementation HDWorkListHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithCustomFrame:(CGRect)frame {

    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListHeaderView" owner:nil options:nil];
    
    self = [array objectAtIndex:0];
    self.frame = frame;
    
    _nameSearchTF.delegate = self;
    
    
    return self;
}

- (void)setCarmodel:(PorscheNewCarMessage *)carmodel {
    _carmodel = carmodel;
    
    _categoryTF.text = carmodel.wocarmodel;
    
}


- (IBAction)buttonAction:(UIButton *)sender {
    if (self.block) {
        self.block(sender);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == _nameSearchTF)
    {
        if (self.block) {
            self.block(_cleanBt);
        }
    }
    
    return YES;
}



@end
