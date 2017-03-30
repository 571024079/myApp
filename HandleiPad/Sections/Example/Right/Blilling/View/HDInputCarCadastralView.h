//
//  HDInputCarCadastralView.h
//  Handlecar
//
//  Created by liuzhaoxu on 14-9-19.
//  Copyright (c) 2014年 HanDu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HDInputCarCadastralView;
@protocol HDInputCarCadastralViewDelegate <NSObject>

@optional
- (void)inputCarCadastralView:(HDInputCarCadastralView *)view didSelectString:(NSString *)string;
- (void)inputCarCadastralView:(HDInputCarCadastralView *)view cancelButtonAction:(UIButton *)button;

@end

@interface HDInputCarCadastralView : UIView

@property (nonatomic, weak) id<HDInputCarCadastralViewDelegate>delegate;

- (id)initViewWithDelegate:(id<HDInputCarCadastralViewDelegate>)delegate;

@end
