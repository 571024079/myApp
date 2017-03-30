//
//  ProjectDetailTableView.m
//  KeyBoardDemo
//
//  Created by Robin on 2016/10/15.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "ProjectDetailTableView.h"
#import "ProjectDetialEditTableViewCell.h"
#import "ProjectDetialWorkHourEditTableViewCell.h"
#import "ProjectDetailPlanHeaderView.h"

@interface ProjectDetailTableView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;//显示更多的 label

//工时model数据源
//@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) NSArray *speraArray;
@property (nonatomic, strong) NSArray *workHourArray;
@end
@implementation ProjectDetailTableView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tableView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.tableView.layer.cornerRadius = 4;
    self.tableView.clipsToBounds = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView cellType:(MaterialTaskTimeDetailsType)cellType {
    
    ProjectDetailTableView *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectDetailTableView"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailTableView" owner:nil options:nil] lastObject];

    }
    cell.cellType = cellType;
    return cell;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView workHours:(NSArray *)workHourArray speras:(NSArray *)speraArray cellType:(MaterialTaskTimeDetailsType)cellType{
    
    ProjectDetailTableView *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectDetailTableView"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectDetailTableView" owner:nil options:nil] lastObject];
        
    }
    cell.speraArray = speraArray;
    cell.workHourArray = workHourArray;
    cell.cellType = cellType;
    if ((cell.speraArray.count + cell.workHourArray.count) > 4) {
        cell.moreLabel.hidden = NO;
    }else {
        cell.moreLabel.hidden = YES;
    }
    return cell;
}

- (void)setEditCell:(BOOL)editCell {
    
    _editCell = editCell;
    
    [self.tableView reloadData];
}

- (void)setCellType:(MaterialTaskTimeDetailsType)cellType {
    
    _cellType = cellType;
}


#pragma mark - UItableVIewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.speraArray.count + self.workHourArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (self.cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
            return 44;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    switch (self.cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            ProjectDetailPlanHeaderView *headerView = [ProjectDetailPlanHeaderView headerWithTableView:tableView withSchemeModel:self.schemeModel];
            headerView.editType = self.editCell;
            return headerView;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MaterialTaskTimeDetailsType type = _cellType;

    switch (type) {
        case MaterialTaskTimeDetailsTypeScheme: //方案库详情
        {
            ProjectDetialEditTableViewCell *cell = [ProjectDetialEditTableViewCell cellWithTableView:tableView];
            cell.isFromNotice = self.isFromNotice;

            if (indexPath.row < self.workHourArray.count) {
                cell.type = MaterialTaskTimeDetailsTypeWorkHours;
                cell.hoursModel = self.workHourArray[indexPath.row];
            } else {
                cell.type = MaterialTaskTimeDetailsTypeMaterial;
                cell.speraModel = self.speraArray[indexPath.row - self.workHourArray.count];
            }
            cell.detailType = MaterialTaskTimeDetailsTypeScheme;
            cell.editCell = self.editCell;
            return cell;

        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial: //备件库详情
        {
            //这个类改成了备件样式
            ProjectDetialWorkHourEditTableViewCell *cell = [ProjectDetialWorkHourEditTableViewCell cellWithTableView:tableView];
            cell.speraModel = self.speraArray.firstObject;
            cell.editCell = self.editCell;
            cell.newCell  = self.new_object;
            return cell;
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours: //工时库详情
        {
            ProjectDetialEditTableViewCell *cell = [ProjectDetialEditTableViewCell cellWithTableView:tableView];
            cell.type = type;
            PorscheSchemeWorkHourModel *workhourModel= self.workHourArray[indexPath.row];
            cell.detailType = type;
            cell.hoursModel = workhourModel;
            cell.editCell = self.editCell;
            cell.newCell  = self.new_object;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
