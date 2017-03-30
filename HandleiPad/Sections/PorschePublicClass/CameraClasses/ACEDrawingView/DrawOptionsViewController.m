//
//  DrawOptionsViewController.m
//  CrameraDemo
//
//  Created by Robin on 16/9/22.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "DrawOptionsViewController.h"

@interface DrawOptionsViewController ()

@end

@implementation DrawOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 40)];
    label.backgroundColor = [UIColor grayColor];
    label.text = @"测试显示";
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
