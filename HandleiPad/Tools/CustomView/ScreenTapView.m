//
//  ScreenTapView.m
//  HandleiPad
//
//  Created by Handlecar on 9/12/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "ScreenTapView.h"
extern NSString *const touchStartstr;
extern NSString *const touchMovedstr;
#define SideLength  20
#import "HDLeftSingleton.h"
@interface ScreenTapView ()<CAAnimationDelegate>

@end

@implementation ScreenTapView

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
    if (self)
    {
        self.touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SideLength, SideLength)];
        
        self.touchView.backgroundColor = [UIColor redColor];
        
        self.touchView.layer.cornerRadius = SideLength/2.0f;
        
        self.touchView.alpha = 0.7;
        
        [self addSubview:self.touchView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchStart:) name:touchStartstr object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchMoved:) name:touchMovedstr object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardWillHideNotification object:nil];

        self.userInteractionEnabled = NO;
        self.hidden = YES;
    }
    return self;
}
- (void)keyboardWillShow:(NSNotification *)notification{
    UIView *keyboardView = [self getKeyboardView];
    [self removeFromSuperview];
    [keyboardView addSubview:self];
}
- (void)keyboardDidHidden:(NSNotification *)notification{
    [self removeFromSuperview];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}
- (UIView *)getKeyboardView{
    UIView *result = nil;
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
//    NSLog(@"%ld",((UIWindow *)windowsArray[2]).windowLevel);
    for (UIView *tmpWindow in windowsArray) {
        //        NSArray *viewArray = [tmpWindow subviews];
        //        for (UIView *tmpWindow  in viewArray) {
        if ([[NSString stringWithUTF8String:object_getClassName(tmpWindow)] isEqualToString:@"UIRemoteKeyboardWindow"]) {
            result = tmpWindow;
            break;
        }
        //        }
        
        if (result != nil) {
            break;
        }
    }
    
    return result;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchStart:(NSNotification *)notification
{
//    NSLog(@"点击开始");
    
    UIEvent *event=[notification.userInfo objectForKey:@"event"];
    CGPoint pt = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:nil];
    
    self.touchView.center = pt;
    
    
    [self tapAnimation];
}


- (void)touchMoved:(NSNotification *)notification
{
//    NSLog(@"点击移动");
    UIEvent *event=[notification.userInfo objectForKey:@"event"];
    CGPoint pt = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:self];
    self.touchView.center = pt;
}

- (void)tapAnimation
{
    CATransition *ca = [[CATransition alloc] init];
    ca.duration = 0.5f;
    ca.delegate = self;
    ca.timingFunction = UIViewAnimationCurveEaseInOut;
    ca.type = kCATransitionFade;//@"rippleEffect";
//    ca.subtype = kCATransitionFromTop;
    [self.touchView.layer addAnimation:ca forKey:@"touch"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.touchView.layer removeAnimationForKey:@"touch"];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return nil;
}

@end
