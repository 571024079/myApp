//
//  ProjectCarStyleCollectionViewCell.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/26.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProjectCarStyleCollectionViewCellDeleteBlock)();
@interface ProjectCarStyleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@property (nonatomic, assign) BOOL editCell;

@property (nonatomic, copy) ProjectCarStyleCollectionViewCellDeleteBlock deleteBlock;

@end
