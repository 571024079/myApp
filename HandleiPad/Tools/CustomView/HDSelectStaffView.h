//
//  HDSelectStaffView.h
//  HandleiPad
//
//  Created by Handlecar on 2016/11/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDSelectStaffView : UIView

/**
 创建员工选择view

 @param currentGroupStaffs 当前组的所有员工
 @param otherGroups 其他组列表
 @return 员工选择view
 
 */
+ (HDSelectStaffView *)selectStaffViewWithView:(UIView *)aroundView CurrentGroupStaffs:(NSArray *)currentGroupStaffs otherGroups:(NSArray *)otherGroups selectCompletion:(void (^)(NSNumber *groupid, NSNumber *staffid, NSString *staffname))completion;

@end
