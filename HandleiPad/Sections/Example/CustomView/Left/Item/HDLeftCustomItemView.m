//
//  HDLeftCustomItemView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftCustomItemView.h"
#import "HDLevelCustomTableViewCell.h"


#define RowHight 70
#define levelHeight 50
@interface HDLeftCustomItemView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) CGRect viewRect;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSouyrce;

@property (nonatomic, copy) void(^customBlock)(PorscheConstantModel *model);

@property (nonatomic, assign) BOOL isNormal;

@property (nonatomic, assign) CGFloat width;

@end

@implementation HDLeftCustomItemView

- (void)drawRect:(CGRect)rect {
    
    //中间镂空的矩形框
    CGRect myRect = self.viewRect;
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:0];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = _isNormal ? [UIColor blackColor].CGColor : [UIColor clearColor].CGColor;
    
    fillLayer.opacity = 0.3;
    [self.layer insertSublayer:fillLayer atIndex:0];
    
}

+ (void)showCustomViewWithModelArray:(NSArray *)levelArray aroundView:(UIView *)aroundView direction:(UIPopoverArrowDirection)direction complete:(void(^)(PorscheConstantModel *model))complete {
    
    
    HDLeftCustomItemView *view = [[HDLeftCustomItemView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    view.viewRect = [aroundView convertRect:aroundView.bounds toView:KEY_WINDOW];
    
    CGRect rect = [HDLeftCustomItemView getRectWithView:aroundView direction:direction levelArray:levelArray];
    
    if (rect.size.width < levelHeight) {
        rect.size.width = levelHeight;
        view.isNormal = NO;
    }
    view.tableView.frame = rect;
    
    view.tableView.layer.masksToBounds = NO;

//    view.tableView.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
    view.tableView.layer.shadowColor = [UIColor blackColor].CGColor;
    view.tableView.layer.shadowOpacity = 0.6;
    view.tableView.layer.shadowOffset = CGSizeMake(0, 1);

    view.tableView.backgroundColor = view.isNormal ? [UIColor whiteColor] : [UIColor clearColor];

    view.customBlock = complete;
    
    view.dataSouyrce = levelArray;
    [view.tableView reloadData];
    
    [HD_FULLView addSubview:view];
}

+ (CGRect)getRectWithView:(UIView *)view direction:(UIPopoverArrowDirection)direction levelArray:(NSArray *)levelArray {
    CGRect rect = [view convertRect:view.bounds toView:KEY_WINDOW];
    BOOL isNormal = rect.size.width < levelHeight ? NO:YES;
    UIPopoverArrowDirection directionNew = direction;
    
    switch (direction) {
        case UIPopoverArrowDirectionUp:
            if (isNormal) {
                if (CGRectGetMinY(rect) < RowHight*5) {
                    directionNew = UIPopoverArrowDirectionDown;
                }
            }else {
                if (CGRectGetMinY(rect) < levelHeight *3) {
                    directionNew = UIPopoverArrowDirectionDown;
                }
            }
            
            break;
        case UIPopoverArrowDirectionLeft:
            if (CGRectGetMinX(rect) < CGRectGetWidth(rect)) {
                directionNew = UIPopoverArrowDirectionRight;
                if (CGRectGetMaxY(rect) < HD_HEIGHT - 200) {
                    directionNew = UIPopoverArrowDirectionUp;
                }
            }
            break;
        case UIPopoverArrowDirectionDown:
            if (isNormal) {
                if (CGRectGetMaxY(rect) > HD_HEIGHT - RowHight*5) {
                    directionNew = UIPopoverArrowDirectionUp;
                }
            }else {
                if (CGRectGetMaxY(rect) > HD_HEIGHT - levelHeight *3) {
                    directionNew = UIPopoverArrowDirectionUp;
                }
            }
            break;
        case UIPopoverArrowDirectionRight:
            if (CGRectGetMaxX(rect) > HD_WIDTH - CGRectGetWidth(rect)) {
                directionNew = UIPopoverArrowDirectionLeft;
                if (CGRectGetMinY(rect) < CGRectGetWidth(rect)) {
                    directionNew = UIPopoverArrowDirectionUp;
                }
            }
            break;
        default:
            break;
    }
    CGRect listRect = CGRectZero;
    CGFloat rowheight = RowHight;
    if (!isNormal) {
        rowheight = levelHeight;
    }
    CGFloat listHeight = levelArray.count < 4 ? levelArray.count * rowheight : rowheight * 5;

    switch (directionNew) {
        case UIPopoverArrowDirectionUp:
        {
            
            listRect = CGRectMake(rect.origin.x, rect.origin.y - listHeight-1, rect.size.width, listHeight);
        }
            break;
        case UIPopoverArrowDirectionDown:
        {
            listRect = CGRectMake(rect.origin.x, CGRectGetMaxY(rect), rect.size.width, listHeight);
            
        }
            break;
        case UIPopoverArrowDirectionLeft:
        {
            listRect = CGRectMake(rect.origin.x - rect.size.width - 10, rect.origin.y, rect.size.width + 30, listHeight);
        }
            break;
        case UIPopoverArrowDirectionRight:
        {
            listRect = CGRectMake(CGRectGetMaxX(rect) + 10, rect.origin.y, rect.size.width + 30, listHeight);
        }
            break;
        default:
            break;
    }
    return listRect;
}


- (instancetype)initWithCustomFrame:(CGRect)frame {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HDLeftCustomItemView" owner:nil options:nil];
    self = [array objectAtIndex:0];
    
    self.frame = frame;
    self.isNormal = YES;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HDLevelCustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HDLevelCustomTableViewCell class])];
    
    self.tableView.layer.cornerRadius = 3;

    
    
    return self;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (!_isNormal) {
        return nil;
    }
    CGRect rect = self.viewRect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.height = RowHight;
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
    label.text = @"请选择分类级别";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(label.bounds) - 1, CGRectGetWidth(label.frame) - 40, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [label addSubview:view];
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDLevelCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HDLevelCustomTableViewCell class]) forIndexPath:indexPath];
    
    
    if (indexPath.row == _dataSouyrce.count - 1) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    
    [self setupCell:cell index:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setupCell:(HDLevelCustomTableViewCell *)cell index:(NSIndexPath *)indexpath {
    if (_dataSouyrce.count) {
        
        if (!_isNormal) {
            cell.levelLb.font = [UIFont systemFontOfSize:10];
            cell.lbHeight.constant = 10;
            cell.lineLeftDis.constant = 0;
            cell.lineRIghtDis.constant = 0;
        }
        
        PorscheConstantModel *model = _dataSouyrce[indexpath.row];
        cell.headerImg.image = [UIImage imageNamed: [NSString stringWithFormat:@"work_list_scheme_level_%@.png",model.cvsubid]];
        
        cell.levelLb.text = model.cvvaluedesc;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isNormal) {
        return 50;
    }
    return RowHight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!_isNormal) {
        return 0.01;
    }
    return RowHight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSouyrce.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSouyrce.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.customBlock) {
        if (_dataSouyrce.count) {
            PorscheConstantModel *model = _dataSouyrce[indexPath.row];
            self.customBlock(model);
        }
    }
    
    
    [self removeFromSuperview];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.viewRect, point) || CGRectContainsPoint(self.tableView.frame, point)) {
        return [super hitTest:point withEvent:event];
    }
    [self removeFromSuperview];
    return nil;
}




@end
