//
//  PorscheType.h
//  HandleiPad
//
//  Created by Robin on 2016/10/17.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MaterialTaskTimeDetailsType) {
    
    MaterialTaskTimeDetailsTypeScheme = 1,//方案详情
    MaterialTaskTimeDetailsTypeMaterial,// 配件详情
    MaterialTaskTimeDetailsTypeWorkHours,//工时详情
//    MaterialTaskTimeDetailsTypeNoticeScheme, // 提醒方案详情
};
typedef enum : NSUInteger {
    PDF_Quotation = 1,
    PDF_Spare,
} PDFType;
@interface PorscheType : NSObject

@end
