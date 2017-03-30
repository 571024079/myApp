//
//  ScanInfoView.h
//  CrameraDemo
//
//  Created by Robin on 16/9/23.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanInfoTableView.h"

typedef enum : NSUInteger {
    ScanInfoViewTypeNormal,   // 行驶证
    ScanInfoViewTypeVIN,      // VIN
} ScanInfoViewType;

typedef void(^ScanFinishBlock)(ScanInfoModel *model);

@interface ScanInfoView : UIView

@property (strong, nonatomic) UIImageView *picImage;

@property (nonatomic, copy) ScanFinishBlock scanfinishBlock;

@property (weak, nonatomic) NSTimer *lineTimer;

@property (nonatomic) ScanInfoViewType viewType;
- (void)showInfo:(NSDictionary *)info;

@end
