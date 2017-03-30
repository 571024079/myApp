//
//  HDWorkListTVHFView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/1.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListTVHFView.h"
#import <quartzcore/quartzcore.h>
@implementation HDWorkListTVHFView


//- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
//    if (self = [super initWithFrame:frame]) {
//        
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListTVHFView" owner:nil options:nil];
//        
//        self = [array objectAtIndex:0];
//        
//        [self layoutIfNeeded];
//        
//        [self drawDashLine:_itemLeftIamgeView lineLength:3 lineSpacing:1 lineColor:color];
//        
//        [self drawDashLine:_itemRightImageView lineLength:3 lineSpacing:1 lineColor:color];
//    }
//    return self;
//
//}

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListTVHFView" owner:nil options:nil];
    
    self.frame = frame;
    self = [array objectAtIndex:0];
    
    [self layoutIfNeeded];

    return self;
    
}

//- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
//    if (self.block) {
//        self.block(HeaderViewActionStyleLongPress);
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


- (IBAction)deleteServiceAction:(UIButton *)sender {
    
    if (self.block) {
        self.block(HeaderViewActionStyleDelete);
    }
}
@end
