//
//  ProjectDetailPlanSubCollectionCell.m
//  HandleiPad
//
//  Created by Robin on 2016/10/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetailPlanSubCollectionCell.h"

@interface ProjectDetailPlanSubCollectionCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *contentButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (strong, nonatomic) UIImageView *imageView;

@end
@implementation ProjectDetailPlanSubCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.f/[UIScreen mainScreen].scale;
    self.layer.cornerRadius = 4;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)setEditCell:(BOOL)editCell {
    _editCell = editCell;

    self.titleButton.userInteractionEnabled = NO;
    self.contentButton.userInteractionEnabled = editCell;
    self.editButton.hidden = !editCell;
    self.deleteButton.hidden = YES;
}


- (void)setCellType:(PorscheConstantModelType)cellType {
    
    _cellType = cellType;
    
    switch (cellType) {
        case PorscheConstantModelTypeCoreDataBusinesstype:
        {
            [self.titleButton setTitle:@"业务" forState:UIControlStateNormal];
        }
            break;
        case PorscheConstantModelTypeCoreDataPartsGroup: // 备件主组
        case PorscheConstantModelTypeCoreDataWorkHourk: //工时主子组
        {
            [self.titleButton setTitle:@"组别" forState:UIControlStateNormal];
        }
            break;
        case PorscheConstantModelTypeCoreDataSchemeLevel:
        {
            [self.titleButton setTitle:@"级别" forState:UIControlStateNormal];
        }
            break;
        case PorscheConstantModelTypeCoreDataFavorite:
        {
            [self.titleButton setTitle:@"收藏夹" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)setConstantModel:(PorscheConstantModel *)constantModel {
    _constantModel = constantModel;
    
    self.contentButton.titleLabel.numberOfLines = 0;
    self.contentButton.titleLabel.contentMode = 1;
//    [self.contentButton setTitle:constantModel.cvvaluedesc forState:UIControlStateNormal];
    self.contentLabel.text = constantModel.cvvaluedesc;
    self.titleButton.userInteractionEnabled = NO;
    self.deleteButton.hidden = YES;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"materialtime_detail_addFavoriteBox"];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (IBAction)titleAction:(UIButton *)sender {
    NSLog(@"标题");
    
    if (self.actionBlock) {
        self.actionBlock(DetailPlanSubCollectionCellTitleAction,sender);
    }
}
- (IBAction)contentButton:(UIButton *)sender {
    NSLog(@"内容");
    if (self.actionBlock) {
        self.actionBlock(DetailPlanSubCollectionCellContentAction,sender);
    }
}
- (IBAction)deleteButton:(UIButton *)sender {
    NSLog(@"删除");

    if (self.actionBlock) {
        self.actionBlock(DetailPlanSubCollectionCellDeleteAction,sender);
    }
}
- (IBAction)editButton:(UIButton *)sender {
    NSLog(@"编辑");
    if (self.actionBlock) {
        self.actionBlock(DetailPlanSubCollectionCellContentAction,self.contentButton);
    }
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath withCellType:(PorscheConstantModelType)cellType {
    
    static NSString *identifer = @"ProjectDetailPlanSubCollectionCell";
    [collectionView registerNib:[UINib nibWithNibName:@"ProjectDetailPlanSubCollectionCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    ProjectDetailPlanSubCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    cell.cellType = cellType;
    return cell;
}


@end
