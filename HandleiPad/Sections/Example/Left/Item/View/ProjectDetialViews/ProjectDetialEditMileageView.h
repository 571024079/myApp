//
//  ProjectDetialEditMileageView.h
//  HandleiPad
//
//  Created by Robin on 16/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProjectDetialEditMileageViewClickBlock)(PorscheSchemeMilesModel *);
@interface ProjectDetialEditMileageView : UIView

@property (nonatomic, copy) ProjectDetialEditMileageViewClickBlock clickBlock;

- (instancetype)initWithFrame:(CGRect)frame withMilesModel:(PorscheSchemeMilesModel *)milesModel;

@end
