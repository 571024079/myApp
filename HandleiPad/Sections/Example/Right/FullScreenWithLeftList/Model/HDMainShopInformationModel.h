//
//  HDMainShopInformationModel.h
//  HandleiPad
//
//  Created by handlecar on 16/12/8.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDMainShopInformationModel : NSObject

@property (nonatomic, strong) NSNumber *customerconfirmnum;//客户确认数
@property (nonatomic, strong) NSNumber *exprienum;//过期交车数
@property (nonatomic, strong) NSNumber *instorenum;//在厂车辆数
@property (nonatomic, strong) NSNumber *todaysubnum;//今日交车数

+ (HDMainShopInformationModel *)dataFormDic:(NSDictionary *)dic;
@end
