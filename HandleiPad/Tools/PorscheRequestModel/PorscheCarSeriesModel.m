//
//  PorscheCarSeriesModel.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheCarSeriesModel.h"

@implementation PorscheCarSeriesModel

- (NSMutableArray *)selectCartypeArray
{
    if (!_selectCartypeArray)
    {
        _selectCartypeArray = [NSMutableArray array];
    }
    return _selectCartypeArray;
}

- (void)clearSelectCartypeArray
{
    self.selectCartypeArray = nil;
}

- (PorscheConstantModel *)constantModel {
    PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
    model.cvvaluedesc = self.cars;
    model.extrainfo = self.carscode;
    model.cvsubid = self.pctid;
    return model;
}


@end

@implementation PorscheCarTypeModel

- (NSMutableArray *)selectCaryearArray
{
    if (!_selectCaryearArray)
    {
        _selectCaryearArray = [NSMutableArray array];
    }
    return _selectCaryearArray;
}


- (void)clearSelectCaryearArray
{
    self.selectCaryearArray = nil;
}

- (PorscheConstantModel *)constantModel {
    
    PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
    model.cvvaluedesc = self.cartype;
    model.extrainfo = self.cartypecode;
    model.configure = self.pctconfigure1;
    model.cvsubid = self.pctid;
    return model;
}

@end

@implementation PorscheCarYearModel

- (NSMutableArray *)selectCaroutputArray
{
    if (!_selectCaroutputArray)
    {
        _selectCaroutputArray = [NSMutableArray array];
    }
    return _selectCaroutputArray;
}

- (void)clearSelectCaroutputArray
{
    self.selectCaroutputArray = nil;
}

- (PorscheConstantModel *)constantModel {
    
    PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
    model.cvvaluedesc = self.year;
    model.extrainfo = self.year;
    model.cvsubid = self.pctid;
    return model;
}

@end

@implementation PorscheCarOutputModel

- (PorscheConstantModel *)constantModel {
    
    PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
    model.cvvaluedesc = self.displacement;
    model.cvsubid = self.pctid;
    return model;
}

@end
