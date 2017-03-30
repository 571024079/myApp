//
//  HDUtil.m
//  HandleiPad
//
//  Created by Handlecar on 2017/2/20.
//  Copyright © 2017年 Handlecar1. All rights reserved.
//

#import "HDUtil.h"
#import "KeychainItemWrapper.h"

static NSString *UUID = @"";

@implementation HDUtil
+ (BOOL)textFieldFilter:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    static NSString *numbers = @"0123456789";
    static NSString *numbersPeriod = @"01234567890.";
    static NSString *numbersComma = @"0123456789,";
    if (range.length > 0 && [string length] == 0) {
        // enable delete
        return YES;
    }
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    if (range.location == 0 && [string isEqualToString:symbol]) {
        // decimalseparator should not be first
        return NO;
    }
    
    if(range.location == 1){
        if ([textField.text isEqualToString:@"0"] && ![string isEqualToString:@"."]){
            return NO;
        }
    }
    
    NSCharacterSet *characterSet;
    NSRange separatorRange = [textField.text rangeOfString:symbol];
    if (separatorRange.location == NSNotFound) {
        if ([symbol isEqualToString:@"."]) {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersPeriod] invertedSet];
        }
        else {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersComma] invertedSet];
        }
    }
    else {
        // allow 2 characters after the decimal separator
        if (range.location > (separatorRange.location + 2)) {
            return NO;
        }
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
    }
    
    if ([[string stringByTrimmingCharactersInSet:characterSet] length] == 0) {
        return NO;
    }
    return YES;

}

// 获取用户uuid
+ (NSString *)getUUIDString;
{
    if (!UUID.length)
    {
        // 查找KeyChain
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"handlecar_Porsche_iOS" accessGroup:@"7G496US846.com.handlecar.porsche"];
        NSString *uuid = [wrapper objectForKey:(id)kSecValueData];
        
        if (uuid.length)
        {
            UUID = uuid;
            return uuid;
        }
        else
        {
            NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [wrapper setObject:idfv forKey:(id)kSecValueData];
            UUID = idfv;
            return idfv;
        }
        
    }
    else
    {
        return UUID;
    }
    
}


@end
