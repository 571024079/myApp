//
//  HDKeyInputTextField.m
//  HandleiPad
//
//  Created by Handlecar on 2017/2/9.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDKeyInputTextField.h"

@implementation HDKeyInputTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)deleteBackward
{
    [super deleteBackward];
    if ([self.deleteBackwardDelegate respondsToSelector:@selector(deleteBackward:)])
    {
        [self.deleteBackwardDelegate deleteBackward:self];
    }
}

@end
