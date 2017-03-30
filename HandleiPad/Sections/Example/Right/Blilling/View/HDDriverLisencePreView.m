//
//  HDDriverLisencePreView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDDriverLisencePreView.h"

@implementation HDDriverLisencePreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"HDDriverLisencePreView" owner:nil options:nil];
    
    self = [array objectAtIndex:0];
    
    self.frame = frame;
    
    _deleteBt.layer.masksToBounds = YES;
    
    _deleteBt.layer.cornerRadius = 15;
    
    
    return self;
    
}

- (IBAction)deleteBtAction:(UIButton *)sender {
    if (self.hDDriverLisencePreViewBlock) {
        self.hDDriverLisencePreViewBlock(HDDriverLisencePreViewStyleDelete,sender);
    }
}
- (IBAction)ShutDownAction:(UIButton *)sender {
    if (self.hDDriverLisencePreViewBlock) {
        self.hDDriverLisencePreViewBlock(HDDriverLisencePreViewStyleShutDown,sender);
    }
}

- (IBAction)reTakePhoto:(UIButton *)sender {
    if (self.hDDriverLisencePreViewBlock) {
        self.hDDriverLisencePreViewBlock(HDDriverLisencePreViewStyleReTakePhoto,sender);
    }
}
@end
