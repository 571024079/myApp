//
//  HDNewSaveView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HDNewSaveView : UIView


+ (instancetype)showMakeSureViewAroundView:(UIView *)view tittleArray:(NSArray *)tittleArray direction:(UIPopoverArrowDirection)direction makeSure:(void(^)())sure cancel:(void(^)())cancel;

- (void)setCancelButtonTitleColorNormal;

@end
