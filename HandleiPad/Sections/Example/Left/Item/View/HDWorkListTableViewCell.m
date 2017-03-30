//
//  HDWorkListTableViewCell.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/8/31.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDWorkListTableViewCell.h"
#import "HDWorkListCollectionViewCell.h"
#import "HDWorkListCollectionViewCelltwo.h"
#import "HDWorkListCollectionViewCellthree.h"
#import "AlertViewHelpers.h"
#import "PorscheItemModel.h"
//删除弹窗
#import "HDPoperDeleteView.h"


extern NSString *const touchStartstr;
extern NSString *const touchMovedstr;
extern NSString *const touchEndedStr;

//非收藏夹的cell高度
#define cellSpace 43
#define collectionViewHeight (LEFT_WITH - 40)/3 - 35

@interface HDWorkListTableViewCell ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//删除弹窗
@property (nonatomic, strong) HDPoperDeleteView *popDeleteView;


//接收imageView时，生成的imageView
@property (nonatomic, strong) UIImageView *floatImageView;


//移动
@property (nonatomic, strong) NSIndexPath *fromIndexpath;
//点击cell所在window的rect
@property (nonatomic, assign) CGRect selectedCellRect;
//拖动产生的ImageView
@property (nonatomic, strong) UIImageView *createImageView;
//点击过item的index
@property (nonatomic, assign) NSInteger oldItem;
//重置，<恢复至未点击状态>
@property (nonatomic, assign) BOOL reSet;

//获取长按拖动状态
@property (nonatomic, assign) BOOL isDrag;

//点击按钮遮罩
@property (nonatomic, strong) UIView *clearView;
//起始坐标
@property (nonatomic, assign) CGPoint fromPoint;
// 提示标签
@property (nonatomic, strong) UILabel *displayLb;
//方框View
@property (nonatomic, strong) UIView *cubView;
//判定滑动tableView 一次只走一次
@property (nonatomic, assign) BOOL isOnceNotification;
//定时器控制状态值，取消显示详情的界面
@property (nonatomic, assign) BOOL isAlreadyShow;

//按钮的位置
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, assign) NSInteger index;

@end
static NSString *identifier1 = @"worklistCVCidentifier1";
static NSString *identifier2 = @"worklistCVCidentifier2";

@implementation HDWorkListTableViewCell


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    	
    [_collectionView registerNib:[UINib nibWithNibName:@"HDWorkListCollectionViewCelltwo" bundle:nil] forCellWithReuseIdentifier:identifier2];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HDWorkListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchBegin:) name:touchStartstr object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesEnd:) name:touchEndedStr object:nil];
    
    //默认为NO，便于显示提示显示详情页面
    _isAlreadyShow = NO;
    _isOnceNotification = NO;
}

- (void)addLongPressAction {
    
    UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveRow:)];
    longPress.minimumPressDuration = 0.2;
    
    [_collectionView addGestureRecognizer:longPress];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([_style isEqualToString:@"collection"]) {
        return 1;
    }
    return self.itemArray.count ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([_style isEqualToString:@"collection"]) {
        return self.dataSource.count + 1;
    }
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //将collection装入数组《目前7个》
    
    //------------------------------------------收藏夹
    if ([_style isEqualToString:@"collection"]) {
        
        [HDLeftSingleton shareSingleton].leftCollectionView = collectionView;
        
        
        HDWorkListCollectionViewCelltwo *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HDWorkListCollectionViewCelltwo" owner:nil options:nil] objectAtIndex:0];
        }
        
        if (indexPath.row == 0) {
            cell.collectionView.hidden = YES;
            cell.array = nil;
            cell.label.text = @"新建";
        } else {
            PorscheSchemeFavoriteModel *data = self.dataSource[indexPath.item - 1];
            cell.collectionView.hidden = NO;
            cell.dataSource = [data.schemelist mutableCopy];
            cell.label.text = data.favoritename;
            [cell layoutIfNeeded];
            //给九宫格的cell添加手势，进入大编辑框
            
            UITapGestureRecognizer *longPressG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowDeltailViewForWorkList:)];
            [cell addGestureRecognizer:longPressG];
        }
        return cell;
        
    }else {
        //----------------------------------非收藏夹
        _leftScrollBt.hidden = NO;
        
        _rightScrollBt.hidden = NO;
        
        HDWorkListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
        
        if (!cell) {
            NSArray *nibCells = [[NSBundle mainBundle] loadNibNamed:@"HDWorkListCollectionViewCell" owner:self options:nil];
            cell = [nibCells objectAtIndex:0];
            
        }
        [self setupCell:cell index:indexPath];
        [cell layoutIfNeeded];

        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_style isEqualToString:@"collection"]) {
        return CGSizeMake((LEFT_WITH - 40 - 15)/4 - 10 , (LEFT_WITH - 40 - 15)/4 - 10 + 20);
    }
    //40.边距 设计图间距43，一行三个item，两个间距为86。三分为28(改成28，方便取6个字的时候依然是一行，切两边的距离调成9，文字大小变成10)(改成28之后，间距需改动至42，不然最后一个cell点击状态显示不完全)
    return CGSizeMake((LEFT_WITH - 40)/3 - 28 , (LEFT_WITH - 40)/3 - 35);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([_style isEqualToString:@"collection"]) {
        return 18;
    }else if ([_style isEqualToString:@"page"]) {
        return 55;
    }else {
        return 42;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([_style isEqualToString:@"collection"]) {
        return 30;
    }else if ([_style isEqualToString:@"page"]) {
        return 35;
    }else {
        return 50;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (![_style isEqualToString:@"collection"]) {
        if (scrollView.contentOffset.x + 324 > scrollView.contentSize.width) {
            NSLog(@"可以刷新了------");
//            [[NSNotificationCenter defaultCenter] postNotificationName:WORK_ORDER_LEFT_REFRESH_MORE_NOTIFINATION object:_style];
            [[HDLeftSingleton shareSingleton] reloadSchemeLeftData:_style];

        }
    }
    
}

//- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
//{
//    CGFloat pageSize = 324;
//    NSInteger page = roundf(offset.x / pageSize);
//    CGFloat targetX = pageSize * page;
//    return CGPointMake(targetX, offset.y);
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
//    targetContentOffset->x = targetOffset.x;
//    targetContentOffset->y = targetOffset.y;
//}

- (void)setupCell:(HDWorkListCollectionViewCell *)cell index:(NSIndexPath *)indexPath {
    
    [self cellBlockActionWithCell:cell index:indexPath];

    //方案数据
    if ( [self.itemArray[indexPath.item] isKindOfClass:[PorscheSchemeModel class]]) {
        PorscheSchemeModel *model = self.itemArray[indexPath.item];
        [self setupCellTextWithCell:cell name:model.schemename schemeprice:model.schemeprice];
        [self setupCellImageWithCell:cell levelid:model.schemelevelid];
        [self setupContainItemWithModel:model cell:cell];
    }else {
        PorscheNewScheme *model = self.itemArray[indexPath.item];
        [self setupCellTextWithCell:cell name:model.schemename schemeprice:model.solutiontotaloriginalpriceforscheme];
        [self setupCellImageWithCell:cell levelid:model.schemelevelid];

    }
}

- (void)setupCellTextWithCell:(HDWorkListCollectionViewCell *)cell name:(NSString *)name schemeprice:(NSNumber *)schemeprice {
    cell.selectedImg.hidden = YES;
    cell.detialImg.hidden = YES;
    cell.oneCellPriceLb.text = @"";
    cell.oneCellContentLb.text = @"";
    cell.contentLb.text = @"";
    NSString *endString = name;
    cell.contentLb.font = [UIFont systemFontOfSize:12];
    
    
//    BOOL isUnfinished = [_style isEqualToString:@"item"];//未完成因为价格为零 目前不显示
    
    //工时文字个数7，显示为上5，下显示其余
    if (name.length == 7) {
        NSString *string = [name substringToIndex:5];
        NSString *lastString = [name substringFromIndex:5];
        endString = [NSString stringWithFormat:@"%@\n%@", string, lastString]; // 设置特定字符长度换行
        NSString *price = [NSString stringWithFormat:@"￥%.f",[schemeprice floatValue]];
        NSString *totalStr = /*isUnfinished ? endString : */[NSString stringWithFormat:@"%@\n%@",endString,price];
        cell.contentLb.text = totalStr;
        
    }else if (name.length > 7 && name.length<= 10){//工时文字小于7，价格和工时
        NSString *string = [name substringToIndex:6];
        NSString *lastString = [name substringFromIndex:6];
        endString = [NSString stringWithFormat:@"%@\n%@", string, lastString]; // 设置特定字符长度换行
        NSString *price = [NSString stringWithFormat:@"￥%.f",[schemeprice floatValue]];
        NSString *totalStr =/* isUnfinished ? name : */[NSString stringWithFormat:@"%@\n%@",endString,price];
        cell.contentLb.text = totalStr;
        
    }else if (name.length < 7){
        NSString *price = [NSString stringWithFormat:@"￥%.f",[schemeprice floatValue]];
        NSString *totalStr = /*isUnfinished ? name : */[NSString stringWithFormat:@"%@\n%@",name,price];
        cell.contentLb.text = totalStr;
    }else {
        NSString *contentStr = [name substringToIndex:10];
        NSString *string = [contentStr substringToIndex:6];
        NSString *lastString = [contentStr substringFromIndex:6];
        NSString *endString = [NSString stringWithFormat:@"%@\n%@…", string, lastString]; // 设置特定字符长度换行
        
        NSString *price = [NSString stringWithFormat:@"￥%.f",[schemeprice floatValue]];
        
        NSString *totalStr = /*isUnfinished ? [contentStr stringByAppendingString:@"…"] : */[NSString stringWithFormat:@"%@\n%@",endString,price];
        cell.contentLb.text = totalStr;
    }
}

- (void)setupCellImageWithCell:(HDWorkListCollectionViewCell *)cell levelid:(NSNumber *)levelid {
    
    //初始cell的背景图
    cell.oneCellBGImg.hidden = YES;
    cell.oneCellBGImgTwo.hidden = NO;
    cell.oneCellBGImgTwo.image = nil;
    cell.categoryLb.text = nil;
    cell.selectedImg.image = nil;
    
    if ([levelid integerValue] == 0 || [levelid integerValue] > 4) {//后台返回不和规范时，显示安全级别
        levelid = @1;
    }
    
    if ([levelid integerValue]== 1) {
        cell.oneCellBGImgTwo.image = [UIImage imageNamed:@"work_list_7.png"];
        cell.selectedImg.image = [UIImage imageNamed:@"work_list_31.png"];
        cell.categoryLb.text = @"安全";
        
        
    }else if ([levelid integerValue]== 2) {
        cell.oneCellBGImgTwo.image = [UIImage imageNamed:@"work_list_8.png"];
        cell.selectedImg.image = [UIImage imageNamed:@"work_list_33.png"];
        cell.categoryLb.text = @"隐患";
        
    }else if ([levelid integerValue]== 3) {
        cell.oneCellBGImgTwo.image = [UIImage imageNamed:@"item_blue_normal.png"];
        cell.selectedImg.image = [UIImage imageNamed:@"work_list_32.png"];
        cell.categoryLb.text = @"信息";
        
    }else if ([levelid integerValue]== 4) {
        cell.oneCellBGImgTwo.image = [UIImage imageNamed:@"work_list_14.png"];
    }
    if ([_style isEqualToString:@"item"]) {
        
        cell.detialImg.hidden = NO;
    }
}

//设置 在工单方案的显示
- (void)setupContainItemWithModel:(PorscheSchemeModel *)model cell:(HDWorkListCollectionViewCell *)cell {
    BOOL iscontain = NO;
    model.flag = @0;
    model.ordersolutionid = nil;
    if (self.idArray) {
        for (PorscheNewScheme *tmp in self.idArray) {
            if ([model.schemeid integerValue] == [tmp.wosstockid integerValue]) {
                iscontain = YES;
                model.flag = tmp.wosisconfirm;
                model.ordersolutionid = tmp.schemeid;
                break;
            }
        }
    }
    if (iscontain) {
        
        if (![_style isEqualToString:@"item"]) {
            //设置, 当取消确认的时候不能被选中, 即使方案在工单中
            if ([model.flag integerValue] == 1) {
                cell.selectedImg.hidden = NO;
                cell.oneCellBGImg.hidden = NO;
                cell.oneCellBGImgTwo.hidden = YES;
            }else {
                cell.selectedImg.hidden = YES;
                cell.oneCellBGImg.hidden = YES;
                cell.oneCellBGImgTwo.hidden = NO;
            }
            
            if ([model.schemelevelid integerValue] == 1) {
                cell.oneCellBGImg.image = [UIImage imageNamed:@"save_selected.png"];
            }else if ([model.schemelevelid integerValue] == 2) {
                cell.oneCellBGImg.image = [UIImage imageNamed:@"item_black-selected.png"];
            }else if ([model.schemelevelid integerValue] == 3) {
                cell.oneCellBGImg.image = [UIImage imageNamed:@"message_seleted.png"];
            }
        }
    }
}
//cell的block事件
- (void)cellBlockActionWithCell:(HDWorkListCollectionViewCell *)cell index:(NSIndexPath *)indexPath {
    WeakObject(self);
    WeakObject(cell)
    cell.block = ^(UIView *sender,HDWorkListCollectionViewCellTapStyle style) {
#pragma mark  右边不是技师增项  cell相关点击失效
        if (![HDLeftSingleton shareSingleton].isTechicianAdditionVC) {
            
        }else if ([[HDLeftSingleton shareSingleton].saveStatus integerValue] == 1) {
            
        }else if (style == HDWorkListCollectionViewCellTapStyleOne) {//单击
            id model = selfWeak.itemArray[indexPath.item];
            //添加相关model
            [selfWeak addedItemActionWithModel:model cell:cellWeak isTap:YES];
            
        }else {//双指
            
        }
        
    };
}

#pragma mark  测试    进行中（删除或者添加model）

- (void)addedSchemeTestWithDic:(id)model isDelete:(BOOL)isDelete {
    WeakObject(self);
//    model.schemetype = @1;
    MBProgressHUD *hud = [MBProgressHUD showProgressMessage:@"" toView:KEY_WINDOW];
    if ([model isKindOfClass:[PorscheSchemeModel class]]) {
        [PorscheRequestManager increaseItemWithModel:model isDelete:isDelete complete:^(NSInteger status, PResponseModel * _Nonnull model) {
            [hud hideAnimated:YES];
            if (status == 100) {
                NSLog(@"添加至工单成功!");
                [selfWeak successToReloadSchemeData];
                
            }else {
                NSLog(@"添加至工单失败!");
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:model.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
            }
        }];
    }else {//未完成方案
        [PorscheRequestManager increaseUnfinishedItemWithModel:model isDelete:isDelete complete:^(NSInteger status, PResponseModel * _Nonnull model) {
            [hud hideAnimated:YES];
            if (status == 100) {
                NSLog(@"添加至工单成功!");
                [selfWeak successToReloadSchemeData];
                
            }else {
                NSLog(@"添加至工单失败!");
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:model.msg height:60 center:HD_FULLView.center superView:HD_FULLView];
            }
        }];
    }
    
}

//添加/删除 成功之后刷新界面
- (void)successToReloadSchemeData {
//    if ([self.style isEqualToString:@"item"]) {//未完成
//        object = kUnfinishedScheme;
//    }else if (![self.style isEqualToString:@"collection"]) {//厂方本地我的
//        object =kScheme;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:TECHICIANADDITION_ADD_ITEM_NOTIFINATION object:nil];
    [[HDLeftSingleton shareSingleton] reloadOrderList];

}



#pragma mark - 长按方案库cell出详情
- (void)tapShowDeltailViewForWorkList:(UITapGestureRecognizer *)tapG {
    CGPoint location = [tapG locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if (indexPath.item == 0) return; //第一个是添加cell
    HDWorkListCollectionViewCell *cell = (HDWorkListCollectionViewCell *)tapG.view;
    //这里把cell做为第一响应(cell默认是无法成为responder,需要重写canBecomeFirstResponder方法)
    [cell becomeFirstResponder];
    
    HDScreenPopFileView *popView = [[HDScreenPopFileView alloc] initWithCustomFrame:CGRectMake(0, 0, HD_WIDTH, HD_HEIGHT)];
    PorscheSchemeFavoriteModel *data = self.dataSource[indexPath.item - 1];
    if (self.idArray.count) {
        popView.inOrderFanganArray = [self.idArray mutableCopy];
    }
    popView.titleName = data.favoritename;
    popView.dataSource = [data.schemelist mutableCopy];
    popView.favorialDataArray = self.dataSource;
    
    WeakObject(self)
    WeakObject(popView)
    
    popView.beginEdit = NO;
    popView.backBlock = ^() {
        if (selfWeak.refreshFovriteListBlock) {
            selfWeak.refreshFovriteListBlock();
        }
    };
    popView.shouldReturnBlock = ^(NSString *string) {
        [selfWeak changeFavoriteNameWithName:string withFavoriteData:data];
    };
    popView.deleteFavoritBlock  = ^() {
        
//        if (popViewWeak.beginEdit) {
//            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"请修改收藏夹名称" height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
//            popViewWeak.beginEdit = YES;
//            return ;
//        }else {
            [selfWeak deteleFavoriteForListWithData:data success:^{
//                [popViewWeak backWithTap:nil];
            }];
//        }
    };
    
    [HD_FULLView addSubview:popView];
}

- (void)getRealLeftAndRightPointArray {
    [[HDLeftSingleton shareSingleton].pointArray removeAllObjects];
    for (UICollectionViewCell *tmpCell in [HDLeftSingleton shareSingleton].allCollectionArray) {
        HDWorkListTableViewCell *cell = (HDWorkListTableViewCell *)tmpCell.superview.superview;
        
        CGRect leftRect = [cell convertRect:cell.leftScrollBt.frame toView:self.window];
        
        CGRect rightRect = [cell convertRect:cell.rightScrollBt.frame toView:self.window];
        
        
        NSArray *array = @[[NSValue valueWithCGRect:leftRect],[NSValue valueWithCGRect:rightRect]];
        
        [[HDLeftSingleton shareSingleton].pointArray addObject:array];
    }
}

- (void)leftAndRightActionWithTapPoint:(CGPoint)tapPoint {
    WeakObject(self);
    [[HDLeftSingleton shareSingleton].pointArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *tmpArray = obj;
        
        [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger arrayIdx, BOOL * _Nonnull stop) {//0：左按钮，1：右按钮
            
            CGRect tmpRect = [obj CGRectValue];
            //当前点在此范围内
            if (CGRectContainsPoint(tmpRect, tapPoint)) {
                selfWeak.idx = idx;
                selfWeak.index = arrayIdx;
                [selfWeak sendMessageWithNotification];
                
            }
            
        }];
    }];
}

- (void)setupSelectedCellRectWithPoint:(CGPoint)tapPoint {
    _fromPoint = tapPoint;
    
    CGPoint tapCenter = _fromPoint;
    
    tapCenter.x -= 20;
    tapCenter.y -= 20;
    
    _selectedCellRect = CGRectMake(0, 0, 40, 40);
    
    _selectedCellRect.origin = tapCenter;
    
}


- (void)addHintLabelWithPoint:(CGPoint)tapPoint {
    
    CGPoint center = tapPoint;
    
    center.y -= 60;
    
    self.displayLb.center = center;
    
    [self.clearView addSubview:self.displayLb];
    
    [self.window addSubview:self.clearView];
}

- (void)addedCreatImageView {
    
    HDWorkListCollectionViewCell *cell = (HDWorkListCollectionViewCell *)[_collectionView cellForItemAtIndexPath:_fromIndexpath];

    _createImageView = [self createItemImageView:cell];
    
    //更改imageView的中心点为手指点击位置
    CGPoint windowPoint = [_collectionView convertPoint:cell.center toView:nil];
    
    _createImageView.center = windowPoint;
    
    _createImageView.alpha = 0.0;
    
}

- (void)showCreatImageViewWithPoint:(CGPoint)tapPoint {
    WeakObject(self);
    if (!CGRectContainsPoint(_selectedCellRect, tapPoint)) {
        [UIView animateWithDuration:0.1 animations:^{
            
            selfWeak.createImageView.center = tapPoint;
            selfWeak.createImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
            selfWeak.createImageView.alpha = 1;
            
            [selfWeak changeShowDetialView];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)needSendNotifinationToScrollTableViewForY:(CGPoint)tapPoint {
    //164 +  收藏夹cell高度(LEFT_WITH - 40 - 15) / 4 + 15
    if (!_isOnceNotification) {
        if (tapPoint.y < 164 + (LEFT_WITH - 40 - 15) / 4 + 15) {//添加至收藏夹时，会调用。
            if ([HDLeftSingleton shareSingleton].tableViewY > 0) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:PROJECT_SCROLL_TABLEVIEW_NOTIFINATION object:nil];
                [[HDLeftSingleton shareSingleton] scrollSchemeLeftToTop:nil];
                _isOnceNotification = YES;
            }
        }
    }
}

//拖动

- (void)moveRow:(UILongPressGestureRecognizer *)sender
{
    //不是技师或者服务顾问界面，不可以移动
    if (![HDLeftSingleton shareSingleton].isTechicianAdditionVC) {
        return;
    }
    //锁定状态下，不能操作
    if ([[HDLeftSingleton shareSingleton].saveStatus integerValue] == 1) {
        return;
    }
    
    //收藏夹不能拖动
    if ([_style isEqualToString:@"collection"]) {
        return;
    }
    WeakObject(self);
    //对于window的相对位置
    CGPoint point = [sender locationInView:_collectionView];
    
    CGPoint tapWindowPoint = [_collectionView convertPoint:point toView:nil];
    
    if (!_isDrag) {//拖动即设置contentoffset.y
        
        _isDrag = YES;
        
        _fromIndexpath = [_collectionView indexPathForItemAtPoint:point];
        
        if (!_fromIndexpath) {
            return;
        }
        
        [HDLeftSingleton shareSingleton].isDrag = YES;

    }
  
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [HDLeftSingleton shareSingleton].dragCubScheme = self.itemArray[_fromIndexpath.row];
        //是否已经显示详情
        if (!_isAlreadyShow) {//未显示详情label 主要是获取一次的fromPoint
            if (![self.window.subviews containsObject:self.clearView]) {
                
                [self setupSelectedCellRectWithPoint:tapWindowPoint];
                
                [self addHintLabelWithPoint:tapWindowPoint];
                
            }
            
        }
        
        [self addedCreatImageView];
        
        
    }else if (sender.state == UIGestureRecognizerStateChanged) {
        
        //实时获取当前 左右滑的按钮坐标
        [self getRealLeftAndRightPointArray];
        //左右滑动事件
        [self leftAndRightActionWithTapPoint:tapWindowPoint];
        //当滑动至特殊位置，改变tableView的contentoffSet。y
        [self needSendNotifinationToScrollTableViewForY:tapWindowPoint];
        // 更改createImanegView的显示
        [self showCreatImageViewWithPoint:tapWindowPoint];
        
        if (![_style isEqualToString:@"item"]) {//非未完成项目拖动
            _createImageView.center = tapWindowPoint;

            if (tapWindowPoint.y > 164 && tapWindowPoint.y < 164 + (LEFT_WITH - 20 - 15) / 4 + 15) {
                UICollectionViewCell *endCell;
                UICollectionView *favoriteCollection = [HDLeftSingleton shareSingleton].allCollectionArray[0];
                
                for (UICollectionViewCell *cell in favoriteCollection.visibleCells) {
                    
                    CGRect cellRect = [cell convertRect:cell.bounds toView:KEY_WINDOW];
                    
                    BOOL contaons = CGRectContainsPoint(cellRect, tapWindowPoint);
                    
                    if (contaons) {
                        
                        endCell = cell;
                        break;
                    }
                }
                if (!endCell) {
                    return;
                }
                NSIndexPath *indexPath = [favoriteCollection indexPathForCell:endCell];
                
                HDWorkListCollectionViewCelltwo *cell = (HDWorkListCollectionViewCelltwo *)[[HDLeftSingleton shareSingleton].leftCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:0]];
                
                if (_oldItem != indexPath.row) {
                    if (self.floatImageView) {
                        [self.floatImageView removeFromSuperview];
                        self.floatImageView = nil;
                    }
                    if (cell&& [HDLeftSingleton  shareSingleton].tableViewY < ((LEFT_WITH - 40 - 15) / 4 + 15) / 2) {
                        
                        self.floatImageView = [self createItemImageView:cell];
                        
                        CGRect windowRect = [cell convertRect:cell.bounds toView:KEY_WINDOW];

                        self.floatImageView.frame = windowRect;
                        
                        [self.window bringSubviewToFront:_createImageView];
                        _oldItem = indexPath.row;
                    }
                    
                }
                if (selfWeak.floatImageView) {
                    self.floatImageView.transform = CGAffineTransformMakeScale(1.15, 1.15);
                }
            }else {
                if (self.floatImageView) {
                    [self.floatImageView removeFromSuperview];
                    self.floatImageView = nil;
                    _oldItem = -1;
                }
            }
        }
   
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (CGRectContainsPoint(_selectedCellRect, tapWindowPoint)) {
            if ([self.window.subviews containsObject:self.clearView]) {
                //在原cell上松手显示详情
                if (self.block) {
                    self.block([HDLeftSingleton shareSingleton].dragCubScheme);
                }
            }
        }
        _isDrag = NO;//拖动结束
        
        [self changeShowDetialView];
        
        //提示详情窗口设置初始状态
        _isAlreadyShow = NO;
        //恢复定时器创建状态
        
        [UIView animateWithDuration:0.1 animations:^{
            
            selfWeak.createImageView.transform = CGAffineTransformMakeScale(1.05, 1.05);
            selfWeak.createImageView.alpha = 0.9;
            selfWeak.createImageView.frame = CGRectMake(0, 0, 1, 1);
            selfWeak.createImageView.center = tapWindowPoint;

        } completion:^(BOOL finished) {
            
            //添加至技师增项
            if (CGRectGetWidth(selfWeak.frame) <= LEFT_WITH) {//限定非全屏才可添加至右边
                if (tapWindowPoint.x > CGRectGetWidth(selfWeak.frame) && tapWindowPoint.y > 184 && tapWindowPoint.y < CGRectGetHeight(selfWeak.window.frame) - 49) {
                    //右边添加对应model
                    PorscheSchemeModel *cubScheme = [HDLeftSingleton shareSingleton].dragCubScheme;
                    //拖动至技师 添加至工单 相关
                    [self addedItemActionWithModel:cubScheme cell:nil isTap:NO];
                    
                }
            }
            
            if (![selfWeak.collectionView isEqual:[[HDLeftSingleton shareSingleton].collectionViewArray objectAtIndex:3]]) {
                //加入收藏夹
                if (tapWindowPoint.y > 194 && tapWindowPoint.y < 194 + (LEFT_WITH - 20 - 15) / 3 + 20 + 5 && tapWindowPoint.x > 0 && tapWindowPoint.x <= selfWeak.frame.size.width) {

                    __block UICollectionViewCell *endCell;
                    UICollectionView *favoriteCollection = [HDLeftSingleton shareSingleton].allCollectionArray[0];
                    for (UICollectionViewCell *cell in favoriteCollection.visibleCells) {
                        
                        CGRect cellRect = [cell convertRect:cell.bounds toView:KEY_WINDOW];
                        BOOL contaons = CGRectContainsPoint(cellRect, tapWindowPoint);
                        if (contaons) {
                            
                            endCell = cell;
                            break;
                        }
                    }
                    if (!endCell) return ;
                    NSIndexPath *indexPath = [favoriteCollection indexPathForCell:endCell];
                    
                    if (selfWeak.createImageView && [HDLeftSingleton  shareSingleton].tableViewY < 60) {
                        
                        PorscheSchemeModel *model = [selfWeak.itemArray objectAtIndex:selfWeak.fromIndexpath.row];
                        
//                        [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTION_ADD_ITEM_NOTIFINATION object:@{@"item":@(indexPath.row), @"model":model}];
                        [[HDLeftSingleton shareSingleton] updateSchemeFavouriteData:@{@"item":@(indexPath.row), @"model":model}];
                    }
                }
                
                if (selfWeak.floatImageView) {
                    
                    [selfWeak.floatImageView removeFromSuperview];
                    
                    selfWeak.floatImageView = nil;
                    selfWeak.oldItem = -1;
                }
            }
            [selfWeak.createImageView removeFromSuperview];
            selfWeak.createImageView = nil;
        }];
        
        if (self.floatImageView) {
            
            [self.floatImageView removeFromSuperview];
            
            self.floatImageView = nil;
            _oldItem = -1;
        }
    }
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
    _isDrag = NO;
}

- (void)setItemArray:(NSMutableArray *)itemArray {
    _itemArray = itemArray;
    [_collectionView reloadData];
}

//渲染图片
- (UIImageView *)createItemImageView:(UIView *)cell {
    //打开图形上下文，并将cell的根层渲染到上下文中，生成图片
    CGPoint center = cell.center;
    center.y = center.y + 194 - [HDLeftSingleton shareSingleton].tableViewY;
    center.x += 20;
    UIGraphicsBeginImageContext(cell.bounds.size);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *cellImageView = [[UIImageView alloc] initWithImage:image];
    cellImageView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    cellImageView.layer.shadowRadius = 5.0;
    [self.window addSubview:cellImageView];
    
    cellImageView.center = center;
    
    return cellImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)leftScrollBtAction:(UIButton *)sender {
    if (![_style isEqualToString:@"collection"]) {
        if (_collectionView.visibleCells.count) {
            HDWorkListCollectionViewCell *cell = _collectionView.visibleCells.firstObject;
            
            NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
            
            if (indexPath.row > 0 ) {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            }
        }
    
    }
    
}

- (IBAction)rightScrollBtAction:(UIButton *)sender {
    if (![_style isEqualToString:@"collection"]) {
        if (_collectionView.visibleCells.count) {
            HDWorkListCollectionViewCell *cell = _collectionView.visibleCells.lastObject;
            NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
            
            if (indexPath.row < self.itemArray.count - 1) {
                [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            }
        }
   
    }
}


//监控点击位置

- (void)touchBegin:(NSNotification *)sender {
    if (![HDLeftSingleton shareSingleton].isItemVC) {
        return;
    }
    if (![HDLeftSingleton shareSingleton].isTechicianAdditionVC || [[HDLeftSingleton shareSingleton].saveStatus integerValue] == 1) {
        return;
    }
    UIEvent *event=[sender.userInfo objectForKey:@"event"];
//    [[HDLeftSingleton shareSingleton].pointArray removeAllObjects];
    
    if ([HDLeftSingleton shareSingleton].collectionViewArray.count == 5) {
        [HDLeftSingleton shareSingleton].allCollectionArray  = [NSMutableArray arrayWithArray:[HDLeftSingleton shareSingleton].collectionViewArray];
        [[HDLeftSingleton shareSingleton].collectionViewArray removeObjectAtIndex:0];
    }

    
    [[HDLeftSingleton shareSingleton].collectionViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint pt = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:obj];
        
        NSIndexPath *indexPath = [obj indexPathForItemAtPoint:pt];
        
        if (indexPath) {
            [HDLeftSingleton shareSingleton].fromIndexpath = indexPath;
            
            [HDLeftSingleton shareSingleton].fromIndex = idx;
            
            
            *stop = YES;
        }
        
    }];
    
//    NSLog(@"touchBegin");
}


- (void)touchMove:(NSNotification *)sender {

    
    
}

//移动结束。获取结束点的cell，indexpath，collection
- (void)touchesEnd:(NSNotification *)sender {
    if (![HDLeftSingleton shareSingleton].isItemVC) {
        return;
    }

    if (![HDLeftSingleton shareSingleton].isTechicianAdditionVC || [[HDLeftSingleton shareSingleton].saveStatus integerValue] == 1) {
        return;
    }
    
    UIEvent *event=[sender.userInfo objectForKey:@"event"];

    __weak typeof(self) selfWeak = self;
    
    [[HDLeftSingleton shareSingleton].collectionViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         CGPoint pt = [[[[event allTouches] allObjects] objectAtIndex:0] locationInView:obj];
        
        NSIndexPath *endIndexPath = [obj indexPathForItemAtPoint:pt];
        
        if ([obj visibleCells].count) {
            if (endIndexPath) {
                
                if ([HDLeftSingleton shareSingleton].isDrag) {
                    
                    [HDLeftSingleton shareSingleton].endIndexPath = endIndexPath;
                    
                    [HDLeftSingleton shareSingleton].endIndex = idx;
                    //方案库不能直接加至未完成,
                    if ([HDLeftSingleton shareSingleton].fromIndex != [HDLeftSingleton shareSingleton].collectionViewArray.count - 1 &&  idx == [HDLeftSingleton shareSingleton].collectionViewArray.count - 1) {
                        return ;
                    }
                     //未完成自己可以条换位置,不可以拖至别的地方
                    if ([HDLeftSingleton shareSingleton].fromIndex == [HDLeftSingleton shareSingleton].collectionViewArray.count - 1 && [HDLeftSingleton shareSingleton].endIndex != [HDLeftSingleton shareSingleton].collectionViewArray.count - 1 ) {
                        return;
                    }
                    
                    
                    
                    [selfWeak getIndexPathAndIndex];
//                    NSLog(@"发动一次添加事件操作");
                    
                    [HDLeftSingleton shareSingleton].isDrag = NO;
                    
                    
                }
                
                *stop = YES;
            }else {
                
                pt.x += cellSpace;
                
                NSIndexPath *endIndexPath = [obj indexPathForItemAtPoint:pt];
                
                if (endIndexPath) {
                    if ([HDLeftSingleton shareSingleton].isDrag) {
                        
                        [HDLeftSingleton shareSingleton].endIndexPath = endIndexPath;
                        
                        [HDLeftSingleton shareSingleton].endIndex = idx;
                        
                        if (idx == [HDLeftSingleton shareSingleton].collectionViewArray.count - 1) {
                            return ;
                        }
                        [selfWeak getIndexPathAndIndex];
                        
                        [HDLeftSingleton shareSingleton].isDrag = NO;
                        
                        return ;
                    }
                    
                    
                }
//                NSLog(@"空白区域加载 pt_x_%f,pt_y_%f",pt.x,pt.y);

                if (pt.x > 0 && pt.y > 0 && pt.y < collectionViewHeight && pt.x < LEFT_WITH - 40) {
                    if ([HDLeftSingleton shareSingleton].isDrag) {
                        
                        [HDLeftSingleton shareSingleton].endIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                        
                        [HDLeftSingleton shareSingleton].endIndex = idx;
                        
                        if (idx == [HDLeftSingleton shareSingleton].collectionViewArray.count - 1) {
                            return ;
                        }
                        
                        [selfWeak getIndexPathAndIndex];
                        
                        [HDLeftSingleton shareSingleton].isDrag = NO;
                        
                        *stop = YES;
                        

                    }
                }
                
            }

        }else {//已经没有项目或者方案了，
            if ([HDLeftSingleton shareSingleton].isDrag) {
                NSLog(@"没有项目和方案pt_x_%f,pt_y_%f",pt.x,pt.y);
                if (pt.x > 0 && pt.y > 0 && pt.y < collectionViewHeight && pt.x < LEFT_WITH - 40) {
                    
                    [HDLeftSingleton shareSingleton].endIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    
                    [HDLeftSingleton shareSingleton].endIndex = idx;
                    
                    [selfWeak getIndexPathAndIndex];
                    
                    [HDLeftSingleton shareSingleton].isDrag = NO;
                    
                    *stop = YES;

                }
            }
            
            
        }

        
    }];

    
    
}

//回去indexPath和index
- (void)getIndexPathAndIndex {
//    [[NSNotificationCenter defaultCenter] postNotificationName:PROJECT_CHANGE_ITEM_CATEGORY_NOTIFINATION object:nil];
    [[HDLeftSingleton shareSingleton] changeSchemeLeftLevel:nil];
}

//遮罩view，收起下拉view

- (UIView *)clearView {
    if (!_clearView) {
        _clearView = [[UIView alloc]initWithFrame:self.window.frame];
        
        _clearView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = _clearView.frame;
        
        button.backgroundColor = [UIColor clearColor];
        
        [_clearView addSubview:button];
        
        [button addTarget:self action:@selector(hiddenListView:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _clearView;
}

- (void)hiddenListView:(UIButton *)sender {
    __weak typeof(self) selfWeak = self;

    selfWeak.isAlreadyShow = NO;
    
    
    [selfWeak.clearView removeFromSuperview];
}

- (UILabel *)displayLb {
    if (!_displayLb) {
        _displayLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        _displayLb.text = @"松手以显示方案详情";
        _displayLb.textAlignment = NSTextAlignmentCenter;
        _displayLb.backgroundColor = [UIColor clearColor];
    }
    return _displayLb;
}

- (void)addedItemActionWithModel:(id)model cell:(UICollectionViewCell *)cell isTap:(BOOL)isTap {
    PorscheSchemeModel *scheme = model;

    if ([self.style isEqualToString:@"item"]) {//未完成项目
        scheme.schemetype = @4;
        [self addedSchemeTestWithDic:model isDelete:NO];

    }else if (![self.style isEqualToString:@"collection"]) {//方案库项目
        if ([scheme.flag integerValue] == 0) {
            
           if (![[HDLeftSingleton shareSingleton] isHasAddToOrderPermissionShowMessage:YES])
           {
               return;
           }
            BOOL isExist = NO;//是否存在(方案在工单中但没有确认)
            for (PorscheNewScheme *temp in self.idArray) {
                if ([scheme.schemeid integerValue] == [temp.wosstockid integerValue]) {
                    isExist = YES;
                    break;
                }
            }
            if (isExist) {
                //确认方案
                WeakObject(self)
//                [self chooseBtWithid:scheme.ordersolutionid type:@3 isChoose:@1 withSchemetype:@0 isNeedSendNoti:NO];
                [PorscheRequestManager chooseBtWithid:scheme.ordersolutionid type:@3 isChoose:@1 success:^{
                    [selfWeak successToReloadSchemeData];
                } fail:^{
                    [selfWeak successToReloadSchemeData];
                }];
            }else {
                //添加方案
                [self addedSchemeTestWithDic:model isDelete:NO];
            }
        }else {//已经在工单的项目(并且确认)
            if (isTap) {
                [self unfinishedItemAddedAlertViewWithModel:scheme cell:cell];
                
            }else {
//                [[NSNotificationCenter defaultCenter] postNotificationName:ADDED_ITEM_NOTIFINATION object:nil];
                [[HDLeftSingleton shareSingleton] showAddedSchemeAlertView];
            }
        }
    }
}
#pragma mark  删除工单中该方案                    
- (void)unfinishedItemAddedAlertViewWithModel:(PorscheSchemeModel *)model cell:(UICollectionViewCell *)cell {
    
    BOOL isEqual = NO;
    PorscheNewScheme *tempModel = nil;
    for (PorscheNewScheme *temp in self.idArray) {
        if ([model.schemeid integerValue] == [temp.wosstockid integerValue]) {
            isEqual = YES;
            tempModel = temp;
            break;
        }
    }
    
    WeakObject(self);
    if (isEqual && tempModel) {
        if ([HDLeftSingleton isUserAdded:tempModel.schemeaddperson]) {
            [HDPoperDeleteView showAlertTableViewWithAroundView:cell withDataSource:@[@"误操作, 移除方案", @"暂不做, 下次提醒"] direction:UIPopoverArrowDirectionLeft selectBlock:^(NSInteger index) {
                switch (index) {
                    case 0:
                        //删除方案
                        [selfWeak addedSchemeTestWithDic:model isDelete:YES];
                        break;
                    case 1:
                    {
                        [PorscheRequestManager chooseBtWithid:model.ordersolutionid type:@3 isChoose:@0 success:^{
                            [selfWeak successToReloadSchemeData];
                        } fail:^{
                            [selfWeak successToReloadSchemeData];
                        }];
                    }
                        break;
                    default:
                        break;
                }
            }];
        }else {
            [HDPoperDeleteView showAlertViewAroundView:cell titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionLeft sure:^{
                //删除方案
                [selfWeak addedSchemeTestWithDic:model isDelete:YES];
            } refuse:^{
                
            } cancel:^{
                
            }];
        }
        
    }else {
        [HDPoperDeleteView showAlertViewAroundView:cell titleArr:@[@"确定取消",@"确定",@"取消"] direction:UIPopoverArrowDirectionLeft sure:^{
            //删除方案
            [selfWeak addedSchemeTestWithDic:model isDelete:YES];
        } refuse:^{
            
        } cancel:^{
            
        }];
    }
}



//- (void)chooseBtWithid:(NSNumber *)projectid type:(NSNumber *)type isChoose:(NSNumber *)value withSchemetype:(NSNumber *)schemetype isNeedSendNoti:(BOOL)isNeenSend {
//    WeakObject(self);
//    [PorscheRequestManager chooseBtWithid:projectid type:type isChoose:value success:^{
//        [selfWeak successToReloadSchemeData];
//    } fail:^{
//    }];
//    
//}

//发送点所在，左右按钮的位置，对应的按钮，实现滑动
- (void)sendMessageWithNotification {
//    [[NSNotificationCenter defaultCenter] postNotificationName:PROJECT_SCROLL_COLLECTIONVIEW_NOTIFINATION object:@{@"status":@1,@"cellIndex":@(self.idx),@"leftOrRight":@(self.index)}];
    [[HDLeftSingleton shareSingleton] scrollSchemeLeftAndRight:@{@"status":@1,@"cellIndex":@(self.idx),@"leftOrRight":@(self.index)}];
}

- (void)changeShowDetialView {

    self.isAlreadyShow = YES;

    [self.displayLb removeFromSuperview];

    [self.clearView removeFromSuperview];
}


#pragma mark - ------ 方案夹删除
- (void)deteleFavoriteForListWithData:(PorscheSchemeFavoriteModel *)data success:(void(^)())success {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:data.favoriteid forKey:@"uid"];
    
    WeakObject(self)
    [PorscheRequestManager deteleFavoritesListWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            if (success) {
                success();
            }
            if (selfWeak.refreshFovriteListBlock) {
                selfWeak.refreshFovriteListBlock();
            }
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
        }
    }];
}
#pragma mark - -----   修改收藏夹名称
- (void)changeFavoriteNameWithName:(NSString *)name withFavoriteData:(PorscheSchemeFavoriteModel *)data {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param hs_setSafeValue:data.favoriteid forKey:@"favoriteid"];
    [param hs_setSafeValue:name forKey:@"favoritename"];
    
    WeakObject(self)
    [PorscheRequestManager changeFavoriteNameWithParams:param completion:^(PResponseModel * _Nonnull responser) {
        if (responser.status == 100) {
            if (selfWeak.refreshFovriteListBlock) {
                selfWeak.refreshFovriteListBlock();
            }
        }else {
            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:responser.msg height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
        }
    } isNeedShowPopView:NO];
}



@end
