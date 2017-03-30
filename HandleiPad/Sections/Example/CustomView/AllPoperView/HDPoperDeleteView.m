//
//  HDPoperDeleteView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/9/24.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDPoperDeleteView.h"
#import "HDLeftSingleton.h"

#define TimePop_StyleOne_Size CGRectMake(0, 0, 480, 280) //日期 星期 上下午
#define TimePop_StyleOne_SIZE CGSizeMake(480, 280)

@implementation HDPoperDeleteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [self removeFromSuperview];
}

#pragma mark  ------初始化 可删除poperVC------
- (instancetype)initWithSize:(CGSize)size  {
    
    if (self = [super init]) {
        
        _deleteView = [[HDdeleteView alloc]initWithCustom];
        _label = _deleteView.deleteLb;
        WeakObject(self);
        
        _deleteView.hDdeleteViewBlock = ^ (HDdeleteViewStyle style) {
            if (selfWeak.hDPoperDeleteViewBlock) {
                selfWeak.hDPoperDeleteViewBlock(style);
            }
            
        };
        
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:_deleteView popoverContentSize:size];
    
    }
    return self;
}

#pragma mark  ------时间筛选pop <2016年 10月 14日 星期五 下午> 默认尺寸<480.280>
- (instancetype)initWithFrameSize:(CGSize)size withFrome:(CGRect)frame withDate:(NSDate *)date {
    if (self = [super init]) {
        if (![HDLeftSingleton shareSingleton].keidanListLeftDatePopView) {
            [HDLeftSingleton shareSingleton].keidanListLeftDatePopView = [HDLeftBillingDateChooseView getCustomFrame:frame withDate:date];
        }else {
            [HDLeftSingleton shareSingleton].keidanListLeftDatePopView.inputDate = date;
        }
//        HDLeftBillingDateChooseView *datepickerView = [HDLeftBillingDateChooseView getCustomFrame:frame withDate:date];
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:[HDLeftSingleton shareSingleton].keidanListLeftDatePopView popoverContentSize:size];
        _poperVC.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
//添加方法获取传进来的时间，不是当前的时间
+ (void)showAlertViewAroundView:(UIView *)view title:(NSString *)title style:(HDLeftBillingDateChooseViewStyle)style withDate:(NSDate *)date withResultBlock:(void(^)(NSString *resultStr))resultBlock {
    
    HDPoperDeleteView *poperView = [[HDPoperDeleteView alloc] initWithFrameSize:TimePop_StyleOne_SIZE withFrome:TimePop_StyleOne_Size withDate:date];
    HDLeftBillingDateChooseView *datepickerView = poperView.poperVC.contentViewController.view.subviews.firstObject;
    
    datepickerView.chooseViewStyle = style;
    
    poperView.poperVC.backgroundColor = [UIColor whiteColor];
    datepickerView.headerTitleLb.text = title;
    
    datepickerView.hDLeftBillingDateChooseViewBlock = ^(HDLeftBillingDateChooseViewStyle style2,NSString *sender) {
        [poperView.poperVC dismissPopoverAnimated:YES];
        poperView.poperVC = nil;
        [poperView removeFromSuperview];
        if (sender) {
            if (resultBlock) {
                resultBlock(sender);
            }
        }

    };
    
    [poperView.poperVC presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
- (instancetype)initWithTimePredicateFrame:(CGRect)frame style:(HDLeftBillingDateChooseViewStyle)style withDate:(NSDate *)date {
    if (self = [super initWithFrame:frame]) {
        if (date != nil) {
            _datepickerView = [HDLeftBillingDateChooseView getCustomFrame:frame withDate:date];
        }else {
            _datepickerView = [HDLeftBillingDateChooseView getCustomFrame:frame];
        }
        _datepickerView.chooseViewStyle = style;
        
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:_datepickerView popoverContentSize:frame.size];
    }
    return self;
}

#pragma mark  ------时间筛选pop <2016年 10月 14日 星期五 下午> 默认尺寸<480.280>
- (instancetype)initWithTimePredicateFrame:(CGRect)frame style:(HDLeftBillingDateChooseViewStyle)style{
    return [self initWithTimePredicateFrame:frame style:style withDate:nil];
}

+ (UIPopoverController *)showDateTimePredicateFrame:(CGRect)frame aroundView:(UIView *)view direction:(UIPopoverArrowDirection)direction headerTitle:(NSString *)title isLimit:(BOOL)isLimit style:(HDLeftBillingDateChooseViewStyle)style complete:(void(^)(HDLeftBillingDateChooseViewStyle style,NSString *endStr))complete {
    HDPoperDeleteView *poperView = [[HDPoperDeleteView alloc]initWithTimePredicateFrame:frame style:style];
    HDLeftBillingDateChooseView *chooseView = poperView.poperVC.contentViewController.view.subviews.firstObject;
    chooseView.headerTitleLb.text = title;
    
    chooseView.hDLeftBillingDateChooseViewBlock = ^(HDLeftBillingDateChooseViewStyle style ,NSString *sender) {
        [poperView.poperVC dismissPopoverAnimated:YES];
        poperView.datepickerView = nil;
        poperView.poperVC = nil;
        [poperView removeFromSuperview];
        
        if (sender) {
            complete(style,sender);
        }
        };
    [poperView.poperVC presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:direction animated:YES];
    return poperView.poperVC;
}



#pragma mark  ------时间筛选pop <2016年 10月 14日 星期五 下午 1 51> 默认尺寸<500.300>
- (instancetype)initWithTimeAndSecondPredicateFrame:(CGRect)frame style:(HDWorkListDateChooseViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        
        if (![HDLeftSingleton shareSingleton].yujiJiaocheTimeDatePopView) {
//            _secondPickerView = [HDWorkListDateChooseView getCustomFrame:frame];
            [HDLeftSingleton shareSingleton].yujiJiaocheTimeDatePopView = [HDWorkListDateChooseView getCustomFrame:frame];
        }
        
        _secondPickerView.dateViewStyle = style;
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:[HDLeftSingleton shareSingleton].yujiJiaocheTimeDatePopView popoverContentSize:frame.size];
        _poperVC.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

#pragma mark  初始化
+ (void)showTimeAndSecondViewFrame:(CGRect)frame aroundView:(UIView *)view style:(HDWorkListDateChooseViewStyle)style direction:(UIPopoverArrowDirection)direction sure:(void (^)(NSString *string))sure cancel:(void (^)())cancel {
    HDPoperDeleteView *poperView = [[HDPoperDeleteView alloc]initWithTimeAndSecondPredicateFrame:frame style:style];
    HDWorkListDateChooseView *chooseView = poperView.poperVC.contentViewController.view.subviews.firstObject;
    chooseView.hDWorkListDateChooseViewBlock = ^(HDWorkListDateChooseViewStyle style ,NSString *sender) {
        [poperView.poperVC dismissPopoverAnimated:NO];
        poperView.secondPickerView = nil;
        poperView.poperVC = nil;
        [poperView removeFromSuperview];
        switch (style) {
            case HDWorkListDateChooseViewStyleSure:
                sure(sender);
                break;
            case HDWorkListDateChooseViewStyleCancel:
                cancel();
                break;
            default:
                break;
        }
        
    };
    [poperView.poperVC presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:direction animated:NO];
//    return poperView.poperVC;
}




#pragma mark  ------时间筛选pop <2016年 10月 14日 星期五> 默认尺寸<400.300>
- (instancetype)initWithTimeAndWeekPredicateFrame:(CGRect)frame style:(HDRightDateChooseViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        _weekDatePickerView = [HDRightDateChooseView getCustomFrame:frame];
        _weekDatePickerView.chooseViewStyle = style;
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:_weekDatePickerView popoverContentSize:frame.size];
        _poperVC.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


+ (UIPopoverController *)showDateAndWeekViewWithFrame:(CGRect)frame aroundView:(UIView *)view direction:(UIPopoverArrowDirection)direction headerTitle:(NSString *)title isLimit:(BOOL)isLimit style:(HDRightDateChooseViewStyle)style complete:(void(^)(HDRightDateChooseViewStyle style,NSString *endStr))complete {
    HDPoperDeleteView *poperView = [[HDPoperDeleteView alloc]initWithTimeAndWeekPredicateFrame:frame style:style];
    HDRightDateChooseView *weekDatePickerView = poperView.poperVC.contentViewController.view.subviews.firstObject;
    weekDatePickerView.headerTitleLb.text = title;
    weekDatePickerView.islimit = isLimit;
    weekDatePickerView.hDRightDateChooseViewBlock = ^(HDRightDateChooseViewStyle style,NSString *string) {
        [poperView.poperVC dismissPopoverAnimated:NO];
        poperView.weekDatePickerView = nil;
        poperView.poperVC = nil;
        [poperView removeFromSuperview];
        if (string) {
            complete(style,string);
        }
    };
    [poperView.poperVC presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:direction animated:NO];
    return poperView.poperVC;
}


#pragma mark  ------保修<240.203>------
- (instancetype)initWithGuaranteeChooseViewFrame:(CGRect)frame dataSource:(NSArray *)dataSource idx:(NSInteger)idx{
    if (self = [super initWithFrame:frame]) {
        _guaranteeChooseView = [GuaranteeChooseView getClassCustomFrame:frame dataSource:dataSource idx:idx];
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:_guaranteeChooseView popoverContentSize:frame.size];
        _poperVC.backgroundColor = MAIN_BLUE;
    }
    return self;
}

- (instancetype)initWithUpDatePhotoViewFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        HDTakePhotoUpData *view = [HDTakePhotoUpData getUpDatePhotoViewFrame:frame];
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:view popoverContentSize:frame.size];
        _poperVC.backgroundColor =[UIColor whiteColor];
    }
    return self;
}
#pragma mark  本地上传/拍照上传
+ (void)showUpDatePhotoViewAroundView:(UIView *)view direction:(UIPopoverArrowDirection)direction Camera:(void (^)())camera location:(void (^)())location {
    HDPoperDeleteView *poperView = [[HDPoperDeleteView alloc]initWithUpDatePhotoViewFrame:CGRectMake(0, 0, 130, 85)];
    HDTakePhotoUpData *updateView = (HDTakePhotoUpData *)poperView.poperVC.contentViewController.view.subviews.firstObject;
    updateView.hdupdatePhotoBlock = ^(UIButton *sender){
        [poperView.poperVC dismissPopoverAnimated:YES];
        poperView.poperVC = nil;
        [poperView removeFromSuperview];
        if (sender.tag == 1) {
            camera();
        }else {
            location();
        }
    };
    CGRect rect = view.bounds;
    CGFloat height = rect.size.height;
    rect.size.height = height *1.05;
    [poperView.poperVC presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}



- (instancetype)initWithFrameSize:(CGSize)size titleArr:(NSArray *)titleArr {
    
    if (self = [super init]) {
        HDdeleteView *view = [HDdeleteView setupCustomTitlleArr:titleArr];
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:view popoverContentSize:size];
        _poperVC.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark  初始化 可删除poperVC
+ (UIPopoverController *)showAlertViewAroundView:(UIView *)view titleArr:(NSArray *)titleArr direction:(UIPopoverArrowDirection)direction sure:(void (^)())sure refuse:(void (^)())refuse cancel:(void (^)())cancel {
    HDPoperDeleteView *poperView = [[HDPoperDeleteView alloc]initWithFrameSize:DELETE_VIEW_SIZE titleArr:titleArr];
    HDdeleteView *deleteView = poperView.poperVC.contentViewController.view.subviews.firstObject;
    deleteView.hDdeleteViewBlock = ^(HDdeleteViewStyle style) {
        [poperView.poperVC dismissPopoverAnimated:YES];
        poperView.poperVC = nil;
        [poperView removeFromSuperview];
        switch (style) {
            case HDdeleteViewStyleSure:
                sure();
                break;
            case HDdeleteViewStyleCancel:
                cancel();
                break;
            case HDdeleteViewStyleRefuse:
                refuse();
                break;
            default:
                break;
        }
    };
    [poperView.poperVC presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:direction animated:YES];
    return poperView.poperVC;
}



#pragma mark - 列表类型的popView
- (instancetype)initWithFrameSize:(CGSize)size withDataSource:(NSArray *)dataSource {
    
    if (self = [super init]) {
        HDPopSelectTableView *view = [HDPopSelectTableView loadPopSelectTableViewWithDataArray:dataSource];
        _poperVC = [AlertViewHelpers getPoperVCWithCustomView:view popoverContentSize:size];
        _poperVC.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
+ (UIPopoverController *)showAlertTableViewWithAroundView:(UIView *)view withDataSource:(NSArray *)dataSource direction:(UIPopoverArrowDirection)direction selectBlock:(void(^)(NSInteger index))selectBolck {
    
    CGSize size = CGSizeZero;
    if (dataSource.count < 6) {
        size = CGSizeMake(250, dataSource.count * 40);
    }else {
        size = CGSizeMake(250, 200);
    }
    
    HDPoperDeleteView *poperView = [[HDPoperDeleteView alloc]initWithFrameSize:size withDataSource:dataSource];
    HDPopSelectTableView *selectTableVeiw = poperView.poperVC.contentViewController.view.subviews.firstObject;
    
    selectTableVeiw.selectCellButtonBlock = ^(NSInteger index) {
        [poperView.poperVC dismissPopoverAnimated:YES];
        poperView.poperVC = nil;
        [poperView removeFromSuperview];
        if (selectBolck) {
            selectBolck(index);
        }
    };
    
    [poperView.poperVC presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:direction animated:YES];
    return poperView.poperVC;
}


@end
