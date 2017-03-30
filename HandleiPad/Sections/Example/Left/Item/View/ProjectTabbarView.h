//
//  ProjectTabbarView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/11.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProjectTabbarViewBlock)(UIButton *);
@interface ProjectTabbarView : UIView

@property (weak, nonatomic) IBOutlet UIButton *factoryBt;
@property (weak, nonatomic) IBOutlet UIButton *locationBt;
@property (weak, nonatomic) IBOutlet UIButton *mineBt;
@property (nonatomic, copy) ProjectTabbarViewBlock tabbarBlock;

- (instancetype)initWithcustomFrame:(CGRect)rect type:(NSInteger)type complete:(void(^)(UIButton *button))complete ;

- (IBAction)switchLocationBtAction:(UIButton *)sender;

@end
