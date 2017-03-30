//
//  ProjectMileageStyleTableViewCell.m
//  HandleiPad
//
//  Created by Robin on 2016/10/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectMileageStyleTableViewCell.h"
#import "PorscheNumericKeyboard.h"
#import "ProjectDetialEditMileageView.h"
#import "ProjectDetialEditTimerView.h"

@class ProjectMileageStyleTableViewCell;

@interface ProjectMileageStyleTableViewCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UIView *mileageView;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editImageWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editImageTrailingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mileageTrashWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editImage2WidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editImage2TrailingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerTranshWidthLayout;

@property (weak, nonatomic) IBOutlet UIButton *mileageAddbutton;
@property (weak, nonatomic) IBOutlet UIButton *timerAddButton;

@property (nonatomic, strong) PorscheSchemeMilesModel *milesModel;
@property (nonatomic, strong) PorscheSchemeMonthModel *monthModel;

@property (nonatomic, strong) UIView *blackView;

@end
@implementation ProjectMileageStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.mileageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mileageView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.mileageView.layer.cornerRadius = 4;
    self.mileageView.clipsToBounds = YES;
    
    self.timerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.timerView.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.timerView.layer.cornerRadius = 4;
    self.timerView.clipsToBounds = YES;
    
    UITapGestureRecognizer *mileageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.mileageView addGestureRecognizer:mileageTap];
    UITapGestureRecognizer *timerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timerTapAction:)];
    [self.timerView addGestureRecognizer:timerTap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [self showEditMileageView];
}

- (void)timerTapAction:(UITapGestureRecognizer *)tap {
    
    [self showEditTimerView];
}

- (void)setMileageString:(NSString *)mileageString {
    _mileageString = mileageString;
    
    self.mileageLabel.text = mileageString;
    
    [self hiddenMilesLabel:NO];
}

- (void)setTimerString:(NSString *)timerString {
    _timerString = timerString;

    self.timerLabel.text = timerString;
    
    [self hiddenMonthLabel:NO];
}

- (void)hiddenMilesLabel:(BOOL)hidden {
    
    self.mileageView.hidden = hidden;
    self.mileageAddbutton.hidden = !hidden;
}

- (void)hiddenMonthLabel:(BOOL)hidden {
    
    self.timerView.hidden = hidden;
    self.timerAddButton.hidden = !hidden;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView withMilesModel:(PorscheSchemeMilesModel *)milesModel MonthModel:(PorscheSchemeMonthModel *)monthModel {
    
    static NSString *identifer = @"ProjectMileageStyleTableViewCell";
    ProjectMileageStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectMileageStyleTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.milesModel = milesModel;
    cell.monthModel = monthModel;
    return cell;
}

- (void)setMilesModel:(PorscheSchemeMilesModel *)milesModel {
    
    _milesModel = milesModel;
    
    self.mileageString = milesModel.milesString;
    
    [self hiddenMilesLabel:!self.mileageString];

}

- (void)setMonthModel:(PorscheSchemeMonthModel *)monthModel {
    
    _monthModel = monthModel;
    
    self.timerString = monthModel.monthString;
    
    [self hiddenMonthLabel:!self.timerString];
}

- (void)setEditCell:(BOOL)editCell {
    
    _editCell = editCell;
    
    self.userInteractionEnabled = editCell;
    self.mileageAddbutton.hidden = !editCell;
    self.timerAddButton.hidden = !editCell;
    if (editCell) {
        self.editImageWidthLayout.constant = 20;
        self.mileageTrashWidthLayout.constant = 20;
        self.editImageTrailingLayout.constant = 5;
        self.editImage2WidthLayout.constant = 20;
        self.timerTranshWidthLayout.constant = 20;
        self.editImage2TrailingLayout.constant = 5;
    
    } else {
        self.editImageWidthLayout.constant = 0;
        self.mileageTrashWidthLayout.constant = 0;
        self.editImageTrailingLayout.constant = 0;
        self.editImage2WidthLayout.constant = 0;
        self.timerTranshWidthLayout.constant = 0;
        self.editImage2TrailingLayout.constant = 0;
    }
}
- (IBAction)mileageAddAction:(UIButton *)sender {
    

    [self showEditMileageView];
}
- (IBAction)timerAddAction:(UIButton *)sender {

    [self showEditTimerView];
}
- (IBAction)deleteMileageView:(id)sender {
    
    [self deleteMileage];
}
- (IBAction)deleteTimeView:(id)sender {
    
    [self deleteTimer];
}

- (void)showEditMileageView{
    
    CGFloat width = HD_WIDTH * 4/5.0;
    ProjectDetialEditMileageView *editMileageView = [[ProjectDetialEditMileageView alloc] initWithFrame:CGRectMake(0, 0, width, width *1/3) withMilesModel:self.milesModel];
    [self.blackView addSubview:editMileageView];
    editMileageView.center = self.blackView.center;
    
    __weak typeof(self)weakself = self;
    
    editMileageView.clickBlock = ^(PorscheSchemeMilesModel *model) {

        weakself.mileageString = model.milesString;
        [weakself hiddenMilesLabel:!weakself.mileageString];
        [weakself closeCarMileageView];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
}

- (void)showEditTimerView {
    
    CGFloat width = HD_WIDTH * 4/5.0;
    ProjectDetialEditTimerView *editTimerView = [ProjectDetialEditTimerView viewFromXibWithFrame:CGRectMake(0, 0, width, 170) withMonthModel:self.monthModel];
    [self.blackView addSubview:editTimerView];
    editTimerView.center = self.blackView.center;
    
    __weak typeof(self)weakself = self;
    editTimerView.saveBlock = ^() {
    
        weakself.timerString = weakself.monthModel.monthString;
        [weakself hiddenMonthLabel:!weakself.timerString];
        [weakself closeCarMileageView];
    };
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
}

- (void)deleteMileage {
    self.milesModel.rangetype = nil;
    self.milesModel.beginmiles = nil;
    self.milesModel.endmiles = nil;
    self.milesModel.allmiles = nil;
    self.milesModel.personmemiles = nil;
    self.milesModel.startmiles = nil;
    self.milesModel.upfloatmiles = nil;
    self.milesModel.downfloatmiles = nil;
    
    [self hiddenMilesLabel:YES];
}

- (void)deleteTimer {
    
    self.monthModel.downfloatmonth = nil;
    self.monthModel.startmonth = nil;
    self.monthModel.timeintervalmonth = nil;
    self.monthModel.upfloatmonth = nil;
    
    [self hiddenMonthLabel:YES];
}

- (UIView *)blackView {
    
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _blackView.bounds;
        [btn addTarget:self action:@selector(closeCarMileageView) forControlEvents:UIControlEventTouchUpInside];
        [_blackView addSubview:btn];
    }
    return _blackView;
}

- (void)closeCarMileageView {
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.blackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.blackView removeFromSuperview];
        self.blackView.alpha = 1.0;
        self.blackView = nil;
    }];
}


- (CGFloat)getStringlength:(NSString *)string {
    
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
