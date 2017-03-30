//
//  ScanInfoModel.h
//  HandleiPad
//
//  Created by Robin on 16/9/29.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanInfoModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *carCardArea; //地域
@property (nonatomic, copy) NSString *carCardNum; //车牌号码
@property (nonatomic, copy) NSString *vin; //vin码

@end
