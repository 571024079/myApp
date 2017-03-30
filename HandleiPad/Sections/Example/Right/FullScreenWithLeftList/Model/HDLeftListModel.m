//
//  HDLeftListModel.m
//  HandleiPad
//
//  Created by handou on 16/10/13.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDLeftListModel.h"

@implementation HDLeftListModel



+ (HDLeftListModel *)dataFrom {
    HDLeftListModel *data = [[HDLeftListModel alloc] init];
    
    NSArray *array3 = @[@1,@2,@8];
    NSArray *array1 = @[@"沪A",@"京B",@"粤C",@"津C",@"皖B",@"湘A",@"鲁B",@"渝A",@"辽C",@"豫A"];
    NSArray *array2 = @[@"Boxster",@"Cayenne",@"Cayman",@"Panamera",@"Carrera GT",@"Macan"];
    data.carplate = [NSString stringWithFormat:@"%@%u%u%u%u%u%u", array1[(arc4random() % 10)], (arc4random() % 9), (arc4random() % 9), (arc4random() % 9), (arc4random() % 9), (arc4random() % 9), (arc4random() % 9)];
    data.cartype = array2[(arc4random() % 6)];
    
//    data.type1 = @((arc4random() % 2) + 1);
    NSInteger c = arc4random() % 99;
    data.type1 = (c - 20)?@2:@1;
    
    if ([data.type1 integerValue] > 1) {
        data.type2 = @((arc4random() % 5));
        
        if ([data.type2 integerValue] > 1) {
            data.type3 = @((arc4random() % 8));
            
            if (([data.type3 integerValue] > 1) && ([data.type3 integerValue] < 8)) {
                data.type4 = @((arc4random() % 8));
                
                if (([data.type4 integerValue] > 1) && ([data.type4 integerValue] < 8)) {
                    data.type5 = array3[arc4random() % 3];
                    data.typeBao = @((arc4random() % 3));
                }else {
                    data.type5 = @(0);
                    data.typeBao = @(0);
                    if ([data.type3 integerValue] == 2) {
                        data.type4 = @3;
                    }
                }
            }else {
                data.type4 = @(0);
                data.type5 = @(0);
                data.typeBao = @(0);
                if ([data.type2 integerValue] > 2) {
                    data.type2 = @1;
                }
                if ([data.type2 integerValue] == 2) {
                    data.type3 = @3;
                }
            }
        }else {
            data.type3 = @(0);
            data.type4 = @(0);
            data.type5 = @(0);
            data.typeBao = @(0);
            if ([data.type1 integerValue] == 2) {
                data.type2 = @1;
            }
        }
    }else {
        data.type2 = @(0);
        data.type3 = @(0);
        data.type4 = @(0);
        data.type5 = @(0);
        data.typeBao = @(0);
    }
    
    NSInteger s = arc4random() % 20;
    BOOL isStay = s?YES:NO;
    data.stayType = isStay?@1:@0;
    
    
    data.carID = @((arc4random() % 900) + 100);
    
    
    
    
    
    
    
    

    return data;
}


+ (NSMutableArray *)dataLoad {
    
    
    NSArray *carPlateArr = @[@[@"沪QWE123",@"Cayman",@"1",@"0",@"0",@"0",@"0",@"0",@"1",@"123"],
                             @[@"沪QNM567",@"Boxster",@"2",@"1",@"0",@"0",@"0",@"0",@"1",@"124"],
                             @[@"皖PAC805",@"911",@"2",@"2",@"8",@"0",@"0",@"0",@"1",@"125"],
                             @[@"浙BCW678",@"Panamera",@"2",@"3",@"2",@"8",@"0",@"1",@"1",@"126"],
                             @[@"苏JJ88QW",@"Cayenne",@"2",@"2",@"2",@"2",@"8",@"2",@"1",@"127"],
                             @[@"京F55YYH",@"918",@"2",@"4",@"4",@"2",@"2",@"0",@"1",@"128"],
                             @[@"津AER667",@"Boxster",@"2",@"6",@"6",@"2",@"8",@"0",@"1",@"129"],
                             @[@"渝KK828M",@"Cayenne",@"2",@"5",@"2",@"5",@"0",@"0",@"1",@"130"],
                             @[@"宁LPJ567",@"911",@"2",@"2",@"2",@"2",@"1",@"0",@"1",@"131"],
                             @[@"赣TYT730",@"Panamera",@"2",@"4",@"4",@"2",@"2",@"0",@"1",@"132"]];
    
    
    
    NSMutableArray *addArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i++) {
        HDLeftListModel *data = [[HDLeftListModel alloc] init];
        NSArray *arrayD = carPlateArr[i];
        
        data.carplate = arrayD[0];
        data.cartype = arrayD[1];
        data.type1 = arrayD[2];
        data.type2 = arrayD[3];
        data.type3 = arrayD[4];
        data.type4 = arrayD[5];
        data.type5 = arrayD[6];
        data.typeBao = arrayD[7];
        data.stayType = arrayD[8];
        data.carID = arrayD[9];
        data.carModel = [[PorscheNewCarMessage alloc]init];
        
        data.carModel.ccarplate = arrayD[0];
        data.carModel.wocarcatena = arrayD[1];
        
        [addArr addObject:data];
    }
    
    return addArr;
}
@end
