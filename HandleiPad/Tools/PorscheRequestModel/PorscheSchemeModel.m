//
//  PorscheSchemeModel.m
//  HandleiPad
//
//  Created by Robin on 2016/11/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheSchemeModel.h"

@implementation PorscheSchemeModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"carlist" : [PorscheSchemeCarModel class],
             @"sparelist" : [PorscheSchemeSpareModel class],
             @"typelist" : [PorscheBusinessModel class],
             @"workhourlist" : [PorscheSchemeWorkHourModel class],
             @"favoritelist":[PorscheSchemeFavoriteModel class]};
}

- (NSString *)checkParameter {
    
    if (!self.schemename||[self.schemename isEqualToString:@""]) return @"请填写方案名";
    if (!self.schemelevelid.integerValue) return @"请选择方案级别";
    
    for (PorscheSchemeSpareModel *spare in self.sparelist) {
        NSString *spareHint = [spare checkSchemeSpareParameter];
        if (![spareHint isEqualToString:@""]) return spareHint;
    }
    
    for (PorscheSchemeWorkHourModel *workHour in self.workhourlist) {
        NSString *workHourHint = [workHour checkSchemeWorkhourParameter];
        if (![workHourHint isEqualToString:@""]) return workHourHint;
    }
    
    return @"";
}

- (NSString *)workhourgroupfuname
{
    PorscheSchemeWorkHourModel *workHour = [self.workhourlist firstObject];
    return workHour.workhourgroupfuname;
}

- (NSString *)workhourgroupsname
{
    PorscheSchemeWorkHourModel *workHour = [self.workhourlist firstObject];
    return workHour.workhourgroupname;
}

@end

@implementation PorscheSchemeCarModel

- (NSString *)carSting {
    
    NSString *car_1 = self.wocarcatena ? self.wocarcatena : @"";
    NSString *car_2 = self.wocarmodel ? self.wocarmodel : @"";
    NSString *car_3 = self.woyearstyle ? self.woyearstyle : @"";
    NSString *car_4 = self.wooutputvolume ? self.wooutputvolume : @"";
    
    NSMutableArray *codes = [NSMutableArray array];
    
    if (car_1.length)
    {
        [codes addObject:car_1];
    }
    
    if (car_2.length) {
        [codes addObject:car_2];
    }
    
    if (car_3.length)
    {
        [codes addObject:car_3];
    }
    
    if (car_4.length) {
        [codes addObject:car_4];
    }
    NSString *code = [codes componentsJoinedByString:@"/"];
    
    
//    if (code.length)
//    {
//        while ([[code substringFromIndex:code.length-1] isEqualToString:@"/"]) {
//            code = [code substringToIndex:code.length-1];
//        }
//    }

    return code;
}


- (NSString *)cartypename
{
    NSString *cartype = @"";
    
    if (self.wocarcatena.length)
    {
        cartype = [cartype stringByAppendingString:self.wocarcatena];
    }
    
    if (self.wocarmodel.length)
    {
        cartype = [cartype stringByAppendingString:[NSString stringWithFormat:@" %@",self.wocarmodel]];
    }
    
    if (self.woyearstyle.length)
    {
        cartype = [cartype stringByAppendingString:[NSString stringWithFormat:@" %@",self.woyearstyle]];
    }
//    self.workHourModel.workhour.cartypename = [NSString stringWithFormat:@"%@ %@ %@",carmodel.wocarcatena,carmodel.wocarmodel, carmodel.woyearstyle];

    return cartype;
}

@end

@implementation PorscheSchemeMilesModel

- (NSString *)milesString {
    
    NSString *miles;
    switch (self.rangetype.integerValue) {
        case 1:
        {
            miles = [NSString stringWithFormat:@"%@万公里~%@万公里",self.beginmiles,self.endmiles];
        }
            break;
        case 2:
        {
            miles = [NSString stringWithFormat:@"%@万公里/上浮%@万公里/下浮%@万公里",self.allmiles,self.upfloatmiles,self.downfloatmiles];
        }
            break;
        case 3:
        {
            miles = [NSString stringWithFormat:@"首次%@万公里/每%@万公里/上浮%@万公里/下浮%@万公里",self.startmiles,self.personmemiles,self.upfloatmiles,self.downfloatmiles];
        }
            break;
        default:
            miles = nil;
            break;
    }
    return miles;
}

@end

@implementation PorscheSchemeMonthModel

- (NSString *)monthString {
    
    if (!self.startmonth) {
        
        return nil;
    }
    NSString *sting = [NSString stringWithFormat:@"首次%@个月/每%@个月/上浮%@个月/下浮%@个月",self.startmonth,self.timeintervalmonth,self.upfloatmonth,self.downfloatmonth];
    return sting;
}

@end

@implementation PorscheSchemeSpareModel

- (void)setupPartNumber:(NSString *)sting {
    
    NSMutableArray *numers = [[NSMutableArray alloc] initWithArray:[sting componentsSeparatedByString:@" "]];
    
    [numers removeObject:@""];
    
    [numers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx == 0) self.parts_no_1 = obj;
        if (idx == 1) self.parts_no_2 = obj;
        if (idx == 2) self.parts_no_3 = obj;
        if (idx == 3) self.parts_no_4 = obj;
        if (idx == 4) self.parts_no_5 = obj;
        if (idx == 5) {
            self.parts_no_6 = obj;
        }
    }];
}

- (void)setupPartNumberWithArray:(NSArray<NSString *> *)array
{
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) self.parts_no_1 = obj;
        if (idx == 1) self.parts_no_2 = obj;
        if (idx == 2) self.parts_no_3 = obj;
        if (idx == 3) self.parts_no_4 = obj;
        if (idx == 4) self.parts_no_5 = obj;
        if (idx == 5) {
            self.parts_no_6 = obj;
        }
    }];
}


- (void)setupImageNumber:(NSString *)sting {
    
    NSMutableArray *numers = [[NSMutableArray alloc] initWithArray:[sting componentsSeparatedByString:@" "]];
    
    [numers removeObject:@""];
    
    [numers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) self.image_no_1 = obj;
        if (idx == 1) self.image_no_2 = obj;
        if (idx == 2) self.image_no_3 = obj;
        if (idx == 3) self.image_no_4 = obj;
    }];
}

- (void)setupImageNumberWithArray:(NSArray<NSString *>*)imagenos
{
    [imagenos enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) self.image_no_1 = obj;
        if (idx == 1) self.image_no_2 = obj;
        if (idx == 2) self.image_no_3 = obj;
        if (idx == 3) self.image_no_4 = obj;
    }];
}

- (NSString *)speraCode {
    
    NSString *part_1 = self.parts_no_1 ? self.parts_no_1 : @"";
    NSString *part_2 = self.parts_no_2 ? self.parts_no_2 : @"";
    NSString *part_3 = self.parts_no_3 ? self.parts_no_3 : @"";
    NSString *part_4 = self.parts_no_4 ? self.parts_no_4 : @"";
    NSString *part_5 = self.parts_no_5 ? self.parts_no_5 : @"";
    NSString *part_6 = self.parts_no_6 ? self.parts_no_6 : @"";

    NSArray *codes = @[part_1,part_2,part_3,part_4,part_5,part_6];
    NSString *code = [codes componentsJoinedByString:@" "];
    
    if ([part_1 isEqualToString:@""]) code = nil;
    
    return code;
}

- (NSArray *)spareCodes
{
    NSString *part_1 = self.parts_no_1 ? self.parts_no_1 : @"";
    NSString *part_2 = self.parts_no_2 ? self.parts_no_2 : @"";
    NSString *part_3 = self.parts_no_3 ? self.parts_no_3 : @"";
    NSString *part_4 = self.parts_no_4 ? self.parts_no_4 : @"";
    NSString *part_5 = self.parts_no_5 ? self.parts_no_5 : @"";
    
        NSString *part_6 = self.parts_no_6 ? self.parts_no_6 : @"";
    NSArray *codes = @[part_1,part_2,part_3,part_4,part_5,part_6];
    return codes;
}


- (NSString *)speraImageCode {
    
    NSString *image_1 = self.image_no_1 ? self.image_no_1 : @"";
    NSString *image_2 = self.image_no_2 ? self.image_no_2 : @"";
    NSString *image_3 = self.image_no_3 ? self.image_no_3 : @"";
    NSString *image_4 = self.image_no_4 ? self.image_no_4 : @"";
    
    NSArray *imageCodes = @[image_1,image_2,image_3,image_4];
    NSString *imageCode = [imageCodes componentsJoinedByString:@" "];
    
    if ([image_1 isEqualToString:@""]) imageCode = nil;
    
    return imageCode;
}


- (NSArray *)spareImageCodes
{
    NSString *image_1 = self.image_no_1 ? self.image_no_1 : @"";
    NSString *image_2 = self.image_no_2 ? self.image_no_2 : @"";
    NSString *image_3 = self.image_no_3 ? self.image_no_3 : @"";
    NSString *image_4 = self.image_no_4 ? self.image_no_4 : @"";
    
    NSArray *imageCodes = @[image_1,image_2,image_3,image_4];
    return imageCodes;
}

- (NSString *)checkParameter {
    
    if (!self.parts_name||[self.parts_name isEqualToString:@""]) return @"请填写备件名称";
    if (!self.parts_no_1||[self.parts_no_1 isEqualToString:@""]) return @"请填写备件编号";
    //17-02-04 czz 要求去掉备件价格的提示,可以为零
//    if (!self.price_after_tax.integerValue) return @"请填写备件价格";
    if (!self.parts_level.integerValue) return @"请选择备件级别";

    return @"";
}
- (NSString *)checkSchemeSpareParameter {
    
    if (!self.parts_name||[self.parts_name isEqualToString:@""]) return @"请填写备件名称";
    if (!self.parts_no_1||[self.parts_no_1 isEqualToString:@""]) return @"请填写备件编号";
    //17-02-04 czz 要求去掉备件价格的提示,可以为零
//    if (!self.price_after_tax.integerValue) return @"请填写备件价格";
    if (!self.parts_num.integerValue) return @"请填写备件数量";
    return @"";
}


- (void)setParts_no:(NSString *)no atIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.parts_no_1 = no;
            break;
        case 1:
            self.parts_no_2 = no;
            break;
        case 2:
            self.parts_no_3 = no;
            break;
        case 3:
            self.parts_no_4 = no;
            break;
        case 4:
            self.parts_no_5 = no;
            break;
        case 5:
            self.parts_no_6 = no;
            break;
        default:
            break;
    }
}
- (void)setImage_no:(NSString *)no atIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.image_no_1 = no;
            break;
        case 1:
            self.image_no_2 = no;
            break;
        case 2:
            self.image_no_3 = no;
            break;
        case 3:
            self.image_no_4 = no;
            break;
        default:
            break;
    }
}
@end

@implementation PorscheBusinessModel

@end

@implementation PorscheSchemeWorkHourModel
+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"cars" : [PorscheSchemeCarModel class]};
}

- (void)setupWorkHourNumber:(NSString *)sting {
    
    NSMutableArray *numers = [[NSMutableArray alloc] initWithArray:[sting componentsSeparatedByString:@" "]];
    
    [numers removeObject:@""];
    
    [numers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) self.workhourcode1 = obj;
        if (idx == 1) self.workhourcode2 = obj;
        if (idx == 2) self.workhourcode3 = obj;
        if (idx == 3) self.workhourcode4 = obj;
        if (idx == 4) self.workhourcode5 = obj;
    }];

}

- (void)setupWorkHourNumberWithArray:(NSArray<NSString *> *)array
{
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) self.workhourcode1 = obj;
        if (idx == 1) self.workhourcode2 = obj;
        if (idx == 2) self.workhourcode3 = obj;
        if (idx == 3) self.workhourcode4 = obj;
        if (idx == 4) self.workhourcode5 = obj;
    }];
}


- (NSString *)workHourCode {
    
    NSString *part_1 = self.workhourcode1 ? self.workhourcode1 : @"";
    NSString *part_2 = self.workhourcode2 ? self.workhourcode2 : @"";
    NSString *part_3 = self.workhourcode3 ? self.workhourcode3 : @"";
    NSString *part_4 = self.workhourcode4 ? self.workhourcode4 : @"";
    NSString *part_5 = self.workhourcode5 ? self.workhourcode5 : @"";
    NSArray *codes = @[part_1,part_2,part_3,part_4,part_5];
    NSString *code = [codes componentsJoinedByString:@" "];
    
    if ([part_1 isEqualToString:@""]) code = nil;
    return code;
}

- (NSArray *)workHourCodes
{
    NSString *part_1 = self.workhourcode1 ? self.workhourcode1 : @"";
    NSString *part_2 = self.workhourcode2 ? self.workhourcode2 : @"";
    NSString *part_3 = self.workhourcode3 ? self.workhourcode3 : @"";
    NSString *part_4 = self.workhourcode4 ? self.workhourcode4 : @"";
    NSString *part_5 = self.workhourcode5 ? self.workhourcode5 : @"";
    NSArray *codes = @[part_1,part_2,part_3,part_4,part_5];
    return codes;
}

- (NSString *)checkParameter {
    
    NSString *hint = [self checkSchemeWorkhourParameter];
    if (![hint isEqualToString:@""]) return hint;
    
    return @"";
}
- (NSString *)checkSchemeWorkhourParameter {
    
    if (!self.workhourname||[self.workhourname isEqualToString:@""]) return @"请填写工时名称";
    if (!self.workhourcode1||[self.workhourcode1 isEqualToString:@""]) return @"请填写工时编号";
    //17-02-04 czz 要求去掉工时价格的提示,可以为零
//    if (!self.workhourprice.integerValue) return @"请填写工时价格";
    if (!self.workhourcount.integerValue) return @"请填写工时数量";
    return @"";
}
- (void)setWorkhourcode:(NSString *)code atIndex:(NSInteger)index;
{
    switch (index) {
        case 0:
            self.workhourcode1 = code;
            break;
        case 1:
            self.workhourcode2 = code;
            break;
        case 2:
            self.workhourcode3 = code;
            break;
        case 3:
            self.workhourcode4 = code;
            break;
        case 4:
            self.workhourcode5 = code;
            break;
        default:
            break;
    }
}
@end

@implementation PorscheSchemeFavoriteModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"schemelist" : [PorscheSchemeModel class]};
}

@end
