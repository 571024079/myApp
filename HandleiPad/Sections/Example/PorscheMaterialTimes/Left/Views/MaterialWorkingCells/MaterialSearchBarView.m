//
//  MaterialSearchBarView.m
//  HandleiPad
//
//  Created by Robin on 16/9/26.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MaterialSearchBarView.h"

@implementation MaterialSearchBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaterialSearchBarView" owner:nil options:nil];
        
        self = [array objectAtIndex:0];
        
//        self.layer.shadowOpacity = 0.5;
//        self.layer.shadowColor = [UIColor grayColor].CGColor;
//        self.layer.shadowRadius = 3;
//        self.layer.shadowOffset = CGSizeMake(1, 1);
//        self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];

    }
    return self;
}

- (void)setSearchType:(BOOL)searchType {
    _searchType = searchType;
    
    
}


@end
