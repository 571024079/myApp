//
//  HDScreenPopFileView.m
//  HandleiPad
//
//  Created by handou on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDScreenPopFileView.h"
#import "MaterialTaskTimeDetailsView.h"
#import "HDScreenPopFileCell.h"
#import "HDPoperDeleteView.h"

@interface HDScreenPopFileView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIScrollViewDelegate,UIAlertViewDelegate>
//输入框
@property (weak, nonatomic) IBOutlet UITextField *textField;
//取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editButtonCenterX;

//顶部标题视图
@property (weak, nonatomic) IBOutlet UIView *topView;
//内容视图
@property (weak, nonatomic) IBOutlet UIView *contentView;
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
//内容collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//内容背景
@property (weak, nonatomic) IBOutlet UIImageView *contentBgImage;
@property (weak, nonatomic) IBOutlet UIView *keepOutVeiw;
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (nonatomic, strong) MaterialTaskTimeDetailsView *detaileView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//@property (nonatomic, assign) NSInteger count;
//@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) NSMutableArray *cellDataSource;
@property (nonatomic, strong) HDPoperDeleteView *popDeleteView;
@property (nonatomic, assign) BOOL isFirstInto;

//保存在新建之后重命名后没有退出再次重命名的字符串
@property (nonatomic, copy) NSString *oldReturnString;

//临时保存当前的标题
@property (nonatomic, copy) NSString *tempTitleStr;


@end

@implementation HDScreenPopFileView

- (instancetype)initWithCustomFrame:(CGRect)frame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"HDScreenPopFileView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    for (UIView *view in self.subviews) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 6;
    }
    
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 10;
    
    self.keepOutVeiw.hidden = NO;
    self.BGView.hidden = YES;
    self.cancelButton.hidden = YES;
    
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleNone;
    
    //初始化pageControl
//    self.pageControl.currentPageIndicatorTintColor = ColorHex(0xD9F700);
//    self.pageControl.pageIndicatorTintColor = ColorHex(0xDDDDDD);
    
    
    #pragma mark - tableview代理，cell注册
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.alwaysBounceHorizontal = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HDScreenPopFileCell" bundle:nil] forCellWithReuseIdentifier:@"HDScreenPopFileCell"];
    
    #pragma mark - 给背景图片添加高斯模糊和返回手势
    //添加高斯模糊效果
    UIBlurEffect *bgEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *bgEffectView = [[UIVisualEffectView alloc] initWithEffect:bgEffect];
    bgEffectView.frame = KEY_WINDOW.bounds;
//    bgEffectView.alpha = .9f;
    [self.bgImage addSubview:bgEffectView];
    
    //给背景图片添加手势，并添加返回方法
    self.bgImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backWithTap:)];
    [self.bgImage addGestureRecognizer:tapG];
    
    #pragma mark - 给内容图片毛玻璃效果
    //添加毛玻璃效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    [self.contentBgImage addSubview:effectView];
    
    #pragma mark - 给编写的标题框添加长按手势
    UILongPressGestureRecognizer *longPressG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWithEditForTitle:)];
    [self.keepOutVeiw addGestureRecognizer:longPressG];

//    self.selectArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSource:) name:SCHEME_LEFT_EDITFAVORITE object:nil];
    
    return self;
}
#pragma mark - 工单中的方案
- (void)setInOrderFanganArray:(NSMutableArray *)inOrderFanganArray {
    _inOrderFanganArray = inOrderFanganArray;
}
#pragma mark - 数据源，并添加pageControl
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    //组合数据，将工单中的方案数据组合数据中
    if (!_isFirstInto) {
        for (PorscheSchemeModel *model in _dataSource) {
            for (PorscheNewScheme *tmp in _inOrderFanganArray) {
                if ([model.schemeid integerValue] == [tmp.wosstockid integerValue]) {
                    model.flag = tmp.wosisconfirm;
                    model.ordersolutionid = tmp.schemeid;
                }
            }
        }
        _isFirstInto = YES;
    }
    
    //拆分数据
    [self getNineViewData];
    
    self.pageControl.numberOfPages = _cellDataSource.count;
    
    [self loadEditButtonCenterX];
    
}
- (NSMutableArray *)cellDataSource {
    
    if (!_cellDataSource) {
        _cellDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellDataSource;
}
#pragma mark - 处理九宫格数据，分拆数据
- (void)getNineViewData {
    NSInteger gap = _dataSource.count%9 ? 1:0;
    NSInteger cellCount = _dataSource.count / 9 + gap;
    for (NSInteger i = 0; i < cellCount; i ++) {
        NSInteger lengcount = _dataSource.count%9 == 0 ? 9 : _dataSource.count%9;
        NSInteger leng = i==cellCount - 1 ? lengcount : 9 ;
        NSMutableArray *data = [[NSMutableArray alloc] initWithArray:[_dataSource subarrayWithRange:NSMakeRange(self.cellDataSource.count * 9, leng)]];
        [self.cellDataSource addObject:data];
    }
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    _textField.text = _titleName;
}

- (void)updateSource:(NSNotification *)obj {
    // 区分移动cell和删除cell的操作，删除需要刷新界面
    if (obj != nil) {
        NSDictionary *dic = obj.object;
        if ([dic[@"style"] isEqualToString:@"detele"]) { //移除cell
            PorscheSchemeModel *model = dic[@"data"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataSource];
            [tempArr removeObject:model];
            [_cellDataSource removeAllObjects];// 重置数据，清空，防止重复添加
            self.dataSource = [NSMutableArray arrayWithArray:tempArr];
            [self.collectionView reloadData];
        }else if ([dic[@"style"] isEqualToString:@"addFangan"]) {//添加方案至工单
            PorscheSchemeModel *model = dic[@"data"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataSource];
            for (PorscheSchemeModel *data in tempArr) {
                if ([data.schemeid isEqual:model.schemeid]) {
                    data.flag = @1;
                    data.ordersolutionid = model.ordersolutionid;
                }
            }
            [_cellDataSource removeAllObjects];// 重置数据，清空，防止重复添加
            self.dataSource = [NSMutableArray arrayWithArray:tempArr];
            [self.collectionView reloadData];
        }else if ([dic[@"style"] isEqualToString:@"deteleFangan"]) {// 删除工单中的方案
            PorscheSchemeModel *model = dic[@"data"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataSource];
            for (PorscheSchemeModel *data in tempArr) {
                if ([data.schemeid isEqual:model.schemeid]) {
                    data.flag = @0;
                    data.ordersolutionid = @0;
                }
            }
            [_cellDataSource removeAllObjects];// 重置数据，清空，防止重复添加
            self.dataSource = [NSMutableArray arrayWithArray:tempArr];
            [self.collectionView reloadData];
        }else if ([dic[@"style"] isEqualToString:@"affirmFangan"]) {// 确认工单中的方案
            PorscheSchemeModel *model = dic[@"data"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataSource];
            for (PorscheSchemeModel *data in tempArr) {
                if ([data.schemeid isEqual:model.schemeid]) {
                    data.flag = @1;
                    data.ordersolutionid = data.ordersolutionid;
                }
            }
            [_cellDataSource removeAllObjects];// 重置数据，清空，防止重复添加
            self.dataSource = [NSMutableArray arrayWithArray:tempArr];
            [self.collectionView reloadData];
        }else if ([dic[@"style"] isEqualToString:@"cancelFangan"]) {// 取消已经确认的工单中的方案
            PorscheSchemeModel *model = dic[@"data"];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataSource];
            for (PorscheSchemeModel *data in tempArr) {
                if ([data.schemeid isEqual:model.schemeid]) {
                    data.flag = @0;
                    data.ordersolutionid = data.ordersolutionid;
                }
            }
            [_cellDataSource removeAllObjects];// 重置数据，清空，防止重复添加
            self.dataSource = [NSMutableArray arrayWithArray:tempArr];
            [self.collectionView reloadData];
        }
    }
    else {
        //这里面有些问题，这样处理获取的依然是老数据，这样不能做到数据的最新，但是刷新界面的时候会造成界面的闪退，估计和移动刷新界面冲突了
        NSMutableArray *tempArr = [NSMutableArray array];
        [_cellDataSource enumerateObjectsUsingBlock:^(NSMutableArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArr addObjectsFromArray:obj];
        }];
        [_cellDataSource removeAllObjects];// 重置数据，清空，防止重复添加
        self.dataSource = [NSMutableArray arrayWithArray:tempArr];
    }
}

#pragma mark - CollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(475, 475);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDScreenPopFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HDScreenPopFileCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDScreenPopFileCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.inOrderFanganArray = _inOrderFanganArray;
    cell.dataSource = _cellDataSource[indexPath.row];
    
    return cell;
}
//#pragma mark - cell的点击事件
//- (void)tapCellAction:(NSIndexPath *)index {
//    if ([_selectArr[index.item] isEqualToString:@"1"]) {
//        [_selectArr replaceObjectAtIndex:index.item withObject:@"0"];
//    }else if ([_selectArr[index.item] isEqualToString:@"0"]) {
//        [_selectArr replaceObjectAtIndex:index.item withObject:@"1"];
//    }
//    [_collectionView reloadData];
//}
#pragma mark - 删除输入按钮方法
- (IBAction)cancelButtonAction:(UIButton *)sender {
    self.textField.text = @"";
}
- (IBAction)deteleFavoriteAction:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除收藏夹？" message:@"将会移除此收藏夹下的所有方案" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != 0) {
        if (self.deleteFavoritBlock) {
            self.deleteFavoritBlock();
            [self removeFromSuperview];
        }
    }
}
- (IBAction)tapKeepOutViewAction:(id)sender {
    [self editButtonAction:_editButton];
}

- (IBAction)editButtonAction:(UIButton *)sender {
    
    self.beginEdit = YES;
}
#pragma mark - 点击标题进行编辑模式
- (void)longPressWithEditForTitle:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
    
        self.beginEdit = YES;
    }
}
#pragma mark - 点击其他地方返回的方法
- (void)backWithTap:(UITapGestureRecognizer *)tapG {
    
    if (!self.beginEdit) {
        [self removeFromSuperview];
        if (_backBlock) {
            _backBlock();
        }
    } else {
        for (PorscheSchemeFavoriteModel *data in _favorialDataArray) {
            if ([data.favoritename isEqualToString:_textField.text] && ![_titleName isEqualToString:_textField.text]) {
                [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"收藏夹名称已存在" height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
                return;
            }
        }
        self.beginEdit = NO;
        [self.textField resignFirstResponder];
    }
}
#pragma mark - 输入框代理

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.editButton.hidden = YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
////    self.beginEdit = NO;
////    
////    //当输入的是空的时候，就将之前的名字从新填充 ,放在前面是避免当新建收藏夹的时候导致了没有从服务器检查名称出现未命名的现象
////    if ([textField.text isEqualToString:@""]) {
////        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"收藏夹名称不能为空" height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
////        self.textField.text = _titleName;
////    }
////    if (self.shouldReturnBlock && ![textField.text isEqualToString:@""] && _isNew) {
////        self.shouldReturnBlock(textField.text);
////    }
////    
////    [self loadEditButtonCenterX];
//    [self textFieldDidEndEditing:textField];
//    
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.beginEdit = NO;
    
    //当输入的是空的时候，就将之前的名字从新填充 ,放在前面是避免当新建收藏夹的时候导致了没有从服务器检查名称出现未命名的现象
    if ([textField.text isEqualToString:@""]) {
        [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"收藏夹名称不能为空" height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
        self.textField.text = _titleName;
    }
    
//    for (PorscheSchemeFavoriteModel *data in _favorialDataArray) {
//        if ([data.favoritename isEqualToString:textField.text] && ![_titleName isEqualToString:textField.text]) {
//            [AlertViewHelpers saveDataActionWithImage:[UIImage imageNamed:@"alert_notice_delete.png"] message:@"收藏夹名称已存在" height:60 center:CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - 100) superView:KEY_WINDOW];
//            return;
//        }
//    }
    
    if (self.shouldReturnBlock && ![textField.text isEqualToString:@""] && ![_titleName isEqualToString:textField.text] && ![_tempTitleStr isEqualToString:textField.text]) {
        self.shouldReturnBlock(textField.text);
//        _oldReturnString = textField.text;
    }
    
    self.editButton.hidden = NO;
    [self loadEditButtonCenterX];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 滚动改变pageControl
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        NSInteger page = fabs(scrollView.contentOffset.x) / (scrollView.frame.size.width / 2);
        _pageControl.currentPage = page;
    }
}

- (void)setBeginEdit:(BOOL)beginEdit {
    
    _beginEdit = beginEdit;
    
    if (beginEdit) {
        self.BGView.hidden = NO;
        self.cancelButton.hidden = NO;
        self.lineView.hidden = NO;
        self.textField.textColor = [UIColor blackColor];
        
        self.tempTitleStr = self.textField.text;
        self.textField.text = @"";
        self.textField.placeholder = self.tempTitleStr;
        
        [self.textField becomeFirstResponder];
    } else {
        self.BGView.hidden = YES;
        self.cancelButton.hidden = YES;
        self.lineView.hidden = YES;
        self.textField.textColor = [UIColor whiteColor];
        
        if ([self.textField.text isEqualToString:@""] && [self.textField.placeholder isEqualToString:self.tempTitleStr]) {
            self.textField.text = self.tempTitleStr;
        }
        
        [self.textField resignFirstResponder];
    }
}

- (void)loadEditButtonCenterX {
    
    CGFloat centerx = [self getStringRect:self.textField.text].width/2.f + 20;
    CGFloat keepWidth = self.keepOutVeiw.bounds.size.width/2.f;
    if (centerx > keepWidth) {
        
        centerx = keepWidth - self.editButton.bounds.size.width/2;
    }
    self.editButtonCenterX.constant = centerx;
}

- (CGSize)getStringRect:(NSString*)aString
{
    CGSize size;
//    NSAttributedString* atrString = [[NSAttributedString alloc] initWithString:aString];
//    NSRange range = NSMakeRange(0, atrString.length);
    NSDictionary* dic =
  @{NSFontAttributeName : [UIFont systemFontOfSize:35]};
//    [atrString attributesAtIndex:0 effectiveRange:&range];
    size = [aString boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return  size;
}

#pragma mark - 移除刷新数据通知
- (void)dealloc {
    _isFirstInto = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"收藏夹释放");
}

#pragma mark - 关闭按钮的操作
- (IBAction)cancenButtonAction:(id)sender {
    [self backWithTap:nil];
}


@end
