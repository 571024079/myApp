//
//  MBProgressHUD+PorscheHUD.m
//  HandleiPad
//
//  Created by Robin on 16/11/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "MBProgressHUD+PorscheHUD.h"

@implementation MBProgressHUD (PorscheHUD)

+ (MBProgressHUD *)showMessageText:(NSString *)message toView:(UIView *)view anutoHidden:(BOOL)autoHidden {
    
    if (autoHidden) {
        return [MBProgressHUD showMessageText:message toView:view afterDelay:1.0];
    }
    return [MBProgressHUD showMessageText:message toView:view];
}

+ (MBProgressHUD *)showMessageText:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)delay {
    
    MBProgressHUD *hub = [MBProgressHUD showMessageText:message toView:view];
    [hub hideAnimated:YES afterDelay:delay];
    return hub;
}

+ (MBProgressHUD *)showMessageText:(NSString *)message toView:(UIView *)view {
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.label.text = message;

    return hub;
}

+ (MBProgressHUD *)showProgressMessage:(NSString *)message toView:(UIView *)view {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hub.label.text = message;
    return hub;
}

- (void)changeTextModeMessage:(NSString *)message toView:(UIView *)view {
    
    if (message.length)
    {
        self.mode = MBProgressHUDModeText;
        self.label.text = message;
    }
    [self hideAnimated:YES afterDelay:1.0];
}

+ (MBProgressHUD *)showMessage:(NSString *)message progressMode:(MBProgressHUDMode)model toView:(UIView *)view {
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hub.mode = model;
    hub.label.text = message;
    return hub;
}

@end
