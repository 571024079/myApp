//
//  LocalDataVersion.h
//  HandleiPad
//
//  Created by Handlecar on 2016/12/7.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LocalDataVersion : NSObject

@property (nonatomic, strong) NSNumber *storeid;
@property (nonatomic, strong) NSString *tablename;
@property (nonatomic, strong) NSNumber *version;

@end
