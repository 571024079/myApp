//
//  PorscheRequestSchemeListModel.h
//  HandleiPad
//
//  Created by Robin on 2016/11/21.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PorscheRequestSchemeListModel : NSObject

@property (nonatomic) BOOL isSetupCar;  // 是否是直接传入车型
@property (nonatomic, copy) NSString *businesstypeids; //业务类型id
@property (nonatomic, copy) NSString *wocarcatena; //车系
//@property (nonatomic, copy) NSString *wocarcatenacode; //车系code
@property (nonatomic, copy) NSString *wocarmodel; //车型
//@property (nonatomic, copy) NSString *wocarmodelcode; //车型code
@property (nonatomic, copy) NSString *woyearstyle; //年款
//@property (nonatomic, copy) NSString *woyearstylecode; //年款code
@property (nonatomic, strong) NSNumber *beginmiles; //公里数起始
@property (nonatomic, strong) NSNumber *endmiles; //公里数结束
@property (nonatomic, strong) NSNumber *month; //时间范围
@property (nonatomic, strong) NSNumber *schemelevelid; //方案级别id
@property (nonatomic, copy) NSString *schemename; //方案名称
@property (nonatomic, strong) NSNumber *schemetype; //方案类型【1：厂方 2：本店;3 自定义方案】
@property (nonatomic, strong) NSNumber *group_id; //备件组别id
@property (nonatomic, strong) NSString *workhourgroupfuid; //工时主组id
@property (nonatomic, strong) NSString *workhourgroupid; //工时子组id

@property (nonatomic, strong) NSMutableArray *favoriteArray; //存收藏夹id
// 车型层级
@property (nonatomic, strong) NSNumber *wocarlevel;//查询第几层  1 车系  2 车型 3 年款
// 当前选择最后一层 的车系 或 车型 或 年款 或 排量 id
@property (nonatomic, strong) NSNumber *scartypeid; //车型id

//未完成筛选参数

/*
 [paramers hs_setSafeValue:model.wocarid forKey:@"wocarid"];
 [paramers hs_setSafeValue:@1 forKey:@"isfromunfinished"];
 */
@property (nonatomic, strong) NSNumber *wocarid;
@property (nonatomic, strong) NSNumber *isfromunfinished;

//是否进行清空
@property (nonatomic, assign) BOOL isClearSearchData;

+ (instancetype)shareModel;

+ (void)tearDown;

- (void)refleshDataWithPctid:(NSNumber *)pctid wocarlevel:(NSNumber *)wocarlevel;

@end


@interface PorscheRequestSchemeDeleteModel : NSObject

@property (nonatomic, strong) NSNumber *caozuotype; // 操作类型【0.所有；1.基础；2.间隔时间；3.公里数；4.车型；5.工时；6.备件；7.业务类型】
@property (nonatomic, strong) NSNumber *isdellall; //【0：单个删除；1：批量删除】
@property (nonatomic, copy) NSString *schemeids; //方案id 可以多个同时删除，如1,2,3,4

@end

@interface PorscheRequestUploadPictureVideoModel : NSObject

@property (nonatomic, copy) NSString *aieditdesc; //编辑描述
@property (nonatomic, strong) NSNumber *aifiletype; //文件类型 1.img、2.video、3.doc、4.excel、5.txt等
@property (nonatomic, strong) NSNumber *aiid;//	附件id
@property (nonatomic, copy) NSString *fullpath; //全路径
@property (nonatomic, copy) NSString *ainame; //附件名称
@property (nonatomic, strong) NSNumber *parentid; //原图id（编辑的图片用）
@property (nonatomic, strong) NSNumber *airelativeid; //关联id
@property (nonatomic, strong) NSDate *aiuploaddate; //上传时间
@property (nonatomic, strong) NSNumber *aipictype; 	//图片类型 1 环车拍照 2 方案拍照 3 备件图拍照
@property (nonatomic, strong) NSNumber *edittype;  // 编辑类型 编辑类型1：原图，2：缩略图
@property (nonatomic, strong) NSNumber *iscovers;  //0 否   1 是
@property (nonatomic, strong) NSNumber *keytype; // 关联类型 1：工单，2：方案，3：备件
@property (nonatomic, strong) NSString *patharray; //编辑笔记途径model数组
@property (nonatomic, strong) NSNumber *relativeid; // 关联id  工单、方案、备件等

@end


/**
 附件查询返回model
 */
@interface PorscheResponserPictureVideoModel : NSObject

@property (nonatomic, strong) NSDate *aideldate; //删除时间
@property (nonatomic, strong) NSNumber *aidelflag; //是否被删除
@property (nonatomic, strong) NSNumber *aidelpersonl; //删除人
@property (nonatomic, copy) NSString *aieditdesc; //编辑备注
@property (nonatomic, strong) NSNumber *aifiletype;//	文件类型
@property (nonatomic, strong) NSNumber *aiid; //附件id
@property (nonatomic, copy) NSString *ainame; //附件名称
@property (nonatomic, strong) NSNumber *aipictype;//图片类型
@property (nonatomic, strong) NSNumber *airelativeid; // 图片类型
@property (nonatomic, strong) NSDate *aiuploaddate;
@property (nonatomic, copy) NSString *aiurl;
@property (nonatomic, strong) NSNumber *edittype;//编辑类型 1：原图，2：编辑图
@property (nonatomic, copy) NSString *fullpath; //	全路径
@property (nonatomic, strong) NSNumber *iscovers;//	是否封面 0：否 1：是
@property (nonatomic, strong) NSNumber *keytype;//	关联类型1：工单，2：方案，3：备件
@property (nonatomic, strong) NSNumber *parentid;//原图id 编辑后的图才有原图id
@property (nonatomic, copy) NSString *patharray; //编辑笔记途径model

//编辑图信息
@property (nonatomic, strong) NSNumber *maiid;//编辑图id
@property (nonatomic, copy) NSString *mainame;//编辑图名称
@property (nonatomic, copy) NSString *maiurl;//编辑地址
@property (nonatomic, copy) NSString *maieditdesc; ////编辑描述
@property (nonatomic, strong) NSNumber *mparentid; //原图id
@property (nonatomic, copy) NSString *mpatharray;//编辑笔记途径model数组
@property (nonatomic, copy) NSString *mfullpath;//全路径

@end


@interface PorscheRequestSperaListhModel : NSObject

@property (nonatomic, copy) NSString *businesstypeids;//业务ID 多个用“,”号隔开
@property (nonatomic, strong) NSNumber *group_id; //组别ID
@property (nonatomic, strong) NSNumber *schemelevelid; //级别ID
@property (nonatomic, copy) NSString *schemename; //备件名称
@property (nonatomic, strong) NSNumber *storeid; //4s店ID
@property (nonatomic, strong) NSNumber *wocarcatena; //车系
@property (nonatomic, strong) NSNumber *wocarmodel;//车型
@property (nonatomic, strong) NSNumber *workhourgroupfuid; //组别ID
@property (nonatomic, strong) NSNumber *woyearstyle;//车款

@end
