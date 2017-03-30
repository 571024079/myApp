//
//  PorscheConstant.m
//  HandleiPad
//
//  Created by 岳小龙 on 2016/12/6.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheConstant.h"
#import "CoreDataManager.h"

@implementation PorscheConstant

+ (instancetype)shareConstant {
    
    static PorscheConstant *constant = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        constant = [[PorscheConstant alloc] init];
        
    });
    return constant;
}

- (void)requestVersionList
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 先清除 coredata
        [self clearCoreData];
        
        WeakObject(self);
        [PHTTPRequestSender sendRequestWithURLStr:CONSTANTDATA_VERSION_URL parameters:nil completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
            if (responser.status == 100)
            {
                //            NSMutableArray *versionList = [NSMutableArray array];
                //            for (NSDictionary *dict in responser.list)
                //            {
                //               LocalDataVersion *version = [LocalDataVersion yy_modelWithJSON:dict];
                //                [versionList addObject:version];
                //            }
                [selfWeak updateConstantDataWithNewVersionList:responser.list];
            }
        }];
    });

}

// 清空coredata
- (void)clearCoreData
{
    NSString*document=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    NSString* sqlitePath = [document stringByAppendingFormat:@"/ConstantData.sqlite"];
    NSString* sqliteshmPath = [document stringByAppendingFormat:@"/ConstantData.sqlite-shm"];
    NSString* sqlitewalpPath = [document stringByAppendingFormat:@"/ConstantData.sqlite-wal"];

    NSError *error;
        NSFileManager* fm = [NSFileManager defaultManager];
        if([fm fileExistsAtPath:sqlitePath]){
            [fm removeItemAtPath:sqlitePath error:&error];
            NSLog(@"error %@",error.localizedDescription);
        }
        if([fm fileExistsAtPath:sqliteshmPath]){
            [fm removeItemAtPath:sqliteshmPath error:&error];
            NSLog(@"error %@",error.localizedDescription);
        }
        if([fm fileExistsAtPath:sqlitewalpPath]){
            [fm removeItemAtPath:sqlitewalpPath error:&error];
            NSLog(@"error %@",error.localizedDescription);
        }
}

- (void)requestConstantListWithTableNames:(NSArray *)tableNames
{
    MBProgressHUD *hub = [MBProgressHUD showProgressMessage:nil toView:HD_FULLView];
    WeakObject(self);
    self.allListInfo = [NSMutableDictionary dictionary];
    for (NSString * tableName in tableNames) {
        [PHTTPRequestSender sendRequestWithURLStr:CONSTANTDATA_LIST_URL parameters:@{@"tablename":tableName} completion:^(PResponseModel * _Nullable responser, NSError * _Nullable error) {
            static NSInteger count = 0;
            count++;
            if (responser.list.count == 0)
            {
                NSLog(@"%@ 无数据",tableName);
            }
            if (responser.status == 100)
            {
//                NSMutableArray *list = [NSMutableArray array];
//                for (NSDictionary *dict in responser.list)
//                {
//                    PorscheConstantModel *model = [PorscheConstantModel yy_modelWithDictionary:dict];
//                    [list addObject:model];
//                }
//                NSString *keyTableName = [tableName copy];
//                keyTableName = [keyTableName uppercaseString];
   
                
                [selfWeak.allListInfo setObject:responser.list forKey:tableName];
            }
            
            if (count == tableNames.count)
            {
                // 开始处理数据
                CoreDataManager *manager = [CoreDataManager shareManager];
                [manager updateDataWithDataInfo:selfWeak.allListInfo];
                [hub hideAnimated:YES];
                NSLog(@"所有类型列表%@",selfWeak.allListInfo);
                self.allListInfo = nil;
                count = 0;
            }
        }];
    }
}

- (NSArray<PorscheConstantModel *> *)getConstantListWithTableName:(NSString *)tableName;
{
    NSArray *list = [[CoreDataManager shareManager] getModelsWithTableName:tableName];
    return list;
}

- (NSArray<PorscheConstantModel *> *)getConstantListHasAllItemAtFirstPostionWithTableName:(NSString *)tableName
{
    PorscheConstantModel *model = [PorscheConstantModel constantAllModel];
    
    NSArray *constantList = [self getConstantListWithTableName:tableName];
    
    NSMutableArray *results = [NSMutableArray arrayWithObject:model];
    [results addObjectsFromArray:constantList];
    
    return results;
}

- (NSArray<PorscheConstantModel *> *)getConstantListHasAllItemAtLastPostionWithTableName:(NSString *)tableName
{
    PorscheConstantModel *model = [PorscheConstantModel constantAllModel];
    
    NSArray *constantList = [self getConstantListWithTableName:tableName];
    NSMutableArray *results = [NSMutableArray arrayWithArray:constantList];
    [results addObject:model];
    
    return results;
}

- (void)updateConstantDataWithNewVersionList:(NSArray *)versionList
{
    NSMutableArray *diffArray = [NSMutableArray array];

    // 是否存在版本列表信息
    CoreDataManager *manage = [CoreDataManager shareManager];
    
    NSArray *reults = [manage getModelsWithTableName:CoreDataVersion];

    if (reults.count)
    {
        // 查找本地version与服务器不一致的常量
        for (NSDictionary *newVersion in versionList)
        {
            for (LocalDataVersion *oldVersion in reults)
            {
                
                // 表名相同，版本不同，记录下来
                if ([newVersion[@"tablename"] isEqualToString:oldVersion.tablename]) {
                    if (![newVersion[@"version"] isEqualToNumber:oldVersion.version]) {
                        [diffArray addObject:newVersion[@"tablename"]];
                    }
                }
            }
            
            // 查询本地缓存，如果本地没有服务器上对应的信息
            NSArray *constantList = [[CoreDataManager shareManager] getModelsWithTableName:[newVersion objectForKey:@"tablename"]];
            if (!constantList.count) {
                [diffArray addObject:[newVersion objectForKey:@"tablename"]];
            }
            
        }
        NSSet *set = [NSSet setWithArray:diffArray];
        diffArray = [[set allObjects] mutableCopy];
 
    }
    else
    {
        // 写入所有常量信息
        diffArray = [versionList valueForKey:@"tablename"];
    }
    [manage updateData:versionList tableName:CoreDataVersion];
    if (diffArray.count)
    {
        //
        [self requestConstantListWithTableNames:diffArray];
    }

}

@end



