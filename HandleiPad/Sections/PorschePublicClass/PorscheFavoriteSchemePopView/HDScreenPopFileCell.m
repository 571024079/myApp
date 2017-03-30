//
//  HDScreenPopFileCell.m
//  HandleiPad
//
//  Created by handou on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDScreenPopFileCell.h"
#import "HDScreenPopFileCellCollectionViewCell.h"
#import "MaterialTaskTimeDetailsView.h"
#import "HDLeftSingleton.h"
#import "HDPoperDeleteView.h"

static HDScreenPopFileCellCollectionViewCell *moveCell;

@interface HDScreenPopFileCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) MaterialTaskTimeDetailsView *detaileView;

@property (nonatomic, strong) UIView *cleanView;

@end

@implementation HDScreenPopFileCell {
    
    UIImageView *_cutView;
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.collectionView registerNib:[UINib nibWithNibName:@"HDScreenPopFileCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HDScreenPopFileCellCollectionViewCell"];
    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_collectionView addGestureRecognizer:longGesture];
}
#pragma mark - 工单中的方案
- (void)setInOrderFanganArray:(NSMutableArray *)inOrderFanganArray {
    _inOrderFanganArray = inOrderFanganArray;
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    
    static CGPoint startPoint;
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            startPoint = [longGesture locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:startPoint];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            
            HDScreenPopFileCellCollectionViewCell *cell = (HDScreenPopFileCellCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            moveCell = cell;
            CGRect cutFrame = [cell convertRect:cell.bounds toView:KEY_WINDOW];
            if (!_cutView) {
                _cutView = [[UIImageView alloc] init];
            }
            _cutView.image = [self imageFromView:cell Rect:cell.bounds];
            _cutView.frame = cutFrame;
            
            [KEY_WINDOW addSubview:_cutView];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            _cutView.frame = [moveCell convertRect:moveCell.bounds toView:KEY_WINDOW];
            break;
        case UIGestureRecognizerStateEnded:
        {
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            [_cutView removeFromSuperview];
            _cutView = nil;
            
            CGPoint endPoint = [longGesture locationInView:self.collectionView];
            BOOL showDetail = fabs(startPoint.x - endPoint.x) < 10.0 && fabs(startPoint.y - endPoint.y) < 10.0;
            if (showDetail) {
                
                [self showDetailViewWithModel:moveCell.model];
            }
            
            BOOL isIn = CGRectContainsPoint(self.collectionView.frame, [longGesture locationInView:self.collectionView]);
            if (isIn) return;
            
            WeakObject(self)
            [selfWeak deteleSchemeForScreenPopFileViewWithData:moveCell.model success:^{
//                [selfWeak.dataSource removeObject:moveCell.model];
//                moveCell.hidden = YES;
//                [selfWeak.collectionView deleteItemsAtIndexPaths:@[[selfWeak.collectionView indexPathForCell:moveCell]]];
                //用刷新界面来操作，防止界面展示的时候用老数据进行使用，不将cell踢出界面
                NSDictionary *dic = @{@"style":@"detele", @"data":moveCell.model};
                [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_EDITFAVORITE object:dic];
            }];
            
            
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"移除" message:@"确定移除此方案？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
//            [alertView show];
        }
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (buttonIndex) {
//        [self.dataSource removeObject:moveCell.model];
//        moveCell.hidden = YES;
//        [self.collectionView deleteItemsAtIndexPaths:@[[self.collectionView indexPathForCell:moveCell]]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_EDITFAVORITE object:nil];
//    }
//}

- (UIImage *)imageFromView:(UIView *)view  Rect:(CGRect)rect
{
    //创建一个基于位图的图形上下文并指定大小为CGSizeMake(300,500)
    UIGraphicsBeginImageContext(rect.size);
    
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形上下文的图片
    UIImage *extractImage =UIGraphicsGetImageFromCurrentImageContext();
    
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    
    //以png格式返回指定图片的数据
    NSData *imageData = UIImagePNGRepresentation(extractImage);
    UIImage *imge = [UIImage imageWithData:imageData];
    
    return imge;
}

- (void)setDataSource:(NSMutableArray<PorscheSchemeModel *> *)dataSource {
    _dataSource = dataSource;
    [_collectionView reloadData];
}

- (UIView *)cleanView {
    
    if (!_cleanView) {
        _cleanView = [[UIView alloc] initWithFrame:KEY_WINDOW.bounds];
        _cleanView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
        [close addTarget:self action:@selector(closeCleanView:) forControlEvents:UIControlEventTouchUpInside];
        close.frame = _cleanView.bounds;
        [_cleanView addSubview:close];
    }
    return _cleanView;
}

- (void)closeCleanView:(UIButton *)sender {
    
    [self.cleanView removeFromSuperview];
    [self.cleanView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.cleanView = nil;
    self.detaileView = nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 30;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 30;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((CGRectGetWidth(self.collectionView.frame) - 4*30) / 3, (CGRectGetWidth(self.collectionView.frame) - 4*30) / 3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(30, 30, 30, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HDScreenPopFileCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HDScreenPopFileCellCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDScreenPopFileCellCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    PorscheSchemeModel *model = _dataSource[indexPath.row];
    cell.model = model;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakObject(self);
    HDScreenPopFileCellCollectionViewCell *cell = (HDScreenPopFileCellCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 添加方案至工单，或者取消工单中的方案
    PorscheSchemeModel *data = selfWeak.dataSource[indexPath.item];
    if ([data.flag integerValue] == 1) {
        cell.userInteractionEnabled = NO;
        
        BOOL isEqual = NO;
        PorscheNewScheme *tempModel = nil;
        for (PorscheNewScheme *temp in selfWeak.inOrderFanganArray) {
            if ([data.schemeid integerValue] == [temp.wosstockid integerValue]) {
                isEqual = YES;
                tempModel = temp;
                break;
            }
        }
        
        
        if (isEqual && tempModel) {
            if ([HDLeftSingleton isUserAdded:tempModel.schemeaddperson]) {
                [HDPoperDeleteView showAlertTableViewWithAroundView:cell withDataSource:@[@"误操作, 移除方案", @"暂不做, 下次提醒"] direction:UIPopoverArrowDirectionLeft selectBlock:^(NSInteger index) {
                    switch (index) {
                        case 0:
                            //删除方案
                            [selfWeak deleteSchemeWithOrderList:cell withDate:data];
                            break;
                        case 1:
                            [selfWeak affirmOrCancelSchemeWithOrderList:data isChoose:@0 withStyle:@"cancelFangan"];
                            break;
                        default:
                            break;
                    }
                }];
            }else {
                [selfWeak deleteSchemeWithOrderList:cell withDate:data];
            }
            
        }else {
            [selfWeak deleteSchemeWithOrderList:cell withDate:data];
        }
        
        
    }else {
        // 增加权限限制
        if ([[HDLeftSingleton shareSingleton].saveStatus integerValue] == 1) {
            return;
        }
        data.schemetype = @1;
        cell.userInteractionEnabled = NO;
        
        if ([data.ordersolutionid integerValue]) { //当前方案在工单中但是没有确认
            [selfWeak affirmOrCancelSchemeWithOrderList:data isChoose:@1 withStyle:@"affirmFangan"];
            
        }else {//当前方案(不)在工单中
            [PorscheRequestManager increaseItemWithModel:data isDelete:NO complete:^(NSInteger status, PResponseModel * _Nonnull model) {
                cell.userInteractionEnabled = YES;
                if (status == 100) {
                    if (model.object[@"ordersolutionid"]) {
                        data.ordersolutionid = model.object[@"ordersolutionid"];
                        data.flag = @1;
                    }
                    NSDictionary *dic = @{@"style":@"addFangan", @"data":data};
                    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_EDITFAVORITE object:dic];
                    //                [[NSNotificationCenter defaultCenter] postNotificationName:TECHICIANADDITION_ADD_ITEM_NOTIFINATION object:nil];
                    [[HDLeftSingleton shareSingleton] reloadOrderList];
                }else {
                    [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:model.msg height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
                }
            }];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据
    id objc = [_dataSource objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [_dataSource removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [_dataSource insertObject:objc atIndex:destinationIndexPath.item];
    
//    [self.dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
     [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_EDITFAVORITE object:nil];
}

#pragma mark - 长按cell出详情
- (void)showDetailViewWithModel:(PorscheSchemeModel *)model {
    
    [MaterialTaskTimeDetailsView showWithID:model.schemeid.integerValue detailType:MaterialTaskTimeDetailsTypeScheme];
}

#pragma mark - ----- 删除方案
- (void)deteleSchemeForScreenPopFileViewWithData:(PorscheSchemeModel *)data success:(void (^)())success {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:data.scfid forKey:@"uid"];
    
    [PorscheRequestManager deteleSchemeDataForScreenPopFileWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            success();
        }
    }];
}

#pragma mark - 从工单中删除方案
- (void)deleteSchemeWithOrderList:(HDScreenPopFileCellCollectionViewCell *)cell withDate:(PorscheSchemeModel *)data {
    [PorscheRequestManager increaseItemWithModel:data isDelete:YES complete:^(NSInteger status, PResponseModel * _Nonnull model) {
        cell.userInteractionEnabled = YES;
        if (status == 100) {
            if (model.object[@"ordersolutionid"]) {
                data.ordersolutionid = model.object[@"ordersolutionid"];
                data.flag = @0;
            }
            NSDictionary *dic = @{@"style":@"deteleFangan", @"data":data};
            [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_EDITFAVORITE object:dic];
            //                [[NSNotificationCenter defaultCenter] postNotificationName:TECHICIANADDITION_ADD_ITEM_NOTIFINATION object:nil];
            [[HDLeftSingleton shareSingleton] reloadOrderList];
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:model.msg height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
        }
    }];
}

#pragma mark - 将工单中的方案确认或者取消确认
- (void)affirmOrCancelSchemeWithOrderList:(PorscheSchemeModel *)data isChoose:(NSNumber *)isChoose withStyle:(NSString *)style {
    [PorscheRequestManager chooseBtWithid:data.ordersolutionid type:@3 isChoose:isChoose success:^{
        data.flag = isChoose;
        NSDictionary *dic = @{@"style":style, @"data":data};
        [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_EDITFAVORITE object:dic];
        [[HDLeftSingleton shareSingleton] reloadOrderList];
    } fail:^{
        
    }];
}



@end
