//
//  HDPreCheckModel.h
//  HandleiPad
//
//  Created by 程凯 on 2017/3/3.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PreCheckFile;
@class PreCheckItem;
@class PreCheckTyre;
@class PreCheckOtherService;
@class PreCheckPayType;


@interface HDPreCheckModel : NSObject
/**
 *工单相关数据
 */
@property (copy, nonatomic) NSString *titleName;//预检单标题
@property (copy, nonatomic) NSString *dmsno;//(预)工单号
@property (copy, nonatomic) NSString *vin;//车架号
@property (copy, nonatomic) NSString *plateall;//车牌号
@property (copy, nonatomic) NSString *checkpersonname;//检验员/检测员
@property (strong, nonatomic) NSNumber *checkpersonid;//检测人ID
@property (copy, nonatomic) NSString *checkday;//日期
@property (strong, nonatomic) NSNumber *curmiles;//当前里程数
@property (strong, nonatomic) NSNumber *wohasfuel;//燃油量
//@property (copy, nonatomic) NSString *cussingn;//客户签名
//@property (copy, nonatomic) NSString *cusingndate;//客户签名日期
@property (copy, nonatomic) NSString *remark;//'备注',
@property (copy, nonatomic) NSString *carimg;//汽车图片
@property (copy, nonatomic) NSString *cars;
/**
 * 预检单相关：单选
 */

@property (strong, nonatomic) NSNumber *orderinfo;//订单概览  0： 未选中   1:机油更换服务  2：中级保养 3：保养 4：其他',
@property (strong, nonatomic) NSNumber *isinfactory;//'接受车辆客户是否在厂 0：未填写   1：在厂  2：不在厂',
@property (strong, nonatomic) NSNumber *hastrycar;//是否在遇到噪音和驾驶动态问题时进行试驾  0：未填写  1：是  2：否',
@property (strong, nonatomic) NSNumber *photoinfo;// 0：未填写  1：是 2：否',

/**
 * 预检单相关：多选
 */
@property (strong, nonatomic) NSArray<PreCheckFile *> *needfiles;//所需文件
@property (strong, nonatomic) NSArray<PreCheckOtherService *> *otherservices;//其他服务
@property (strong, nonatomic) NSArray<PreCheckPayType *> *paytypes;//付款方式

/**
 * 预检单相关：步骤列表
 */
@property (strong, nonatomic) NSArray<PreCheckItem *> *step1;//步骤1
@property (strong, nonatomic) NSArray<PreCheckItem *> *step2;//步骤2
@property (strong, nonatomic) NSArray<PreCheckItem *> *step4;//步骤4
@property (strong, nonatomic) NSArray<PreCheckItem *> *step5;//步骤5
@property (strong, nonatomic) NSArray<PreCheckTyre *> *tyres;//轮胎信息


@end


/*
 所需文件model
 修改的时候传下面两个参数
 */
@interface PreCheckFile : NSObject
@property (strong, nonatomic) NSNumber *hpcfcid;// 所需文件ID: 1 行驶证 2：客户授权  3：保修和保养手册 4：车轮防盗螺栓套筒' 5：
@property (strong, nonatomic) NSNumber *state;//0:不选中  1：选中

@end


/*
 所需服务model
 修改的时候传下面两个参数
 */
@interface PreCheckOtherService : NSObject
@property (strong, nonatomic) NSNumber *hpcscid;//所需服务  1：加满油 2：保留文件 3：保准清洗 4：高级内饰清洗  5：高级车身清洗',
@property (strong, nonatomic) NSNumber *state;//0:不选中  1：选中

@end

/*
 付款方式model
 修改的时候传下面两个参数
 */
@interface PreCheckPayType : NSObject
@property (strong, nonatomic) NSNumber *hpcpcid;//'付款方式 0：未填写  1：现金  2：借记/信用卡 3：其他'',',
@property (strong, nonatomic) NSNumber *state;//0:不选中  1：选中

@end


/*
 轮胎信息
 修改的时候传下面两个参数
 */
@interface PreCheckTyre : NSObject
@property (strong, nonatomic) NSNumber *wotpatterndepth;// int(10) DEFAULT '0' COMMENT '花纹深度',
@property (strong, nonatomic) NSNumber *wotypeuseyear;// varchar(14) DEFAULT '' COMMENT 年限,
@property (strong, nonatomic) NSNumber *wottype;// tinyint(3) DEFAULT '1' COMMENT '轮胎类型：  1：左前轮胎 2：右前轮胎 3：左后轮胎 4：右后轮胎  5：备胎',
@property (strong, nonatomic) NSNumber *wotid;
@end



/*
 步骤信息:
 * 修改显示，用下面两个参数
 * 1	喇叭
 2	车外/车内照明
 3	雨刷器/清洗器/大灯清洗系统
 4	离合器/换挡杆/手刹
 5	组合仪表/娱乐信息系统/开关
 6	点烟器/电源插座
 7	安全带/安全带扣
 8	机油油位
 9	PCM功能及导航更新
 10	空调系统和设置
 11	挡风玻璃,车窗，车镜
 12	撑杆（发动机舱改，厢盖，车门，后窗）
 13	减震器/饰条/盖罩密封情况/泄露
 14	备用轮胎/补充胶
 15	改装
 16	轮胎（N标记，旋转）
 17	钢圈（基本状况）
 18	散热器进气道（目测）
 19	制动盘（磨损，锈蚀，损坏）
 20	制动片（厚度）
 21	卡钳，软管（目测）
 22	轮胎磨损情况，车桥定位
 23	排气系统
 24	车底防护装置，护板，盖板
 25	动力传输，万向节/驱动轴
 26	泄露（液体，气体）和车底管路
 27	悬挂和减震器（臂，接头，防尘套，衬套）  
 
*/
@interface PreCheckItem : NSObject
@property (copy, nonatomic) NSString *hpcmname;//` varchar(50) DEFAULT '' COMMENT '检查项目',
@property (strong, nonatomic) NSNumber *hpcmcolor;//` tinyint(3) DEFAULT '1' COMMENT '检查项目颜色 1：黑色  2：红色'
//修改的时候传下面两个参数
@property (strong, nonatomic) NSNumber *hpcmcid;// tinyint(4) DEFAULT '0' COMMENT '检测项目关联ID',
@property (strong, nonatomic) NSNumber *hpcistate;// tinyint(4) DEFAULT '0' COMMENT '检车状态 1：正常  2：有待检查  3：不正常',

@end







