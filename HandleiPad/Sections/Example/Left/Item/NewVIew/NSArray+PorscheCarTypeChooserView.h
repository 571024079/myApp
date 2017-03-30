//
//  NSArray+PorscheCarTypeChooserView.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/16.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PorscheCarSeriesModel.h"

@interface NSArray (PorscheCarTypeChooserView)

- (PorscheCarSeriesModel *)containCarseriesWithCars:(PorscheCarSeriesModel *)cars;

- (PorscheCarTypeModel *)containCartypeWithCartype:(PorscheCarTypeModel *)cartype;

- (PorscheCarYearModel *)containCaryearWithYear:(PorscheCarYearModel *)year;

- (PorscheCarOutputModel *)containCaroutputWithDisplacement:(PorscheCarOutputModel *)displacement;
@end
