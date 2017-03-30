//
//  PorscheWorkHoursModel.m
//  HandleiPad
//
//  Created by Robin on 2016/11/28.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheWorkHoursModel.h"

@implementation PorscheWorkHoursModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"cars" : [PorscheSchemeCarModel class],
             @"business" : [PorscheBusinessModel class]};
}

//NSMutableArray<PorscheSchemeCarModel *> *car; //车系
//PorscheSchemeMilesModel *km; //公里数相关
//PorscheSchemeMonthModel *month; //月数相关
//PorscheSchemeWorkHourModel *workhour; //工时
//NSArray <PorscheBusinessModel *>*business;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cars = [[NSMutableArray alloc] init];
        self.km = [[PorscheSchemeMilesModel alloc] init];
        self.month = [[PorscheSchemeMonthModel alloc] init];
        self.workhour = [[PorscheSchemeWorkHourModel alloc] init];
        self.business = [[NSArray alloc] init];
    }
    return self;
}

@end
