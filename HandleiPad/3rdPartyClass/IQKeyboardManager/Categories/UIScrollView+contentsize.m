//
//  UIScrollView+contentsize.m
//  IQKeyboardTest
//
//  Created by Handlecar on 10/19/16.
//  Copyright © 2016 handlecar. All rights reserved.
//

#import "UIScrollView+contentsize.h"

@implementation UIScrollView (contentsize)

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentSize = CGSizeMake(0, self.bounds.size.height);
}

@end
