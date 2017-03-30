//
//  BaseViewController.m
//  TableViewDrag
//
//  Created by OS X EI Capitan on 16/8/23.
//  Copyright © 2016年 OrangeCheng. All rights reserved.
//

#import "BaseViewController.h"

#import "HDLeftSingleton.h"
//extern NSString *const touchStartstr;


@interface BaseViewController ()



@end

@implementation BaseViewController

- (void)dealloc {
//    NSLog(@"BaseViewController.dealloc");
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [HDLeftSingleton shareSingleton].rightVC = self;
//    [self settabbarViewAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [HDLeftSingleton shareSingleton].rightVC = nil;

}
//- (void)settabbarViewAnimation {
//    
//    CATransition* animation = [CATransition animation];
//    [animation setDuration:0.3f];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromTop];
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [self.view.layer addAnimation:animation forKey:@"switchView"];
//}

//- (void)touchStart:(NSNotification *)notification {
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchStart:) name:touchStartstr object:nil];
}

- (void)baseReloadData {
    
}

#pragma mark - 处理数字，添加逗号
- (NSString *)setStringStyleWithNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style {
    NSString *string = @"";
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:style];
    string = [currencyFormatter stringFromNumber:number];
    if ([[string substringToIndex:1] isEqualToString:@"$"]) {
        string = [NSString stringWithFormat:@"￥%@", [string substringFromIndex:1]];
    }
    return string;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
