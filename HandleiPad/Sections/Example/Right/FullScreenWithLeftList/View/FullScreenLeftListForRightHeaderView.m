//
//  FullScreenLeftListForRightHeaderView.m
//  HandleiPad
//
//  Created by handou on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "FullScreenLeftListForRightHeaderView.h"

@implementation FullScreenLeftListForRightHeaderView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"FullScreenLeftListForRightHeaderView" owner:self options:nil] firstObject];
        
        for (UIView *view in self.subviews) {
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 3;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    return self;
}

- (IBAction)bottomButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (_delegate && [_delegate respondsToSelector:@selector(bottomViewButtonActionForHeader:)]) {
        [_delegate bottomViewButtonActionForHeader:btn];
    }
}




@end
