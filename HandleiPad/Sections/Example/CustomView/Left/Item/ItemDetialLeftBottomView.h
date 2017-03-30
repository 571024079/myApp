//
//  ItemDetialLeftBottomView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ItemDetialLeftBottomViewBtStyle) {
    ItemDetialLeftBottomViewBtStyleAddSingle = 1,//添加单独项目
    ItemDetialLeftBottomViewBtStyleFullScreen,//全屏
};

typedef void(^ItemDetialLeftBottomViewBlock)(ItemDetialLeftBottomViewBtStyle,UIButton *);
@interface ItemDetialLeftBottomView : UIView


//添加单独项目Bt
@property (weak, nonatomic) IBOutlet UIButton *addSingleItemBt;

//全屏Bt
@property (weak, nonatomic) IBOutlet UIButton *fullSrcreenBt;

@property (nonatomic, copy) ItemDetialLeftBottomViewBlock itemDetialLeftBottomViewBlock;

- (instancetype)initWithCustomFrame:(CGRect)frame;

//添加单独项目事件
- (IBAction)addSingleItemBtAction:(UIButton *)sender;
//全屏事件
- (IBAction)fullScreenBtAction:(UIButton *)sender;

- (void)changeUserEnabledAndViewWithStatus:(NSNumber *)status;



@end
