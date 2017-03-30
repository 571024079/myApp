//
//  HDStatusChangeManager.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/12/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDStatusChangeManager.h"
#import "HDLeftSingleton.h"

@implementation HDStatusChangeManager

+ (void)changeStatusLeft:(HDLeftStatusStyle)left right:(HDRightStatusStyle)right {
//    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_RIGHT_STEP_NOTIFINATION object:@{@"left":@(left),@"right":@(right)}];
    [[HDLeftSingleton shareSingleton] changeWorkFlowWithInfo:@{@"left":@(left),@"right":@(right)}];

}

+ (void)removeNetVC {
    [[NSNotificationCenter defaultCenter] postNotificationName:WEB_URL_TAP_NOTIFICATION object:nil];
}

@end
