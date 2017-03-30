//
//  MaterialTimeRangeTableViewCell.h
//  HandleiPad
//
//  Created by Robin on 16/10/28.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MaterialTimeRangeTableViewCellBlock)(UIView *view);
@interface MaterialTimeRangeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *firstMileageTF;
@property (weak, nonatomic) IBOutlet UITextField *secondMileageTF;
@property (weak, nonatomic) IBOutlet UITextField *timeRangeTF;
@property (nonatomic, assign) NSInteger timeRangeId;
@property (nonatomic, copy) MaterialTimeRangeTableViewCellBlock clickBlock;

- (void)refreshRequestSchemeMonth:(PorscheConstantModel *)month;

@end
