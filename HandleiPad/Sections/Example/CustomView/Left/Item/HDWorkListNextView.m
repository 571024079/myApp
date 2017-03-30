//
//  HDWorkListNextView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListNextView.h"

#import "HDWorkListNextViewTableViewCell.h"

@interface HDWorkListNextView ()<UITableViewDelegate,UITableViewDataSource>

@end

static NSString *HDWorkListNextViewCellIdentifier = @"HDWorkListNextViewTableViewCell";

@implementation HDWorkListNextView



- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListNextView" owner:self options:nil];
    self = [array objectAtIndex:0];
    self.frame = frame;
    
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListNextViewTableViewCell" bundle:nil] forCellReuseIdentifier:HDWorkListNextViewCellIdentifier];
    
    _tableView.showsVerticalScrollIndicator = NO;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    _tableView.bounces = YES;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _selectedRow = -1;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDWorkListNextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDWorkListNextViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListNextViewTableViewCell" owner:nil options:nil];
        
        cell = [array objectAtIndex:0];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.lightGrayView.hidden = NO;
    cell.lightGrayView.backgroundColor = ColorHex(0xc9c9c9);
    cell.backgroundColor = ColorHex(0xfafafa);
    
    cell.label.text = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.label.textColor = ColorHex(0x333000);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row == _selectedRow) {
        cell.lightGrayView.hidden = YES;

        
        cell.backgroundColor = ColorHex(0x850000);
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRow = indexPath.row;
    [tableView reloadData];
    [self removeFromSuperview];
    
    if (self.hdWorkListNextViewBlock) {
        self.hdWorkListNextViewBlock(self.dataArray[indexPath.row]);
    }
    
}




- (void)setupFrameWithView:(UIView *)aroundView direction:(HDWorkListNextViewDirectinStyle)direction height:(CGFloat)height {
    CGRect rect = [aroundView convertRect:aroundView.bounds toView:KEY_WINDOW];
    
    switch (direction) {
        case 1:
        {
            self.frame = CGRectMake(CGRectGetMinX(rect) - 10, CGRectGetMinY(rect) - height, CGRectGetWidth(rect)+20,height);
        }
            break;
        case 2:
        {
            self.frame = CGRectMake(CGRectGetMinX(rect) - CGRectGetWidth(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), height);
        }
            break;
        case 3:
        {
            self.frame = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetWidth(rect), height);
        }
            break;
        case 4:
        {
            self.frame = CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect),height);
        }
            break;
        default:
            break;
    }
}









/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
