//
//  PorscheSperaModel.h
//  HandleiPad
//
//  Created by Robin on 2016/11/28.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PorscheBusinessModel,PorscheSperaStock;
@interface PorscheSperaModel : NSObject

@property (nonatomic, strong) NSArray<PorscheSperaStock *> *stocks;//库存
@property (nonatomic, strong) NSArray<PorscheBusinessModel *> *business; //业务数组
@property (nonatomic, strong) NSMutableArray <PorscheSchemeCarModel *> *cars; //适用车型

@property (nonatomic, strong) PorscheSchemeSpareModel *parts; //备件信息

@property (nonatomic, copy) NSString *type;  // 修改或者添加的时候用  add OR update

- (NSString *)speraCode;

- (NSArray *)speraCodes;

- (NSString *)speraImageCode;
- (NSArray *)speraImageCodes;
@end

@interface PorscheSperaStock : NSObject

@property (nonatomic, strong) NSNumber *pbsamount; //库存数量
@property (nonatomic, strong) NSNumber *pbsid; //库存ID
@property (nonatomic, copy) NSString *pbsname; //库存名称
@property (nonatomic, strong) NSNumber *pbstype; //	库存类型 1：本店 2：PCN 3：PAG 4：无货

@end

