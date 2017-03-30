//
//  PorscheCarTypeChooserView.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/15.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PorscheCarTypeChooserViewSaveBlock)(NSArray<PorscheCarSeriesModel *> *);

@interface PorscheCarTypeChooserView : UIView

@property (nonatomic, copy) PorscheCarTypeChooserViewSaveBlock saveBlcok;

@property (nonatomic, assign) BOOL multipleChoice;

+ (instancetype)viewWithXib;

@end
