//
//  PorscheCustomModel.m
//  HandleiPad
//
//  Created by Handlecar on 9/11/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "PorscheCustomModel.h"

@implementation PorscheCustomModel


+ (NSArray *)getAllPorsheCarSeries
{
    NSMutableArray *carSeries = [NSMutableArray array];
    
    
    // Boxster
    PorscheCarSeries *series1 = [[PorscheCarSeries alloc] init];
    series1.carSeriesId = @1;
    series1.carSeriesName = @"Boxster";
    // 对应车型
    NSMutableArray *series1CarTypeArray = [NSMutableArray array];
    [series1CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@1 andName:@"Boxster"]];
    [series1CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@2 andName:@"Boxster S"]];
    series1.cartypeArray = series1CarTypeArray;
    
    // Cayman
    PorscheCarSeries *series2 = [[PorscheCarSeries alloc] init];
    series2.carSeriesId = @2;
    series2.carSeriesName = @"Cayman";
    // 对应车型
    NSMutableArray *series2CarTypeArray = [NSMutableArray array];
    [series2CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@3 andName:@"Cayman"]];
    [series2CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@4 andName:@"Cayman S"]];
    series2.cartypeArray = series2CarTypeArray;

    
    // 911
    PorscheCarSeries *series3 = [[PorscheCarSeries alloc] init];
    series3.carSeriesId = @3;
    series3.carSeriesName = @"911";
    // 对应车型
    /*
     911 Carrera
     911 Carrera S
     911 Carrera 4
     911 Carrera 4S
     911 Targa 4
     911 Targa 4S
     911 Turbo
     911Turbo S
     */
    NSMutableArray *series3CarTypeArray = [NSMutableArray array];
    [series3CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@5 andName:@"911 Carrera"]];
    [series3CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@6 andName:@"911 Carrera S"]];
    [series3CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@7 andName:@" 911 Carrera 4"]];
    [series3CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@8 andName:@"911 Carrera 4S"]];
    [series3CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@9 andName:@"911 Targa 4"]];
    [series3CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@10 andName:@"911 Targa 4 S"]];
    [series3CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@11 andName:@"911 Turbo"]];
    [series3CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@12 andName:@"911 Turbo S"]];
    series3.cartypeArray = series3CarTypeArray;
    
    //  Panamera
    PorscheCarSeries *series4 = [[PorscheCarSeries alloc] init];
    series4.carSeriesId = @4;
    series4.carSeriesName = @"Panamera";
    NSMutableArray *series4CarTypeArray = [NSMutableArray array];
    [series4CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@13 andName:@"Panamera"]];
    [series4CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@14 andName:@"Panamera 4"]];
    [series4CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@15 andName:@"Panamera 4S"]];
    [series4CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@16 andName:@"Panamer Turbo"]];
    [series4CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@17 andName:@"Panamer Turbo S"]];
    series4.cartypeArray = series4CarTypeArray;
    
    // Cayenne
    PorscheCarSeries *series5 = [[PorscheCarSeries alloc] init];
    series5.carSeriesId = @5;
    series5.carSeriesName = @"Cayenne";
    NSMutableArray *series5CarTypeArray = [NSMutableArray array];
    [series5CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@18 andName:@"Cayenne"]];
    [series5CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@19 andName:@"Cayenne S"]];
    [series5CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@20 andName:@"Cayenne GTS"]];
    [series5CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@21 andName:@"Cayenne Turbo"]];
    [series5CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@22 andName:@"Cayenne Turbo S"]];
    series5.cartypeArray = series5CarTypeArray;
    
    // Macan
    PorscheCarSeries *series6 = [[PorscheCarSeries alloc] init];
    series6.carSeriesId = @6;
    series6.carSeriesName = @"Macan";
    NSMutableArray *series6CarTypeArray = [NSMutableArray array];
    [series6CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@23 andName:@"Macan"]];
    [series6CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@24 andName:@"Macan S"]];
    [series6CarTypeArray addObject:[PorscheCustomModel getCarTypeWithCarTypeId:@25 andName:@"Macan Turbo"]];
    series6.cartypeArray = series6CarTypeArray;
    
    [carSeries addObject:series1];
    [carSeries addObject:series2];
    [carSeries addObject:series3];
    [carSeries addObject:series4];
    [carSeries addObject:series5];
    [carSeries addObject:series6];
    
    
    NSArray *dataSource = [carSeries valueForKey:@"carSeriesName"];
    
    return dataSource;
}

+ (NSArray *)getCarypeWithCarSeries:(NSString *)carSeries
{
    if ([carSeries isEqualToString:@"Boxster"])
    {
        return @[@"Boxster",@"Boxster S"];
    }
    if ([carSeries isEqualToString:@"Cayman"])
    {
        return @[@"Cayman",@"Cayman S"];
    }
    if ([carSeries isEqualToString:@"911"])
    {
        return @[@"911 Carrera",@"911 Carrera S",@"911 Carrera 4",@"911 Carrera 4S",@"911 Targa 4",@"911 Targa 4 S",@"911 Turbo",@"911 Turbo S"];
    }
    
    if ([carSeries isEqualToString:@"Panamera"])
    {
        return @[@"Panamera",@"Panamera 4",@"Panamera 4S",@"Panamer Turbo",@"Panamer Turbo S"];
    }

    if ([carSeries isEqualToString:@"Cayenne"])
    {
        return @[@"Cayenne",@"Cayenne S",@"Panamera 4S",@"Cayenne GTS",@"Cayenne Turbo",@"Cayenne Turbo S"];
    }

    if ([carSeries isEqualToString:@"Macan"])
    {
        return @[@"Macan",@"Macan S",@"Macan Turbo"];
    }
    
    return @[];
}

+ (PorscheCartype *)getCarTypeWithCarTypeId:(NSNumber *)cartypeId andName:(NSString *)cartypeName;
{
    PorscheCartype *cartype1 = [[PorscheCartype alloc] init];
    cartype1.cartypeId = cartypeId;
    cartype1.cartypeName = cartypeName;
    return cartype1;
}
/*
洗车、精洗、保养、维修、钣金、喷漆、美容、轮胎
 */
+ (NSArray *)getAllTeams
{
    return @[@"贴花，油漆，清洁用品",@"发动机",@"燃油系统，加热装置",@"变速箱，轴，制动器",@"支撑杆工具，中央管",@"车身",@"电子设备，仪表",@"工具，后视镜",@"附件"];
}

//工时主组

+ (NSArray *)getAllItemMainData {
    
    return @[@"整车-一般",@"发动机",@"燃油供应",@"变速箱",@"悬架",@"车身",@"车身—外侧设备",@"车身—外侧设备",@"空调",@"电气系统",@"整台车辆",@"车漆"];
}

+ (NSArray *)getSubTeamWithTeam:(NSString *)team {

    if ([team isEqualToString:@"整车-一般"]) {
        return @[@"销售检查",@"保养、诊断"];
    }
    if ([team isEqualToString:@"发动机"]) {
        return @[@"曲轴箱、悬架",@"曲轴齿轮、活塞",@"气缸盖、气门控制",@"润滑",@"冷却"];
    }
    if ([team isEqualToString:@"燃油供应"]) {
        return @[@"燃油供应控制",@"废气涡轮增压",@"燃油系统-电子点火",@"排气系统",@"巡航控制起动机电源",@"点火系统"];
    }
    if ([team isEqualToString:@"变速箱"]) {
        return @[@"离合器控制",@"自动离合器-变矩器",@"自动变速器-辅助壳体启动",@"自动变速器-挡位控制",@"主减速器-差速器、差速器锁"];
    }
    if ([team isEqualToString:@"悬架"]) {
        return @[@"驱动轴前轮悬架",@"驱动轴后轮悬架",@"空气悬架水平控制",@"车轮、轮胎、悬架校正",@"防抱死制动系统（ABS)",@"制动器-制动机构",@"制动器-液压制动系统、调节器",@"转向"];
    }
    if ([team isEqualToString:@"车身"]) {
        return @[@"车身前部",@"车身中心、车顶、车架",@"车身后部",@"活门盖",@"中控锁系统前门",@"中央锁后门"];
    }
    if ([team isEqualToString:@"车身—外侧设备"]) {
        return @[@"滑动车顶、倾斜车顶",@"保险杠",@"玻璃窗、车窗控制",@"外部设备",@"内饰",@"乘客保护"];
    }
    if ([team isEqualToString:@"车身—内侧设备"]) {
        return @[@"绝缘衬里",@"座椅框架",@"座椅装饰罩"];
    }
    if ([team isEqualToString:@"空调"]) {
        return @[@"加热",@"辅助暖风",@"通风",@"空调",@"辅助空调系统"];
    }
    if ([team isEqualToString:@"电气系统"]) {
        return @[@"收音机、立体声音响、电话、车载电脑",@"挡风玻璃刮水器和洗涤器系统",@"车外灯开关",@"车内灯开关",@"电缆"];
    }
    if ([team isEqualToString:@"整台车辆"]) {
        return @[@"整台车辆"];
    }
    if ([team isEqualToString:@"车漆"]) {
        return @[@"车漆"];
    }
    return @[];
}

+ (NSArray *)getBusinessTypes
{

    return @[@"洗车",@"精洗",@"保养",@"维修",@"钣金",@"喷漆",@"美容",@"轮胎"];
}

@end


@implementation PorscheCarSeries



@end

@implementation PorscheCartype



@end
