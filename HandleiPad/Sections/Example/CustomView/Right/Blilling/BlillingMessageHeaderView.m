//
//  BlillingMessageHeaderView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "BlillingMessageHeaderView.h"

@implementation BlillingMessageHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustomFrame:(CGRect)frame {
        
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BlillingMessageHeaderView" owner:nil options:nil];
    self.frame = frame;
    self = [array objectAtIndex:0];
        

    
    return self;
}

@end
