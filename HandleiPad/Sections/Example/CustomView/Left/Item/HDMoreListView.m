//
//  HDMoreListView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDMoreListView.h"
#import "HDWorkListTableViews.h"

@interface HDMoreListView ()

@property (nonatomic, strong) HDWorkListTableViews *listView;
@property (nonatomic, strong) HDWorkListTableViews *listViewTwo;
@property (nonatomic, strong) HDWorkListTableViews *listViewThree;
@property (nonatomic, strong) HDWorkListTableViews *listViewFour;
@property (nonatomic, assign) CGRect aroundRect;
@property (nonatomic, strong)  PorscheConstantModel *firstData;
@property (nonatomic, strong)  PorscheConstantModel *secondData;


@end

@implementation HDMoreListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    //中间镂空的矩形框
    CGRect myRect = self.aroundRect;
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
//添加  点击其他区域的block
+ (void)showListViewWithView:(UIView *)aroundView Data:(NSMutableArray *)array direction:(UIPopoverArrowDirection)direction withType:(viewFormStyle)type complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete removeComplete:(void(^)(NSArray *dataArray))removeComplete {
    __block NSString *endString;
    CGRect rect = [aroundView convertRect:aroundView.bounds toView:KEY_WINDOW];
    HDMoreListView *view = [[HDMoreListView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    view.aroundRect = rect;
    if (removeComplete) {
        view.removewViewBlock = removeComplete;
    }
    WeakObject(view);
    
    view.listView = [HDWorkListTableViews showTableViewlistViewAroundView:aroundView superView:view direction:direction dataSource:array size:CGSizeMake(CGRectGetWidth(aroundView.frame), 200) seletedNeedDelete:NO complete:^(NSNumber *idx, BOOL needAccessoryDisclosureIndicator, HDWorkListTableViewsStyle style) {
        
        id model = [array objectAtIndex:[idx integerValue]];
        view.secondData = nil;
        view.firstData = model;
        //只有车系和车型两种
        if ([view.subviews containsObject:view.listViewTwo]) {
            [view.listViewTwo removeFromSuperview];
        }
        if (type == viewFormStyle_carType) { //车型车系
            
            [HDMoreListView classifyWithModel:model superView:viewWeak aroundView:viewWeak.listView direction:UIPopoverArrowDirectionRight endString:endString withType:viewFormStyle_carType complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
                complete(contentOne, contentTwo, idx);
            }];
            
        }else {
            [HDMoreListView classifyWithModel:model superView:viewWeak aroundView:viewWeak.listView direction:UIPopoverArrowDirectionRight endString:endString withType:viewFormStyle_other complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
                complete(contentOne, contentTwo, idx);
            }];
        }
        
    }];
    [KEY_WINDOW addSubview:view];
}


+ (void)showListViewWithView:(UIView *)aroundView Data:(NSMutableArray *)array direction:(UIPopoverArrowDirection)direction withType:(viewFormStyle)type complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete {
    __block NSString *endString;
    CGRect rect = [aroundView convertRect:aroundView.bounds toView:KEY_WINDOW];
    HDMoreListView *view = [[HDMoreListView alloc]initWithCustomFrame:KEY_WINDOW.frame];
    view.aroundRect = rect;
    
    WeakObject(view);
    
    view.listView = [HDWorkListTableViews showTableViewlistViewAroundView:aroundView superView:view direction:direction dataSource:array size:CGSizeMake(CGRectGetWidth(aroundView.frame), 200) seletedNeedDelete:NO complete:^(NSNumber *idx, BOOL needAccessoryDisclosureIndicator, HDWorkListTableViewsStyle style) {
        
        id model = [array objectAtIndex:[idx integerValue]];
        
        //只有车系和车型两种
        if ([view.subviews containsObject:view.listViewTwo]) {
            [view.listViewTwo removeFromSuperview];
        }
        if (type == viewFormStyle_carType) { //车型车系
            
            [HDMoreListView classifyWithModel:model superView:viewWeak aroundView:viewWeak.listView direction:UIPopoverArrowDirectionRight endString:endString withType:viewFormStyle_carType complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
                complete(contentOne, contentTwo, idx);
            }];
            
        }else {
            [HDMoreListView classifyWithModel:model superView:viewWeak aroundView:viewWeak.listView direction:UIPopoverArrowDirectionRight endString:endString withType:viewFormStyle_other complete:^(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx) {
                complete(contentOne, contentTwo, idx);
            }];
        }
        
    }];
    [KEY_WINDOW addSubview:view];
}


+ (void)showListViewWithView:(UIView *)aroundView Data:(NSMutableArray *)array direction:(UIPopoverArrowDirection)direction complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete {
    
    [HDMoreListView showListViewWithView:aroundView Data:array direction:direction withType:viewFormStyle_other complete:complete];
    
}

+ (void)showListViewWithView:(UIView *)aroundView Data:(NSMutableArray *)array direction:(UIPopoverArrowDirection)direction complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete removeComplete:(void(^)(NSArray *dataArray))removeComplete {
    [HDMoreListView showListViewWithView:aroundView Data:array direction:direction withType:viewFormStyle_other complete:complete removeComplete:removeComplete];

}



+ (void)classifyWithModel:(id)model superView:(HDMoreListView *)superView aroundView:(HDWorkListTableViews *)aroundView direction:(UIPopoverArrowDirection)direction endString:(NSString *)endString withType:(viewFormStyle)type complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete {
    
    if (type == viewFormStyle_carType) { //车型车系
        if ([model isKindOfClass:[PorscheConstantModel class]]) {
            PorscheConstantModel *data = (PorscheConstantModel *)model;
            if ([data.cvvaluedesc isEqualToString:@"全部"] && [data.cvsubid isEqual:@-1]) {
                complete(data,nil,-1);
                superView.firstData = data;
                superView.secondData = nil;
                [superView removeSelf];
            }else {
                complete(data,nil,-1);
                [HDStoreInfoManager shareManager].currpage = @1;
                [HDStoreInfoManager shareManager].pagesize = @100;
                [PorscheRequestManager getAllCarTypeConstantWithCarsPctid:data.cvsubid completion:^(NSArray<PorscheConstantModel *> * _Nullable carTListype, PResponseModel * _Nullable responser) {
                    
                    if (carTListype.count) {
                        [HDMoreListView addedMoreListViewWithDataArray:[carTListype mutableCopy] superView:superView arounfView:superView.listView direction:UIPopoverArrowDirectionRight complete:^(NSString *content,NSInteger idx) {
                            
                            PorscheConstantModel *temp = carTListype[idx];
                            
                            complete(data,temp,idx);
                            superView.secondData = temp;
                            [superView removeSelf];
                        }];
                    }else {
                        complete(data,nil,-1);
                        superView.firstData = data;
                        superView.secondData = nil;
                        [superView removeSelf];
                    }
                }];                
            }
        }
        
    }else {
        if ([model isKindOfClass:[NSString class]]) {
            PorscheConstantModel *temp = [[PorscheConstantModel alloc] init];
            temp.cvvaluedesc = model;
            complete(temp,nil,-1);
            superView.firstData = temp;
            superView.secondData = nil;
            [superView removeSelf];
        }else if ([model isKindOfClass:[PorscheConstantModel class]]) {
            PorscheConstantModel *tmp = model;
//            __block NSString *totalString = tmp.cvvaluedesc;
            complete(tmp,nil,-1);
            superView.firstData = tmp;
            superView.secondData = nil;
            if (tmp.children.count) {
                [HDMoreListView addedMoreListViewWithDataArray:[tmp.children mutableCopy] superView:superView arounfView:superView.listView direction:UIPopoverArrowDirectionRight complete:^(NSString *content,NSInteger idx) {
                    
                    PorscheSubConstant *tempSub = tmp.children[idx];
                    PorscheConstantModel *temp = [[PorscheConstantModel alloc] init];
                    temp.cvvaluedesc = content;
                    temp.cvsubid = tempSub.cvsubid;
                    complete(tmp,temp,idx);
                    superView.firstData = tmp;
                    superView.secondData = temp;
                    [superView removeSelf];
                }];
            }else {
                [superView removeSelf];
            }
        }
    }
}


+ (void)classifyWithModel:(id)model superView:(HDMoreListView *)superView aroundView:(HDWorkListTableViews *)aroundView direction:(UIPopoverArrowDirection)direction endString:(NSString *)endString complete:(void(^)(PorscheConstantModel *contentOne, PorscheConstantModel *contentTwo,NSInteger idx))complete {
    
    [HDMoreListView classifyWithModel:model superView:superView aroundView:aroundView direction:direction endString:endString withType:viewFormStyle_other complete:complete];
    
}



+ (void)addedMoreListViewWithDataArray:(NSMutableArray *)array superView:(HDMoreListView *)superView arounfView:(UIView *)aroundView direction:(UIPopoverArrowDirection)direction complete:(void(^)(id content,NSInteger idx))complete {
    
    
    HDMoreListView *view = (HDMoreListView *)superView;
    view.listViewTwo = [HDWorkListTableViews showTableViewlistViewAroundView:aroundView superView:superView direction:direction dataSource:array size:CGSizeMake(CGRectGetWidth(aroundView.frame), 200) seletedNeedDelete:NO complete:^(NSNumber *idx, BOOL needAccessoryDisclosureIndicator, HDWorkListTableViewsStyle style) {
        PorscheSubConstant *model = [array objectAtIndex:[idx integerValue]];
        complete(model.cvvaluedesc,[idx integerValue]);
        
//        [superView removeSelf];
    }];
}

- (instancetype)initWithCustomFrame:(CGRect)frame {
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    self = nib.firstObject;
    self.frame = frame;
    
    return self;
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    if (CGRectContainsPoint(self.listView.frame, point) || CGRectContainsPoint(self.listViewTwo.frame, point)|| CGRectContainsPoint(self.aroundRect, point)|| CGRectContainsPoint(self.listViewThree.frame, point)|| CGRectContainsPoint(self.listViewFour.frame, point)) {

        return [super hitTest:point withEvent:event];
    }
    
    [self removeSelf];
    
    return nil;
}

- (void)removeSelf {
    if (self.removewViewBlock) {
        NSMutableArray *array = [NSMutableArray array];
        if (self.firstData) {
            [array addObject:self.firstData];
        }
        
        if (self.secondData) {
            [array addObject:self.secondData];
        }
        self.removewViewBlock(array);
    }
    [self removeFromSuperview];
}




@end
