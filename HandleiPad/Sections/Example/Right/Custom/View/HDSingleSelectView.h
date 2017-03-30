//
//  HDSingalSelectView.h
//  HandleiPad
//
//  Created by Handlecar on 16/11/3.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SingleSelectFinished)(NSInteger index);

@interface HDSingleSelectView : UIView
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) SingleSelectFinished selectFinishedBlock;

+ (HDSingleSelectView *)loadSingleSelectViewWithOrigin:(CGPoint)point;
@end
