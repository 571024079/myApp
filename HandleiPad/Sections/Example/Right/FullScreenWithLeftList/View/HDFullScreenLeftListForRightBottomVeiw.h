//
//  HDFullScreenLeftListForRightBottomVeiw.h
//  HandleiPad
//
//  Created by handou on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^HDFullScreenLeftListForRightBottomVeiwBlock)();
@interface HDFullScreenLeftListForRightBottomVeiw : UIView

//交车按钮界面
@property (nonatomic, weak) IBOutlet UIView *jiaocheView;

//@property (nonatomic, copy) HDFullScreenLeftListForRightBottomVeiwBlock hDFullScreenLeftListForRightBottomVeiwBlock;

@property (nonatomic, copy) void(^hDFullScreenLeftListForRightBottomVeiwBlock)(UIButton *sender);

@property (weak, nonatomic) IBOutlet UIButton *jiaocheBt;

- (instancetype)initWithCustomFrame:(CGRect)frame;
@end
