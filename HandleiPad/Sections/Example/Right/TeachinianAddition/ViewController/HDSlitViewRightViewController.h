//
//  HDSlitViewRightViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/30.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HDSlitViewRightViewController : BaseViewController

//方案库备件库返回
- (void)materialBackToTechnianVC:(NSDictionary *)sender;
//刷新方案列表
- (void)addModel:(NSDictionary *)sender;
@end
