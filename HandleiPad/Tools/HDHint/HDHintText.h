//
//  HDHintText.h
//  HandleiPad
//
//  Created by Handlecar on 2017/2/16.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HDHintText : NSObject

+ (void)showNormalHintWithMessage:(NSString *)mesage;
+ (void)showExceptionHint:(NSString *)mesage;

@end
