
//
//  HDSelectStaffView.m
//  HandleiPad
//
//  Created by Handlecar on 2016/11/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDSelectStaffView.h"
#import "HDLeftSingleton.h"
#import "HDSelectStaffTableViewCell.h"

#define CellHeight 45

@interface HDSelectStaffView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *currentGroupTableView;
@property (weak, nonatomic) IBOutlet UITableView *otherGroupTableView;
@property (weak, nonatomic) IBOutlet UITableView *otherGroupStaffTableview;

@property (nonatomic, strong) NSArray *currentGroupStaffs;
@property (nonatomic, strong) NSArray *otherGroups;
@property (nonatomic, strong) NSArray *otherGroupStaffs;
@property (nonatomic, strong) NSNumber *currentGroupid;
@property (nonatomic, strong) NSNumber *selectGroupid;

@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic, copy) void (^completion)(NSNumber *, NSNumber *, NSString *);
@property (nonatomic) CGFloat topOriginY;

@end

@implementation HDSelectStaffView

- (void)drawRect:(CGRect)rect {
    
    //中间镂空的矩形框
    CGRect myRect = self.viewRect;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:4];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer insertSublayer:fillLayer atIndex:0];
    
}
+ (HDSelectStaffView *)selectStaffViewWithView:(UIView *)aroundView CurrentGroupStaffs:(NSArray *)currentGroupStaffs otherGroups:(NSArray *)otherGroups selectCompletion:(void (^)(NSNumber *groupid, NSNumber *staffid, NSString *staffname))completion
{
    CGRect rect = [aroundView convertRect:aroundView.bounds toView:KEY_WINDOW];
    HDSelectStaffView *selectStaffView = [[[NSBundle mainBundle] loadNibNamed:@"HDSelectStaffView" owner:self options:nil] objectAtIndex:0];
    
    [selectStaffView.otherGroupTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDSelectStaffTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HDSelectStaffTableViewCell class])];
    [selectStaffView.currentGroupTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDSelectStaffTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HDSelectStaffTableViewCell class])];
    [selectStaffView.otherGroupStaffTableview registerNib:[UINib nibWithNibName:NSStringFromClass([HDSelectStaffTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HDSelectStaffTableViewCell class])];
    
    selectStaffView.viewRect = rect;
    
    [selectStaffView configTableView];
    
    selectStaffView.completion = completion;

    [selectStaffView makeMockDataWithInfoData:currentGroupStaffs otherGroups:otherGroups];
    //调整frame
    [selectStaffView setupRectWithAroundViewRect:rect];
    //开单信息人员的下拉框 位置进行调整,因为要显示全部的数据不再限制只显示4个
    //17-03-01修改显示,最长不能超过状态栏
    if ((rect.origin.y - (CellHeight * currentGroupStaffs.count)) < 30) {
        selectStaffView.topOriginY = 30;
    }else {
        selectStaffView.topOriginY = rect.origin.y - (CellHeight * currentGroupStaffs.count);
    }
    [selectStaffView resetTableView:selectStaffView.currentGroupTableView dataSourceCount:selectStaffView.currentGroupStaffs.count];
    [HD_FULLView addSubview:selectStaffView];

    return  selectStaffView;
}

- (void)setupRectWithAroundViewRect:(CGRect)rect {
    //x 轴
    CGRect currentRect = self.currentGroupTableView.frame;
    currentRect.origin.x = CGRectGetMinX(rect);
    currentRect.size.width = CGRectGetWidth(rect);
    
    CGRect otherRect = self.otherGroupTableView.frame;
    otherRect.origin.x = currentRect.origin.x + 5 + CGRectGetWidth(rect);
    otherRect.size.width = CGRectGetWidth(rect);
    
    CGRect otherStaffRect = self.otherGroupStaffTableview.frame;
    otherStaffRect.origin.x = otherRect.origin.x + 5 + CGRectGetWidth(rect);
    otherStaffRect.size.width = CGRectGetWidth(rect);

    //y 轴
    currentRect.origin.y = CGRectGetMinY(rect) - CGRectGetHeight(self.currentGroupTableView.frame);
    otherRect.origin.y = CGRectGetMinY(rect) - CGRectGetHeight(self.otherGroupTableView.frame);;
    otherStaffRect.origin.y = CGRectGetMinY(otherRect);
    self.currentGroupTableView.frame = currentRect;
    self.otherGroupTableView.frame = otherRect;
    self.otherGroupStaffTableview.frame = otherStaffRect;
    
}


- (void)makeMockDataWithInfoData:(NSArray *)infodata otherGroups:(NSArray *)otherData {
    _currentGroupStaffs = infodata;
    _otherGroups = otherData;
}


- (void)configTableView
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITableView class]])
        {
            UITableView *tableView = (UITableView *)view;
            
            tableView.layer.cornerRadius = 5.f;
            tableView.layer.masksToBounds = YES;
            tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
            tableView.separatorColor = [UIColor darkGrayColor];
            tableView.showsVerticalScrollIndicator = NO;
            tableView.backgroundView.backgroundColor = MAIN_BLUE;
            tableView.backgroundColor = MAIN_BLUE;

        }
    }
    
    _otherGroupTableView.hidden = YES;
    _otherGroupStaffTableview.hidden = YES;
}

// 动态调整当前组列表的高度
- (void)resetTableView:(UITableView *)tableView dataSourceCount:(NSInteger)count
{
    
    
      CGFloat height = count * CellHeight;
    if (height > _viewRect.origin.y) {
        height = _viewRect.origin.y - 30;
    }
    // UI图列表显示4项
//    CGFloat limitHeight = 4 *CellHeight;
//    
//    if (height < limitHeight) {
//        CGFloat offsetHeight = limitHeight - height;
//        CGRect currentGroupTableViewFrame = tableView.frame;
//        if (tableView == _currentGroupTableView)
//        {
//            currentGroupTableViewFrame.origin.y = _topOriginY + offsetHeight;
//        }
//        currentGroupTableViewFrame.size.height = height;
//        tableView.frame = currentGroupTableViewFrame;
//    }
    
    //开单信息人员的下拉框 位置进行调整,因为要显示全部的数据不再限制只显示4个   czz 要求
    CGRect currentGroupTableViewFrame = tableView.frame;
    if (tableView == _currentGroupTableView)
    {
        currentGroupTableViewFrame.origin.y = _topOriginY;
    }
    currentGroupTableViewFrame.size.height = height;
    tableView.frame = currentGroupTableViewFrame;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.currentGroupTableView) {
        return _currentGroupStaffs.count;
    }
    else if (tableView == self.otherGroupTableView)
    {
        return _otherGroups.count;
    }
    else
    {
        return _otherGroupStaffs.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HDSelectStaffTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HDSelectStaffTableViewCell class]) forIndexPath:indexPath];
    
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
    cell.selectedBackgroundView.backgroundColor = MAIN_RED;
    cell.backgroundColor = MAIN_BLUE;
    
    NSString *text = nil;
    
    if (tableView == _currentGroupTableView) {
        PorscheConstantModel *staff = [_currentGroupStaffs objectAtIndex:indexPath.row];
        text = staff.cvvaluedesc;
    }
    else if (tableView == _otherGroupTableView){
        PorscheConstantModel *staffgroup = [_otherGroups objectAtIndex:indexPath.row];
        text = staffgroup.cvvaluedesc;
    }
    else if (tableView == _otherGroupStaffTableview)
    {
        PorscheConstantModel *staff = [_otherGroupStaffs objectAtIndex:indexPath.row];

        text = staff.cvvaluedesc;

    }
    cell.contentLb.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _currentGroupTableView) {
        PorscheConstantModel *staff = [_currentGroupStaffs objectAtIndex:indexPath.row];

        if (_otherGroups.count && indexPath.row == 0 && [staff.cvsubid integerValue] == 0)//点击其他
        {
            [self showSelectTableView:_otherGroupTableView];
            
            [self resetTableView:_otherGroupTableView dataSourceCount:_otherGroups.count];
        }
        else
        {
#pragma mark  获取当前选择的员工id和名称
            PorscheConstantModel *staff = [_currentGroupStaffs objectAtIndex:indexPath.row];
            [self selectCompletionAtGroup:nil staffid:staff.cvsubid staffname:staff.cvvaluedesc];
        }
    }
    else if (tableView == _otherGroupTableView){//点击了组数组中数据
        PorscheConstantModel *staff = [_otherGroups objectAtIndex:indexPath.row];
        WeakObject(self);
        [PorscheRequestManager getStaffListTestWithGroupId:staff.cvsubid  positionId:[HDLeftSingleton shareSingleton].selectedPosid complete:^(NSMutableArray * _Nonnull classifyArray, PResponseModel * _Nonnull responser) {
            
            selfWeak.otherGroupStaffs = classifyArray;
            
            [selfWeak showSelectTableView:selfWeak.otherGroupStaffTableview];
            
            [selfWeak resetTableView:_otherGroupStaffTableview dataSourceCount:selfWeak.otherGroupStaffs.count];
        }];
    
    }
    else if (tableView == _otherGroupStaffTableview)
    {
#pragma mark  获取当前选择的员工id和名称
        PorscheConstantModel *staff = [_otherGroupStaffs objectAtIndex:indexPath.row];
        [self selectCompletionAtGroup:nil staffid:staff.cvsubid staffname:staff.cvvaluedesc];
    }
    
}


- (void)selectCompletionAtGroup:(NSNumber *)groupid staffid:(NSNumber *)staffid staffname:(NSString *)staffname
{
    if (self.completion) {
        self.completion(groupid,staffid,staffname);
    }
    [self removeFromSuperview];
}
- (void)showSelectTableView:(UITableView *)tableView
{
    tableView.hidden = NO;
    [tableView reloadData];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (CGRectContainsPoint(self.currentGroupTableView.frame, point) || (CGRectContainsPoint(self.otherGroupTableView.frame, point) && self.otherGroupTableView.hidden == NO)|| (CGRectContainsPoint(self.otherGroupStaffTableview.frame, point) && self.otherGroupStaffTableview.hidden == NO)) {
        return [super hitTest:point withEvent:event];
    }
    
    [self removeFromSuperview];
    return nil;
}

@end
