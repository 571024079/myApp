//
//  HDSingalSelectView.m
//  HandleiPad
//
//  Created by Handlecar on 16/11/3.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSingleSelectView.h"
@interface HDSingleSelectView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation HDSingleSelectView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configTableView];
}

+ (HDSingleSelectView *)loadSingleSelectViewWithOrigin:(CGPoint)point
{
    HDSingleSelectView *view = [[[NSBundle mainBundle] loadNibNamed:@"HDSingleSelectView" owner:nil options:nil] objectAtIndex:0];
    CGRect frame = view.frame;
    frame.origin = point;
    view.frame = frame;
    return view;
}

- (void)configTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
}


- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *printTypereuseStr = @"printType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:printTypereuseStr];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:printTypereuseStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 164, 42)];
        
        titleLabel.textColor = MAIN_BLUE;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.tag = 333;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:titleLabel];
        
        UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(10, cell.bounds.size.height - 1, 144, 1)];
        line.backgroundColor = [UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1];
        [cell.contentView addSubview:line];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:333];
    titleLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectFinishedBlock) {
        _selectFinishedBlock(indexPath.row);
    }
}

- (void)dealloc
{
    NSLog(@"HDSingleSelectView 销毁了");
}


@end
