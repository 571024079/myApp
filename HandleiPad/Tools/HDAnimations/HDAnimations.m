//
//  HDAnimations.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/2.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDAnimations.h"

typedef NS_ENUM(NSInteger, HDAnimationStyle) {
    HDAnimationStyleScale = 1,
    HDAnimationStyleRotate,
    HDAnimationStyleopacity,
    HDAnimationStyleposition,
    HDAnimationStylebackground,
    
};

@implementation HDAnimations


+ (void)AnimationWithView:(UIView *)view style:(NSArray <NSNumber *>*)styleArray {
    
    
    
    

    if (styleArray.count > 0) {//组合动画
        NSString * groupKey = NSStringFromClass(view.class);
        
        NSMutableArray *animationArray = [NSMutableArray array];
        
        for (NSNumber * tmpNum in styleArray) {
            switch ([tmpNum integerValue]) {
                case 1:
                    [animationArray addObject:[HDAnimations scaleAnimation]];
                    
                    [groupKey stringByAppendingString:[NSString stringWithFormat:@"%@-",tmpNum]];
                    break;
                case 2:
                    [animationArray addObject:[HDAnimations rotateAnimation]];
                    [groupKey stringByAppendingString:[NSString stringWithFormat:@"%@-",tmpNum]];

                    break;
                case 3:
                    [animationArray addObject:[HDAnimations opacityAnimation]];
                    [groupKey stringByAppendingString:[NSString stringWithFormat:@"%@-",tmpNum]];

                    break;
                case 4:
                    [animationArray addObject:[HDAnimations positionAnimation]];
                    [groupKey stringByAppendingString:[NSString stringWithFormat:@"%@-",tmpNum]];

                    break;
                case 5:
                    [animationArray addObject:[HDAnimations backgroundAnimation]];
                    [groupKey stringByAppendingString:[NSString stringWithFormat:@"%@-",tmpNum]];

                    break;
                    
                default:
                    break;
            }
        }
        
        if (animationArray.count > 1) {
            CAAnimationGroup *group = [CAAnimationGroup new];
            group.duration = 1.0f;
            
            [view layoutIfNeeded];
            group.animations = animationArray;
            
            
            [view.layer addAnimation:group forKey:groupKey];

        }else if (animationArray.count == 1) {
            [view layoutIfNeeded];

            [view.layer addAnimation:animationArray.firstObject forKey:groupKey];
        }
    }
    
}

//缩放
+ (CABasicAnimation *)scaleAnimation {
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//同上
    anima.fromValue = [NSNumber numberWithFloat:0.0f];
    anima.toValue = [NSNumber numberWithFloat:1.0f];
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    anima.duration = 1.0f;
    
    return anima;
}
//旋转
+ (CABasicAnimation *)rotateAnimation {
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.toValue = [NSNumber numberWithFloat:2 *M_PI];
    anima.duration = 1.0f;
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    
    return anima;
}

//透明度
+ (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:0.0f];
    anima.toValue = [NSNumber numberWithFloat:1.0f];
    anima.duration = 1.5f;
    
    return anima;
}
//位移
+ (CABasicAnimation *)positionAnimation {
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    anima.duration = 1.0f;
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    //anima.fillMode = kCAFillModeForwards;
    //anima.removedOnCompletion = NO;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return anima;
}
//背景色变化
+ (CABasicAnimation *)backgroundAnimation {
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    
    anima.toValue =(id) [UIColor greenColor].CGColor;
    anima.duration = 1.0f;
    
    return anima;
}




@end
