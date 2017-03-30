//
//  HDMaterialHeaderView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDMaterialHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIView *headerSuperView;
@property (weak, nonatomic) IBOutlet UILabel *selectedCountLabel;

- (instancetype)initWithCustomFrame:(CGRect)frame;

@end
