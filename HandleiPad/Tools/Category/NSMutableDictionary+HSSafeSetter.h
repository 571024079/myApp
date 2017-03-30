//
//  NSMutableDictionary+HSSafeSetter.h
//  Navigator
//
//  Created by Cheney Lau on 24/09/2013.
//  Copyright (c) 2013 Hibu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (HSSafeSetter)

- (void)hs_setSafeValue:(id)value forKey:(NSString*)key;

- (void)hs_setSafeValue:(id)value withDefault:(id)defaultForUnsafeValues forKey:(NSString*)key;

//开单实时上传 没操作的时候
- (void)hs_setSafeEmptyValue:(id)value forKey:(NSString*)key;
@end
