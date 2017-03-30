//
//  SpareSettingModel.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/22.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpareSettingModel : NSObject
/*
 private String partsno;//备件编号
 private String partsnum;//备件数量
 private String pastdes;//备件描述
 private String ordrtype;//订单类型
 */
@property (nonatomic, strong) NSString *partsno;
@property (nonatomic, strong) NSString *partsnum;
@property (nonatomic, strong) NSString *pastdes;
@property (nonatomic, strong) NSString *ordrtype;
@property (nonatomic, strong) NSNumber *wospid;
@end
