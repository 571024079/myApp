//
//  CoreDataManager.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalDataVersion.h"

//hc_basic_businesstype：业务类型 hc_basic_cancelreason：取消原因 hc_basic_insurancecompany：保修公司 hc_basic_url：网页链接 hc_common_value：常量 hc_store_department：部门列表 hc_store_group：组列表 hc_store_position：职位列表 string	类型【方案级别：FAJB，结算方式：JSFS，库存类型：KCLX，保修状态：BXZT，开单状态：KDZT，间隔月数：JGYS】

@interface CoreDataManager : NSObject
//管理对象，上下文，持久性存储模型对象
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//被管理的数据模型，数据结构
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//连接数据库的
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)shareManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//- (void)insertData:(NSArray *)datas tableName:(NSString *)tableName;
- (void)updateData:(NSArray *)datas tableName:(NSString *)tableName;
- (NSArray *)getModelsWithTableName:(NSString *)tableName;
- (void)updateDataWithDataInfo:(NSDictionary *)dataInfo;
- (PorscheConstantModel *)queryPostionInfoWithPositionId:(NSNumber *)postionid;
@end
