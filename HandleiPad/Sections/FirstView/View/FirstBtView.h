//
//  FirstBtView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/2.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstBtViewDelegate <NSObject>

- (void)buttonActionClickButton:(UIButton *)sender;

@end


typedef void(^FirstBtViewBlock)(UIButton *);
@interface FirstBtView : UIView

@property (nonatomic, copy) FirstBtViewBlock firstBtViewBlock;

@property (nonatomic, assign) id<FirstBtViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)buttonAction:(UIButton *)sender;

- (instancetype)initWithCustomFrame:(CGRect)frame;
@end
