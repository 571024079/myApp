//
//  HDMaterialHeaderView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDMaterialHeaderView.h"

@implementation HDMaterialHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDMaterialHeaderView" owner:self options:nil];
        
    self = [array objectAtIndex:0];
    self.frame = frame;
    self.headerSuperView.layer.cornerRadius = 3;
    self.headerSuperView.layer.borderColor = Color(200, 200, 200).CGColor;
    self.headerSuperView.layer.borderWidth = 1;
        
    
    return self;
}

@end
