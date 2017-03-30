//
//  PenSigner.h
//  HandleiPad
//
//  Created by Robin on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PenSignerSaveImageBlock)(UIImage *,NSString *,UIButton *);
@interface PenSigner : UIView

@property (nonatomic, copy) PenSignerSaveImageBlock signerImageBlock;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//建议Size 882*575
+ (instancetype)viewFromXibWithFrame:(CGRect)frame;

@end
