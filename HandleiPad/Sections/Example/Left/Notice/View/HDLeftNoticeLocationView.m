//
//  HDLeftNoticeLocationView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftNoticeLocationView.h"
#import "HDWorkListCollectionViewCell.h"
#import "PorscheItemModel.h"
#import "MaterialTaskTimeDetailsView.h"
#import "HDLeftSingleton.h"
#import "HDLeftNoticeListModel.h"


@interface HDLeftNoticeLocationView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



@property (nonatomic, strong) MaterialTaskTimeDetailsView *detaileView;

@property (nonatomic, strong) UIView *clearView;

@end

@implementation HDLeftNoticeLocationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    self = [array objectAtIndex:0];
    self.frame = frame;
    
    //cell注册
    [_collectionView registerNib:[UINib nibWithNibName:@"HDWorkListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"worklistCVCidentifier1"];
    
    return self;
}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HDWorkListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"worklistCVCidentifier1" forIndexPath:indexPath];
    
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"worklistCVCidentifier1" owner:nil options:nil];
        cell = array.firstObject;
    }
    [cell setDefaultHidden];
    
    HDLeftNoticeFanganModel *data = _dataSource[indexPath.item];
    PorscheCarMessage *model = [[PorscheCarMessage alloc] init];
    model.message = data.schemename;
    model.modelStyle = (PorscheCarMessageStyle)[data.readstate integerValue];
    model.schemeid = data.schemeid;
    model.noticeid = data.noticeid;

    cell.model = model;
    WeakObject(self);
    cell.clickBlock = ^() {
        
        HDLeftNoticeFanganModel *model = selfWeak.dataSource[indexPath.item];
        
        if ([HDPermissionManager isNotThisPermission:HDTaskNotice_MyShopNotice_Read])
        {
            return ;
        }
        
        // 是否需要显示加入工单按钮
        BOOL isShould = NO;
        if ( [selfWeak.model.wostatus integerValue] == 2 || [selfWeak.model.wostatus integerValue] == 4) {
            isShould = YES;
        }
        
        WeakObject(self)
        [MaterialTaskTimeDetailsView showNotificationSchemeDetail:[model.schemeid integerValue] noticeID:[model.noticeid integerValue] shouldAddToOrder:isShould clickAction:^(DetailViewBackType type, NSInteger schemeid, id model){
            if (type == DetailViewBackTypeJoinWorkOrder) {
                
                if ([selfWeak.model.orderid integerValue]) {
                    // 调用添加方案
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    [param hs_setSafeValue:@(schemeid) forKey:@"schemestockid"];
                    [param hs_setSafeValue:@1 forKey:@"schemtype"];
                    [param hs_setSafeValue:@0 forKey:@"schemid"];
                    [param hs_setSafeValue:@([HDLeftSingleton shareSingleton].stepStatus) forKey:@"processstatus"];
                    [param hs_setSafeValue:@1 forKey:@"type"];

                    
                    [PHTTPRequestSender sendRequestWithURLStr:WORK_ORDER_INCREASE_SCHEME_URL parameters:param completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
                        if (responser.status == 100)
                        {
//                            MBProgressHUD *hub = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
                            
//                            [hub changeTextModeMessage:@"添加成功" toView:KEY_WINDOW];
                            
                            [[[HDLeftSingleton shareSingleton] rightVC] baseReloadData];
                        }
                    }];
                    
                    
                    
                }
            }
        }];
#warning 如果当前方案已不存在 会返回-100 自动拉取新列表数据
        
    };
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(80, 72);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 47;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 25;
}


//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}



- (IBAction)leftBtAction:(UIButton *)sender {
    
    HDWorkListCollectionViewCell *cell = _collectionView.visibleCells.firstObject;
    
    NSIndexPath *idx = [_collectionView indexPathForCell:cell];
    
    if (idx.item > 0) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx.item - 1 inSection:idx.section] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
}

- (IBAction)rightBtAction:(UIButton *)sender {
    HDWorkListCollectionViewCell *cell = _collectionView.visibleCells.lastObject;
    
    NSIndexPath *idx = [_collectionView indexPathForCell:cell];
    
    if (idx.item < _dataSource.count - 1) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:idx.item + 1 inSection:idx.section] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}

- (UIView *)clearView {
    if (!_clearView) {
        _clearView = [[UIView alloc]initWithFrame:KEY_WINDOW.frame];
        _clearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = _clearView.frame;
        [_clearView addSubview:button];
    }
    return _clearView;
}

- (void)hiddenView:(UIButton *)sender {
    WeakObject(self)
    [selfWeak.clearView removeFromSuperview];
    [selfWeak.detaileView removeFromSuperview];

}



@end
