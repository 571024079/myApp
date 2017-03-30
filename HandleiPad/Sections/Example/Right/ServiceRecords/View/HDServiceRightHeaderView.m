//
//  HDServiceRightHeaderView.m
//  HandleiPad
//
//  Created by handou on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRightHeaderView.h"
#import "HDServiceRightHeaderCollectionCell.h"
#import "HDServiceRightTextFieldView.h"

@interface HDServiceRightHeaderView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stayFactoryLabel;
//标签内容展示collectionView的fram
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionWidth;
//搜索和清空的父界面
@property (weak, nonatomic) IBOutlet UIView *searchAndClearSupperView;
//清空按钮
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@end

@implementation HDServiceRightHeaderView

- (instancetype)initWithCustomFrame:(CGRect)frame {
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRightHeaderView" owner:self options:nil] objectAtIndex:0];
    self.frame = frame;
    
    for (UIView *view in self.subviews) {
        if (view == _searchAndClearSupperView) {
            for (UIView *viewSub in _searchAndClearSupperView.subviews) {
                viewSub.layer.masksToBounds = YES;
                viewSub.layer.cornerRadius = 3;
                viewSub.layer.borderWidth = 1;
                viewSub.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
        }else {
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 3;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    
    self.stayFactoryLabel.layer.masksToBounds = YES;
    self.stayFactoryLabel.layer.cornerRadius = 6;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HDServiceRightHeaderCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"headerViewCell"];
    
    self.headerViewTF.delegate = self;
//    self.headerViewtempTF.delegate = self;
    [self.headerViewTF addTarget:self action:@selector(textDidEnd:) forControlEvents:UIControlEventEditingChanged];
    
    
    //保存初始的frame
    if (!self.rightModel.carflglist.count) {
        self.collectionWidth.constant = 0.0;
    }
    
    return self;
}

- (void)setRightModel:(HDServiceRecordsRightModel *)rightModel {
    _rightModel = rightModel;
    [self loadViewData:_rightModel];
    // 设置范围
    CGFloat rectwith = (CGRectGetWidth(self.middleView.frame) - CGRectGetMinX(self.collectionView.frame) - CGRectGetWidth(self.titleAddButton.frame)) - 120 - 10;
    CGFloat width = 0.0;
    if (_rightModel.carflglist.count) {
        for (HDServiceRecordsCarflgModel *carflgData in _rightModel.carflglist) {
            //计算字符串长度
            CGSize size = [carflgData.targetname boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:nil context:nil].size;
            carflgData.width = @(size.width);
        }
    }
    
    if (_rightModel.carflglist.count) {
        for (HDServiceRecordsCarflgModel *carflgData in _rightModel.carflglist) {
            //计算字符串长度
            CGFloat cellWidth = [carflgData.width floatValue] + 25;
            width += cellWidth + 10;
        }
        //判断数据，根据数据显示输入框的长度
        if (width >= rectwith) {
            self.collectionWidth.constant = rectwith;
        }else {
            self.collectionWidth.constant = width;
        }
    }else {
        self.collectionWidth.constant = 0.0;
    }
    [_collectionView reloadData];
    //超过范围，改变偏移量
    if (_rightModel.carflglist.count && (width >= rectwith)) {
        CGPoint offSize = _collectionView.contentOffset;
        offSize.x = width - rectwith - 10;
        _collectionView.contentOffset = offSize;
    }
}

- (void)loadViewData:(HDServiceRecordsRightModel *)model {
    self.carPlateLabel.text = [NSString stringWithFormat:@"%@%@", model.plateplace, model.carplate];
    self.carTypeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", model.carcatena?model.carcatena:@"", model.cartype?model.cartype:@"", model.yearstyle?model.yearstyle:@""];
    self.carDistanceLabel.text = [NSString stringWithFormat:@"%@公里", [self setStringStyleWithNumber:model.miles withStyle:NSNumberFormatterDecimalStyle]];
    self.carVINLabel.text = model.vin;
}

#pragma mark - 点击方法
- (IBAction)headerViewButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (button == _clearButton) {
        [self clearButtonAction];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(serviceRightHeaderViewButtonAction:withStyle:)]) {
        [_delegate serviceRightHeaderViewButtonAction:button withStyle:(ServiceRightHeaderViewButtonStyle)button.tag];
    }
}

#pragma mark - 清空按钮的操作
- (void)clearButtonAction {
    _yewuleixingTF.text = @"";
    _gonglishuTF.text = @"";
    _jinchangriqiTF.text = @"";
    _jiaocheriqiTF.text = @"";
}

#pragma mark - CollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDServiceRecordsCarflgModel *carflgData = _rightModel.carflglist[indexPath.item];
    
    CGFloat width = [carflgData.width floatValue];
    CGSize size = CGSizeMake(width + 25, 24);
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(3, 0, 3, 0);
    return edgeInsets;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _rightModel.carflglist.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDServiceRightHeaderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HDServiceRightHeaderCollectionCell" owner:self options:nil] objectAtIndex:0];
    }
    HDServiceRecordsCarflgModel * carflgData = _rightModel.carflglist[indexPath.item];
    cell.titelLabel.text = carflgData.targetname;
    
    // 点击删除回调方法
    WeakObject(self)
    cell.deleteBlock = ^(HDServiceRightHeaderCollectionCell *thisCell) {
        [selfWeak deleteCellAction:thisCell];
    };
    
    return cell;
}

#pragma mark - Block 删除cell方法
- (void)deleteCellAction:(HDServiceRightHeaderCollectionCell *)cell {
    [self.headerViewTF resignFirstResponder];
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    HDServiceRecordsCarflgModel *model = _rightModel.carflglist[indexPath.item];
    if (_delegate && [_delegate respondsToSelector:@selector(headerCarflgDeteleWith:)]) {
        [_delegate headerCarflgDeteleWith:model];
    }
}



#pragma mark - 输入框点击完成输入回调
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    bool b = [_delegate headerViewTextFieldShouldReturn:textField withDataSource:[_rightModel.carflglist mutableCopy]];
    if (b) {
        return YES;
    }else {
        return NO;
    }
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    bool b = [_delegate headerViewTextFiel:textField shouldChangeCharactersInRange:range replacementString:string];
//    if (b) {
//        return YES;
//    }else {
//        return NO;
//    }
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    if (_delegate && [_delegate respondsToSelector:@selector(headerViewTextFieldDidEndEditing:)]) {
//        [_delegate headerViewTextFieldDidEndEditing:textField];
//    }
//}
- (IBAction)textDidEnd:(UITextField *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(headerViewTextDidEnd:)]) {
        [_delegate headerViewTextDidEnd:sender];
    }
    
}



#pragma mark - 处理数字，添加逗号
- (NSString *)setStringStyleWithNumber:(NSNumber *)number withStyle:(NSNumberFormatterStyle)style {
    NSString *string = @"";
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:style];
    string = [currencyFormatter stringFromNumber:number];
    if ([[string substringToIndex:1] isEqualToString:@"$"]) {
        string = [NSString stringWithFormat:@"￥%@", [string substringFromIndex:1]];
    }
    return string;
}


@end
