//
//  PorscheWorkHoursModel.h
//  HandleiPad
//
//  Created by Robin on 2016/11/28.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PorscheWorkHoursModel : NSObject

@property (nonatomic, strong) NSMutableArray<PorscheSchemeCarModel *> *cars; //车系
@property (nonatomic, strong) PorscheSchemeMilesModel *km; //公里数相关
@property (nonatomic, strong) PorscheSchemeMonthModel *month; //月数相关
@property (nonatomic, strong) PorscheSchemeWorkHourModel *workhour; //工时
@property (nonatomic, strong) NSArray <PorscheBusinessModel *>*business;

@property (nonatomic, copy) NSString *type;  // 修改或者添加的时候用  add OR update

@end
