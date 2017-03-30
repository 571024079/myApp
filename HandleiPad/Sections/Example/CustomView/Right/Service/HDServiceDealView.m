//
//  HDServiceDealView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceDealView.h"

typedef void(^HdServiceDealViewBlock)(UIButton *button);

@interface HDServiceDealView ()

@property (weak, nonatomic) IBOutlet UIView *listView;

@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic, copy) HdServiceDealViewBlock hdServiceBlock;
@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UIView *specialView;
@property (weak, nonatomic) IBOutlet UIView *threehandleView;

@property (weak, nonatomic) IBOutlet UIView *threeConfirmView;
@property (weak, nonatomic) IBOutlet UIView *threeFirstLine;
@property (weak, nonatomic) IBOutlet UILabel *threeTechLabel;
@property (weak, nonatomic) IBOutlet UIImageView *threeTechLeftImageView;
@property (weak, nonatomic) IBOutlet UILabel *threeFirstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *threeFirstImageView;
@property (weak, nonatomic) IBOutlet UILabel *threeThreeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *threeThreeImageView;
@property (weak, nonatomic) IBOutlet UIView *fourHandleView;
@property (weak, nonatomic) IBOutlet UILabel *fourFirstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fourFirstImageView;

@end
@implementation HDServiceDealView


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

+ (void)showMakeSureViewAroundView:(UIView *)view direction:(UIPopoverArrowDirection)direction titleArr:(NSArray *)titleArr first:(void(^)())custom second:(void(^)())material {
    [HDServiceDealView showMakeSureViewAroundView:view viewType:HDServiceDealViewNormal direction:direction titleArr:titleArr first:custom second:material three:nil four:nil];
}
+ (void)showMakeSureViewAroundView:(UIView *)view viewType:(HDServiceDealViewType)type  direction:(UIPopoverArrowDirection)direction titleArr:(NSArray *)titleArr  first:(void(^)())custom second:(void(^)())material three:(void (^)())three
{
    [HDServiceDealView showMakeSureViewAroundView:view viewType:type direction:direction titleArr:titleArr first:custom second:material three:three four:nil];
}
- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    self = nib.firstObject;
    self.frame = frame;
//    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    return self;
}

- (IBAction)makeSureBtAction:(UIButton *)sender {
    if (self.hdServiceBlock) {
        self.hdServiceBlock(sender);
    }
    [self removeFromSuperview];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//
//    if (CGRectContainsPoint(self.listView.frame, point) || CGRectContainsPoint(self.viewRect, point)) {
//        
//        return [super hitTest:point withEvent:event];
//    }
//    [self removeFromSuperview];
//
//    return nil;
//}


+ (void)showMakeSureViewAroundView:(UIView *)view viewType:(HDServiceDealViewType)type  direction:(UIPopoverArrowDirection)direction titleArr:(NSArray *)titleArr  first:(void(^)())custom second:(void(^)())material three:(void (^)())three four:(void (^)())four
{
    CGRect viewRect = [view convertRect:view.bounds toView:KEY_WINDOW];
    CGRect listViewRect;
    switch (direction) {
        case UIPopoverArrowDirectionUp:
            listViewRect = CGRectMake(CGRectGetMinX(viewRect), CGRectGetMinY(viewRect) - 129.5, CGRectGetWidth(viewRect), 129.5);
            break;
        case UIPopoverArrowDirectionDown:
            listViewRect = CGRectMake(CGRectGetMinX(viewRect), CGRectGetMinY(viewRect) - 130, 130, 129.5);
            break;
        case UIPopoverArrowDirectionLeft:
            listViewRect = CGRectMake(CGRectGetMinX(viewRect), CGRectGetMinY(viewRect) - 130, 130, 129.5);
            break;
        case UIPopoverArrowDirectionRight:
            listViewRect = CGRectMake(CGRectGetMinX(viewRect), CGRectGetMinY(viewRect) - 130, 130, 129.5);
            break;
            
        default:
            break;
    }
    
    HDServiceDealView *dealView = [[HDServiceDealView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    dealView.viewRect = viewRect;
    if (titleArr.count == 3) {
        dealView.titleView.hidden = NO;
        dealView.titleLb.text = titleArr.firstObject;
        dealView.rightLb.text = titleArr[1];
        dealView.leftLb.text = titleArr.lastObject;
    }else if (titleArr.count == 2) {
        dealView.rightLb.text = titleArr.firstObject;
        dealView.leftLb.text = titleArr.lastObject;
    }
    dealView.listView.frame = listViewRect;
    dealView.hdServiceBlock = ^(UIButton *button) {
        if (button.tag == 1) {
            if (custom) {
                custom();
            }
        }else if(button.tag == 2)
        {
            if (material) {
                material();
            }
        }
        else if (button.tag == 3)
        {
            if (three) {
                three();
            }
        }
        else if (button.tag == 4)
        {
            if (four)
            {
                four();
            }
        }
    };
    
    if (type == HDServiceDealViewTechinian)
    {
        dealView.normalView.hidden = YES;
        dealView.specialView.hidden = NO;
        dealView.listView.hidden = NO;
        dealView.threehandleView.hidden = YES;
    }
    else if(type == HDServiceDealViewNormal)
    {
        dealView.normalView.hidden = NO;
        dealView.specialView.hidden = YES;
        dealView.listView.hidden = NO;
        dealView.threehandleView.hidden = YES;
    }
    else if (type == HDServiceDealViewThreeHandle)
    {
        dealView.listView.hidden = YES;
        dealView.threehandleView.hidden = NO;
    }
    else if (type == HDServiceDealViewToTechAndSpare)
    {
        dealView.listView.hidden = YES;
        dealView.threehandleView.hidden = NO;
        dealView.threeFirstLine.hidden = YES;
        dealView.threeConfirmView.hidden = YES;
        dealView.threehandleView.backgroundColor = [UIColor clearColor];
        // 技师蓝色
        dealView.threeTechLabel.textColor = MAIN_BLUE;
        dealView.threeTechLeftImageView.image = [UIImage imageNamed:@"hd_service_to_left_sure.png"];
    }
    else if (type == HDServiceDealViewThreeHandleEnterGuarantee || type == HDServiceDealViewThreeHandleCheckGuarantee)
    {
        dealView.listView.hidden = YES;
        dealView.threehandleView.hidden = NO;
        dealView.threeFirstLabel.text = titleArr[0];
        dealView.threeFirstImageView.image = nil;
        [dealView.threeFirstLabel sizeToFit];
        dealView.threeFirstLabel.center = dealView.threeFirstLabel.superview.center;
        
        // 保修审批加✔️
        if (type ==  HDServiceDealViewThreeHandleCheckGuarantee)
        {
            dealView.threeFirstImageView.frame = CGRectMake(10, 12, 15, 15);
            dealView.threeFirstLabel.frame = CGRectMake(40, 0, 95, 42.5);
            dealView.threeFirstImageView.image = [UIImage imageNamed:@"work_list_29.png"];
        }
    }
    else if (type == HDServiceDealViewToSeviceAndTech)
    {
        dealView.listView.hidden = YES;
        dealView.threehandleView.hidden = NO;
        dealView.threeFirstLine.hidden = YES;
        dealView.threeConfirmView.hidden = YES;
        dealView.threehandleView.backgroundColor = [UIColor clearColor];
        // 服务
        dealView.threeTechLabel.textColor = MAIN_BLUE;
        dealView.threeTechLabel.text = titleArr[0];
        CGRect frame1 = dealView.threeThreeLabel.frame;
        frame1.origin.x = 10;
        dealView.threeTechLabel.frame = frame1;
        
        dealView.threeTechLeftImageView.frame = CGRectMake(105, 11.5, 15, 15);
        dealView.threeTechLeftImageView.image = [UIImage imageNamed:@"hd_service_to_right_custom_sure"];
        
        dealView.threeThreeLabel.textColor = MAIN_RED;
        dealView.threeThreeLabel.text = titleArr[1];
    }
    else if (type == HDServiceDealViewFourHandleEnterGuarantee)
    {
        dealView.listView.hidden = YES;
        dealView.threehandleView.hidden = YES;
        dealView.fourHandleView.hidden = NO;
        dealView.fourFirstLabel.text = titleArr[0];
        dealView.fourFirstImageView.image = nil;
    }
    else if (type == HDServiceDealViewFourHandleCheckGuarantee)
    {
        dealView.listView.hidden = YES;
        dealView.threehandleView.hidden = YES;
        dealView.fourHandleView.hidden = NO;
        dealView.fourFirstLabel.text = titleArr[0];
    }
    [HD_FULLView endEditing:YES];
    [HD_FULLView addSubview:dealView];
}
- (IBAction)backgroundButtonAction:(id)sender {
    [self removeFromSuperview];
}

@end
