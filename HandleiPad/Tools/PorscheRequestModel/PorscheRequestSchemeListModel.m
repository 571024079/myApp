//
//  PorscheRequestSchemeListModel.m
//  HandleiPad
//
//  Created by Robin on 2016/11/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheRequestSchemeListModel.h"

static PorscheRequestSchemeListModel *requestmodel = nil;
static dispatch_once_t onceToken;

@implementation PorscheRequestSchemeListModel

//@property (nonatomic, copy) NSString *businesstypeids; //业务类型id
//@property (nonatomic, copy) NSString *wocarcatena; //车系
//@property (nonatomic, copy) NSString *wocarmodel; //车型
//@property (nonatomic, copy) NSString *woyearstyle; //年款
////@property (nonatomic, copy) NSString *woyearstylecode; //年款code
//@property (nonatomic, strong) NSNumber *beginmiles; //公里数起始
//@property (nonatomic, strong) NSNumber *endmiles; //公里数结束
//@property (nonatomic, strong) NSNumber *month; //时间范围
//@property (nonatomic, strong) NSNumber *schemelevelid; //方案级别id
//@property (nonatomic, copy) NSString *schemename; //方案名称
//@property (nonatomic, strong) NSNumber *schemetype; //方案类型【1：厂方 2：本店;3 自定义方案】
//@property (nonatomic, strong) NSNumber *group_id; //备件组别id
//@property (nonatomic, strong) NSNumber *workhourgroupfuid; //工时主组id
//@property (nonatomic, strong) NSNumber *workhourgroupid; //工时子组id

+ (instancetype)shareModel {
    
    
    dispatch_once(&onceToken, ^{
        
        requestmodel = [[PorscheRequestSchemeListModel alloc] init];
        NSLog(@"PorscheRequestSchemeListModel 创建了！！！！");
        requestmodel.month = @(-1);
        [requestmodel addObserver];
    });
    
    
    return requestmodel;
}

+ (void)tearDown {
    
    [requestmodel removeObserver];
    requestmodel = nil;
    onceToken = 0l;
}

- (NSMutableArray *)favoriteArray {
    
    if (!_favoriteArray) {
        _favoriteArray = [[NSMutableArray alloc] init];
    }
    return _favoriteArray;
}

- (void)addObserver {
    
    [self addObserver:self forKeyPath:@"businesstypeids" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"wocarcatena" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"wocarmodel" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"woyearstyle" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"beginmiles" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"endmiles" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"month" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"schemelevelid" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [self addObserver:self forKeyPath:@"schemename" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
//    [self addObserver:self forKeyPath:@"schemetype" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"group_id" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"workhourgroupfuid" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"workhourgroupid" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

- (void)removeObserver {
    
    [self removeObserver:self forKeyPath:@"businesstypeids" context:nil];
    [self removeObserver:self forKeyPath:@"wocarcatena" context:nil];
    [self removeObserver:self forKeyPath:@"wocarmodel" context:nil];
    [self removeObserver:self forKeyPath:@"woyearstyle" context:nil];
    [self removeObserver:self forKeyPath:@"beginmiles" context:nil];
    [self removeObserver:self forKeyPath:@"endmiles" context:nil];
    [self removeObserver:self forKeyPath:@"month" context:nil];
    [self removeObserver:self forKeyPath:@"schemelevelid" context:nil];
//    [self removeObserver:self forKeyPath:@"schemename" context:nil];
//    [self removeObserver:self forKeyPath:@"schemetype" context:nil];
    [self removeObserver:self forKeyPath:@"group_id" context:nil];
    [self removeObserver:self forKeyPath:@"workhourgroupfuid" context:nil];
    [self removeObserver:self forKeyPath:@"workhourgroupid" context:nil];
}

- (void)postNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCHEME_LEFT_SEARCH_NOTIFICATION object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_isSetupCar)
    {
        return;
    }
//    [self resetWocarlevel];
    NSLog(@"搜索条件改变了！！！！！");
    [self postNotification];
}



- (void)refleshDataWithPctid:(NSNumber *)pctid wocarlevel:(NSNumber *)wocarlevel
{
    [self resetWocarlevelWithPctid:pctid wocarlevel:wocarlevel];
    [self postNotification];
}

- (void)resetWocarlevelWithPctid:(NSNumber *)pctid wocarlevel:(NSNumber *)wocarlevel
{
    self.wocarlevel = wocarlevel;
    self.scartypeid = pctid;
}

@end

@implementation PorscheRequestSchemeDeleteModel

@end

@implementation PorscheRequestUploadPictureVideoModel

@end

@implementation PorscheResponserPictureVideoModel

@end

@implementation PorscheRequestSperaListhModel

@end
