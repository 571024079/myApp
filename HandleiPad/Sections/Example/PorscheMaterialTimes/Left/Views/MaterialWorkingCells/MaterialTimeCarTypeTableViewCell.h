//
//  MaterialTimeCarTypeTableViewCell.h
//  MaterialDemo
//
//  Created by Robin on 16/9/28.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MaterialTimeCarTypeClick) {
    
    MaterialTimeCarTypeClickMainGroup,
    MaterialTimeCarTypeClickSubGroup,
    MaterialTimeCarTypeClickYearGroup
};

typedef void(^CarTypeClickBlock)(MaterialTimeCarTypeClick CarType, UIView *view);
@interface MaterialTimeCarTypeTableViewCell : UITableViewCell

//@property (nonatomic, copy) CarTypeClickBlock clickBlock;
@property (weak, nonatomic) IBOutlet UITextField *mainCarTF;
@property (weak, nonatomic) IBOutlet UITextField *subCarTF;
@property (weak, nonatomic) IBOutlet UITextField *yearCarTF;

@property (nonatomic, assign) BOOL setupCar;

@end
