//
//  HDInputCarCadastralView.m
//  Handlecar
//
//  Created by liuzhaoxu on 14-9-19.
//  Copyright (c) 2014年 HanDu. All rights reserved.
//

#import "HDInputCarCadastralView.h"

@implementation HDInputCarCadastralView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initViewWithDelegate:(id<HDInputCarCadastralViewDelegate>)delegate
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HDInputCarCadastralView" owner:self options:nil];
    
    self = [nib objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (IBAction)cancelButtonAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(inputCarCadastralView:cancelButtonAction:)]) {
        [_delegate inputCarCadastralView:self cancelButtonAction:sender];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadAllButtonTitle];
}

- (void)loadAllButtonTitle
{
    NSArray *array = [NSArray arrayWithObjects://34个
                       @"京",
                       @"沪",
                       @"津",
                       @"渝",
                       @"黑",
                       @"吉",
                       @"辽",
                       @"蒙",
                       @"冀",
                       @"新",
                       @"甘",
                       @"青",
                       @"陕",
                       @"宁",
                       @"豫",
                       @"鲁",
                       @"晋",//
                       @"皖",
                       @"鄂",
                       @"湘",
                       @"苏",
                       @"川",
                       @"贵",
                       @"云",
                       @"桂",
                       @"藏",
                       @"浙",
                       @"赣",//
                       @"粤",
                       @"闽",
//                       @"台",
                       @"琼",
//                       @"港",
//                       @"澳",
                      
                       @"临",
                      @"警沪",
                      @"未上牌",
                      nil];
    
    for (int i = 0; i < array.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        [button setBackgroundImage:[UIImage imageNamed:@"carCadCadastral_highlight"] forState:UIControlStateHighlighted];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
    }
}

- (IBAction)selectCarCadastralButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (_delegate && [_delegate respondsToSelector:@selector(inputCarCadastralView:didSelectString:)]) {
        [_delegate inputCarCadastralView:self didSelectString:[button currentTitle]];
    }
}

@end
