//
//  HDServiceRecordsRightModel.m
//  HandleiPad
//
//  Created by handou on 16/10/20.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDServiceRecordsRightModel.h"

@implementation HDServiceRecordsRightModel

+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"carflglist" : [HDServiceRecordsCarflgModel class],
             @"workorderlist" : [HDServiceYearListModel class]};
    
}

@end


/*
 ************************** 标签列表对象model *****************************
 */
@implementation HDServiceRecordsCarflgModel

@end

/*
 ************************** 下拉提示框标签列表对象model *****************************
 */
@implementation HDServiceRecordsCarflgTableViewModel

@end

/*
 ************************** 历史工单列表对象model *****************************
 */
@implementation HDServiceRecordsRightDetailCellModel
+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"finishedSolutionlist" : [HDserviceDetailCellCustomModel class],
             @"unfinishedSolutionlist" : [HDserviceDetailCellCustomModel class]};
}

@end



/*
 ************************** 年份分类model *****************************
 */
@implementation HDServiceYearListModel
+ (nullable NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"workorderlistdetail" : [HDServiceRecordsRightDetailCellModel class]};
}

@end



/*
 ************************** 已完成方案列表(未完成方案列表)model *****************************
 */
@implementation HDserviceDetailCellCustomModel

@end


























