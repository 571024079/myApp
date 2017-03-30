//
//  ServiceShareListView.h
//  HandleiPad
//
//  Created by Robin on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceShareListView : UIView

+ (instancetype)viewFromXibWithItemRect:(CGRect)rect Item:(NSInteger)item; //0==Top other == bottom

@end
