//
//  PorschePrintAffirmView.h
//  HandleiPad
//
//  Created by Robin on 16/11/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PorschePrintAffirmViewPrintType) {
    
    PorschePrintAffirmViewPrintTypeALL, //全部
    PorschePrintAffirmViewPrintTypeSelfPay, //自费
    PorschePrintAffirmViewPrintTypeUpkeep, //保养
    PorschePrintAffirmViewPrintTypeInner //内结
};

typedef enum : NSUInteger {
    PorschePrintAffirmViewPrint,
    PorschePrintAffirmViewShare,
}  PorschePrintAffirmViewType;

typedef void(^PorschePrintAffirmViewBlock)(NSArray *pays, NSInteger count);
@interface PorschePrintAffirmView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (instancetype)showPrinAffirmViewAndComplete:(PorschePrintAffirmViewBlock)complete;

+ (instancetype)showPrinAffirmViewType:(PorschePrintAffirmViewType)viewType complete:(PorschePrintAffirmViewBlock)complete;


@end
