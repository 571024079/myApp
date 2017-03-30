//
//  CustomBarItemView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "CustomBarItemView.h"

@implementation CustomBarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        
        [self addSubview:self.button];
        
        [self.button addSubview:self.label];
        [self.button addSubview:self.redView];
        _redView.hidden = YES;
        _label.hidden = YES;
        
    }
    return self;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:self.frame];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 + 2, 2, self.frame.size.width  / 3, self.frame.size.width /3)];
        _label.backgroundColor = Color(153,0,0);
        _label.layer.masksToBounds = YES;
        _label.layer.cornerRadius = self.frame.size.width /6;
       
        _label.textAlignment = NSTextAlignmentCenter;
       
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:9];
    }
    return _label;
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width / 2 + 10, 6, 6, 6)];
        _redView.backgroundColor = MAIN_RED;
        _redView.layer.masksToBounds = YES;
        _redView.layer.cornerRadius = 3;
    }
    return _redView;
}

- (void)buttonAction:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
