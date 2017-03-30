//
//  PorscheApplication.m
//  HandleiPad
//
//  Created by Handlecar on 9/12/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "PorscheApplication.h"
//
NSString *const touchStartstr = @"touchStartTap";
NSString *const touchMovedstr = @"touchMovedTap";
NSString *const touchEndedStr = @"touchEndedTap";
@implementation PorscheApplication

- (void)sendEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeTouches) {
        if ([[event.allTouches anyObject] phase] == UITouchPhaseBegan) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:touchStartstr object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"event"]]];
        }
        else if([[event.allTouches anyObject] phase] == UITouchPhaseMoved)
        {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:touchMovedstr object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"event"]]];
        }else if ([[event.allTouches anyObject] phase] == UITouchPhaseEnded) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:touchEndedStr object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"event"]]];
        }
    }
    [super sendEvent:event];
}

@end
