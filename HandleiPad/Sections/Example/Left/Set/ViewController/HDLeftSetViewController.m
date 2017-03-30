//
//  HDLeftSetViewController.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftSetViewController.h"

@interface HDLeftSetViewController ()

@end

@implementation HDLeftSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *keepOutLabel = [[UILabel alloc] init];
    keepOutLabel.frame = CGRectMake(364 / 2 - 100, CGRectGetHeight(self.view.frame) / 2 - 20, 200, 40);
    keepOutLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightThin];
    keepOutLabel.textAlignment = NSTextAlignmentCenter;
    keepOutLabel.textColor = [UIColor blackColor];
    keepOutLabel.text = @"暂无信息";
    
    [self.view addSubview:keepOutLabel];
    
    
    // Do any additional setup after loading the view.
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
