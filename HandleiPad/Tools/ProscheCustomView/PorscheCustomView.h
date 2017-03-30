//
//  PorscheCustomView.h
//  HandleiPad
//
//  Created by Robin on 16/10/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ListViewDirection) {
    
    ListViewDirectionUp,
    ListViewDirectionDown,
    ListViewDirectionLeft,
    ListViewDirectionRight
};

typedef void(^PorscheCustomViewListViewBlcok)(NSMutableArray *);

typedef void (^PorscheCustomAlertViewBlcok)(NSInteger idx);

@interface PorscheCustomView : UIView

@property (nonatomic, copy) PorscheCustomViewListViewBlcok saveBlock;

+ (PorscheCustomView *)defaultProsche;

//自定义列表选择器
- (void)showListView:(UIView *)view direction:(ListViewDirection)direction andDataArray:(NSArray *)arr celected:(void(^)(NSInteger index))index;

@end
