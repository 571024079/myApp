//
//  ProjectCarStyleAndDisTableViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/26.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ProjectCarStyleAndDisTableViewCellType) {
    
    ProjectCarStyleAndDisTableViewCellCarType,
    ProjectCarStyleAndDisTableViewCellCarMileage
};

//cell被点击的block
typedef void(^ProjectCarStyleCellClickBlock)(NSInteger, CGRect);
typedef void(^ProjectCarStyleCellContentSizeUpdateBlock)(NSInteger);

@interface ProjectCarStyleAndDisTableViewCell : UITableViewCell

//集合视图
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//分类lb
@property (weak, nonatomic) IBOutlet UILabel *cateGoryLb;


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL editCell;

@property (nonatomic, copy) ProjectCarStyleCellClickBlock clickBlock;

@property (nonatomic, assign) ProjectCarStyleAndDisTableViewCellType type;

+ (instancetype)cellWithTableView:(UITableView *)tableView withType:(MaterialTaskTimeDetailsType)cellType;

- (void)scrollToAddView;

@end
