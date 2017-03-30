//
//  HDServiceLeftBottomView.m
//  HandleiPad
//
//  Created by handou on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceLeftBottomView.h"

@implementation HDServiceLeftBottomView

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDServiceLeftBottomView" owner:nil options:nil];
    
    self = [array objectAtIndex:0];
    self.frame = frame;
    
    _tapCount = 0;
    _allCount = 0;
    
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    
    
    return self;
}

- (IBAction)allButtonAction:(UIButton *)sender {
    _allCount++;
    if (self.serviceLeftBottomViewBlock) {
        self.serviceLeftBottomViewBlock(ServiceLeftBottomViewStyle_all,sender,_allCount);
    }
}

- (IBAction)myCarButtonAction:(UIButton *)sender {
    _tapCount ++;
    if (self.serviceLeftBottomViewBlock) {
        self.serviceLeftBottomViewBlock(ServiceLeftBottomViewStyle_mycar,sender,_tapCount);
    }
}

@end
