//
//  ScanInfoTableView.h
//  CrameraDemo
//
//  Created by Robin on 16/9/23.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanInfoModel.h"

@protocol ScanInfoTableViewDelegate <NSObject>

@optional
- (void)scanInfoTableViewcarCardastralWillShow; //地域键盘将要显示
- (void)scanInfoTableViewcarCardastralWillDismiss; //地域键盘将要消失
- (void)scanInfoTableViewCancleClick; //取消
- (void)scanInfoTableViewConfilrmWidth:(ScanInfoModel *)model; //完成

@end

@interface ScanInfoTableView : UIView

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *carNumTextFied;
@property (weak, nonatomic) IBOutlet UITextField *vinTextField;

@property(weak, nonatomic) id <ScanInfoTableViewDelegate> delegate;

@end
