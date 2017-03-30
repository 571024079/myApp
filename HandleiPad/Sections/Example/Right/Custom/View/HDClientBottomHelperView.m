//
//  HDClientBottomHelperView.m
//  HandleiPad
//
//  Created by Handlecar1 on 16/10/19.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "HDClientBottomHelperView.h"
#import "NSString+Additional.h"
@implementation HDClientBottomHelperView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCustomFrame:(CGRect)frame {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    self = array.firstObject;
    self.frame = frame;
    return self;
}

- (void)setupViewSave:(BOOL)isSave {
    _signBt.userInteractionEnabled = !isSave;
    
#pragma mark  已确认  不能再确认
    if (!isSave) {
        if (_carMessage) {
            if ([_carMessage.orderstatus isShowCustomLighting]) {
//                [_signBt setBackgroundImage:[UIImage imageNamed:@"gray_backGroundImage.png"] forState:UIControlStateNormal];
                _signBt.userInteractionEnabled = YES;
            }
        }
    }
}


- (void)setCarMessage:(PorscheNewCarMessage *)carMessage {
    _carMessage = carMessage;
    
    _itemTimeLb.text = carMessage.workhouroriginalprice ? [NSString formatMoneyStringWithFloat:[carMessage.workhouroriginalprice1 floatValue]] : @"-----";
    _materialLb.text = carMessage.partsoriginalprice ? [NSString formatMoneyStringWithFloat:[carMessage.partsoriginalprice1 floatValue]] : @"-----";
    _preferentialLb.text = carMessage.wodiscountprice ? [NSString formatMoneyStringWithFloat:[carMessage.wodiscountprice floatValue]] : @"-----";
    _totalPriceLb.text = carMessage.ordertotalprice ? [NSString formatMoneyStringWithFloat:[carMessage.ordertotalprice floatValue]] : @"-----";
    PorscheResponserPictureVideoModel *picModel= carMessage.attachmentsforsign.firstObject;
    [self setupSignTime:carMessage.customersigndate];
    [self setupSignImage:picModel.fullpath];
    
}

- (void)setupSignImage:(NSString *)imageStr {
    self.imageView.image = nil;
    if (imageStr && ![imageStr isEqualToString:@""]) {
        NSString *urlStr = [imageStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    [self.signBt setTitle:imageStr && ![imageStr isEqualToString:@""] ? nil : @"点击客户签字" forState:UIControlStateNormal];
}

- (void)setupSignTime:(NSString *)timeString {
    if (timeString && ![timeString isEqualToString:@""]) {
        NSString *string = [NSString getStringForAll:timeString];
        _signDateLb.text = string;
    }else {
        _signDateLb.text = [[NSDate date] stringWithMinuteAccuracy];
    }
}

- (IBAction)signBtAction:(UIButton *)sender {
    
    if (self.hDClientBottomHelperViewBlock) {
        self.hDClientBottomHelperViewBlock();
    }
    
}
@end
