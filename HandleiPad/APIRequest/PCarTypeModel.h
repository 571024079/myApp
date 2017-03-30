//
//  PCarTypeModel.h
//  HandleiPad
//
//  Created by Handlecar on 9/24/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCarTypeModel : NSObject
/*
 int level = Util.convertToInt(request.getParameter("level"));
 int pid = Util.convertToInt(request.getParameter("pid"));
 String year = request.getParameter("year");
 int carsflg = Util.convertToInt(request.getParameter("carsflg"));
 String cars = request.getParameter("cars");
 */

@property (nonatomic, strong) NSNumber *level;  // 后台层级 id
@property (nonatomic, strong) NSNumber *pid;    // id  车系id or 车型 id or 年款id
@property (nonatomic, strong) NSString *year;   // 年款
@property (nonatomic, strong) NSNumber *carsflg;
@property (nonatomic, strong) NSString *cars;  // 车系
@property (nonatomic, strong) NSNumber *Id;  // id  与OC关键字冲突 改为Id
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bracketName; // 带有中括号的名字
@property (nonatomic, strong) NSNumber *oldcode;
@property (nonatomic, strong) NSNumber *lycode;
@property (nonatomic, strong) NSString *cartypeArrays;  //

+ (NSArray *)cartypeModelsFromArray:(NSArray *)cartypeArrays;

@end
