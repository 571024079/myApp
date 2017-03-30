//
//  MaterialTimeGroupTableViewCell.h
//  MaterialDemo
//
//  Created by Robin on 16/9/28.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MaterialTimeGroupClickType) {
    
    MaterialTimeGroupMainGroupClick,
    MaterialTimeGroupSubGroupClick,
    MaterialTimeGroupMaterialGroupClick
};

typedef void(^MaterialTimeGroupClickBlock)(MaterialTimeGroupClickType, UIView *);

@interface MaterialTimeGroupTableViewCell : UITableViewCell

//@property (nonatomic, copy) MaterialTimeGroupClickBlock clickBlcok;
@property (weak, nonatomic) IBOutlet UITextField *mainGroupTF;
@property (weak, nonatomic) IBOutlet UITextField *subGroupTF;

@property (nonatomic, assign) MaterialTaskTimeDetailsType cellType;

- (void)refreshRequestSchemeListModeltype:(NSInteger)type constant:(PorscheConstantModel *)constant;

@end
