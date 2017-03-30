//
//  PorscheTwoStageListhView.m
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheTwoStageListhView.h"
#import "PorscheMultipleListTableViewCell.h"

@interface PorscheTwoStageListhView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *subTableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation PorscheTwoStageListhView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UITableView *)subTableView {
    
    if (!_subTableView) {
        _subTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 100, 100, 100) style:UITableViewStylePlain];
        _subTableView.delegate = self;
        _subTableView.dataSource = self;
        _subTableView.separatorColor = Color(24, 25, 17);
        _subTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _subTableView;
}

+ (void)showSingleListViewFrom:(UIView *)view dataSource:(NSArray<PorscheConstantModel *> *)dataSource selected:(NSString *)selected showArrow:(BOOL)showArrow direction:(ListViewDirection)direction complete:(PorscheSingleListhViewClickBlock)complete {
    
    [super showSingleListViewFrom:view dataSource:dataSource selected:selected showArrow:showArrow direction:direction complete:NULL];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PorscheMultipleListTableViewCell *cell = [PorscheMultipleListTableViewCell cellWithTableVIew:tableView];
    cell.contentView.backgroundColor = MAIN_BLUE;
    PorscheConstantModel *model = self.dataSource[indexPath.row];
    cell.contentLabel.text = model.cvvaluedesc;
    cell.arrow.hidden = YES;
    cell.mutltiple = NO;
    cell.select = NO;

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
