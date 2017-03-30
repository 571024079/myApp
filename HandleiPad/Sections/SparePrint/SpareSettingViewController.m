//
//  SpareSettingViewController.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/22.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "SpareSettingViewController.h"
#import "SpareSettingTableViewCell.h"
#import "SpareSettingModel.h"
#import "PorscheMultipleListhView.h"
@interface SpareSettingViewController ()<UITableViewDelegate,UITableViewDataSource,SpareSettingTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSArray *spareInfo;
@end

@implementation SpareSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.contentView.layer.cornerRadius = 3;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.masksToBounds = YES;
//    [self getSpareList];
}

- (NSArray *)spareInfo
{
    // 备件
    NSArray *spareInfolist = [self.dataSource yy_modelToJSONObject];
    if (spareInfolist.count)
    {
        return spareInfolist;
    }
    return nil;
}

- (void)getSpareList
{//pdfPartsInfoDtos
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:self.view];
    [PHTTPRequestSender sendRequestWithURLStr:PRINT_SPARE_LIST parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
        [hud hideAnimated:YES];
        if (!error)
        {
            if (responser.status == 100)
            {
                // 获取备件列表
                NSArray *sparelistInfo = [responser.object objectForKey:@"pdfPartsInfoDtos"];
                
                NSMutableArray *spareArray = [NSMutableArray array];
                
                for (NSDictionary *info in sparelistInfo)
                {
                    SpareSettingModel *model = [SpareSettingModel yy_modelWithDictionary:info];
                    [spareArray addObject:model];
                }
                self.dataSource = spareArray;
                [_tableView reloadData];
                
            }
            else
            {
                
            }
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"spare";
    SpareSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpareSettingTableViewCell" owner:nil options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    
    SpareSettingModel *spare = [self.dataSource objectAtIndex:indexPath.row];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.spareNumberLabel.text = spare.partsno;
    cell.needCountLabel.text = spare.partsnum;
    cell.spareDescriptionLabel.text = spare.pastdes;
    cell.orderTypeLabel.text = spare.ordrtype;
    
    return cell;
}

- (void)spareSettingTableViewCell:(SpareSettingTableViewCell *)cell orderTypeButtonClick:(id)sender
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    PorscheConstantModel *const1 = [[PorscheConstantModel alloc] init];
    const1.cvsubid = @1;
    const1.cvvaluedesc = @"VOR";
    
    PorscheConstantModel *const2 = [[PorscheConstantModel alloc] init];
    const2.cvsubid = @2;
    const2.cvvaluedesc = @"IO";
    
    PorscheConstantModel *const3 = [[PorscheConstantModel alloc] init];
    const3.cvsubid = @3;
    const3.cvvaluedesc = @"BO";
    
    SpareSettingModel *spare = [self.dataSource objectAtIndex:indexPath.row];

    [PorscheMultipleListhView showSingleListViewFrom:sender dataSource:@[const1,const2,const3] selected:nil showArrow:NO direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel,NSInteger idx) {
        spare.ordrtype = constantModel.cvvaluedesc;
        cell.orderTypeLabel.text = constantModel.cvvaluedesc;
        // 调用保存接口
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param hs_setSafeValue:spare.wospid forKey:@"wospid"];
        [param hs_setSafeValue:spare.ordrtype forKey:@"ordertype"];
        [PHTTPRequestSender sendRequestWithURLStr:SAVE_SPARE_LIST parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
            if (responser.status == 100)
            {
                
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)preViewAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(spareSettingViewController:printType:WithInfo:)])
    {
        [self.delegate spareSettingViewController:self printType:SparePrintTypePreView WithInfo:self.spareInfo];
    }
    [self closeVC];
}
- (IBAction)printAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(spareSettingViewController:printType:WithInfo:)])
    {
        [self.delegate spareSettingViewController:self printType:SparePrintTypePrint WithInfo:self.spareInfo];
    }
    [self closeVC];
}
- (IBAction)saveAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(spareSettingViewController:printType:WithInfo:)])
    {
        [self.delegate spareSettingViewController:self printType:SparePrintTypeSave WithInfo:self.spareInfo];
    }
    [self closeVC];

}
- (IBAction)cancelAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(spareSettingViewController:printType:WithInfo:)])
    {
        [self.delegate spareSettingViewController:self printType:SparePrintTypeNone WithInfo:self.spareInfo];
    }
    [self closeVC];
}

- (void)closeVC
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
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
