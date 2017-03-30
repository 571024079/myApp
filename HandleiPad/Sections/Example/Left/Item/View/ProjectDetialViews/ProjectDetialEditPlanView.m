//
//  ProjectDetialEditPlanView.m
//  HandleiPad
//
//  Created by Robin on 16/10/9.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectDetialEditPlanView.h"

@interface ProjectDetialEditPlanView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *leftDataSource;

@property (nonatomic, strong) NSArray *rightDataSource;

@property (nonatomic, copy) NSString *leftStr;

@property (nonatomic, copy) NSString *rightStr;

@end

@implementation ProjectDetialEditPlanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ProjectDetialEditPlanView" owner:nil options:nil];
        
        self = [array objectAtIndex:0];
        
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        
        self.leftStr = self.leftDataSource[0];
        self.rightStr = self.rightDataSource[0];
    }
    return self;
}

- (NSArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = @[@[@"",@"",@""],@[]];
    }
    return _dataSource;
}

- (NSArray *)leftDataSource {
    
    if (!_leftDataSource) {
        _leftDataSource = @[@"级别",@"业务",@"组别",@"车型"];
    }
    return _leftDataSource;
}

- (NSArray *)rightDataSource {
    
    if (!_rightDataSource) {
        _rightDataSource = @[@"常用",@"保养",@"制动",@"安全",@"制动",@"保养",@"安全",@"常用"];
    }
    return _rightDataSource;
}

- (NSArray *)getRightStringWidthleft:(NSString *)lefStr {
    
//    NSArray *array;
//    if ([lefStr isEqualToString:@"级别"]) {
//        array = @[@"安全",@"信息",@"隐患"];
//    }
//    
//    if ([lefStr isEqualToString:@"业务"]) {
//        array = @[@"洗车",@"精洗",@"保养",@"维修",@"钣金",@"喷漆",@"美容",@"轮胎"];
//    }
//    
//    if ([lefStr isEqualToString:@"组别"]) {
//        array = @[@"整车-一般",@"发动机",@"燃油供应",@"变速箱",@"悬架",@"车身",@"车身—外侧设备",@"车身—内侧设备",@"空调",@"电气系统",@"整台车辆",@"车漆"];
//    }
//    
//    if ([lefStr isEqualToString:@"车型"]) {
//        array = @[@"Boxster",@"Cayman",@"911",@"Panamera",@"Cayenne",@"Macan"];
//    }
    
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
        return self.leftDataSource.count;
    } else {
        
        return self.rightDataSource.count;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            return self.leftDataSource[row];
            break;
            
        case 1:
            return self.rightDataSource[row];
            break;
        default:
            return @"";
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (component) {
        case 0:
            NSLog(@"%@",self.leftDataSource[row]);
            self.leftStr = self.leftDataSource[row];
            break;
        case 1:
            NSLog(@"%@",self.rightDataSource[row]);
            self.rightStr = self.rightDataSource[row];
            break;
        default:
            break;
    }
}
- (IBAction)doneAction:(UIButton *)sender {
    
    if (self.clickBlock) {
        self.clickBlock(self.leftStr,self.rightStr);
    }
}
- (IBAction)cancleAction:(id)sender {
}

@end
