//
//  PCarTypeModel.m
//  HandleiPad
//
//  Created by Handlecar on 9/24/16.
//  Copyright © 2016 Handlecar1. All rights reserved.
//

#import "PCarTypeModel.h"

@implementation PCarTypeModel

+ (NSArray *)cartypeModelsFromArray:(NSArray *)cartypeArrays
{
    NSMutableArray *cartypeModels = [NSMutableArray array];
    
    for (NSDictionary *cartypeInfo in cartypeArrays)
    {
        PCarTypeModel *model = [[PCarTypeModel alloc] init];
        [model setValuesForKeysWithDictionary:cartypeInfo];
        
        // 去掉中括号以及中间的字符串
        NSString *name = [cartypeInfo objectForKey:@"name"];
        model.bracketName = name;
        model.name = [PCarTypeModel deleteBracketContainChinese:name];
        model.Id = [cartypeInfo objectForKey:@"id"];
        [cartypeModels addObject:model];
    }
    
    return cartypeModels;
}

+ (NSString *)deleteBracketContainChinese:(NSString *)needHandleString
{
    NSRange startRange = [needHandleString rangeOfString:@"["];
    NSRange endRange = [needHandleString rangeOfString:@"]"];
    
    if ((startRange.location != NSNotFound)
        &&(endRange.location != NSNotFound))
    {
        needHandleString = [needHandleString substringWithRange:NSMakeRange(0, startRange.location)];
    }
    
    return needHandleString;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"key == %@",key);
}

@end
