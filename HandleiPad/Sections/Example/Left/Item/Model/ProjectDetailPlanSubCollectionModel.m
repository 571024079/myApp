//
//  ProjectDetailPlanSubCollectionModel.m
//  HandleiPad
//
//  Created by Robin on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetailPlanSubCollectionModel.h"

@implementation ProjectDetailPlanSubCollectionModel

+ (instancetype)modelWithBusiness:(PorscheBusinessModel *)busniness {
    
    ProjectDetailPlanSubCollectionModel *model = [[ProjectDetailPlanSubCollectionModel alloc] init];
    model.title = @"业务";
    model.content = busniness.businesstypename;
    model.contentid = busniness.businesstypeid.integerValue;
    return model;
}

- (PorscheBusinessModel *)toBusinessModel {
    
    PorscheBusinessModel *model = [[PorscheBusinessModel alloc] init];
    
    model.businesstypeid = [NSNumber numberWithInteger:self.contentid];
    model.businesstypename = self.content;
    
    
    return model;
}

@end
