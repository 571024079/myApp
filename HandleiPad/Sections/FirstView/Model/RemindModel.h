//
//  RemindModel.h
//  HandleiPad
//
//  Created by Handlecar1 on 17/1/18.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindModel : NSObject

@property (nonatomic, strong) NSNumber *allnum;//所有消息数量；
@property (nonatomic, strong) NSNumber *increasenum;//增项通知数量
@property (nonatomic, strong) NSNumber *newtasknum;//新任务数量
@property (nonatomic, strong) NSNumber *partsnum;//所有消息数量；
@property (nonatomic, strong) NSNumber *statenum;//状态变化数量

@end
