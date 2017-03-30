//
//  NSArray+PorscheCarTypeChooserView.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "NSArray+PorscheCarTypeChooserView.h"
@implementation NSArray (PorscheCarTypeChooserView)


- (PorscheCarSeriesModel *)containCarseriesWithCars:(PorscheCarSeriesModel *)cars
{
    for (PorscheCarSeriesModel *carseries in self)
    {
        if ([carseries.pctid isEqualToNumber:cars.pctid])
        {
            return carseries;
        }
    }
    return nil;
}


- (PorscheCarTypeModel *)containCartypeWithCartype:(PorscheCarTypeModel *)cartype
{
    for (PorscheCarTypeModel *cartypeModel in self)
    {
        if ([cartypeModel.pctid isEqualToNumber:cartype.pctid])
        {
            return cartypeModel;
        }
    }
    return nil;
}



- (PorscheCarYearModel *)containCaryearWithYear:(PorscheCarYearModel *)year
{
    for (PorscheCarYearModel *caryearModel in self)
    {
        if ([caryearModel.pctid isEqualToNumber:year.pctid])
        {
            return caryearModel;
        }
    }
    return nil;
}


- (PorscheCarOutputModel *)containCaroutputWithDisplacement:(PorscheCarOutputModel *)displacement
{
    for (PorscheCarOutputModel *output in self)
    {
        if ([output.pctid isEqualToNumber:displacement.pctid])
        {
            return output;
        }
    }
    return nil;
}
@end
