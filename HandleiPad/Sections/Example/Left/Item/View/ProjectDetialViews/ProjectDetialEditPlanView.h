//
//  ProjectDetialEditPlanView.h
//  HandleiPad
//
//  Created by Robin on 16/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProjectDetialEditPlanViewClickBlock)(NSString *, NSString *);
@interface ProjectDetialEditPlanView : UIView

@property (nonatomic, copy) ProjectDetialEditPlanViewClickBlock clickBlock;

@end
