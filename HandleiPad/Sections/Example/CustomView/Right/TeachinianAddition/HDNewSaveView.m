//
//  HDNewSaveView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDNewSaveView.h"


typedef void(^HDNewSaveViewBlock)(UIButton *button);

@interface HDNewSaveView ()

@property (weak, nonatomic) IBOutlet UIView *listView;

@property (weak, nonatomic) IBOutlet UILabel *tittle;
@property (weak, nonatomic) IBOutlet UIButton *sureBt;
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
//根据传入的View 设置宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
//根据传入的view 设置X
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceWithRight;



@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic, copy) HDNewSaveViewBlock hDNewSaveViewBlock;

@end
@implementation HDNewSaveView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    //中间镂空的矩形框
    CGRect myRect = self.viewRect;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:4];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer insertSublayer:fillLayer atIndex:0];
}

+ (instancetype)showMakeSureViewAroundView:(UIView *)view tittleArray:(NSArray *)tittleArray direction:(UIPopoverArrowDirection)direction makeSure:(void(^)())sure cancel:(void(^)())cancel {
    CGRect viewRect = [view convertRect:view.bounds toView:KEY_WINDOW];
    CGRect listViewRect;
    switch (direction) {
        case UIPopoverArrowDirectionUp:
            listViewRect = CGRectMake(CGRectGetMinX(viewRect), CGRectGetMinY(viewRect) - 130, CGRectGetWidth(viewRect), 130);
            break;
        case UIPopoverArrowDirectionDown:
            listViewRect = CGRectMake(CGRectGetMinX(viewRect), CGRectGetMinY(viewRect) - 130, 130, 85);
            break;
        case UIPopoverArrowDirectionLeft:
            listViewRect = CGRectMake(CGRectGetMinX(viewRect), CGRectGetMinY(viewRect) - 130, 130, 85);
            break;
        case UIPopoverArrowDirectionRight:
            listViewRect = CGRectMake(CGRectGetMinX(viewRect), CGRectGetMinY(viewRect) - 130, 130, 85);
            break;
            
        default:
            break;
    }
    
    HDNewSaveView *dealView = [[HDNewSaveView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    dealView.viewRect = viewRect;

//    dealView.listView.frame = listViewRect;
    dealView.width.constant = CGRectGetWidth(listViewRect);
    CGFloat distanceWithRight = HD_WIDTH - CGRectGetMaxX(listViewRect);
    dealView.distanceWithRight.constant = distanceWithRight;
    
    dealView.hDNewSaveViewBlock = ^(UIButton *button) {
        if (button.tag == 1) {
            sure();
        }else {
            cancel();
        }
    };
    [dealView setupTittleWithArray:tittleArray];
    
    [HD_FULLView endEditing:YES];
    [HD_FULLView addSubview:dealView];
    return dealView;
}

- (void)setCancelButtonTitleColorNormal
{
    
    [self.cancelBt setTitleColor:MAIN_BLUE forState:UIControlStateNormal];
}

- (void)setupTittleWithArray:(NSArray *)tittleArray {
    if (tittleArray.count > 2) {
        _tittle.text = tittleArray.firstObject;
        [_sureBt setTitle:tittleArray[1] forState:UIControlStateNormal];
        [_cancelBt setTitle:tittleArray.lastObject forState:UIControlStateNormal];
    }
    
}

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    self = nib.firstObject;
    self.frame = frame;
    return self;
}

- (IBAction)makeSureBtAction:(UIButton *)sender {
    if (self.hDNewSaveViewBlock) {
        self.hDNewSaveViewBlock(sender);
    }
    [self removeFromSuperview];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (CGRectContainsPoint(self.listView.frame, point) || CGRectContainsPoint(self.viewRect, point)) {
        
        return [super hitTest:point withEvent:event];
    }
    [self removeFromSuperview];
    
    return nil;
}








@end
