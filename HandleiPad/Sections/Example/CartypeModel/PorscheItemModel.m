//
//  PorscheItemModel.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/12.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PorscheItemModel.h"

@implementation PorscheItemModel

//+ (NSMutableArray *)getAllItemData {
//    NSMutableArray *array = [NSMutableArray array];
//    
//    [array addObjectsFromArray:@[[PorscheItemModel getItemWith:1],[PorscheItemModel getItemWith:2],[PorscheItemModel getItemWith:3],[PorscheItemModel getItemWith:4],[PorscheItemModel getItemWith:5]]];
//    
//    return array;
//}
//
//+ (NSArray *)getItemWith:(NSInteger)number {
//    
//    NSMutableArray *array = [NSMutableArray array];
//    
//    switch (number) {
//        case 1:
//        {//数据类型--安全
//            PorscheItemDetialModel *model1 = [PorscheItemDetialModel getModelWithArray:@[@"620 500 40",@"",@"更换机油机滤",@"200",@"2.5",@"500"]];
//            
//            PorscheItemDetialModel *model2 = [PorscheItemDetialModel getModelWithArray:@[@"569-26-22 ",@"563 956 111 43 MKL",@"美孚机油",@"130",@"4",@"520"]];
//            PorscheItemDetialModel *model3 = [PorscheItemDetialModel getModelWithArray:@[@"566-26-22 ",@"563 956 111 43 MKL",@"博世机滤",@"80",@"1",@"80"]];
//            PorscheItemDetialModel *model4 = [PorscheItemDetialModel getModelWithArray:@[@"563-26-22 ",@"563 956 111 43 MKL",@"博世",@"30",@"1",@"50"]];
//            
//            model1.modelCategoryStyle = PorscheItemModelCategooryStyleSave;
//            model2.modelCategoryStyle = PorscheItemModelCategooryStyleSave;
//            model3.modelCategoryStyle = PorscheItemModelCategooryStyleSave;
//            model4.modelCategoryStyle = PorscheItemModelCategooryStyleSave;
//            
//            model1.modelStyle = PorscheItemModelStyleItemTime;
//            model2.modelStyle = PorscheItemModelStyleMaterial;
//            model3.modelStyle = PorscheItemModelStyleMaterial;
//            model4.modelStyle = PorscheItemModelStyleMaterial;
//            
//            [array addObjectsFromArray:@[model1,model2,model3,model4]];
//            return array;
//
//        }
//            break;
//        case 2:
//        {//数据类型-隐患
//            PorscheItemDetialModel *model1 = [PorscheItemDetialModel getModelWithArray:@[@"958 600 20",@"",@"更换火花塞",@"70",@"2",@"140"]];
//            PorscheItemDetialModel *model2 = [PorscheItemDetialModel getModelWithArray:@[@"588-26-22 ",@"563 956 111 43 MKL",@"马勒火花塞",@"80",@"4",@"320"]];
//            PorscheItemDetialModel *model3 = [PorscheItemDetialModel getModelWithArray:@[@"588-26-22 ",@"563 956 111 43 MKL",@"博世机滤",@"80",@"1",@"80"]];
//            PorscheItemDetialModel *model4 = [PorscheItemDetialModel getModelWithArray:@[@"588-26-22 ",@"563 956 111 43 MKL",@"博世",@"30",@"1",@"50"]];
//            
//            model1.modelCategoryStyle = PorscheItemModelCategooryStyleHiddenDanger;
//            model2.modelCategoryStyle = PorscheItemModelCategooryStyleHiddenDanger;
//            model3.modelCategoryStyle = PorscheItemModelCategooryStyleHiddenDanger;
//            model4.modelCategoryStyle = PorscheItemModelCategooryStyleHiddenDanger;
//            
//            model1.modelStyle = PorscheItemModelStyleItemTime;
//            model2.modelStyle = PorscheItemModelStyleMaterial;
//            model3.modelStyle = PorscheItemModelStyleMaterial;
//            model4.modelStyle = PorscheItemModelStyleMaterial;
//            
//            [array addObjectsFromArray:@[model1,model2,model3,model4]];
//            return array;
//
//        }
//            break;
//        case 3:
//        {//数据类型--信息
//            PorscheItemDetialModel *model1 = [PorscheItemDetialModel getModelWithArray:@[@"856 230 50",@"",@"更换正时的套装",@"160",@"4",@"640"]];
//            PorscheItemDetialModel *model2 = [PorscheItemDetialModel getModelWithArray:@[@"558-26-22 ",@"563 956 111 43 MKL",@"皮带",@"300",@"2",@"600"]];
//            PorscheItemDetialModel *model3 = [PorscheItemDetialModel getModelWithArray:@[@"558-26-22 ",@"563 956 111 43 MKL",@"水泵",@"800",@"1",@"800"]];
//            PorscheItemDetialModel *model4 = [PorscheItemDetialModel getModelWithArray:@[@"558-26-22 ",@"563 956 111 43 MKL",@"博世",@"30",@"1",@"50"]];
//            
//            model1.modelCategoryStyle = PorscheItemModelCategooryStyleMessage;
//            model2.modelCategoryStyle = PorscheItemModelCategooryStyleMessage;
//            model3.modelCategoryStyle = PorscheItemModelCategooryStyleMessage;
//            model4.modelCategoryStyle = PorscheItemModelCategooryStyleMessage;
//            
//            model1.modelStyle = PorscheItemModelStyleItemTime;
//            model2.modelStyle = PorscheItemModelStyleMaterial;
//            model3.modelStyle = PorscheItemModelStyleMaterial;
//            model4.modelStyle = PorscheItemModelStyleMaterial;
//            
//            [array addObjectsFromArray:@[model1,model2,model3,model4]];
//            return array;
//
//        }
//            break;
//        case 4:
//        {//数据类型--安全
//            PorscheItemDetialModel *model1 = [PorscheItemDetialModel getModelWithArray:@[@"562 680 60",@"",@"更换刹车片套装",@"110",@"2",@"220"]];
//            PorscheItemDetialModel *model2 = [PorscheItemDetialModel getModelWithArray:@[@"568-26-22 ",@"563 956 111 43 MKL",@"刹车片",@"60",@"8",@"480"]];
//            PorscheItemDetialModel *model3 = [PorscheItemDetialModel getModelWithArray:@[@"508-26-22 ",@"563 956 111 43 MKL",@"刹车油",@"50",@"2",@"100"]];
//            PorscheItemDetialModel *model4 = [PorscheItemDetialModel getModelWithArray:@[@"538-26-22 ",@"563 956 111 43 MKL",@"博世",@"30",@"1",@"50"]];
//            
//            model1.modelCategoryStyle = PorscheItemModelCategooryStyleSave;
//            model2.modelCategoryStyle = PorscheItemModelCategooryStyleSave;
//            model3.modelCategoryStyle = PorscheItemModelCategooryStyleSave;
//            model4.modelCategoryStyle = PorscheItemModelCategooryStyleSave;
//            
//            model1.modelStyle = PorscheItemModelStyleItemTime;
//            model2.modelStyle = PorscheItemModelStyleMaterial;
//            model3.modelStyle = PorscheItemModelStyleMaterial;
//            model4.modelStyle = PorscheItemModelStyleMaterial;
//            
//            [array addObjectsFromArray:@[model1,model2,model3,model4]];
//            return array;
//
//        }
//            break;
//        case 5:
//        {//数据类型--自定义
//            PorscheItemDetialModel *model1 = [PorscheItemDetialModel getModelWithArray:@[@"958 600 20",@"",@"更换火花塞",@"70",@"2",@"140"]];
//            PorscheItemDetialModel *model2 = [PorscheItemDetialModel getModelWithArray:@[@"588-26-22 ",@"563 956 111 43 MKL",@"马勒火花塞",@"80",@"4",@"320"]];
//            PorscheItemDetialModel *model3 = [PorscheItemDetialModel getModelWithArray:@[@"588-26-22 ",@"563 956 111 43 MKL",@"博世机滤",@"80",@"1",@"80"]];
//            PorscheItemDetialModel *model4 = [PorscheItemDetialModel getModelWithArray:@[@"588-26-22 ",@"563 956 111 43 MKL",@"博世",@"30",@"1",@"50"]];
//            
//            model1.modelCategoryStyle = PorscheItemModelCategooryStyleCustom;
//            model2.modelCategoryStyle = PorscheItemModelCategooryStyleCustom;
//            model3.modelCategoryStyle = PorscheItemModelCategooryStyleCustom;
//            model4.modelCategoryStyle = PorscheItemModelCategooryStyleCustom;
//            
//            model1.modelStyle = PorscheItemModelStyleItemTime;
//            model2.modelStyle = PorscheItemModelStyleMaterial;
//            model3.modelStyle = PorscheItemModelStyleMaterial;
//            model4.modelStyle = PorscheItemModelStyleMaterial;
//            
//            [array addObjectsFromArray:@[model1,model2,model3,model4]];
//            return array;
//        }
//        default:
//            return nil;
//            break;
//    }
//    
//}
//
//
//@end
//
//@implementation PorscheItemDetialModel
//
//+ (PorscheItemDetialModel *)getModelWithArray:(NSArray *)array {
//    PorscheItemDetialModel *model = [[PorscheItemDetialModel alloc] initWithFigueNumber:array[0] listNumber:array[1] name:array[2] price:array[3] count:array[5] totalPrice:array[5]];
//    
//    return model;
//}
//
//
//- (instancetype)initWithFigueNumber:(NSString *)number listNumber:(NSString *)listNumber name:(NSString *)name price:(NSString *)price count:(NSString *)count totalPrice:(NSString *)totalPrice {
//    if (self = [super init]) {
//        //默认左边是没选中的
//        _modelLeftSelectedStyle = PorscheItemModelUnselected;
//        //默认数据右边是 被选中的
//        _modelRightSelectedStyle = PorscheItemModelSelected;
//        //默认数据，需要库存确认
//        _cubStyle = PorscheItemModelCubStyleNeedConfirm;
//        //默认自费
//        _guaranteeStyle = PorscheMaterialAndItemTimeGuaranteeStyleSelfPay;
//
//        _isSingleAddModel = NO;
//        _modelIsNewMaretial = NO;
//        _isCanAddItemTime = NO;
//        _itemFigueNumber = number;
//        _itemNumberList = listNumber;
//        _itemName = name;
//        _itemPrice = price;
//        _itemCount = count;
//        _itemTotalPrice = totalPrice;
//    }
//    return self;
//}
//
//
//- (instancetype)init {
//    if (self = [super init]) {
//        _modelLeftSelectedStyle = PorscheItemModelUnselected;
//        _modelRightSelectedStyle = PorscheItemModelSelected;
//        schemetype = NO;
//        _modelIsNewMaretial = NO;
//        _isCanAddItemTime = NO;
//    }
//    return self;
//}
//
//
//
//@end
//
//
//@implementation PorscheCarMessage
//
//- (instancetype)initWithDic:(NSDictionary *)dic {
//    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dic];
//    }
//    return self;
//}
//
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    
//}
//
//
//+ (NSArray *)getCarNoticeModel:(NSInteger)integer {
//    
//    NSMutableArray *dataArray = [NSMutableArray array];
//    
//    NSArray *carNumberArray = @[@"XNI596",@"OKI596",@"HGF596",@"YIJ596",@"OIN596",@"DBX596"];
//    
//    for (int i = 0; i < integer; i ++) {
//        NSInteger idx = arc4random() % 6;
//        NSInteger readStyle = arc4random() % 2;
//        PorscheCarMessage *model = [[PorscheCarMessage alloc]initWithDic:@{@"carLocation":@"沪",@"carNumber":carNumberArray[idx],@"vinNumber":@"WEI1DH2921ELA29654",@"carCategory":@"911 Camera S 2016款",@"message":@"等待您确认备件",}];
//        model.modelStyle = readStyle;
//        model.selectedStyle = PorscheItemModelUnselected;
//        
//        [dataArray addObject:model];
//    }
//    return dataArray;
//    
//}
//
//+ (NSArray *)getLocationCarNoticeModel:(NSInteger)integer {
//    
//    NSArray *messageArray =[NSArray arrayWithObjects:@"911保养促销",@"备件:叉车片\n价格更新为",nil];
//    NSArray *priceArray = @[@"￥500.00",@"￥2,800.00"];
//    
////    NSArray *category = @[@"方案",@"价格"];
//    NSArray *array = [PorscheCarMessage getCarNoticeModel:integer];
//    for (PorscheCarMessage *model in array) {
//        
//        NSLog(@"调用+1");
//        NSInteger idx = arc4random() % 2;
//        NSInteger idx2 = arc4random() % 2;
//        
//        model.message = messageArray[idx];
//        model.changePrice = priceArray[idx2];
////        model.categoryStyle = category[idx];
//    }
//    return array;
//    
//}

@end




