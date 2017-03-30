//
//  UIImagePickerController+Landscape.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "UIImagePickerController+Landscape.h"

@implementation UIImagePickerController (Landscape)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
@end
