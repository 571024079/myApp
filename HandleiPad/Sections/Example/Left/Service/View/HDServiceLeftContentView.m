//
//  HDServiceLeftContentView.m
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceLeftContentView.h"
#import "KandanLeftTableViewCell.h"
#import "HDLeftListModel.h"
#import "HDLeftSingleton.h"

@interface HDServiceLeftContentView ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
//选中index
@property (nonatomic, assign) NSInteger selectedRow;
//滚动图标
@property (weak, nonatomic) IBOutlet UIView *labelGView;
@property (nonatomic, assign) BOOL isSelect;
//含有不再厂数据的数组
@property (nonatomic, strong) NSMutableArray *stayListDataSource;

@end

@implementation HDServiceLeftContentView
- (instancetype)initWithCustomFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceLeftContentView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"KandanLeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"KandanLeftTableViewCellid"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectedRow = -1;
    
    _labelGViewHeight.constant = 0;
    
    return self;
}


- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
    if (dataSource.count > 0 && [_viewStatus integerValue] == 1) {
        _selectedRow = 0;
        PorscheNewCarMessage *data = _dataSource[0];
        //更新数据通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:SERVICE_LEFT_DETAIL_DATASOURCE_NOTIFINATION object:@{@"status":@"selectCell", @"data": data}];
        [[HDLeftSingleton shareSingleton] reloadServiceHistoryViewFromLeft:@{@"status":@"selectCell", @"data": data}];
    }
    
    if (_dataSource.count < 9) {
        _labelGViewHeight.constant = 0;
    }else {
        _labelGViewHeight.constant = (9 / (_dataSource.count * 1.0)) * CGRectGetHeight(_tableView.frame);
//        _labelGView.frame = [self setLabelGViewFrame];
    }
    [_tableView reloadData];
}

#pragma mark - 滚动联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        
        CGFloat offSetY = scrollView.contentOffset.y;
        
        CGFloat labelGViewCurrentY = 0;
        if (offSetY > 0)
        {
            CGFloat labelGViewScale = offSetY /(scrollView.contentSize.height - scrollView.bounds.size.height);
            
            labelGViewCurrentY = labelGViewScale * (_tableView.frame.size.height - self.labelGView.bounds.size.height);
        }
        
        if ((labelGViewCurrentY + self.labelGView.bounds.size.height) >= _tableView.frame.size.height)
        {
            labelGViewCurrentY =_tableView.bounds.size.height - self.labelGView.bounds.size.height;
        }
        
        if (labelGViewCurrentY < 0)
        {
            labelGViewCurrentY = 0;
        }
        
        self.labelGViewTopHeight.constant = labelGViewCurrentY;
        
//        p = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.size.height);// 计算当前偏移的Y在总滚动长度的比例
//        CGFloat height = CGRectGetHeight(_tableView.frame) - _labelGViewHeight.constant;
//        if ((p * height) < (CGRectGetHeight(self.tableView.frame) - _labelGViewHeight.constant) && p > 0) {
//            _labelGView.frame = CGRectMake(self.frame.size.width - 5, p * height, 5, _labelGViewHeight.constant);
//        }else if (p > 0 && (p * height) > (CGRectGetHeight(self.tableView.frame) - _labelGViewHeight.constant)){
//            _labelGView.frame = CGRectMake(self.frame.size.width - 5, CGRectGetHeight(self.tableView.frame) - _labelGViewHeight.constant, 5, _labelGViewHeight.constant);
//        }else if (p < 0) {
//            _labelGView.frame = CGRectMake(self.frame.size.width - 5, 0, 5, _labelGViewHeight.constant);
//        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        if (scrollView.contentOffset.y <= 0) {
            CGPoint point = scrollView.contentOffset;
            point.y = 0;
            scrollView.contentOffset = point;
        }
    }
}


- (CGRect)setLabelGViewFrame {
    CGRect frame = _labelGView.frame;
//    
//    CGFloat p = _tableView.contentOffset.y / (_tableView.contentSize.height - _tableView.frame.size.height);// 计算当前偏移的Y在总滚动长度的比例
//    CGFloat height = CGRectGetHeight(_tableView.frame) - _labelGViewHeight.constant;
//    frame.origin.y = p * height;
    frame.size.height = _labelGViewHeight.constant;
    
    return frame;
}


#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KandanLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KandanLeftTableViewCellid" forIndexPath:indexPath];
    
    [cell setShadow];
    //默认颜色 --保养，内联图标
    [cell setImage:@"" color:nil];
    
    if (!cell) {
        NSArray *nibCells = [[NSBundle mainBundle] loadNibNamed:@"KandanLeftTableViewCell" owner:nil options:nil];
        cell = [nibCells objectAtIndex:0];
        
    }
    PorscheNewCarMessage *data = _dataSource[indexPath.section];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.carNumberLb.textColor = [UIColor blackColor];
    cell.carCategoryLb.textColor = [UIColor blackColor];
    cell.shadowSuperView.backgroundColor = [UIColor whiteColor];
    
    
    cell.carNumberLb.text = [NSString stringWithFormat:@"%@%@", data.plateplace, data.ccarplate];
    cell.carCategoryLb.text = [NSString stringWithFormat:@"%@ %@", data.ccarcatena, data.ccarmodel];
    
    
    [cell setCellStyleForData:data withSelect:NO];
    if (indexPath.section == _selectedRow) {
        
        cell.carNumberLb.textColor = [UIColor whiteColor];
        cell.carCategoryLb.textColor = [UIColor whiteColor];
        cell.shadowSuperView.backgroundColor = MAIN_BLUE;
        
        [cell setCellStyleForData:data withSelect:YES];
        
    }
    [cell layoutIfNeeded];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRow = indexPath.section;
    PorscheNewCarMessage *data = _dataSource[indexPath.section];
    
//    [HDStoreInfoManager shareManager].carorderid = data.orderid;
    //更新数据通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:SERVICE_LEFT_DETAIL_DATASOURCE_NOTIFINATION object:@{@"status":@"selectCell", @"data": data}];
    [[HDLeftSingleton shareSingleton] reloadServiceHistoryViewFromLeft:@{@"status":@"selectCell", @"data": data}];

    
    [tableView reloadData];
}

@end
