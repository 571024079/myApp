//
//  PorscheModel.h
//  HandleiPad
//
//  Created by Robin on 2016/11/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PorscheSchemeModel.h"
#import "PorscheModifySchemeModel.h"
#import "PorscheRequestSchemeListModel.h"
#import "PorscheSperaModel.h"
#import "PorscheWorkHoursModel.h"
#import "PorscheConstantModel.h"


//方案级别
typedef NS_ENUM(NSInteger, PorscheSchemeLevelStyle) {
    PorscheSchemeLevelStyleSave = 1,//安全
    PorscheSchemeLevelStyleHiddenDanger,//隐患
    PorscheSchemeLevelStyleMessage,// 信息
    PorscheSchemeLevelStyleCustom,//自定义
};

#ifndef PorscheModel_h
#define PorscheModel_h



#endif /* PorscheModel_h */
