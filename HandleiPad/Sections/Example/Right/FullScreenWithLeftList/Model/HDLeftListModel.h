//
//  HDLeftListModel.h
//  HandleiPad
//
//  Created by handou on 16/10/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDLeftListModel : NSObject

@property (nonatomic, strong) NSNumber *carID;//id
@property (nonatomic, copy) NSString *carplate;//车牌
@property (nonatomic, copy) NSString *cartype;//车型
@property (nonatomic, strong) NSNumber *type1;//第一个类型
@property (nonatomic, strong) NSNumber *type2;//第二个类型
@property (nonatomic, strong) NSNumber *type3;//第三个类型
@property (nonatomic, strong) NSNumber *type4;//第四个类型
@property (nonatomic, strong) NSNumber *type5;//第五个类型
@property (nonatomic, strong) NSNumber *stayType;//是否在厂
@property (nonatomic, strong) NSNumber *typeBao;//保险图标
@property (nonatomic, strong) PorscheNewCarMessage *carModel;

@property (nonatomic, strong) NSMutableArray *dateSource;//携带详情的参数


//+ (HDLeftListModel *)shareLeftList;

+ (HDLeftListModel *)dataFrom;
+ (NSMutableArray *)dataLoad;

@end
