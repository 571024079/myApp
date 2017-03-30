//
//  ProjectDetailPlanSubCollectionModel.h
//  HandleiPad
//
//  Created by Robin on 16/10/18.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ProjectDetailPlanSubCollectionType) {
    
    ProjectDetailPlanSubCollectionTypeBusiness = 1, //业务
    ProjectDetailPlanSubCollectionTypeLevel, //级别
    ProjectDetailPlanSubCollectionTypeSperaGroup, //备件组别
    ProjectDetailPlanSubCollectionTypeWorkHourMainGroup, //工时主组
    ProjectDetailPlanSubCollectionTypeWorkHourSubGroup  //工时子组
};

@interface ProjectDetailPlanSubCollectionModel : NSObject


@property (nonatomic, assign) ProjectDetailPlanSubCollectionType modelType;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger contentid;

@property (nonatomic, copy) NSString *subContent;

@property (nonatomic, assign) NSInteger subContentid;

@property (nonatomic, strong) NSNumber *relationId;

//title不可更改
//@property (nonatomic, assign) BOOL protectedModel;

+ (instancetype)modelWithBusiness:(PorscheBusinessModel *)busniness;

- (PorscheBusinessModel *)toBusinessModel;


@end
