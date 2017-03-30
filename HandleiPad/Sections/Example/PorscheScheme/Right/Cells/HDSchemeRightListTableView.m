//
//  HDSchemeRightListTableView.m
//  HandleiPad
//
//  Created by Robin on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSchemeRightListTableView.h"
#import "HDSchemeRightListTableViewCell.h"
//#import "MaterialRightModel.h"
#import "HDPoperDeleteView.h"
#import "PorscheCarModel.h"
#import "MaterialTaskTimeDetailsView.h"

@interface HDSchemeRightListTableView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) HDPoperDeleteView *popDeleteView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *addSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightLayout;
@property (weak, nonatomic) IBOutlet UIView *cutView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cutViewHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLabelWidthLayout;

@end

@implementation HDSchemeRightListTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewWithNibdataSource:(NSMutableArray *)dataSoure addSource:(NSMutableArray *)addSource{
    
    HDSchemeRightListTableView *view = [[[NSBundle mainBundle] loadNibNamed:@"HDSchemeRightListTableView" owner:nil options:nil] lastObject];
    
    view.dataArray = dataSoure;
    view.addSource = addSource;
    
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addRefreshView];
}

- (void)setHiddenBottomView:(BOOL)hiddenBottomView {
    _hiddenBottomView = hiddenBottomView;
    
    if (hiddenBottomView) {
        self.topViewHeightLayout.constant = self.frame.size.height;
        self.cutViewHeightLayout.constant = 0;
        self.selectLabelWidthLayout.constant = 0;
        self.cutView.hidden = YES;
    }
}

- (void)addRefreshView {
    
    __weak typeof(self)weakself = self;
    self.topTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (weakself.loadDataBlock) {
            weakself.loadDataBlock(NO);
        }
    }];
    
    self.topTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakself.loadDataBlock) {
            weakself.loadDataBlock(YES);
        }
    }];
}

- (void)refreshTableViewWithDataSource:(NSMutableArray *)dataSource {
    
    self.dataArray = dataSource;
    
    [self.topTableView reloadData];
    [self.bottomTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _topTableView) {

        return self.dataArray.count;
    } else {
        
        return self.addSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HDSchemeRightListTableViewCell *cell = [HDSchemeRightListTableViewCell cellWithTableView:tableView];
    cell.hiddenSelected = self.hiddenBottomView;
    __weak typeof(self)weakself = self;
    if (tableView == self.topTableView) {
        cell.model = self.dataArray[indexPath.row];
         PorscheSchemeModel *model = self.dataArray[indexPath.row];
        cell.cellSelected = NO;
        for (PorscheSchemeModel * schemeModel in self.addSource) {
            if (schemeModel.schemeid.integerValue == cell.model.schemeid.integerValue) {
                cell.cellSelected = YES;
            }
        }
        
        WeakObject(cell);
        cell.chickBlock = ^() {
            if (cellWeak.cellSelected) {
                WeakObject(self);
                [HDPoperDeleteView showAlertViewAroundView:cellWeak.chickButton titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
//                    PorscheSchemeModel *model = weakself.dataArray[indexPath.row];
                    [selfWeak removeSourceWithModel:model];
                } refuse:^{
                    
                } cancel:^{
                    
                }];
            } else {
                [self addSourceWithModel:cellWeak.model];
            }
        };
        
        cell.longTapBlock = ^() {
            
            [weakself showSchemeView:cellWeak.model];
        };
    } else {
        cell.deleteButton = YES;
        cell.model = self.addSource[indexPath.row];
        PorscheSchemeModel *model = self.addSource[indexPath.row];
        WeakObject(cell);
        cell.chickBlock = ^() {
            WeakObject(self);
            [HDPoperDeleteView showAlertViewAroundView:cellWeak.chickButton titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
//                PorscheSchemeModel *model = weakself.dataArray[indexPath.row];
                [selfWeak removeSourceWithModel:model];
            } refuse:^{
                
            } cancel:^{
                
            }];
        };
    }
    return cell;
}

-(void)showSchemeView:(PorscheSchemeModel *)model {
    
    WeakObject(self);
    [MaterialTaskTimeDetailsView showWithID:model.schemeid.integerValue detailType:MaterialTaskTimeDetailsTypeScheme clickAction:^(DetailViewBackType backType,NSInteger detailId, id responderModel) {
        if (backType == DetailViewBackTypeJoinWorkOrder) {
            
            [selfWeak addSourceWithModel:model];
        }
    }];
}

- (void)removeSourceWithModel:(PorscheSchemeModel *)model {
    [self.addSource enumerateObjectsUsingBlock:^(PorscheSchemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.schemeid.integerValue == model.schemeid.integerValue) {
            [self.addSource removeObject:obj];
        }
    }];
    
    [self.topTableView reloadData];
    [self.bottomTableView reloadData];
    
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}

- (void)addSourceWithModel:(PorscheSchemeModel *)model {
    [self.addSource addObject:model];
    [self.topTableView reloadData];
    [self.bottomTableView reloadData];
    
        if (self.refreshBlock) {
            self.refreshBlock();
        }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bottomTableView || self.hiddenBottomView) {
        return;
    }
    HDSchemeRightListTableViewCell *cell = (HDSchemeRightListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    PorscheSchemeModel *model = self.dataArray[indexPath.row];
    
    if (cell.cellSelected) {
        WeakObject(self);
        [HDPoperDeleteView showAlertViewAroundView:cell.chickButton titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionRight sure:^{
            PorscheSchemeModel *model;
            model = selfWeak.dataArray[indexPath.row];
            [selfWeak removeSourceWithModel:model];
        } refuse:^{
            
        } cancel:^{
            
        }];
        
        
    } else {
        [self addSourceWithModel:model];
    }
}

@end
