//
//  ProjectCarStyleCollectionViewCellModel.h
//  HandleiPad
//
//  Created by Robin on 16/10/10.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectCarStyleCollectionViewCellModel : NSObject
//车系
@property (nonatomic, copy) NSString *carLine;
//车型
@property (nonatomic, copy) NSString *carType;
//年份
@property (nonatomic, copy) NSString *carYear;
//排量
@property (nonatomic, copy) NSString *carCC;

@end
