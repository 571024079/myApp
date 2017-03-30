//
//  HDPopSelectTableView.m
//  HandleiPad
//
//  Created by handlecar on 2017/3/10.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDPopSelectTableView.h"
#import "HDPopSelectTableViewCell.h"

@interface HDPopSelectTableView ()<UITableViewDelegate, UITableViewDataSource, HDPopSelectTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSMutableArray *dataSource;//列表数据

@end

@implementation HDPopSelectTableView
+ (instancetype)loadPopSelectTableViewWithDataArray:(NSArray *)dataSource {
    
    HDPopSelectTableView *thisView = [[[NSBundle mainBundle] loadNibNamed:@"HDPopSelectTableView" owner:self options:nil] objectAtIndex:0];
    thisView.dataSource = [dataSource mutableCopy];
    thisView.tableView.delegate = thisView;
    thisView.tableView.dataSource = thisView;
    thisView.tableView.scrollEnabled = NO;
    
    return thisView;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (_dataSource.count < 6) {
        _tableView.scrollEnabled = NO;
    }
    [_tableView reloadData];
}

#pragma mark - TableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HDPopSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popSelectTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDPopSelectTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    if (indexPath.row == _dataSource.count - 1) {
        cell.leftLine.hidden = YES;
        cell.rightLine.hidden = YES;
    }else {
        cell.leftLine.hidden = NO;
        cell.rightLine.hidden = NO;
    }
    
    NSString *contentStr = _dataSource[indexPath.row];
    cell.leftContentLb.text = contentStr;
    
    return cell;
}


#pragma mark - 实现Cell的Delegate
- (void)tableViewCellRightButtonActionWith:(UIButton *)button withCell:(HDPopSelectTableViewCell *)thisCell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:thisCell];
    if (_selectCellButtonBlock) {
        _selectCellButtonBlock(indexPath.row);
    }
}



@end
