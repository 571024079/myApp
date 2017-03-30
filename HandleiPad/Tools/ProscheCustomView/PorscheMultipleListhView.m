//
//  PorscheMultipleListhView.m
//  HandleiPad
//
//  Created by Robin on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheMultipleListhView.h"
#import "PorscheMultipleListTableViewCell.h"

#define LIST_HEIGHT 40

@interface PorscheMultipleListhView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) PorscheMultipleListhViewClickBlock multipleclickBlock;

@property (nonatomic, copy) PorscheSingleListhViewClickBlock singleclickBlock;

@property (nonatomic, copy) PorscheTwoStageListhViewClickBlock twoStageclickBlcok;

@property (nonatomic, assign) NSInteger selectMaxCount;

@property (nonatomic, assign) NSInteger selectMinCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
//顶部的更多视图
@property (weak, nonatomic) IBOutlet UIView *moreUpView;
//底部的更多视图
@property (weak, nonatomic) IBOutlet UIView *moreDownView;

@property (nonatomic, strong) NSArray<PorscheConstantModel *>*dataSource;

@property (nonatomic, strong) NSArray<PorscheSubConstant *>*subDataSource;

@property (nonatomic, strong) NSMutableArray<PorscheConstantModel *> *selectSource;

@property (nonatomic, assign) CGRect viewRect;

@property (nonatomic, assign) BOOL hiddenArrow;

@property (nonatomic, assign) BOOL showClearBtn;

@property (nonatomic, strong) UIButton *emptyButton;

@property (nonatomic, strong) NSNumber *limitStyle;

@end

@implementation PorscheMultipleListhView

- (void)drawRect:(CGRect)rect {

    CGRect myRect = self.viewRect;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:4];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer insertSublayer:fillLayer atIndex:0];
    
}

- (void)showHint:(BOOL)maxHint {
    
    NSString * massage;
    if (maxHint) {
        massage = [NSString stringWithFormat:@"最多可选择%ld项",(long)self.selectMaxCount];
    } else {
        massage = [NSString stringWithFormat:@"最少选择%ld项",(long)self.selectMinCount];
    }
    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:massage height:60 center:KEY_WINDOW.center superView:KEY_WINDOW];
}

+ (instancetype)getFormXibWithFrom:(UIView *)view dataSource:(NSArray *)dataSource seleted:(NSArray *)selecteds showClear:(BOOL)showClear direction:(ListViewDirection)direction {
    return [PorscheMultipleListhView getFormXibWithFrom:view dataSource:dataSource seleted:selecteds showClear:showClear direction:direction withLimit:@0];
}
+ (instancetype)getFormXibWithFrom:(UIView *)view dataSource:(NSArray *)dataSource seleted:(NSArray *)selecteds showClear:(BOOL)showClear direction:(ListViewDirection)direction withLimit:(NSNumber *)limitStyle {
    CGRect viewRect = [view convertRect:view.bounds toView:KEY_WINDOW];
    CGFloat BottomToBottom = KEY_WINDOW.bounds.size.height - CGRectGetMaxY(viewRect) - 10;
    CGFloat topToBottom = KEY_WINDOW.bounds.size.height - CGRectGetMinY(viewRect) - 10;
    CGRect listRect;
    switch (direction) {
        case ListViewDirectionUp:
        {
            CGFloat listHeight = dataSource.count < 6 ? dataSource.count * LIST_HEIGHT : LIST_HEIGHT*5;
            listRect = CGRectMake(viewRect.origin.x, viewRect.origin.y - listHeight, viewRect.size.width, listHeight);
        }
            break;
        case ListViewDirectionDown:
        {
            CGFloat listHeight = MIN(dataSource.count * LIST_HEIGHT, BottomToBottom);
            listRect = CGRectMake(viewRect.origin.x, CGRectGetMaxY(viewRect), viewRect.size.width, listHeight);
            
        }
            break;
        case ListViewDirectionLeft:
        {
            CGFloat listHeight = MIN(dataSource.count * LIST_HEIGHT, topToBottom);
            listRect = CGRectMake(viewRect.origin.x - viewRect.size.width - 10, viewRect.origin.y, viewRect.size.width + 30, listHeight);
        }
            break;
        case ListViewDirectionRight:
        {
            CGFloat listHeight = MIN(dataSource.count * LIST_HEIGHT, topToBottom);
            listRect = CGRectMake(CGRectGetMaxX(viewRect) + 10, viewRect.origin.y, viewRect.size.width + 30, listHeight);
        }
            break;
        default:
            break;
    }
    
    PorscheMultipleListhView *listView = [[[NSBundle mainBundle] loadNibNamed:@"PorscheMultipleListhView" owner:nil options:nil] lastObject];
    listView.frame = KEY_WINDOW.bounds;
    listView.tableView.tableFooterView = [UIView new];
    listView.viewRect = viewRect;
    listView.tableView.frame = listRect;
    
    listView.dataSource = dataSource;
    listView.selectSource = [selecteds mutableCopy];
    listView.selectMaxCount = 1;
    
    listView.showClearBtn = showClear;
    
    listView.limitStyle = limitStyle;
    
    //添加更多的显示
    CGRect moreUpViewFrame = CGRectMake(CGRectGetMinX(listRect), CGRectGetMinY(listRect) - 1, CGRectGetWidth(listRect), 30);
    listView.moreUpView.frame = moreUpViewFrame;
    listView.moreUpView.backgroundColor = MAIN_BLUE;
    listView.moreUpView.hidden = YES;
    
    CGRect moreDownViewFrame = CGRectMake(CGRectGetMinX(listRect), CGRectGetMaxY(listRect) - 30, CGRectGetWidth(listRect), 30);
    listView.moreDownView.frame = moreDownViewFrame;
    listView.moreDownView.backgroundColor = MAIN_BLUE;
    if ((listView.dataSource.count * LIST_HEIGHT) > listRect.size.height) {
        listView.moreDownView.hidden = NO;
    }else {
        listView.moreDownView.hidden = YES;
    }
    
    [KEY_WINDOW endEditing:YES];
    
    return listView;
}

+ (void)showSingleListViewFrom:(UIView *)view dataSource:(NSArray *)dataSource selected:(NSString *)selected showArrow:(BOOL)showArrow direction:(ListViewDirection)direction complete:(PorscheSingleListhViewClickBlock)complete {
    
    [PorscheMultipleListhView showSingleListViewFrom:view dataSource:dataSource selected:selected showArrow:showArrow showClearButton:NO direction:direction withLimit:@0 complete:complete];
}

+ (void)showSingleListViewFrom:(UIView *)view dataSource:(NSArray<PorscheConstantModel *> *)dataSource selected:(NSString *)selected showArrow:(BOOL)showArrow showClearButton:(BOOL)showClear direction:(ListViewDirection)direction complete:(PorscheSingleListhViewClickBlock)complete {
    
    [PorscheMultipleListhView showSingleListViewFrom:view dataSource:dataSource selected:selected showArrow:showArrow showClearButton:showClear direction:direction withLimit:@0 complete:complete];
}

+ (void)showSingleListViewFrom:(UIView *)view dataSource:(NSArray<PorscheConstantModel *> *)dataSource selected:(NSString *)selected showArrow:(BOOL)showArrow showClearButton:(BOOL)showClear direction:(ListViewDirection)direction withLimit:(NSNumber *)limitStyle complete:(PorscheSingleListhViewClickBlock)complete {
    
    NSArray *selecteds;
    if (!selected || [selected isEqualToString:@""]) {
        selecteds = @[];
    } else {
        selecteds= @[selected];
    }
    
    CGRect rect = [view convertRect:view.bounds toView:KEY_WINDOW];
    
    ListViewDirection directionNew = direction;
    
    switch (direction) {
        case ListViewDirectionUp:
            if (CGRectGetMinY(rect) < 200) {
                directionNew = ListViewDirectionDown;
            }
            break;
        case ListViewDirectionLeft:
            if (CGRectGetMinX(rect) < CGRectGetWidth(rect)) {
                directionNew = ListViewDirectionRight;
                if (CGRectGetMaxY(rect) < HD_HEIGHT - 200) {
                    directionNew = ListViewDirectionUp;
                }
            }
            break;
        case ListViewDirectionDown:
            if (CGRectGetMaxY(rect) > HD_HEIGHT - 200) {
                directionNew = ListViewDirectionUp;
            }
            break;
        case ListViewDirectionRight:
            if (CGRectGetMaxX(rect) > HD_WIDTH - CGRectGetWidth(rect)) {
                directionNew = ListViewDirectionLeft;
                if (CGRectGetMinY(rect) < CGRectGetWidth(rect)) {
                    directionNew = ListViewDirectionUp;
                }
            }
            break;
        default:
            break;
    }
    
    PorscheMultipleListhView *singleListView = [PorscheMultipleListhView getFormXibWithFrom:view dataSource:dataSource seleted:selecteds showClear:showClear direction:directionNew withLimit:limitStyle];
    singleListView.selectMaxCount = 1;
    singleListView.hiddenArrow = !showArrow;
    [KEY_WINDOW addSubview:singleListView];
    
    if (complete) {
        singleListView.singleclickBlock = complete;
    }
}



+ (void)showTwoStageListViewFrom:(UIView *)view dataSource:(NSArray *)dataSource selected:(PorscheConstantModel *)selectedModel direction:(ListViewDirection)direction complete:(PorscheTwoStageListhViewClickBlock)complete {
    
    NSArray *selecteds;
    if (!selectedModel) {
        selecteds = @[];
    } else {
        selecteds= @[selectedModel];
    }
    
    PorscheMultipleListhView *singleListView = [PorscheMultipleListhView getFormXibWithFrom:view dataSource:dataSource seleted:selecteds showClear:NO direction:direction];
    singleListView.selectMaxCount = 1;
    singleListView.hiddenArrow = NO;
    [KEY_WINDOW addSubview:singleListView];
    
    if (complete) {
        singleListView.twoStageclickBlcok = complete;
    }
}


+ (void)showMultipleListViewFrom:(UIView *)view dataSource:(NSArray<PorscheConstantModel *> *)dataSource selecteds:(NSArray *)selecteds maxSelectCount:(NSInteger)maxCount MinSelectCount:(NSInteger)minCount direction:(ListViewDirection)direction complete:(PorscheMultipleListhViewClickBlock)complete {
    
    PorscheMultipleListhView *multipleListView = [PorscheMultipleListhView getFormXibWithFrom:view dataSource:dataSource seleted:selecteds showClear:NO direction:direction];
    multipleListView.selectMaxCount = maxCount;
    multipleListView.selectMinCount = minCount;
    multipleListView.hiddenArrow = YES;
    [KEY_WINDOW addSubview:multipleListView];
    
    if (complete) {
        multipleListView.multipleclickBlock = complete;
    }
}

- (void)setShowClearBtn:(BOOL)showClearBtn {
    _showClearBtn = showClearBtn;
    
    if (showClearBtn) {
        [self setupEmptyBtn];
    }
}

- (void)setupEmptyBtn {
    
    UIButton *emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emptyButton.frame = CGRectMake(CGRectGetMaxX(self.viewRect) - 25, CGRectGetMinY(self.viewRect) + 5, 20, 20);
    [emptyButton setImage:[UIImage imageNamed:@"Camera_DrawDelete"] forState:UIControlStateNormal];
    [emptyButton addTarget:self action:@selector(backEmptyModel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emptyButton];
}

- (void)backEmptyModel:(UIButton *)btn {
    
    PorscheConstantModel *constant = [[PorscheConstantModel alloc] init];
    if (self.singleclickBlock) {
        self.singleclickBlock(constant, 0);
    }
    if (self.twoStageclickBlcok && !self.hiddenArrow) {
        
        PorscheSubConstant *subConstantModel = [[PorscheSubConstant alloc] init];
        self.twoStageclickBlcok(constant,subConstantModel);
    }
    [self removeFromSuperview];
}

- (void)setDataSource:(NSArray<PorscheConstantModel *> *)dataSource {
    
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return LIST_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        return self.dataSource.count;
    } else {
        
        return self.subDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        PorscheMultipleListTableViewCell *cell = [PorscheMultipleListTableViewCell cellWithTableVIew:tableView];
        cell.contentView.backgroundColor = MAIN_BLUE;
        PorscheConstantModel *model = self.dataSource[indexPath.row];
        cell.contentLabel.text = model.cvvaluedesc;
        cell.arrow.hidden = self.hiddenArrow;
        cell.mutltiple = self.selectMaxCount > 1 ? YES :NO;
        cell.select = NO;
        [self.selectSource enumerateObjectsUsingBlock:^(PorscheConstantModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.cvsubid.integerValue == model.cvsubid.integerValue) {
                cell.select = YES;
                *stop = YES;
            }
        }];
        return cell;
    } else {
        
        PorscheMultipleListTableViewCell *cell = [PorscheMultipleListTableViewCell cellWithTableVIew:tableView];
        cell.contentView.backgroundColor = MAIN_BLUE;
        PorscheSubConstant *model = self.subDataSource[indexPath.row];
        cell.contentLabel.text = model.cvvaluedesc;
        cell.arrow.hidden = YES;
        cell.mutltiple = NO;
        cell.select = NO;
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) { //一级选择
        PorscheMultipleListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        PorscheConstantModel *model = self.dataSource[indexPath.row];
        
        if (self.selectSource.count >= self.selectMaxCount && !cell.select && self.selectMaxCount > 1) {
            
            [self showHint:YES];
            return;
        }
        cell.select = !cell.select;
        
        if (self.twoStageclickBlcok) {
            self.subDataSource = model.children;
            [self updateSubTableViewFrame];
            self.subTableView.hidden = NO;
            [self.subTableView reloadData];
        }
        
        if (cell.select) {
            [self.selectSource addObject:model];
            
        } else { //二级选择框
            
            [self.selectSource enumerateObjectsUsingBlock:^(PorscheConstantModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.cvsubid.integerValue == model.cvsubid.integerValue) {
                    [self.selectSource removeObject:obj];
                }
            }];
        }
        
        if (self.singleclickBlock) {
            self.singleclickBlock([self.selectSource firstObject], [_dataSource indexOfObject:[self.selectSource firstObject]]);
        }
        
        if (self.selectMaxCount == 1) {
            if (self.multipleclickBlock) {
                self.multipleclickBlock(self.selectSource);
            }
        }
        
        if (self.selectSource.count >= self.selectMaxCount && self.hiddenArrow == YES) {
            
            [self removeFromSuperview];
        }

    } else { //两级选择
        
        if (self.twoStageclickBlcok && !self.hiddenArrow) {
            
            self.twoStageclickBlcok([self.selectSource lastObject],self.subDataSource[indexPath.row]);
            [self removeFromSuperview];
        }
    }
}

- (void)updateSubTableViewFrame {
    
    CGRect tabeleViewRect = self.tableView.frame;
    
    self.subTableView.frame = CGRectMake(CGRectGetMaxX(tabeleViewRect) + 5 , tabeleViewRect.origin.y, CGRectGetWidth(tabeleViewRect), MIN(CGRectGetHeight(tabeleViewRect), self.subDataSource.count * LIST_HEIGHT));
}

- (IBAction)closeAction:(UIButton *)sender {
    
    if (self.selectSource.count < self.selectMinCount) {
        
        [self showHint:NO];
        return;
    }
    if (self.selectMaxCount > 1) {
        if (self.multipleclickBlock) {
            self.multipleclickBlock(self.selectSource);
        }
    }
    
    [self removeFromSuperview];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (self.hiddenArrow) {
        if (CGRectContainsPoint(self.tableView.frame, point) || CGRectContainsPoint(self.viewRect, point)) {
            return [super hitTest:point withEvent:event];
        }
    } else {
        if (CGRectContainsPoint(self.tableView.frame, point) || CGRectContainsPoint(self.viewRect, point) || CGRectContainsPoint(self.subTableView.frame, point)) {
            return [super hitTest:point withEvent:event];
        }
    }
    
   
    
    [self closeAction:nil];
    return nil;
}

#pragma mark - 判断当前处于底部还是顶部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat height = scrollView.frame.size.height;
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat contentSetY = scrollView.contentSize.height;
        
        if ((self.dataSource.count * LIST_HEIGHT) > height) {
            
            if (offsetY <= 0) {
                if (self.moreDownView.hidden == YES) {
                    [self moreViewAnimate:self.moreDownView withShowAndHidden:1];
                }else if (self.moreUpView.alpha == 1) {
                    [self moreViewAnimate:self.moreUpView withShowAndHidden:0];
                }
            }else if (offsetY > 0 && (offsetY + height) < contentSetY) {
                if (self.moreUpView.hidden == YES) {
                    [self moreViewAnimate:self.moreUpView withShowAndHidden:1];
                }else if (self.moreDownView.hidden == YES) {
                    [self moreViewAnimate:self.moreDownView withShowAndHidden:1];
                }
            }else if ((offsetY + height) >= contentSetY) {
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

@end
