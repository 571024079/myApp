//
//  UIButton+Permission.m
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/22.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "UIButton+Permission.h"

@implementation UIButton (Permission)

- (void)setPermission:(BOOL)permission {
    
    self.enabled = permission;
    self.alpha = permission ? 1.f : 0.5f;
}

@end
