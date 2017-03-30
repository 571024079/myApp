//
//  ProjectTabbarView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/11/11.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "ProjectTabbarView.h"

@interface ProjectTabbarView ()

@property (nonatomic, assign) NSInteger type;//1.厂方  2.本店  3.我的

@end

@implementation ProjectTabbarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithcustomFrame:(CGRect)rect type:(NSInteger)type complete:(void(^)(UIButton *button))complete {
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    self = nibArray.firstObject;
    self.frame = rect;
    self.type = type;
    
    //设置默认字体颜色 和背景图片
    [self setupAllBtdefault];
    self.tabbarBlock = complete;
  
    //
    [self setupBtWithType:type];
    
    return self;
}

- (void)setupBtWithType:(NSInteger)type {
    switch (type) {
        case 0:
        {
            [self setupBtAction:_factoryBt textColor:Color(255, 255, 255) imageStr:@"project_left_factory_radius_blue.png"];

        }
            break;
        case 1:
        {
            [self setupBtAction:_locationBt textColor:Color(255, 255, 255) imageStr:@"project_left_factory_radius_blue.png"];

        }
            break;
        case 2:
        {
            [self setupBtAction:_mineBt textColor:Color(255, 255, 255) imageStr:@"project_left_factory_radius_blue.png"];

        }
            break;
        default:
            break;
    }
}

- (IBAction)switchLocationBtAction:(UIButton *)sender {
    [self setupAllBtdefault];

    [self setupBtAction:sender textColor:Color(255, 255, 255) imageStr:@"project_left_factory_radius_blue.png"];
    
    if (self.tabbarBlock) {
        self.tabbarBlock(sender);
    }

}

//设置全部，默认显示
- (void)setupAllBtdefault {
    [self setupBtAction:_factoryBt textColor:Color(119, 119, 119) imageStr:@"project_left_factory_radius_gray_border.png"];
    [self setupBtAction:_locationBt textColor:Color(119, 119, 119) imageStr:@"project_left_factory_radius_gray_border.png"];
    [self setupBtAction:_mineBt textColor:Color(119, 119, 119) imageStr:@"project_left_factory_radius_gray_border.png"];
}

-(void)setupBtAction:(UIButton *)button textColor:(UIColor *)color imageStr:(NSString *)imageStr {
    [button setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];

}




@end
