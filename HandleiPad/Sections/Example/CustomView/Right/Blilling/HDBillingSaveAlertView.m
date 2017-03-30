//
//  HDBillingSaveAlertView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDBillingSaveAlertView.h"

@implementation HDBillingSaveAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//<120 .50>

+ (instancetype)getCustomFrame:(CGRect)frame {
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    HDBillingSaveAlertView *view = array.firstObject;
    view.frame = frame;
    
    view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
    
    view.layer.masksToBounds = YES;
    
    view.layer.cornerRadius = 5;
    
    return view;
}

@end
