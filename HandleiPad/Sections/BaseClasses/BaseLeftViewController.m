//
//  BaseLeftViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/12/29.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "BaseLeftViewController.h"
#import "HDLeftSingleton.h"

@interface BaseLeftViewController ()

@end

@implementation BaseLeftViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [HDLeftSingleton shareSingleton].leftVC = self;
    //    [self settabbarViewAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [HDLeftSingleton shareSingleton].leftVC = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)baseReloadData
{
    
}

- (void)baseReloadDataWithObject:(id)objc
{
    
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
