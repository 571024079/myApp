//
//  SpareSettingViewController.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/22.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SparePrintTypePreView = 1,
    SparePrintTypePrint,
    SparePrintTypeSave,
    SparePrintTypeNone,
} SparePrintType;

@class SpareSettingViewController;
@protocol SpareSettingViewControllerDelegate <NSObject>

- (void)spareSettingViewController:(SpareSettingViewController *)viewController printType:(SparePrintType )printType WithInfo:(NSArray *)spareInfo;

@end

@interface SpareSettingViewController : UIViewController
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) id<SpareSettingViewControllerDelegate>delegate;

@end
