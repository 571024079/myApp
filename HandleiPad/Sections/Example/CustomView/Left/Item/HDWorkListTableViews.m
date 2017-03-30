//
//  HDWorkListTableViews.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListTableViews.h"
#import "HDWorkListTBViewsTableViewCellOne.h"

#define CELLHEIGHT 40

@interface HDWorkListTableViews ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) CGRect viewRect;
//顶部的更多视图
@property (weak, nonatomic) IBOutlet UIView *moreUpView;
//底部的更多视图
@property (weak, nonatomic) IBOutlet UIView *moreDownView;

@property (nonatomic, assign) UIPopoverArrowDirection direction;

@end

static NSString *HDWorkListTableViewsTableViewCellID = @"HDWorkListTBViewsTableViewCellOneID";

@implementation HDWorkListTableViews

//- (void)drawRect:(CGRect)rect {
//    
//    //中间镂空的矩形框
//    CGRect myRect = self.viewRect;
//    //背景
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
//    //镂空
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:4];
//    [path appendPath:circlePath];
//    [path setUsesEvenOddFillRule:YES];
//    
//    CAShapeLayer *fillLayer = [CAShapeLayer layer];
//    fillLayer.path = path.CGPath;
//    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
//    fillLayer.fillColor = [UIColor blackColor].CGColor;
//    fillLayer.opacity = 0.5;
//    [KEY_WINDOW.layer insertSublayer:fillLayer atIndex:0];
//    
//}

+ (HDWorkListTableViews *)showTableViewlistViewAroundView:(UIView *)aroundView superView:(UIView *)superView direction:(UIPopoverArrowDirection)direction dataSource:(NSMutableArray *)dataSource size:(CGSize)size seletedNeedDelete:(BOOL)isNeed complete:(HDWorkListTableViewsBlock)complete {
    CGRect rect = [aroundView convertRect:aroundView.bounds toView:superView];
    CGRect viewRect = CGRectZero;
    switch (direction) {
        case UIPopoverArrowDirectionUp:
        {
            viewRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) - size.height, CGRectGetWidth(rect), size.height);
        }
            break;
        case UIPopoverArrowDirectionLeft:
        {
            viewRect = CGRectMake(CGRectGetMinX(rect) - size.width, CGRectGetMinY(rect), CGRectGetWidth(rect), size.height);
        }
            break;
        case UIPopoverArrowDirectionDown:
        {
            viewRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetWidth(rect), size.height);
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            viewRect = CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), size.height);
        }
            break;
            
        default:
            break;
    }
    HDWorkListTableViews *view = [[HDWorkListTableViews alloc]initWithCustomFrame:viewRect];
    view.frame = viewRect;
    view.viewRect = rect;
    view.direction = direction;
    view.dataSource = dataSource;
    view.block = complete;
    view.isNeedDelete = isNeed;
    view.tableView.tableFooterView = [UIView new];
    
    CGRect listRect = view.frame;
    //添加更多的显示
//    CGRect moreUpViewFrame = CGRectMake(CGRectGetMinX(listRect), CGRectGetMinY(listRect) - 1, CGRectGetWidth(listRect), 30);
//    view.moreUpView.frame = moreUpViewFrame;
    view.moreUpView.backgroundColor = MAIN_BLUE;
    view.moreUpView.hidden = YES;
    
//    CGRect moreDownViewFrame = CGRectMake(CGRectGetMinX(listRect), CGRectGetMaxY(listRect) - 30, CGRectGetWidth(listRect), 30);
//    view.moreDownView.frame = moreDownViewFrame;
    view.moreDownView.backgroundColor = MAIN_BLUE;
    if ((view.dataSource.count * CELLHEIGHT) > listRect.size.height) {
        view.moreDownView.hidden = NO;
    }else {
        view.moreDownView.hidden = YES;
    }
    
    [superView addSubview:view];
    return view;
}

+ (HDWorkListTableViews *)showTableViewlistViewAroundView:(UIView *)aroundView direction:(UIPopoverArrowDirection)direction dataSource:(NSMutableArray *)dataSource size:(CGSize)size seletedNeedDelete:(BOOL)isNeed complete:(HDWorkListTableViewsBlock)complete {
    CGRect rect = [aroundView convertRect:aroundView.bounds toView:KEY_WINDOW];
    CGRect viewRect = CGRectZero;
    switch (direction) {
        case UIPopoverArrowDirectionUp:
        {
            viewRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect) - size.height, CGRectGetWidth(rect), size.height);
        }
            break;
        case UIPopoverArrowDirectionLeft:
        {
            viewRect = CGRectMake(CGRectGetMinX(rect) - size.width, CGRectGetMinY(rect), CGRectGetWidth(rect), size.height);
        }
            break;
        case UIPopoverArrowDirectionDown:
        {
            viewRect = CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetWidth(rect), size.height);
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            viewRect = CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), size.height);
        }
            break;
            
        default:
            break;
    }
    HDWorkListTableViews *view = [[HDWorkListTableViews alloc]initWithCustomFrame:viewRect];
    view.dataSource = dataSource;
    [view.tableView reloadData];
    view.block = complete;
    view.viewRect = rect;
    view.isNeedDelete = isNeed;
    [KEY_WINDOW addSubview:view];
    return view;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    CGFloat height = dataSource.count * 40 < 200 ? dataSource.count * 40 : 200;
    CGRect viewRect = CGRectZero;
    switch (self.direction) {
        case UIPopoverArrowDirectionUp:
        {
            viewRect = CGRectMake(CGRectGetMinX(_viewRect), CGRectGetMinY(_viewRect) - height, CGRectGetWidth(_viewRect), height);
            self.frame = viewRect;
        }
            break;
        case UIPopoverArrowDirectionLeft:
        {
            viewRect = CGRectMake(CGRectGetMinX(_viewRect) - _viewRect.size.width, CGRectGetMinY(_viewRect), CGRectGetWidth(_viewRect), height);
            self.frame = viewRect;
        }
            break;
        case UIPopoverArrowDirectionDown:
        {
            viewRect = CGRectMake(CGRectGetMinX(_viewRect), CGRectGetMaxY(_viewRect), CGRectGetWidth(_viewRect), height);
            self.frame = viewRect;
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            viewRect = CGRectMake(CGRectGetMaxX(_viewRect), CGRectGetMinY(_viewRect), CGRectGetWidth(_viewRect), height);
            self.frame = viewRect;
        }
            break;
            
        default:
            break;
    }
    if ((_dataSource.count * CELLHEIGHT) > self.frame.size.height) {
        self.moreDownView.hidden = NO;
    }else {
        self.moreDownView.hidden = YES;
    }
    
    [_tableView reloadData];
}



- (instancetype)initWithCustomFrame:(CGRect)frame {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListTableViews" owner:self options:nil];
    self = [array objectAtIndex:0];
//    self.frame = frame;
    
    [_tableView registerNib:[UINib nibWithNibName:@"HDWorkListTBViewsTableViewCellOne" bundle:nil] forCellReuseIdentifier:HDWorkListTableViewsTableViewCellID];
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.bounces = NO;
    _selectedRow = -1;
    self.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //[self selectedRow];
    _isNeedDelete = NO;
    return self;
}

- (void)setShadow {
//    self.layer.shadowColor = [UIColor whiteColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowRadius = 3;
//    self.layer.shadowOpacity = 0.5;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDWorkListTBViewsTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:HDWorkListTableViewsTableViewCellID forIndexPath:indexPath];

    if (!cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListTBViewsTableViewCellOne" owner:nil options:nil];
        
        cell = [array objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    
    cell.backgroundColor = MAIN_BLUE;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.rightImageView.hidden = NO;
    if (!_needAccessoryDisclosureIndicator) {
        cell.rightImageView.hidden = YES;
    }
    
    if (indexPath.row == _selectedRow) {
        cell.backgroundColor = ColorHex(0x850000);
    }
    //设置内容
    [self setupCellLabelWithindex:indexPath cell:cell];
    
    return cell;
}

- (void)setupCellLabelWithindex:(NSIndexPath *)idx cell:(HDWorkListTBViewsTableViewCellOne *)cell {
    id model = [self.dataSource objectAtIndex:idx.row];
    if ([model isKindOfClass:[NSString class]]) {
        cell.label.text = model;
    }else if ([model isKindOfClass:[PorscheConstantModel class]]) {
        PorscheConstantModel *tmp = model;
        cell.label.text = tmp.cvvaluedesc;
        if (tmp.children.count) {
            cell.rightImageView.hidden = NO;
        }
    }else if ([model isKindOfClass:[PorscheSubConstant class]]) {
        PorscheSubConstant *tmp = model;
        cell.label.text = tmp.cvvaluedesc;
//        if (tmp.children.count) {
//            cell.rightImageView.hidden = NO;
//        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count ? self.dataSource.count: 0;
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
    
    if (self.block) {
        self.block(@(indexPath.row),_needAccessoryDisclosureIndicator,_style);
    }

    if (_isNeedDelete) {
        [self removeFromSuperview];
    }
}



#pragma mark - 判断当前处于底部还是顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat height = scrollView.frame.size.height;
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat contentSetY = scrollView.contentSize.height;
        
        if ((self.dataSource.count * 40) > height) {
            
            if (offsetY <= 0 + CELLHEIGHT) {
                if (self.moreDownView.hidden == YES) {
                    [self moreViewAnimate:self.moreDownView withShowAndHidden:1];
                }else if (self.moreUpView.alpha == 1) {
                    [self moreViewAnimate:self.moreUpView withShowAndHidden:0];
                }
            }else if (offsetY > 0 + CELLHEIGHT && (offsetY + height) < contentSetY - CELLHEIGHT) {
                if (self.moreUpView.hidden == YES) {
                    [self moreViewAnimate:self.moreUpView withShowAndHidden:1];
                }else if (self.moreDownView.hidden == YES) {
                    [self moreViewAnimate:self.moreDownView withShowAndHidden:1];
                }
            }else if ((offsetY + height) >= contentSetY - CELLHEIGHT) {
                if (self.moreUpView.hidden == YES) {
                    [self moreViewAnimate:self.moreUpView withShowAndHidden:1];
                }else if (self.moreDownView.alpha == 1) {
                    [self moreViewAnimate:self.moreDownView withShowAndHidden:0];
                }
            }
        }
    }
}
#pragma mark - 当处于顶部或者底部的时候进行界面的变换
//  0->消失   1->出现
- (void)moreViewAnimate:(UIView *)view withShowAndHidden:(NSInteger)style {
    WeakObject(self)
    if (style == 1) {//出现
        if (view == selfWeak.moreUpView) {//上
            view.hidden = NO;
            [UIView animateWithDuration:1.0 animations:^{
                //                view.frame = CGRectMake(CGRectGetMinX(listRect), CGRectGetMinY(listRect) - 1, CGRectGetWidth(listRect), 30);
                view.alpha = 1;
            }];
        }else {// 下
            view.hidden = NO;
            [UIView animateWithDuration:1.0 animations:^{
                //                view.frame = CGRectMake(CGRectGetMinX(listRect), CGRectGetMaxY(listRect) - 30, CGRectGetWidth(listRect), 30);
                view.alpha = 1;
            }];
        }
    }else {//消失
        if (view == selfWeak.moreUpView) {//上
            [UIView animateWithDuration:1.0 animations:^{
                //                view.frame = CGRectMake(CGRectGetMinX(listRect), CGRectGetMinY(listRect) - 30 - 1, CGRectGetWidth(listRect), 30);
                view.alpha = 0;
            } completion:^(BOOL finished) {
                view.hidden = YES;
            }];
        }else {// 下
            [UIView animateWithDuration:1.0 animations:^{
                //                view.frame = CGRectMake(CGRectGetMinX(listRect), CGRectGetMaxY(listRect), CGRectGetWidth(listRect), 30);
                view.alpha = 0;
            } completion:^(BOOL finished) {
                view.hidden = YES;
            }];
        }
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
