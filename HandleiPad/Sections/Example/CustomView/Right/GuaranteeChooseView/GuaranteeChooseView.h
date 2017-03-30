//
//  GuaranteeChooseView.h
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


//1.内结  2.保修   3.自费
typedef void(^GuaranteeChooseViewBlock)(UIButton *,NSInteger);

@interface GuaranteeChooseView : UIView



@property (weak, nonatomic) IBOutlet UILabel *headerLb;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, copy) GuaranteeChooseViewBlock guaranteeChooseViewBlock;

- (IBAction)buttonClickAction:(UIButton *)sender;


//默认尺寸 <240.203>
+ (instancetype)getClassCustomFrame:(CGRect)frame dataSource:(NSArray *)dataSource idx:(NSInteger)idx;


@end
