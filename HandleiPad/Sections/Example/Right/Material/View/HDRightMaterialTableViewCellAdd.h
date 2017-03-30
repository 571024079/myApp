//
//  HDRightMaterialTableViewCellAdd.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, HDRightMaterialTableViewCellAddStyle) {
    HDRightMaterialTableViewCellAddStyleDown = 1,// <#content#>
    
};

typedef void(^HDRightMaterialTableViewCellAddBlock)(HDRightMaterialTableViewCellAddStyle,UIButton *);



@interface HDRightMaterialTableViewCellAdd : UITableViewCell

@property (nonatomic, copy) HDRightMaterialTableViewCellAddBlock hDRightMaterialTableViewCellAddBlock;

@property (weak, nonatomic) IBOutlet UIButton *downBt;
@property (weak, nonatomic) IBOutlet UITextField *PCNtf;

- (IBAction)downBtAction:(UIButton *)sender;

@end
