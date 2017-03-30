//
//  HDFirstViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/2.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface HDFirstViewController : UIViewController

// 提醒跳转
- (void)changeToRemindVC;
- (void)setNoticeCountWithNumber:(NSNumber *)number;
@end
