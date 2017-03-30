//
//  PorscheCustomView.m
//  HandleiPad
//
//  Created by Robin on 16/10/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheCustomView.h"
#import <AVKit/AVKit.h>
#import "HDWorkListTableViews.h"
#import "PorscheMultipleListhView.h"
#import "PorscheCustomModel.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height;
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width;


@interface PorscheCustomView () <UIAlertViewDelegate>

@property (nonatomic, strong)NSMutableDictionary *carDic;

@property (nonatomic, assign) PorscheCustomAlertViewBlcok alertViewBlcok;

@end

@implementation PorscheCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static PorscheCustomView *prosche;
+ (PorscheCustomView *)defaultProsche {
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        prosche = [[PorscheCustomView alloc] init];
    });
    return prosche;
}

- (void)showListView:(UIView *)view direction:(ListViewDirection)direction andDataArray:(NSArray *)arr celected:(void(^)(NSInteger))index {
    
    CGRect rect = [view convertRect:view.bounds toView:KEY_WINDOW];
    CGRect listRect;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(rect);
    switch (direction) {
        case ListViewDirectionUp:
            listRect = CGRectMake(rect.origin.x, rect.origin.y - arr.count * 40, rect.size.width, arr.count * 40);
            break;
        case ListViewDirectionDown:
            listRect = CGRectMake(rect.origin.x, CGRectGetMaxY(rect), rect.size.width, height);
            break;
        case ListViewDirectionLeft:
            listRect = CGRectMake(rect.origin.x - rect.size.width - 10, rect.origin.y, rect.size.width + 30, height);
            break;
        case ListViewDirectionRight:
            listRect = CGRectMake(CGRectGetMaxX(rect) + 10, rect.origin.y, rect.size.width + 30, 200);
            break;
        default:
            break;
    }
    
    UIView *cleanView = [[UIView alloc] initWithFrame:KEY_WINDOW.bounds];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    closeBtn.frame = cleanView.bounds;
    [cleanView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(removeMyListView:) forControlEvents:UIControlEventTouchUpInside];
    [cleanView addSubview:closeBtn];

    
    HDWorkListTableViews *planListView = [[HDWorkListTableViews alloc] initWithCustomFrame:CGRectZero];
    planListView.selectedRow = -1;
    planListView.style = HDWorkListTableViewsStyleCategory;
    planListView.frame = listRect;
    planListView.dataSource = arr;
    [planListView.tableView reloadData];
    __weak typeof(closeBtn)weakbtn = closeBtn;
    planListView.block = ^(NSNumber *number,BOOL needAccessoryDisclosureIndicator, HDWorkListTableViewsStyle style) {
        
        index([number integerValue]);
        [self removeMyListView:weakbtn];
    };
       [cleanView addSubview:planListView];
    [[UIApplication sharedApplication].keyWindow addSubview:cleanView];
}

- (HDWorkListTableViews *)getPlanListView {
    
    HDWorkListTableViews *planListView = [[HDWorkListTableViews alloc] initWithCustomFrame:CGRectZero];
    planListView.selectedRow = -1;
    planListView.style = HDWorkListTableViewsStyleCategory;
    return planListView;
}

- (NSMutableArray *)getCarType:(NSMutableDictionary *)dic {
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < dic.allKeys.count; i++) {
        
        NSString *str_1 = dic.allKeys[i];
        NSMutableDictionary *dic_1 = [dic valueForKey:str_1];
        
        if (!dic_1.allKeys.count) {
            NSArray *arr = @[str_1];
            [dataArray addObject:arr];
            continue;
        }
        
        for (NSInteger k = 0; k < dic_1.allKeys.count; k ++) {
            
            NSString *str_2 = dic_1.allKeys[k];
            NSMutableDictionary *dic_2 = [dic_1 valueForKey:str_2];
            
            if (!dic_2.allKeys.count) {
                NSArray *arr = @[str_1,str_2];
                [dataArray addObject:arr];
                continue;
            }
            for (NSInteger j = 0; j < dic_2.allKeys.count; j ++) {
                
                NSString *str_3 = dic_2.allKeys[j];
                NSMutableDictionary *dic_3 = [dic_2 valueForKey:str_3];
                
                if (!dic_3.allKeys.count) {
                    NSArray *arr = @[str_1,str_2,str_3];
                    [dataArray addObject:arr];
                    continue;
                }
                
                for (NSInteger n = 0; n < dic_3.allKeys.count; n ++) {
                    
                    NSString *str_4 = dic_3.allKeys[n];
                    NSArray *arr = @[str_1,str_2,str_3,str_4];
                    [dataArray addObject:arr];
                }
            }
        }
    }
    
    return dataArray;
}


- (void)saveAction:(UIButton *)sender {
    
    if (self.saveBlock) {
        
        NSMutableDictionary *dic = [self.carDic copy];
       NSMutableArray *array = [self getCarType:dic];
        self.saveBlock(array);
    }
    
    [sender.superview removeFromSuperview];
}

- (void)cancleAction:(UIButton *)sender {
    
    [sender.superview removeFromSuperview];
}

- (UIView *)getCleanView {
    
    UIView *cleanView = [[UIView alloc] initWithFrame:KEY_WINDOW.bounds];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    closeBtn.frame = cleanView.bounds;
    [cleanView addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(removeMyListView:) forControlEvents:UIControlEventTouchUpInside];
    [cleanView addSubview:closeBtn];
    
    return cleanView;
}

- (void)removeMyListView:(UIButton *)sender {
    
    [sender.superview removeFromSuperview];
}

@end
