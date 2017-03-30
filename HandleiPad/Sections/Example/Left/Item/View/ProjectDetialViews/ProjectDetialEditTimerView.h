//
//  ProjectDetialEditTimerView.h
//  HandleiPad
//
//  Created by Robin on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ProjectDetialEditTimerViewBlock)();
@interface ProjectDetialEditTimerView : UIView

@property (nonatomic, copy) ProjectDetialEditTimerViewBlock saveBlock;

+ (instancetype)viewFromXibWithFrame:(CGRect)frame withMonthModel:(PorscheSchemeMonthModel *)monthModel;

@end
