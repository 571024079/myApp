//
//  HDScreenPopFileCellCollectionViewCell.h
//  HandleiPad
//
//  Created by Robin on 16/11/2.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HDScreenPopFileCellCollectionViewCellLongPressBlock)();
@interface HDScreenPopFileCellCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PorscheSchemeModel *model;

//@property (nonatomic, assign) BOOL cellSelected;

@end
