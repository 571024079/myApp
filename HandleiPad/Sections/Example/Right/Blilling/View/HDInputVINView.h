//
//  HDInputVINView.h
//  Handlecar
//
//  Created by liuzhaoxu on 14-9-5.
//  Copyright (c) 2014年 HanDou. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HDInputVINViewFInishVINInputBlock)(NSString *);

@class HDInputVINView;

@protocol HDInputVinViewDelegate <NSObject>

@optional
- (void)inputVINView:(HDInputVINView *)inputView inputVIN:(NSString *)vinNo;

@end

@interface HDInputVINView : UIView

@property (weak, nonatomic) IBOutlet UIView *btSuperView;

@property (weak, nonatomic) IBOutlet UILabel *VINLb;

@property (nonatomic, copy) HDInputVINViewFInishVINInputBlock hDInputVINViewFInishVINInputBlock;

- (void)showInputView:(id<HDInputVinViewDelegate>)delegate originalVINNo:(NSString *)vinNo textField:(UITextField *)textField;

@end
