//
//  MaterialRightViewController.h
//  MaterialDemo
//
//  Created by Robin on 16/9/27.
//  Copyright © 2016年 Robin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ControllerType) {
    
    ControllerTypeWithMaterial = 1,  //备件库表
    ControllerTypeWithWorkingHours //工时库表
};

@interface MaterialRightViewController : UIViewController


- (instancetype)initWithType:(ControllerType)type;

@end
