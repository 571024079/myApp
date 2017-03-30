//
//  PorscheCustomModel.h
//  HandleiPad
//
//  Created by Handlecar on 9/11/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PorscheCartype;
@class PorscheCarSeries;
// 保时捷车型选择 数据集合
@interface PorscheCustomModel : NSObject
@property (nonatomic, strong) NSArray <PorscheCarSeries *> *carSeriesArray;  // 车系集合，包含车型，车型包含组别

+ (NSArray *)getAllPorsheCarSeries;
+ (NSArray *)getAllTeams;
+ (NSArray *)getBusinessTypes;
// 使用车系获取对应车型
+ (NSArray *)getCarypeWithCarSeries:(NSString *)carSeries;


//工时主组
+ (NSArray *)getAllItemMainData;
// 使用主组获取对应子组
+ (NSArray *)getSubTeamWithTeam:(NSString *)team;

@end


// 车系
@interface PorscheCarSeries : NSObject
@property (nonatomic, strong) NSNumber *carSeriesId;
@property (nonatomic, strong) NSString *carSeriesName;
@property (nonatomic, strong) NSArray<PorscheCartype *> *cartypeArray;
@end


// 车型
@interface PorscheCartype : NSObject
@property (nonatomic, strong) NSNumber *cartypeId;
@property (nonatomic, strong) NSString *cartypeName;
@end
