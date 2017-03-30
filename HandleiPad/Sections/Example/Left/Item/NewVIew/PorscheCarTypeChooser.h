//
//  PorscheCarTypeChooser.h
//  HandleiPad
//
//  Created by Robin on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^PorscheCarTypeChooserSaveBlock)(NSArray *);
@interface PorscheCarTypeChooser : UIView

@property (nonatomic, copy) PorscheCarTypeChooserSaveBlock saveBlcok;

@property (nonatomic, assign) BOOL multipleChoice;

+ (instancetype)viewWithXib;



@end
