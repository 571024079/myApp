//
//  MaterialRightTimeTitleBar.m
//  HandleiPad
//
//  Created by Robin on 16/9/28.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MaterialRightTimeTitleBar.h"

@implementation MaterialRightTimeTitleBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaterialRightTimeTitleBar" owner:nil options:nil];
        self = [array objectAtIndex:0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaterialRightTimeTitleBar" owner:nil options:nil];
        self = [array objectAtIndex:0];

    }
    return self;
}

@end
