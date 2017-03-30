//
//  LinkageTextField.m
//  MutipleAccessView
//
//  Created by Handlecar on 2017/2/17.
//  Copyright © 2017年 handlecar. All rights reserved.
//

#import "LinkageTextField.h"

@implementation LinkageTextField

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
    if ([self.linkageDelegate respondsToSelector:@selector(keyBoardDeleteBackward:)])
    {
        [self.linkageDelegate keyBoardDeleteBackward:self];
    }
}

@end
