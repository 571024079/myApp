//
//  FirstBtView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/2.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "FirstBtView.h"


@implementation FirstBtView

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"FirstBtView" owner:nil options:nil];
    
    self = [array objectAtIndex:0];
    
    self.frame = frame;
    
    _numLb.layer.masksToBounds = YES;
    
    _numLb.layer.cornerRadius = 15;
        

    return self;
}

- (IBAction)buttonAction:(UIButton *)sender {
    
//    if (self.firstBtViewBlock) {
//        self.firstBtViewBlock(sender);
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonActionClickButton:)]) {
        [self.delegate buttonActionClickButton:sender];
    }
}
@end
