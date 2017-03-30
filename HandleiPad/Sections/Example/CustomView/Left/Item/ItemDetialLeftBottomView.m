//
//  ItemDetialLeftBottomView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ItemDetialLeftBottomView.h"

@implementation ItemDetialLeftBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustomFrame:(CGRect)frame  {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ItemDetialLeftBottomView" owner:self options:nil];
    
    self = [array objectAtIndex:0];
    self.frame = frame;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    
    return self;
}

- (IBAction)addSingleItemBtAction:(UIButton *)sender {
    if (self.itemDetialLeftBottomViewBlock) {
        self.itemDetialLeftBottomViewBlock(ItemDetialLeftBottomViewBtStyleAddSingle,sender);
    }
}

- (IBAction)fullScreenBtAction:(UIButton *)sender {
    
    if (self.itemDetialLeftBottomViewBlock) {
        self.itemDetialLeftBottomViewBlock(ItemDetialLeftBottomViewBtStyleFullScreen,sender);
    }
}

- (void)changeUserEnabledAndViewWithStatus:(NSNumber *)status {
    [self.fullSrcreenBt setTitle:@"全屏" forState:UIControlStateNormal];
    BOOL isSave = [status integerValue] == 1 ? YES : NO;
    [self.fullSrcreenBt setBackgroundImage:[UIImage imageNamed: isSave ? @"gray_backGroundImage.png":@"sure_bg_blue.png"] forState:UIControlStateNormal];
    self.fullSrcreenBt.userInteractionEnabled = !isSave;
    [self.addSingleItemBt setTitleColor:isSave ? [UIColor lightGrayColor] : MAIN_BLUE forState:UIControlStateNormal];
    self.addSingleItemBt.userInteractionEnabled = !isSave;
    [self.fullSrcreenBt setTitleColor:isSave ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    //没有添加自定义方案的权限
    if ([HDPermissionManager isNotWithNOAlertViewThisPermission:HDOrder_GoSchemeLibrary_AddCustomScheme]) {
        self.addSingleItemBt.userInteractionEnabled = NO;
        [self.addSingleItemBt setTitleColor: [UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
}

@end
