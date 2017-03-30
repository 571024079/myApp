//
//  PenSigner.m
//  HandleiPad
//
//  Created by Robin on 16/10/23.
//  Copyright © 2016年 Handlecar1. All rights reserved.
//

#import "PenSigner.h"
#import "ACEDrawingView.h"

@interface PenSigner ()

@property (weak, nonatomic) IBOutlet ACEDrawingView *derwingView;
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (nonatomic, copy) NSString *dateStr;

@end

@implementation PenSigner

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewFromXibWithFrame:(CGRect)frame
{
   
    PenSigner *penSigner = [[[NSBundle mainBundle] loadNibNamed:@"PenSigner" owner:nil options:nil] firstObject];
    
    penSigner.frame = frame;
    
    penSigner.derwingView.lineWidth = 3;
    
    NSDate *nowDate = [NSDate date];
    penSigner.dateStr = [nowDate stringWithMinuteAccuracy];
    penSigner.dataLabel.text = [NSString stringWithFormat:@"签字日期:%@",penSigner.dateStr];
    penSigner.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    penSigner.contentView.layer.masksToBounds = YES;
    penSigner.contentView.layer.borderWidth = 1;
    penSigner.contentView.layer.cornerRadius = 6;
    penSigner.contentView.layer.borderColor = Color(200, 200, 200).CGColor;
    return penSigner;
}

- (UIImage *)imageFromView:(UIView *)view  Rect:(CGRect)rect
{
    //创建一个基于位图的图形上下文并指定大小为CGSizeMake(300,500)
    UIGraphicsBeginImageContext(rect.size);
    
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //返回一个基于当前图形上下文的图片
    UIImage *extractImage =UIGraphicsGetImageFromCurrentImageContext();
    
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    
    //以png格式返回指定图片的数据
    NSData *imageData = UIImagePNGRepresentation(extractImage);
    UIImage *imge = [UIImage imageWithData:imageData];
    
    return imge;
}


- (IBAction)cancleAndSureAction:(UIButton *)sender {
    UIImage *image = self.derwingView.image;
    NSString *dateStr = [self.dateStr copy];
    
    if (self.signerImageBlock) {
        self.signerImageBlock(image,dateStr,sender);
    }
}

@end
