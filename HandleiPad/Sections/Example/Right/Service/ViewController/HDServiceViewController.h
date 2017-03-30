//
//  HDServiceViewController.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HDServiceViewController : BaseViewController

//方案库/备件库工时库返回
- (void)materialBackToTechnianVC:(NSDictionary *)sender;
//刷新方案列表
- (void)addModel:(NSDictionary *)sender;
@end
