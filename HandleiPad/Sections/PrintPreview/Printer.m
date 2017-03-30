//
//  Printer.m
//  HandleiPad
//
//  Created by Ais on 2016/12/14.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "Printer.h"

@interface Printer ()<UIPrintInteractionControllerDelegate>
@property (nonatomic, copy) NSString *printerName;
@property (nonatomic,copy) NSURL *printerURL;
@property (nonatomic, strong) UIPrinter *printer;
@property (nonatomic) NSInteger copies;
@property (nonatomic, strong) NSData *myPDFData;
@end

@implementation Printer

- (void)selectPrinterToPrinterWithView:(UIView *)view copies:(NSInteger)copies printPDFData:(NSData *)myPDFData
{
    self.copies = copies;
    self.myPDFData = myPDFData;
    UIPrinterPickerController *pickerController =[UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    
    CGRect rect;
//    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    rect = CGRectMake(480, 50, 0, 0);
    [pickerController presentFromRect:rect inView:view animated:YES completionHandler:^(UIPrinterPickerController *controller, BOOL userDidSelect, NSError *err){
        if (userDidSelect)
        {
            // save the urlString and Printer name, do your UI interactions
            self.printerName = controller.selectedPrinter.displayName;
//            self.submitButton.enabled = YES;
            
            self.printerURL = controller.selectedPrinter.URL;
            
//            self.airPrinterName = controller.selectedPrinter.displayName;
            NSLog(@"Selected printer:%@", controller.selectedPrinter.displayName);
            [self printPDFWithView:view];
        }
    }];
}



- (void)printPDFWithView:(UIView *)view
{
    
    NSArray *printintItems = [self printingItems];
    if (!printintItems.count) {
        NSLog(@"无打印信息");
        return;
    }
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    if  (pic && [UIPrintInteractionController canPrintData: self.myPDFData] ) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"打印，打印";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
//        pic.showsPageRange = YES;
        pic.printingItems = printintItems;
        
//        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
//        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
////            self.content = nil;
//            if (!completed && error)
//                NSLog(@"FAILED! due to error in domain %@ with error code %u",
//                      error.domain, error.code);
//        };
        self.printer = [UIPrinter printerWithURL:self.printerURL];
        [self printInteractionController:pic printToPrinter:self.printer completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
            if (completed && !error)
            {
                NSLog(@"打印完成");
            }
            else
            {
                NSLog(@"打印失败");
            }
        }];
}
}


- (void)printInteractionController:(UIPrintInteractionController *)pic printToPrinter:(UIPrinter *)printer  completionHandler:(nullable UIPrintInteractionCompletionHandler)completion
{
//    self.printer = [UIPrinter printerWithURL:self.printerURL];
    [pic printToPrinter:self.printer completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {

            NSLog(@"打印循环完毕");
            if (completion)
            {
                completion(printInteractionController,completed,error);
            }
    }];

}


- (NSArray *)printingItems
{
    if (!self.copies && self.myPDFData.length)
    {
        return nil;
    }
    
    NSMutableArray *printTimes = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.copies; i++)
    {
        [printTimes addObject:self.myPDFData];
    }
    
    return printTimes;
}

@end
