//
//  PorscheWebViewController.m
//  HandleiPad
//
//  Created by Robin on 16/11/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheWebViewController.h"
#import "HDNetworkTableViewCell.h"
@interface PorscheWebViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<PorscheConstantModel *> *dataSource;
@end

@implementation PorscheWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:WEBLIST_DISAPPEAR_NOTIFICATION object:nil];
    
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataURL];
    }
    return _dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDNetworkTableViewCell *cell = [HDNetworkTableViewCell cellWithTableView:tableView];
    PorscheConstantModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.cvvaluedesc;
    cell.webLabel.text = model.extrainfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSURL*url=[NSURL URLWithString:@"http://www.porsche.com"];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    };
    PorscheConstantModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    if (model.extrainfo.length)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WEB_URL_TAP_NOTIFICATION object:nil userInfo:@{@"URL":model.extrainfo}];
    }
    
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
