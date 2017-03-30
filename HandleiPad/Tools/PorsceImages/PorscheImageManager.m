//
//  PorscheImageManager.m
//  HandleiPad
//
//  Created by Robin on 16/10/25.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheImageManager.h"

@implementation PorscheImageManager

+ (NSString *)getSafetyColorImage:(PorscheSchemeLevelStyle)style selected:(BOOL)selected {
    
    NSString *imageName;
    switch (style) {
        case PorscheSchemeLevelStyleSave: //安全
        {
            imageName = selected ? @"materialtime_list_safecolor_selected":@"materialtime_list_safecolor_normal";
        }
            break;
        case PorscheSchemeLevelStyleHiddenDanger: //隐患
        {
            imageName = selected ? @"materialtime_list_troublecolor_selected":@"materialtime_list_troublecolor_normal";
        }
            break;
        case PorscheSchemeLevelStyleMessage: //信息
        {
            imageName = selected ? @"materialtime_list_infocolor_selected":@"materialtime_list_infocolor_normal";
        }
            break;
        case PorscheSchemeLevelStyleCustom: //未分类
        {
            imageName = selected ? @"materialtime_list_noClasscolor_selected":@"materialtime_list_noClasscolor_normal";
        }
            break;
            
        default:
            break;
    }
    return imageName;
}

+ (NSString *)getSafetyImage:(PorscheItemModelCategooryStyle)style selected:(BOOL)selected {
    
    NSString *imageName;
    switch (style) {
        case PorscheItemModelCategooryStyleSave: //安全
        {
            imageName = selected ? @"materialtime_list_safe_selected":@"materialtime_list_safe_normal";
        }
            break;
        case PorscheItemModelCategooryStyleHiddenDanger: //隐患
        {
            imageName = selected ? @"materialtime_list_trouble_selected":@"materialtime_list_trouble_normal";
        }
            break;
        case PorscheItemModelCategooryStyleMessage: //信息
        {
            imageName = selected ? @"materialtime_list_info_selected":@"materialtime_list_info_normal";
        }
            break;
        case PorscheItemModelCategooryStyleCustom: //未分类
        {
            imageName = selected ? @"materialtime_list_noClass_selected":@"materialtime_list_noClass_normal";
        }
            break;
        case PorscheItemModelCategooryStyleMix:
        {
            imageName = selected ? @"materialtime_list_noClass_selected":@"materialtime_list_noClass_normal";
        }
            break;
        case PorscheItemModelCategooryStyleUnfinished:
        {
            imageName = selected ? @"materialtime_list_noClass_selected":@"materialtime_list_noClass_normal";
        }
            break;
        case PorscheItemModelCategooryStyleUnknow:
        {
            imageName = selected ? @"materialtime_list_noClass_selected":@"materialtime_list_noClass_normal";
        }
            break;
            
        default:
            break;
    }
    return imageName;
}

+ (NSString *)getSchemeRectItemBackImage:(PorscheItemModelCategooryStyle)style selected:(BOOL)selected {
    
    NSString *imageName;
    switch (style) {
        case PorscheItemModelCategooryStyleSave: //安全
        {
            imageName = selected ? @"scheme_right_rectCell_red_selected":@"scheme_right_rectCell_red_normal";
        }
            break;
        case PorscheItemModelCategooryStyleHiddenDanger: //隐患
        {
            imageName = selected ? @"scheme_right_rectCell_black_selected":@"scheme_right_rectCell_black_normal";
        }
            break;
        case PorscheItemModelCategooryStyleMessage: //信息
        {
            imageName = selected ? @"scheme_right_rectCell_blue_selected":@"scheme_right_rectCell_blue_normal";
        }
            break;
        case PorscheItemModelCategooryStyleCustom: //未分类
        {
            imageName = selected ? @"scheme_right_rectCell_gray_selected":@"scheme_right_rectCell_gray_normal";
        }
            break;
        default:
            break;
    }
    return imageName;
}

+ (NSString *)getSchemeSmallRectItemBackImage:(PorscheItemModelCategooryStyle)style selected:(BOOL)selected {
    
    NSString *imageName;
    switch (style) {
        case PorscheItemModelCategooryStyleSave: //安全
        {
            imageName = selected ? @"save_selected":@"work_list_7";
        }
            break;
        case PorscheItemModelCategooryStyleHiddenDanger: //隐患
        {
            imageName = selected ? @"item_black-selected":@"work_list_8";
        }
            break;
        case PorscheItemModelCategooryStyleMessage: //信息
        {
            imageName = selected ? @"message_seleted":@"item_blue_normal";
        }
            break;
        case PorscheItemModelCategooryStyleCustom: //未分类
        {
            imageName = selected ? @"work_list_711":@"work_list_712";
        }
            break;
        default:
            break;
    }
    return imageName;
}

+ (NSString *)getSchemeBusinessImage:(PorscheCarBusinessType)type selected:(BOOL)selected {

    NSString *imageName;
    switch (type) {
        case PorscheCarBusinessTypeUnknow: //未分类
        {
            imageName = selected ? @"materialtime_list_noCategory_selected":@"materialtime_list_noCategory_normal";
        }
            break;
        case PorscheCarBusinessTypeCarWash: //精洗
            
        {
            imageName = selected ? @"materialtime_list_clean_selected":@"materialtime_list_clean_normal";
        }
            break;
        case PorscheCarBusinessTypeCarUpkeep: //保养
        {
            imageName = selected ? @"materialtime_list_service_selected":@"materialtime_list_service_normal";
        }
            break;
        case PorscheCarBusinessTypeCarMaintain: //维修
        {
            imageName = selected ? @"materialtime_list_repair_selected":@"materialtime_list_repair_normal";
        }
            
            break;
        case PorscheCarBusinessTypeCarMetal: //钣金
        {
            imageName = selected ? @"materialtime_list_metal_selected":@"materialtime_list_metal_normal";
        }
            break;
        case PorscheCarBusinessTypeCarSpray: //喷漆
        {
            imageName = selected ? @"materialtime_list_spray_selected":@"materialtime_list_spray_normal";
        }
            break;
        case PorscheCarBusinessTypeCarBeautify: // 美容
        {
            imageName = selected ? @"materialtime_list_beautycar_selected":@"materialtime_list_beautycar_normal";
        }
            break;
        case PorscheCarBusinessTypeCarWheel: //轮子
        {
            imageName = selected ? @"materialtime_list_wheel_selected":@"materialtime_list_wheel_normal";
        }
            break;
        default:
            break;
    }
    return imageName;
}

+ (NSString *)getSchemeBusinessSmallIconImage:(PorscheCarBusinessType)type{
    
    NSString *imageName;
    switch (type) {
        case PorscheCarBusinessTypeUnknow: //未分类
        {
            imageName = @"scheme_right_rectCell_smallicon_noCategory_normal";
        }
            break;
        case PorscheCarBusinessTypeCarWash: //精洗
            
        {
            imageName = @"scheme_right_rectCell_smallicon_clean_normal";
        }
            break;
        case PorscheCarBusinessTypeCarUpkeep: //保养
        {
            imageName = @"scheme_right_rectCell_smallicon_service_normal";
        }
            break;
        case PorscheCarBusinessTypeCarMaintain: //维修
        {
            imageName = @"scheme_right_rectCell_smallicon_repair_normal";
        }
            
            break;
        case PorscheCarBusinessTypeCarMetal: //钣金
        {
            imageName = @"scheme_right_rectCell_smallicon_metal_normal";
        }
            break;
        case PorscheCarBusinessTypeCarSpray: //喷漆
        {
            imageName = @"scheme_right_rectCell_smallicon_spray_normal";
        }
            break;
        case PorscheCarBusinessTypeCarBeautify: // 美容
        {
            imageName = @"scheme_right_rectCell_smallicon_beautycar_normal";
        }
            break;
        case PorscheCarBusinessTypeCarWheel: //轮子
        {
            imageName = @"scheme_right_rectCell_smallicon_wheel_normal";
        }
            break;
        default:
            break;
    }
    return imageName;
}

+ (NSString *)getMaterialHoursIconImage:(MaterialTaskTimeDetailsType)type Normal:(BOOL)normal {
    
    NSString *imageName;
    
    switch (type) {
        case MaterialTaskTimeDetailsTypeMaterial:
            imageName = normal ? @"work_list_25":@"hd_custom_item_time_material";
            break;
        case MaterialTaskTimeDetailsTypeWorkHours:
            imageName = normal ? @"work_list_24":@"hd_custom_item_time_pic";
            break;
        default:
            break;
    }
    return imageName;
}

+ (NSString *)getTickImage:(BOOL)selected {
    
    return selected ? @"materialtime_list_checkbox_selected": @"materialtime_list_checkbox_normal";
}

@end
