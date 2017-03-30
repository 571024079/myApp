//
//  HDPreCheckCommonCollectionCell.m
//  HandleiPad
//
//  Created by 程凯 on 2017/3/2.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDPreCheckCommonCollectionCell.h"
#import "HDPreCheckCommonCellDetailCell.h"//内容详情 cell
#import "HDPreCheckModel.h"

@interface HDPreCheckCommonCollectionCell ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HDPreCheckCommonCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置一圈的边界
    self.contentView.layer.borderColor = PRECHECK_BORDER_COLOR.CGColor;
    self.contentView.layer.borderWidth = 0.5;
    
    //设置列表视图的代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _mySlider.minimumTrackTintColor = [UIColor clearColor];
    _mySlider.maximumTrackTintColor = [UIColor clearColor];
    _mySlider.thumbTintColor = [UIColor clearColor];
    
    //给滚动条添加点击的手势
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderClickAction:)];
    [_mySlider addGestureRecognizer:tapG];
    
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [_tableView reloadData];
}

- (void)setWohasfuel:(NSNumber *)wohasfuel {
    _wohasfuel = wohasfuel;
    if ([_wohasfuel integerValue]) {
        _mySlider.value = (12.5 * _wohasfuel.integerValue) * 0.01;
        [self setOilMeterImageWithSlider:_mySlider];
    }
}


#pragma mark - 油表图片操作
//滑动
- (IBAction)sliderSlideAction:(UISlider *)sender {
    if ([_viewForm integerValue] == 1) {
        return;
    }
    [self setOilMeterImageWithSlider:sender];
    
    NSInteger value = [self numberOfSliderValue:_mySlider];
    if (_wohasfuelBlock) {
        _wohasfuelBlock(@(value));
    }
}
//点击
- (void)sliderClickAction:(UITapGestureRecognizer *)tapG {
    
    if ([_viewForm integerValue] == 1) {
        return;
    }
    
    CGPoint location = [tapG locationInView:_mySlider];
    CGFloat scale = location.x / _mySlider.bounds.size.width;
    _mySlider.value = scale;
    
    [self setOilMeterImageWithSlider:_mySlider];
    
    
    NSInteger value = [self numberOfSliderValue:_mySlider];
    if (_wohasfuelBlock) {
        _wohasfuelBlock(@(value));
    }
}
//设置油表的图片
- (void)setOilMeterImageWithSlider:(UISlider *)sender {
    
    NSInteger value = [self numberOfSliderValue:sender];
    NSString *imageName = [NSString stringWithFormat:@"oilMeter_%ld", value];
    _topImageView.image = [UIImage imageNamed:imageName];
    
}

- (NSInteger)numberOfSliderValue:(UISlider *)slider {
    CGFloat value = slider.value;
    if (value <= 0) {
        return 0;
    }else if (value > 0 && value <= 0.125) {
        return 1;
    }else if (value > 0.125 && value <= 0.25) {
        return 2;
    }else if (value > 0.25 && value <= 0.375) {
        return 3;
    }else if (value > 0.375 && value <= 0.5) {
        return 4;
    }else if (value > 0.5 && value <= 0.625) {
        return 5;
    }else if (value > 0.625 && value <= 0.75) {
        return 6;
    }else if (value > 0.75 && value <= 0.875) {
        return 7;
    }else {
        return 8;
    }
}


#pragma mark - TableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDPreCheckCommonCellDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commonCellDetailCell"];
//    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDPreCheckCommonCellDetailCell" owner:self options:nil] objectAtIndex:0];
//    }
    cell.viewForm = _viewForm;
    if (indexPath.row == 0) {//设置标题 cell
        cell.titleView.hidden = NO;
        cell.dataView.hidden = YES;
    }else {
        cell.titleView.hidden = YES;
        cell.dataView.hidden = NO;
        
        
        PreCheckItem *item = _dataSource[indexPath.row - 1];
        cell.contentLb.text = item.hpcmname;
        cell.contentLb.textColor = [item.hpcmcolor integerValue] == 2 ? MAIN_RED : [UIColor blackColor];
        cell.hpcistate = item.hpcistate;
        WeakObject(self)
        WeakObject(cell)
        cell.selectBtnBlock = ^(SelectButtonType selectBtnType) {
            NSIndexPath *indexCell = [tableView indexPathForCell:cellWeak];
            PreCheckItem *itemCell = selfWeak.dataSource[indexCell.row - 1];
            itemCell.hpcistate = @(selectBtnType);
            if (selfWeak.saveCellDataBlock) {
                selfWeak.saveCellDataBlock(selfWeak.dataSource);
            }
        };
        
        
    }
    
    return cell;
}





@end
