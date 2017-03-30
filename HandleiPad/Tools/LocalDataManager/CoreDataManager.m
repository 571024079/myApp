//
//  CoreDataManager.m
//  HandleiPad
//
//  Created by Handlecar on 2016/12/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "CoreDataManager.h"
static CoreDataManager *manager = nil;

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoreDataManager *)shareManager
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
        
    });
    
    return manager;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ConstantData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ConstantData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.获取Documents路径
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



- (void)insertData:(NSArray *)datas tableName:(NSString *)tableName
{
    tableName = [tableName uppercaseString];

//    NSLog(@"数据保存地址:%@",[self applicationDocumentsDirectory]);
    NSManagedObjectContext *context = self.managedObjectContext;
    for (NSDictionary * version in datas)
    {

         id newVersion = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:context];
        for (NSString *key in version) {
            
            if ([newVersion respondsToSelector:NSSelectorFromString(key)])
            {
                [newVersion setValue:version[key] forKey:key];
            }
        }
     
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}


- (void)updateData:(NSArray *)datas tableName:(NSString *)tableName
{
    tableName = [tableName uppercaseString];
        [self deleteListWithTableName:tableName];
        [self insertData:datas tableName:tableName];

}

- (void)updateDataWithDataInfo:(NSDictionary *)dataInfo
{
        for (NSString *tableName in dataInfo) {
            
            [self updateData:dataInfo[tableName] tableName:tableName];
        }


}

- (NSArray *)getModelsWithTableName:(NSString *)tableName
{
    tableName = [tableName uppercaseString];
/*
 #define  CoreDataVersion            @"VERSIONLIST"                  // 版本列表
 #define  CoreDataBusinesstype       @"HC_BASIC_BUSINESSTYPE"        // 业务类型
 #define  CoreDataCancelReason       @"HC_BASIC_CANCELREASON"        // 取消原因列表
 #define  CoreDataInsuranceCompany   @"HC_BASIC_INSURANCECOMPANY"    // 保险公司列表
 #define  CoreDataURL                @"HC_BASIC_URL"                 // 网页链接列表
 #define  CoreDataCommonValue        @"HC_COMMON_VALUE"              // 常量
 #define  CoreDataDepartment         @"HC_STORE_DEPARTMENT"          // 部门列表
 #define  CoreDataGroup              @"HC_STORE_GROUP"               // 组列表
 #define  CoreDataPosition           @"HC_STORE_POSITION"            // 职位列表
 #define  CoreDataWorkHourk          @"HC_WORK_HOUR_GROUP"           // 工时列表
 #define  CoreDataSchemeLevel        @"FAJB"                         // 方案级别列表
 #define  CoreDataPayWay             @"JSFS"                         // 结算方式列表
 #define  CoreDataStoreType          @"KCLX"                         // 库存类型列表
 #define  CoreDataWarranty           @"BXZT"                         // 保修状态列表
 #define  CoreDataOrderStatus        @"KDZT"                         // 开单状态列表
 #define  CoreDataInterval           @"JGYS"                         //间隔月数
 */

    
    return [self queryListWithTableName:tableName];
}

- (PorscheConstantModelType)getTypeWithTableName:(NSString *)tableName {
    

    if ([tableName isEqualToString:CoreDataBusinesstype]) return PorscheConstantModelTypeCoreDataBusinesstype;
    if ([tableName isEqualToString:CoreDataCancelReason]) return PorscheConstantModelTypeCoreDataCancelReason;
    if ([tableName isEqualToString:CoreDataInsuranceCompany]) return PorscheConstantModelTypeCoreDataInsuranceCompany;
    if ([tableName isEqualToString:CoreDataURL]) return PorscheConstantModelTypeCoreDataURL;
    if ([tableName isEqualToString:CoreDataCommonValue]) return PorscheConstantModelTypeCoreDataCommonValue;
    if ([tableName isEqualToString:CoreDataDepartment]) return PorscheConstantModelTypeCoreDataDepartment;
    if ([tableName isEqualToString:CoreDataGroup]) return PorscheConstantModelTypeCoreDataGroup;
    if ([tableName isEqualToString:CoreDataPosition]) return PorscheConstantModelTypeCoreDataPosition;
    if ([tableName isEqualToString:CoreDataWorkHourk]) return PorscheConstantModelTypeCoreDataWorkHourk;
    if ([tableName isEqualToString:CoreDataSchemeLevel]) return PorscheConstantModelTypeCoreDataSchemeLevel;
    if ([tableName isEqualToString:CoreDataPayWay]) return PorscheConstantModelTypeCoreDataPayWay;
    if ([tableName isEqualToString:CoreDataStoreType]) return PorscheConstantModelTypeCoreDataStoreType;
    if ([tableName isEqualToString:CoreDataWarranty]) return PorscheConstantModelTypeCoreDataWarranty;
    if ([tableName isEqualToString:CoreDataOrderStatus]) return PorscheConstantModelTypeCoreDataOrderStatus;
    if ([tableName isEqualToString:CoreDataInterval]) return PorscheConstantModelTypeCoreDataInterval;
    
    return 0;
}

- (NSArray *)queryListWithTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (id info in fetchedObjects) {

        if ([tableName isEqualToString:CoreDataVersion])
        {
            LocalDataVersion *tableversion = (LocalDataVersion *)info;
            LocalDataVersion *version = [[LocalDataVersion alloc] init];
            version.tablename = tableversion.tablename;
            version.storeid = tableversion.storeid;
            version.version = tableversion.version;
            
            [resultArray addObject:version];
        }
        else
        {
            PorscheConstantModel *model = [[PorscheConstantModel alloc] init];
            PorscheConstantModel *infoModel = (PorscheConstantModel *)info;
            
            model.cvsubid = infoModel.cvsubid;
            model.cvvaluedesc = infoModel.cvvaluedesc;
            
            if ([info respondsToSelector:NSSelectorFromString(@"extrainfo")])
            {
                model.extrainfo = infoModel.extrainfo;
            }
            
            if ([tableName isEqualToString:CoreDataWorkHourk])
            {
                model.cvsubid = (NSNumber *)infoModel.cvsubidstr;
            }
            
            if ([info respondsToSelector:NSSelectorFromString(@"children")])
            {
                NSMutableArray *children = [NSMutableArray array];
                for (NSDictionary *sub in infoModel.children)
                {
                    PorscheSubConstant *subModel = [PorscheSubConstant yy_modelWithDictionary:sub];
                    if ([tableName isEqualToString:CoreDataWorkHourk])
                    {
                        subModel.cvsubid = [sub objectForKey:@"cvsubidstr"];
                    }
                    [children addObject:subModel];
                }
                model.children = children;
                model.constantType = [self getTypeWithTableName:tableName];
            }
            [resultArray addObject:model];
        }
    }
    
    return resultArray;
}


- (void)deleteListWithTableName:(NSString *)tableName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}


- (PorscheConstantModel *)queryPostionInfoWithPositionId:(NSNumber *)postionid
{
    NSArray *positions = [self queryListWithTableName:CoreDataPosition];
    
    for (PorscheConstantModel *sub in positions)
    {
        if ([sub.cvsubid isEqualToNumber:postionid])
        {
            return sub;
        }
    }
    
    return nil;
}

- (void)deleteCoreDataFile
{
    //NSURL *documentUrl = [self applicationDocumentsDirectory];
    
}


@end
