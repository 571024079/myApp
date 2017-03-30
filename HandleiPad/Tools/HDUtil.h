//
//  HDUtil.h
//  HandleiPad
//
//  Created by Handlecar on 2017/2/20.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDUtil : NSObject
+ (BOOL)textFieldFilter:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (NSString *)getUUIDString;

@end
