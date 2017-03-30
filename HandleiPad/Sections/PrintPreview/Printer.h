//
//  Printer.h
//  HandleiPad
//
//  Created by Ais on 2016/12/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Printer : NSObject
//- (void)printPDFWithView:(UIView *)view;
//- (void)printPDF;
- (void)selectPrinterToPrinterWithView:(UIView *)view copies:(NSInteger)copies printPDFData:(NSData *)myPDFData;
@end
