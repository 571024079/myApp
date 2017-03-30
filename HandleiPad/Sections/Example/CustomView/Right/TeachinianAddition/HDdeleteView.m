//
//  HDdeleteView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDdeleteView.h"

@implementation HDdeleteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustom {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDdeleteView" owner:nil options:nil];
    
    self = [array objectAtIndex:0];
    
    _refuseBtWidth.constant = 0;
    
    return self;
}

+ (instancetype)setupCustomTitlleArr:(NSArray *)titleArr {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDdeleteView" owner:nil options:nil];
    
    HDdeleteView * view = [array objectAtIndex:0];
    view.refuseBtWidth.constant = 0;

    [view setupTextWithTittleArr:titleArr];
    if (titleArr.count >= 4) {
        view.refuseBtWidth.constant = 132;
    }
    
    return view;
}

- (void)setupTextWithTittleArr:(NSArray *)titleArr {
    _deleteLb.text = titleArr.count >0 ?  titleArr.firstObject : nil;
    [_sureBt setTitle:titleArr.count > 1 ? titleArr[1] :@"" forState:UIControlStateNormal];
    if (titleArr.count == 3) {
        [_cancelBt setTitle: titleArr[2] forState:UIControlStateNormal];
    }else if (titleArr.count >= 4) {
        [_hiddenBt setTitle: titleArr[2] forState:UIControlStateNormal];
        [_cancelBt setTitle: titleArr[3] forState:UIControlStateNormal];
    }
}

- (void)setupViewAboutBottomViewThreeBt:(BOOL)isThree {
    if (isThree) {
        _refuseBtWidth.constant = 132;
    }else {
        _refuseBtWidth.constant = 0;
    }
}
//拒绝
- (IBAction)refuseBtAction:(UIButton *)sender {
    if (self.hDdeleteViewBlock) {
        self.hDdeleteViewBlock(HDdeleteViewStyleRefuse);
    }
}

- (IBAction)sureBtAction:(UIButton *)sender {
    if (self.hDdeleteViewBlock) {
        self.hDdeleteViewBlock(HDdeleteViewStyleSure);
    }
}

- (IBAction)cancelBtAction:(UIButton *)sender {
    
    if (self.hDdeleteViewBlock) {
        self.hDdeleteViewBlock(HDdeleteViewStyleCancel);
    }
}
@end
