//
//  ItemListLeftBottomView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ItemListLeftBottomView.h"

@implementation ItemListLeftBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ItemListLeftBottomView" owner:nil options:nil];
    
        self = [array objectAtIndex:0];
        self.frame = frame;

        _tapCount = 0;
        
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowRadius = 3;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
        
    
    return self;
}

- (IBAction)fullScreenBtAction:(UIButton *)sender {
    if (self.itemListLeftBottomViewBlock) {
        self.itemListLeftBottomViewBlock(ItemListLeftBottomViewStyleFullScreen,sender,_tapCount);
    }
}

- (IBAction)chooseMyCarBtAction:(UIButton *)sender {
    _tapCount ++;
    if (self.itemListLeftBottomViewBlock) {
        self.itemListLeftBottomViewBlock(ItemListLeftBottomViewStyleChooseMyCar,sender,_tapCount);
    }
}
@end
