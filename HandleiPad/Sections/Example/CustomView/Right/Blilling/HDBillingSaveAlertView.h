//
//  HDBillingSaveAlertView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDBillingSaveAlertView : UIView
// notice_white.png:提醒  默认是保存图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//默认是已保存
@property (weak, nonatomic) IBOutlet UILabel *messageLb;


+ (instancetype)getCustomFrame:(CGRect)frame;


@end
