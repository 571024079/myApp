//
//  MaterialTimeGroupTableViewCell.m
//  MaterialDemo
//
//  Created by Robin on 16/9/28.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import "MaterialTimeGroupTableViewCell.h"

@interface MaterialTimeGroupTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *mainGroupBtn;
@property (weak, nonatomic) IBOutlet UIButton *subGroupBtn;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewWidthMup;

@property (nonatomic, strong) NSMutableArray *spareMainGroupArray; //备件主组数据源

@property (nonatomic, strong) NSMutableArray *workHourMainGroupArray; //工时主组数据源

@property (nonatomic, strong) NSMutableArray *workHourSubGroupArray; //工时子组数据源

@end

@implementation MaterialTimeGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.secondView.hidden = YES;
//    self.secondViewWidthMup.constant = - self.contentView.bounds.size.width/2 + 16;
}

- (NSMutableArray *)spareMainGroupArray {
    
    if (!_spareMainGroupArray) {
        
        _spareMainGroupArray = [[NSMutableArray alloc] initWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataPartsGroup]];
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
        model.cvvaluedesc = @"全部";
        [_spareMainGroupArray insertObject:model atIndex:0];
    }
    return _spareMainGroupArray;
}

- (NSMutableArray *)workHourMainGroupArray {
    
    if (!_workHourMainGroupArray) {
        _workHourMainGroupArray = [[NSMutableArray alloc] initWithArray:[[PorscheConstant shareConstant] getConstantListWithTableName:CoreDataWorkHourk]];
        PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
        model.cvvaluedesc = @"全部";
        [_workHourMainGroupArray insertObject:model atIndex:0];
    }
    return _workHourMainGroupArray;
}

- (NSMutableArray *)workHourSubGroupArray {
    
    [self.workHourMainGroupArray enumerateObjectsUsingBlock:^(PorscheConstantModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([(NSString *)obj.cvsubid isEqualToString:[PorscheRequestSchemeListModel shareModel].workhourgroupfuid]) {
            
            NSMutableArray *newconstantArray = [[NSMutableArray alloc] init];
            [obj.children enumerateObjectsUsingBlock:^(PorscheSubConstant * _Nonnull subobj, NSUInteger idx, BOOL * _Nonnull stop) {
               
                PorscheConstantModel *constant = [[PorscheConstantModel alloc] init];
                constant.cvsubid = subobj.cvsubid;
                constant.cvvaluedesc = subobj.cvvaluedesc;
                [newconstantArray addObject:constant];
                
            }];

            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            model.cvvaluedesc = @"全部";
            [newconstantArray insertObject:model atIndex:0];
            
            _workHourSubGroupArray = newconstantArray;
            
            *stop = YES;
        }
    }];
    
    return _workHourSubGroupArray;
}


- (void)setCellType:(MaterialTaskTimeDetailsType)cellType {
    
    _cellType = cellType;
    
    switch (cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
        {
            self.secondView.hidden = YES;
            self.secondViewWidthMup.constant = - self.contentView.bounds.size.width/2 + 16;
            
        }
            break;
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            self.secondView.hidden = YES;
            self.secondViewWidthMup.constant = - self.contentView.bounds.size.width/2 + 16;
            
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            
            
        }
            break;
        default:
            break;
    }
    //17-02-04 czz 要求清空操作
    if (![[PorscheRequestSchemeListModel shareModel].group_id integerValue] && ![[PorscheRequestSchemeListModel shareModel].workhourgroupfuid integerValue] && ![[PorscheRequestSchemeListModel shareModel].workhourgroupid integerValue]) {
        self.mainGroupTF.text = nil;
        self.subGroupTF.text = nil;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MaterialTimeGroupTableViewCell" owner:nil options:nil];
        self = [array objectAtIndex:0];
    }
    return self;
}
- (IBAction)mainGroupClick:(UIButton *)sender {
    switch (_cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
        case MaterialTaskTimeDetailsTypeMaterial:
            [self showListViewOnView:self.mainGroupTF clickType:MaterialTimeGroupMaterialGroupClick];
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
            [self showListViewOnView:self.mainGroupTF clickType:MaterialTimeGroupMainGroupClick];
            break;
        default:
            break;
    }
}
- (IBAction)subGroupClick:(UIButton *)sender {
    [self showListViewOnView:self.self.subGroupTF clickType:MaterialTimeGroupSubGroupClick];
}

- (void)refreshRequestSchemeListModeltype:(NSInteger)type constant:(PorscheConstantModel *)constant {
    
    switch (self.cellType) {
        case MaterialTaskTimeDetailsTypeScheme:
        case MaterialTaskTimeDetailsTypeMaterial:
        {
            if (type == 1)[PorscheRequestSchemeListModel shareModel].group_id = constant.cvsubid;
        }
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
        {
            if (type == 1){
                [PorscheRequestSchemeListModel shareModel].workhourgroupfuid = (NSString *) constant.cvsubid;
                [PorscheRequestSchemeListModel shareModel].workhourgroupid = nil;
            }
            if (type == 2) {
                [PorscheRequestSchemeListModel shareModel].workhourgroupid = (NSString *)constant.cvsubid;
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)showListViewOnView:(UIView *)view clickType:(MaterialTimeGroupClickType)clickType{
    
    NSArray *modelArray;
    switch (clickType) {
        case MaterialTimeGroupMainGroupClick:
        {
            modelArray = self.workHourMainGroupArray;
        }
            break;
        case MaterialTimeGroupSubGroupClick:
        {
            modelArray = self.workHourSubGroupArray;
        }
            break;
        case MaterialTimeGroupMaterialGroupClick:
        {
            modelArray = self.spareMainGroupArray;
        }
            break;
        default:
            break;
    }
    
    WeakObject(self);
    [PorscheMultipleListhView showSingleListViewFrom:view dataSource:modelArray selected:nil showArrow:NO showClearButton:NO direction:ListViewDirectionDown complete:^(PorscheConstantModel *constantModel, NSInteger idx) {
        
        if (clickType == MaterialTimeGroupMainGroupClick || clickType == MaterialTimeGroupMaterialGroupClick) {
            selfWeak.mainGroupTF.text = constantModel.cvvaluedesc;
            selfWeak.subGroupTF.text = @"";
            [selfWeak refreshRequestSchemeListModeltype:1 constant:constantModel];
        }
        if (clickType == MaterialTimeGroupSubGroupClick) {
            selfWeak.subGroupTF.text = constantModel.cvvaluedesc;
            [selfWeak refreshRequestSchemeListModeltype:2 constant:constantModel];
        }

    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
