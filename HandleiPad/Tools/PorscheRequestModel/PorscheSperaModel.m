//
//  PorscheSperaModel.m
//  HandleiPad
//
//  Created by Robin on 2016/11/28.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheSperaModel.h"

@implementation PorscheSperaModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"stocks" : [PorscheSperaStock class],
             @"business" : [PorscheBusinessModel class],
             @"cars" : [PorscheSchemeCarModel class]};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stocks = [[NSArray alloc] init];
        self.business = [[NSArray alloc] init];
        self.parts = [[PorscheSchemeSpareModel alloc] init];
        self.parts.parts_stock_type = @(0);
        self.cars = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)speraCode {
    
    NSString *part_1 = self.parts.parts_no_1 ? self.parts.parts_no_1 : @"";
    NSString *part_2 = self.parts.parts_no_2 ? self.parts.parts_no_2 : @"";
    NSString *part_3 = self.parts.parts_no_3 ? self.parts.parts_no_3 : @"";
    NSString *part_4 = self.parts.parts_no_4 ? self.parts.parts_no_4 : @"";
    NSString *part_5 = self.parts.parts_no_5 ? self.parts.parts_no_5 : @"";
    NSArray *codes = @[part_1,part_2,part_3,part_4,part_5];

    NSString *code = [part_1 isEqualToString:@""] ? nil : [codes componentsJoinedByString:@" "];
    return code;
}

- (NSArray *)speraCodes
{
    NSString *part_1 = self.parts.parts_no_1 ? self.parts.parts_no_1 : @"";
    NSString *part_2 = self.parts.parts_no_2 ? self.parts.parts_no_2 : @"";
    NSString *part_3 = self.parts.parts_no_3 ? self.parts.parts_no_3 : @"";
    NSString *part_4 = self.parts.parts_no_4 ? self.parts.parts_no_4 : @"";
    NSString *part_5 = self.parts.parts_no_5 ? self.parts.parts_no_5 : @"";
    NSArray *codes = @[part_1,part_2,part_3,part_4,part_5];
    return codes;
}

- (NSString *)speraImageCode {
    
    NSString *image_1 = self.parts.image_no_1 ? self.parts.image_no_1 : @"";
    NSString *image_2 = self.parts.image_no_2 ? self.parts.image_no_2 : @"";
    NSString *image_3 = self.parts.image_no_3 ? self.parts.image_no_3 : @"";
    NSString *image_4 = self.parts.image_no_4 ? self.parts.image_no_4 : @"";
    
    NSArray *imageCodes = @[image_1,image_2,image_3,image_4];
    NSString *imageCode = [image_1 isEqualToString:@""] ? nil : [imageCodes componentsJoinedByString:@" "];
    return imageCode;
}

- (NSArray *)speraImageCodes {
    NSString *image_1 = self.parts.image_no_1 ? self.parts.image_no_1 : @"";
    NSString *image_2 = self.parts.image_no_2 ? self.parts.image_no_2 : @"";
    NSString *image_3 = self.parts.image_no_3 ? self.parts.image_no_3 : @"";
    NSString *image_4 = self.parts.image_no_4 ? self.parts.image_no_4 : @"";
    
    NSArray *imageCodes = @[image_1,image_2,image_3,image_4];
    return imageCodes;
}


@end

@implementation PorscheSperaStock

@end

