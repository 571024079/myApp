//
//  HDWorkListNextView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HDWorkListNextViewDirectinStyle) {
    HDWorkListNextViewDirectinStyleUp = 1,// 上
    HDWorkListNextViewDirectinStyleLeft,//左
    HDWorkListNextViewDirectinStyleDown,//下
    HDWorkListNextViewDirectinStyleRight,//右
};

typedef void(^HDWorkListNextViewBlock)(NSString *);

@interface HDWorkListNextView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tableView;


//选中
@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) HDWorkListNextViewBlock hdWorkListNextViewBlock;

- (instancetype)initWithCustomFrame:(CGRect)frame;
//出现的位置
- (void)setupFrameWithView:(UIView *)aroundView direction:(HDWorkListNextViewDirectinStyle)direction height:(CGFloat)height;

@end
