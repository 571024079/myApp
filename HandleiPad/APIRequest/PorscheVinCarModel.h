//
//  PorscheVinCarModel.h
//  HandleiPad
//
//  Created by Robin on 16/10/27.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PorscheVinCarTypeModel.h"

@interface PorscheVinCarModel : NSObject

@property (nonatomic, copy) NSString *cars;

@property (nonatomic, copy) NSArray <PorscheVinCarTypeModel *>*cartTypes;

@end
